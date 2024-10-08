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

  // List of possible premium status values
  final List<String> _premiumStatusOptions = ['Yes', 'No'];

  // Current account and premium status values
  late String _selectedAccountStatus;
  late String _selectedPremiumStatus;

  // Controllers for editable numeric fields
  final TextEditingController _elCoinsController = TextEditingController();
  final TextEditingController _elFragsController = TextEditingController();
  final TextEditingController _rankPointsController = TextEditingController();
  final TextEditingController _rankController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values
    _selectedAccountStatus = widget.user.accountStatus;
    _selectedPremiumStatus = widget.user.premium ? 'Yes' : 'No';
    _elCoinsController.text = '${widget.user.elCoins}';
    _elFragsController.text = '${widget.user.elFrags}';
    _rankPointsController.text = '${widget.user.rankPoints}';
    _rankController.text = '${widget.user.rank}';
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

            // Section 2: Account Information with Dropdowns
            _buildSectionTitle('Account Information'),
            _buildInfoCard(
              context,
              children: [
                _buildDetailRow(
                    'Is Admin:', widget.user.isAdmin ? 'Yes' : 'No'),
                _buildDropdownRow('Premium Status:', _selectedPremiumStatus,
                    _premiumStatusOptions, (String newValue) {
                  setState(() {
                    _selectedPremiumStatus = newValue;
                  });
                }),
                _buildDetailRow(
                    'Is Online:', widget.user.isOnline ? 'Yes' : 'No'),
                _buildNumericInputRow('ElCoins:', _elCoinsController),
                _buildNumericInputRow('ElFrags:', _elFragsController),
                _buildNumericInputRow('Rank Points:', _rankPointsController),
                _buildNumericInputRow('Rank:', _rankController),
                _buildDropdownRow('Account Status:', _selectedAccountStatus,
                    _accountStatusOptions, (String newValue) {
                  setState(() {
                    _selectedAccountStatus = newValue;
                  });
                }),
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

  // Helper function to build a dropdown row for selection
  Widget _buildDropdownRow(String title, String currentValue,
      List<String> options, Function(String) onChanged) {
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
              items: options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build an editable numeric input row
  Widget _buildNumericInputRow(String title, TextEditingController controller) {
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
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a number',
              ),
              onChanged: (value) {
                // Optionally, you can add validation here
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build the update button
  Widget _buildUpdateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          // Prepare data for update
          final updatedUser = UserModel(
            isOnline: widget.user.isOnline,
            visitors: widget.user.visitors,
            follow: widget.user.follow,
            followers: widget.user.followers,
            giftReceived: widget.user.giftReceived,
            giftSent: widget.user.giftSent,
            uid: widget.user.uid,
            userName: widget.user.userName,
            email: widget.user.email,
            phone: widget.user.phone,
            country: widget.user.country,
            gender: widget.user.gender,
            age: widget.user.age,
            nativeLanguage: widget.user.nativeLanguage,
            preferredLanguages: widget.user.preferredLanguages,
            selfIntroduction: widget.user.selfIntroduction,
            profilePicUrl: widget.user.profilePicUrl,
            coverPicUrl: widget.user.coverPicUrl,
            deviceToken: widget.user.deviceToken,
            isAdmin: widget.user.isAdmin,
            elCoins: int.tryParse(_elCoinsController.text) ?? 0,
            elFrags: int.tryParse(_elFragsController.text) ?? 0,
            rankPoints: int.tryParse(_rankPointsController.text) ?? 0,
            rank: int.tryParse(_rankController.text) ?? 0,
            premium: _selectedPremiumStatus == 'Yes',
            accountStatus: _selectedAccountStatus,
            // Add other fields as necessary
          );

          // Call update function here (make sure to implement it)
          await _updateUserDetails(updatedUser);
        },
        child: const Text('Update User Details'),
      ),
    );
  }

  // Placeholder for the function to update user details in the database
  Future<void> _updateUserDetails(UserModel updatedUser) async {
    // Implement your update logic here, e.g., update Firestore or any database
    await FirebaseFirestore.instance
        .collection('users')
        .doc(updatedUser.uid)
        .update({
      'premium': updatedUser.premium,
      'elCoins': updatedUser.elCoins,
      'elFrags': updatedUser.elFrags,
      'rankPoints': updatedUser.rankPoints,
      'rank': updatedUser.rank,
      'accountStatus': updatedUser.accountStatus,
    });

    // Show a message after updating
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User details updated successfully!')),
    );
  }
}
