import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';

class PassengerDetailsScreen extends StatefulWidget {
  final String selectedSeat;
  const PassengerDetailsScreen({super.key, required this.selectedSeat});

  @override
  State<PassengerDetailsScreen> createState() => _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState extends State<PassengerDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Passenger Details', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTripSummary(),
              const SizedBox(height: 32),
              const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: SystemFonts.w700)),
              const SizedBox(height: 16),
              _buildTextField('First Name', FontAwesomeIcons.user),
              const SizedBox(height: 16),
              _buildTextField('Last Name', FontAwesomeIcons.user),
              const SizedBox(height: 16),
              _buildTextField('Email Address', FontAwesomeIcons.envelope, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildTextField('Phone Number', FontAwesomeIcons.phone, keyboardType: TextInputType.phone),
              const SizedBox(height: 32),
              const Text('Travel Documents', style: TextStyle(fontSize: 18, fontWeight: SystemFonts.w700)),
              const SizedBox(height: 16),
              _buildTextField('Passport Number', FontAwesomeIcons.passport),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Normally we'd save the booking. For this demo, we go straight to manifest dashboard to show admin view.
                    context.go('/manifest');
                  }
                },
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

  Widget _buildTripSummary() {
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
                widget.selectedSeat,
                style: const TextStyle(color: AppTheme.primaryBlue, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Flight', style: TextStyle(color: AppTheme.textLight, fontSize: 12)),
              SizedBox(height: 4),
              Text(
                'AL-421',
                style: TextStyle(color: AppTheme.primaryBlue, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, {TextInputType? keyboardType}) {
    return TextFormField(
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
class SystemFonts {
  static const w700 = FontWeight.w700;
}
