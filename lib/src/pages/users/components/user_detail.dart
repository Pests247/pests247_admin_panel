import 'package:flutter/material.dart';
import 'package:admin_dashboard/src/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetail extends StatefulWidget {
  final UserModel user;

  const UserDetail({super.key, required this.user});

  @override
  UserDetailState createState() => UserDetailState();
}

class UserDetailState extends State<UserDetail> {
  // List of possible account status values
  final List<String> _accountStatusOptions = [
    'active',
    'banned',
    'suspended',
    'deactivated'
  ];

  // Current account status value
  late String _selectedAccountStatus;

  @override
  void initState() {
    super.initState();
    // Set initial value of _selectedAccountStatus to the user's current account status
    _selectedAccountStatus = widget.user.accountStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.user.userName}\'s Details'),
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
                _buildDetailRow('UID:', widget.user.uid),
                _buildDetailRow('Username:', widget.user.userName),
                _buildDetailRow('Email:', widget.user.email),
                _buildDetailRow('Phone:', widget.user.phone),
                _buildDetailRow('Country:', widget.user.country),
                _buildDetailRow('Gender:', widget.user.gender),
                _buildDetailRow('Age:', '${widget.user.age}'),
                _buildDetailRow('Native Language:', widget.user.nativeLanguage),
                _buildDetailRow('Preferred Languages:',
                    widget.user.preferredLanguages.join(', ')),
                _buildDetailRow(
                    'Self Introduction:', widget.user.selfIntroduction),
                _buildImageRow('Profile Picture', widget.user.profilePicUrl),
                _buildImageRow('Cover Picture', widget.user.coverPicUrl),
                _buildDetailRow(
                    'Device Token:', widget.user.deviceToken ?? 'N/A'),
              ],
            ),

            const SizedBox(height: 20), // Spacer

            // Section 2: Account Information with a Dropdown for Account Status
            _buildSectionTitle('Account Information'),
            _buildInfoCard(
              context,
              children: [
                _buildDetailRow(
                    'Is Admin:', widget.user.isAdmin ? 'Yes' : 'No'),
                _buildDetailRow(
                    'Premium Status:', widget.user.premium ? 'Yes' : 'No'),
                _buildDetailRow(
                    'Is Online:', widget.user.isOnline ? 'Yes' : 'No'),
                _buildDetailRow('ElCoins:', '${widget.user.elCoins}'),
                _buildDetailRow('ElFrags:', '${widget.user.elFrags}'),
                _buildDetailRow('Rank Points:', '${widget.user.rankPoints}'),
                _buildDetailRow('Rank:', '${widget.user.rank}'),
                _buildDropdownRow('Account Status:', _selectedAccountStatus),
                _buildUpdateButton(), // Update button
              ],
            ),

            const SizedBox(height: 20), // Spacer

            // Section 3: Activity Information
            _buildSectionTitle('Activity Information'),
            _buildInfoCard(
              context,
              children: [
                _buildDetailRow('Followers:', '${widget.user.followers}'),
                _buildDetailRow('Following:', '${widget.user.follow}'),
                _buildDetailRow('Visitors:', '${widget.user.visitors}'),
                _buildDetailRow(
                    'Gift Received:', '${widget.user.giftReceived}'),
                _buildDetailRow('Gift Sent:', '${widget.user.giftSent}'),
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

  // Helper function to build a row with an image if URL is provided
  Widget _buildImageRow(String title, String? imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          imageUrl != null && imageUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      color: Colors.red,
                      size: 50,
                    ),
                  ),
                )
              : const Text(
                  'No image available',
                  style: TextStyle(fontSize: 16, color: Colors.redAccent),
                ),
        ],
      ),
    );
  }

  // Helper function to build a dropdown row for account status selection
  Widget _buildDropdownRow(String title, String currentValue) {
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
            child: DropdownButton<String>(
              value: currentValue,
              isExpanded: true,
              items: _accountStatusOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedAccountStatus = newValue;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build the Update button
  Widget _buildUpdateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: ElevatedButton(
        onPressed: _updateAccountStatus,
        child: const Text('Update Account Status'),
      ),
    );
  }

  // Function to update account status in Firestore and refresh UI
  Future<void> _updateAccountStatus() async {
    try {
      // Reference to Firestore document (replace with your collection path)
      final docRef =
          FirebaseFirestore.instance.collection('users').doc(widget.user.uid);

      // Update account status in Firestore
      await docRef.update({'accountStatus': _selectedAccountStatus});

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account status updated successfully')),
      );

      // Refresh UI by updating the state
      setState(() {
        widget.user.accountStatus = _selectedAccountStatus;
      });
    } catch (e) {
      // Show error message if the update fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update account status: $e')),
      );
    }
  }
}
