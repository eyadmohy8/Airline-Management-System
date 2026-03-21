import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme.dart';

class ManifestDashboardScreen extends StatelessWidget {
  const ManifestDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Flight AL-421 Manifest', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.download, size: 20),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildStatsHeader(),
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Text('Passenger List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: 8,
              itemBuilder: (context, index) {
                return _buildPassengerTile(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader() {
    return Container(
      color: AppTheme.primaryBlue,
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total', '186'),
          _buildStatItem('Checked In', '142'),
          _buildStatItem('Boarding', '8'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    return Column(
      children: [
        Text(count, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildPassengerTile(int index) {
    final names = ['Alex Johnson', 'Maria Garcia', 'James Smith', 'Linda Brown', 'Robert Davis', 'Michael Miller', 'William Wilson', 'David Moore'];
    final seats = ['1A', '2B', '3C', '4D', '5A', '6B', '7C', '8D'];
    final statuses = ['Checked In', 'Boarded', 'Checked In', 'Pending', 'Boarded', 'Checked In', 'Pending', 'Checked In'];
    final isBoarded = statuses[index] == 'Boarded';
    final isPending = statuses[index] == 'Pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppTheme.backgroundLight,
          child: Text(
            seats[index],
            style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        title: Text(names[index], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Ticket: AL829${index}394'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isBoarded ? Colors.green.shade50 : (isPending ? Colors.orange.shade50 : Colors.blue.shade50),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            statuses[index],
            style: TextStyle(
              color: isBoarded ? Colors.green.shade700 : (isPending ? Colors.orange.shade700 : AppTheme.primaryBlue),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
