import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../models/flight.dart';
import '../../providers/booking_provider.dart';

class FlightResultsScreen extends StatelessWidget {
  final String origin;
  final String destination;

  const FlightResultsScreen({
    super.key,
    required this.origin,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Select Flight', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildRouteHeader(context, origin, destination),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // Fetch flights matching origin and destination
              stream: FirebaseFirestore.instance
                  .collection('flights')
                  .where('departureCity', isEqualTo: origin)
                  .where('destinationCity', isEqualTo: destination)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        'No flights found for $origin to $destination.\n\n(Tip: Try "New York" to "London" if you seeded the DB)',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final flight = Flight.fromFirestore(docs[index]);
                    return _buildFlightCard(
                      context: context,
                      flight: flight,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteHeader(BuildContext context, String orig, String dest) {
    String safeCode(String city) {
      if (city.isEmpty) return '---';
      return city.substring(0, city.length > 3 ? 3 : city.length).toUpperCase();
    }

    return Container(
      color: AppTheme.primaryBlue,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildAirportCode(safeCode(orig), orig),
            _buildFlightPath(),
            _buildAirportCode(safeCode(dest), dest),
          ],
        ),
      ),
    );
  }

  Widget _buildAirportCode(String code, String city) {
    return Column(
      children: [
        Text(
          code,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          city,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildFlightPath() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const Text(
              '1 Passenger',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.accentGold, width: 2),
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Wrap(
                        direction: Axis.horizontal,
                        children: List.generate(
                          (constraints.constrainWidth() / 8).floor(),
                          (index) => Container(
                            width: 4,
                            height: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            color: Colors.white38,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Icon(
                  FontAwesomeIcons.plane,
                  color: AppTheme.accentGold,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightCard({
    required BuildContext context,
    required Flight flight,
  }) {
    String formatTime(DateTime time) {
      return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    }
    
    final duration = flight.arrivalTime.difference(flight.departureTime);
    final durationStr = '${duration.inHours}h ${duration.inMinutes % 60}m';
    
    return GestureDetector(
      onTap: () {
        // Save the selected flight to the global provider, then move to Seat Selection
        context.read<BookingProvider>().selectFlight(flight);
        context.push('/seats');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(FontAwesomeIcons.planeDeparture, color: AppTheme.primaryBlue, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      flight.flightNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppTheme.textMain,
                      ),
                    ),
                  ],
                ),
                Text(
                  '\$${flight.price.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(color: Color(0xFFF0F0F0)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeColumn(
                  formatTime(flight.departureTime), 
                  (flight.departureCity.length > 3 ? flight.departureCity.substring(0,3) : flight.departureCity).toUpperCase()
                ),
                Column(
                  children: [
                    Text(durationStr, style: const TextStyle(color: AppTheme.textLight, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      width: 60,
                      height: 1,
                      color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                    ),
                    const SizedBox(height: 8),
                    const Text('Direct', style: TextStyle(color: AppTheme.primaryBlue, fontSize: 12)),
                  ],
                ),
                _buildTimeColumn(
                  formatTime(flight.arrivalTime), 
                  (flight.destinationCity.length > 3 ? flight.destinationCity.substring(0,3) : flight.destinationCity).toUpperCase()
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeColumn(String time, String code) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppTheme.textMain,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          code,
          style: const TextStyle(color: AppTheme.textLight, fontSize: 14),
        ),
      ],
    );
  }
}
