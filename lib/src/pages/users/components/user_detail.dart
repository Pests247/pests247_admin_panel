import 'package:admin_dashboard/src/models/user_model.dart';
import 'package:flutter/material.dart';

class UserDetail extends StatelessWidget {
  final UserModel user;

  const UserDetail({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.userName}\'s Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Personal Information
            _buildSectionTitle('Personal Information'),
            _buildInfoCard(
              context,
              children: [
                _buildDetailRow('Username:', user.userName),
                _buildDetailRow('Email:', user.email),
                _buildDetailRow('Phone:', user.phone),
                _buildDetailRow('Country:', user.country),
                _buildDetailRow('Gender:', user.gender),
                _buildDetailRow('Age:', '${user.age}'),
                _buildDetailRow('Self Introduction:', user.selfIntroduction),
              ],
            ),

            const SizedBox(height: 20), // Spacer

            // Section 2: Account Information
            _buildSectionTitle('Account Information'),
            _buildInfoCard(
              context,
              children: [
                _buildDetailRow('Premium Status:', user.premium ? 'Yes' : 'No'),
                _buildDetailRow('Is Online:', user.isOnline ? 'Yes' : 'No'),
                _buildDetailRow('ElCoins:', '${user.elCoins}'),
                _buildDetailRow('ElFrags:', '${user.elFrags}'),
                _buildDetailRow('Rank Points:', '${user.rankPoints}'),
                _buildDetailRow('Rank:', '${user.rank}'),
              ],
            ),

            const SizedBox(height: 20), // Spacer

            // Section 3: Activity Information
            _buildSectionTitle('Activity Information'),
            _buildInfoCard(
              context,
              children: [
                _buildDetailRow('Followers:', '${user.followers}'),
                _buildDetailRow('Following:', '${user.follow}'),
                _buildDetailRow('Visitors:', '${user.visitors}'),
                _buildDetailRow('Gift Received:', '${user.giftReceived}'),
                _buildDetailRow('Gift Sent:', '${user.giftSent}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build a section title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  // Helper function to build an info card
  Widget _buildInfoCard(BuildContext context,
      {required List<Widget> children}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  // Helper function to build a detailed row with title and value
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
