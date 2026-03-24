import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking.dart';

class PassengerDetailsScreen extends StatefulWidget {
  const PassengerDetailsScreen({super.key});

  @override
  State<PassengerDetailsScreen> createState() => _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState extends State<PassengerDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passportController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passportController.dispose();
    super.dispose();
  }

  Future<void> _processBooking() async {
    if (!_formKey.currentState!.validate()) return;
    
    final provider = context.read<BookingProvider>();
    final flight = provider.selectedFlight;
    final seat = provider.selectedSeat;
    final user = FirebaseAuth.instance.currentUser;
    
    if (flight == null || seat == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Flight or seat is missing.')));
      return;
    }
    
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You must be logged in to book.')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final db = FirebaseFirestore.instance;
      
      // 1. Create Booking record
      final passengerDetails = PassengerDetails()
        ..name = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'
        ..email = _emailController.text.trim()
        ..passport = _passportController.text.trim();

      final booking = Booking(
        userId: user.uid,
        flightId: flight.id,
        passenger: passengerDetails,
        seatNumber: seat,
        bookingDate: DateTime.now(),
        totalPaid: flight.price,
        status: 'CONFIRMED',
      );

      final batch = db.batch();
      final newBookingRef = db.collection('bookings').doc();
      batch.set(newBookingRef, booking.toMap());
      
      // 2. Add seat to flight's bookedSeats
      final flightRef = db.collection('flights').doc(flight.id);
      batch.update(flightRef, {
        'bookedSeats': FieldValue.arrayUnion([seat]),
        'availableSeats': FieldValue.increment(-1),
      });

      // Commit transaction
      await batch.commit();

      if (mounted) {
        provider.clearBooking();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking Successful!')));
        context.go('/search');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Booking failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final flight = context.watch<BookingProvider>().selectedFlight;
    final seat = context.watch<BookingProvider>().selectedSeat ?? '';

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Passenger Details', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTripSummary(seat, flight?.flightNumber ?? ''),
              const SizedBox(height: 32),
              const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildTextField('First Name', FontAwesomeIcons.user, controller: _firstNameController),
              const SizedBox(height: 16),
              _buildTextField('Last Name', FontAwesomeIcons.user, controller: _lastNameController),
              const SizedBox(height: 16),
              _buildTextField('Email Address', FontAwesomeIcons.envelope, controller: _emailController, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildTextField('Phone Number', FontAwesomeIcons.phone, controller: _phoneController, keyboardType: TextInputType.phone),
              const SizedBox(height: 32),
              const Text('Travel Documents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildTextField('Passport Number', FontAwesomeIcons.passport, controller: _passportController),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: _processBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGold,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Confirm Booking', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripSummary(String seat, String flightNumber) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 5),
            blurRadius: 15,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Seat Number', style: TextStyle(color: AppTheme.textLight, fontSize: 12)),
              const SizedBox(height: 4),
              Text(
                seat,
                style: const TextStyle(color: AppTheme.primaryBlue, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Flight', style: TextStyle(color: AppTheme.textLight, fontSize: 12)),
              const SizedBox(height: 4),
              Text(
                flightNumber,
                style: const TextStyle(color: AppTheme.primaryBlue, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, {TextInputType? keyboardType, required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.primaryBlue, size: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
