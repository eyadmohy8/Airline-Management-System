import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/booking_provider.dart';

class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({super.key});

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final Set<String> _selectedSeats = {};

  void _toggleSeat(String seatId, List<String> takenSeats) {
    if (takenSeats.contains(seatId)) return;
    
    setState(() {
      if (_selectedSeats.contains(seatId)) {
        _selectedSeats.remove(seatId);
      } else {
        if (_selectedSeats.isNotEmpty) {
          _selectedSeats.clear();
        }
        _selectedSeats.add(seatId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final flight = context.watch<BookingProvider>().selectedFlight;
    if (flight == null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: AppTheme.primaryBlue),
        body: const Center(child: Text('No flight selected')),
      );
    }
    
    final takenSeats = flight.bookedSeats;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text('Select Seat - ${flight.flightNumber}', style: const TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: AppTheme.primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildAirplaneHeader(),
          _buildSeatLegend(),
          Expanded(
            child: _buildSeatMap(takenSeats),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildAirplaneHeader() {
    return Container(
      width: double.infinity,
      color: AppTheme.primaryBlue,
      padding: const EdgeInsets.only(bottom: 24),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 240,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(120),
                topRight: Radius.circular(120),
              ),
            ),
          ),
          const Column(
            children: [
              SizedBox(height: 40),
              Text('Economy Class', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeatLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLegendItem(Colors.white, 'Available', hasBorder: true),
          _buildLegendItem(Colors.grey.shade400, 'Taken', hasBorder: false),
          _buildLegendItem(AppTheme.accentGold, 'Selected', hasBorder: false),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, {required bool hasBorder}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: hasBorder ? Border.all(color: Colors.grey.shade300) : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textLight)),
      ],
    );
  }

  Widget _buildSeatMap(List<String> takenSeats) {
    return Container(
      width: 280,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ListView.builder(
        itemCount: 15,
        itemBuilder: (context, index) {
          final row = index + 1;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSeat('$row:A', takenSeats),
                const SizedBox(width: 12),
                _buildSeat('$row:B', takenSeats),
                
                SizedBox(
                  width: 40,
                  child: Center(
                    child: Text(
                      row.toString(),
                      style: const TextStyle(color: AppTheme.textLight, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                
                _buildSeat('$row:C', takenSeats),
                const SizedBox(width: 12),
                _buildSeat('$row:D', takenSeats),
            ],
          ));
        },
      ),
    );
  }

  Widget _buildSeat(String rawId, List<String> takenSeats) {
    final parts = rawId.split(':');
    final seatId = '${parts[0]}${parts[1]}';
    
    final isTaken = takenSeats.contains(seatId);
    final isSelected = _selectedSeats.contains(seatId);

    Color color = Colors.white;
    Color borderColor = Colors.grey.shade300;
    
    if (isTaken) {
      color = Colors.grey.shade300;
      borderColor = Colors.grey.shade300;
    } else if (isSelected) {
      color = AppTheme.accentGold;
      borderColor = AppTheme.accentGold;
    }

    return GestureDetector(
      onTap: () => _toggleSeat(seatId, takenSeats),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 42,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
          border: Border.all(color: borderColor),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.accentGold.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: isSelected 
          ? const Center(child: Icon(Icons.check, color: Colors.white, size: 20))
          : null,
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -5),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Selected Seat', style: TextStyle(color: AppTheme.textLight, fontSize: 12)),
              Text(
                _selectedSeats.isEmpty ? 'None' : _selectedSeats.first,
                style: const TextStyle(
                  color: AppTheme.primaryBlue,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _selectedSeats.isNotEmpty 
              ? () {
                  context.read<BookingProvider>().selectSeat(_selectedSeats.first);
                  context.push('/passenger_details');
                } 
              : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Continue', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
