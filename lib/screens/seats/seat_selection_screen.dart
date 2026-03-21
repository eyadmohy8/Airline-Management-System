import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';

class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({super.key});

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  // Using a simple set to keep track of selected seats
  final Set<String> _selectedSeats = {};
  
  // Mocking taken seats
  final Set<String> _takenSeats = {'1A', '1C', '2B', '4D', '5A', '7C', '7D'};

  void _toggleSeat(String seatId) {
    if (_takenSeats.contains(seatId)) return;
    
    setState(() {
      if (_selectedSeats.contains(seatId)) {
        _selectedSeats.remove(seatId);
      } else {
        // Limiting to 1 seat selection for simplicity in this demo,
        // can be changed to match number of passengers.
        if (_selectedSeats.isNotEmpty) {
          _selectedSeats.clear();
        }
        _selectedSeats.add(seatId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Select Seat', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildAirplaneHeader(),
          _buildSeatLegend(),
          Expanded(
            child: _buildSeatMap(),
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
          // A curved shape to represent the nose of the plane
          Container(
            width: 240,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
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

  Widget _buildSeatMap() {
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ListView.builder(
        itemCount: 15, // 15 rows
        itemBuilder: (context, index) {
          final row = index + 1;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSeat('$row:A'),
                const SizedBox(width: 12),
                _buildSeat('$row:B'),
                
                // Aisle row indicator
                SizedBox(
                  width: 40,
                  child: Center(
                    child: Text(
                      row.toString(),
                      style: const TextStyle(color: AppTheme.textLight, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                
                _buildSeat('$row:C'),
                const SizedBox(width: 12),
                _buildSeat('$row:D'),
            ],
          ));
        },
      ),
    );
  }

  Widget _buildSeat(String rawId) {
    // Format to 1A, 2B etc.
    final parts = rawId.split(':');
    final seatId = '${parts[0]}${parts[1]}';
    
    final isTaken = _takenSeats.contains(seatId);
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
      onTap: () => _toggleSeat(seatId),
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
                    color: AppTheme.accentGold.withOpacity(0.4),
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
            color: Colors.black.withOpacity(0.05),
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
                  context.push('/passenger_details', extra: _selectedSeats.first);
                } 
              : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Continue', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
