import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';

class FlightResultsScreen extends StatelessWidget {
  const FlightResultsScreen({super.key});

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
          _buildRouteHeader(context),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: 4,
              itemBuilder: (context, index) {
                final prices = [r'$450', r'$520', r'$600', r'$850'];
                final times = ['08:00 AM', '11:30 AM', '02:15 PM', '06:45 PM'];
                final arrivals = ['10:30 AM', '02:00 PM', '04:45 PM', '09:15 PM'];
                final airlines = ['AeroLine', 'AeroLine Express', 'AeroLine Elite', 'AeroLine'];
                return _buildFlightCard(
                  context: context,
                  airline: airlines[index],
                  departureTime: times[index],
                  arrivalTime: arrivals[index],
                  price: prices[index],
                  duration: '2h 30m',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteHeader(BuildContext context) {
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
            _buildAirportCode('NYC', 'New York'),
            _buildFlightPath(),
            _buildAirportCode('LHR', 'London'),
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
              '14 Oct, 1 Passenger',
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
    required String airline,
    required String departureTime,
    required String arrivalTime,
    required String price,
    required String duration,
  }) {
    return GestureDetector(
      onTap: () {
        context.push('/seats'); // Navigate to seat selection
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
                      airline,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppTheme.textMain,
                      ),
                    ),
                  ],
                ),
                Text(
                  price,
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
                _buildTimeColumn(departureTime, 'NYC'),
                Column(
                  children: [
                    Text(duration, style: const TextStyle(color: AppTheme.textLight, fontSize: 12, fontWeight: FontWeight.bold)),
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
                _buildTimeColumn(arrivalTime, 'LHR'),
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
