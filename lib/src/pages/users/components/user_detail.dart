import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_dashboard/src/models/user_model.dart';
import 'dart:convert'; // Required for JSON decoding

class UserDetailsScreen extends StatefulWidget {
  final UserModel user;

  const UserDetailsScreen({super.key, required this.user});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final TextEditingController _creditsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.user.userName} Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Personal Information'),
            _buildInfoCard([
              _buildDetailRow('UID:', widget.user.uid),
              _buildDetailRow('Username:', widget.user.userName),
              _buildDetailRow('Email:', widget.user.email),
              _buildDetailRow('Phone:', widget.user.phone),
              _buildDetailRow('Country:', widget.user.country),
              _buildDetailRow('Account Type:', widget.user.accountType),
              _buildDetailRow('Last Seen:', widget.user.lastSeen),
              _buildImageRow('Profile Picture', widget.user.profilePicUrl),
              _buildCompanyInfoRow('Company Info',widget.user.companyInfo ?? {}),

            ]),

            _buildSectionTitle('Financial Information'),
            _buildInfoCard([
              // _buildDetailRow('Card Number:', widget.user.cardNumber),
              // _buildDetailRow('Card Expiry:', widget.user.cardExpiry),
              _buildNumericInputRow('Credits:', _creditsController),
              _buildListRow('Credit History:', widget.user.creditHistoryList),
            ]),

            _buildSectionTitle('Activity Information'),
            _buildInfoCard([
              _buildDetailRow('Completed Services:', widget.user.completedServices?.toString() ?? '0'),
              _buildDetailRow('Email Template:', widget.user.emailTemplate),
              _buildDetailRow('SMS Template:', widget.user.smsTemplate),
              _buildListRow('Lead Locations:', widget.user.leadLocations),
              _buildListRow('Reviews:', widget.user.reviews),
              _buildMapRow('Question & Answer Form:', widget.user.questionAnswerForm),
            ]),

            // _buildUpdateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
      ),
    );
  }

  Widget _buildCompanyInfoRow(String title, Map<String, dynamic>? companyInfo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 8),

          // Check if companyInfo is null or empty
          if (companyInfo == null || companyInfo.isEmpty)
            const Text('No company information available', style: TextStyle(color: Colors.redAccent))
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoItem("🏢 Company Name:", companyInfo["name"]),
                _buildInfoItem("📍 Location:", companyInfo["location"]),
                _buildInfoItem("📧 Email:", companyInfo["emailAddress"]),
                _buildInfoItem("📞 Phone:", companyInfo["phoneNumber"]),
                _buildInfoItem("🌐 Website:", companyInfo["website"]),
                _buildInfoItem("👥 Company Size:", companyInfo["size"]),
                _buildInfoItem("🎯 Experience:", companyInfo["experience"]),
                _buildInfoItem("📝 Description:", companyInfo["description"]),

                if (companyInfo["logo"] != null && companyInfo["logo"].isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      const Text("📌 Company Logo:", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Image.network(companyInfo["logo"], height: 80, width: 80, fit: BoxFit.cover),
                    ],
                  ),
              ],
            ),
        ],
      ),
    );
  }


  Widget _buildInfoItem(String label, String? value) {
    return value != null && value.isNotEmpty
        ? Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    )
        : const SizedBox.shrink(); // Hide if no value is present
  }



  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 5, child: Text(value, overflow: TextOverflow.visible)),
        ],
      ),
    );
  }

  Widget _buildImageRow(String title, String? imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          imageUrl != null && imageUrl.isNotEmpty
              ? Image.network(imageUrl, height: 100, width: 100, fit: BoxFit.cover)
              : const Text('No image available', style: TextStyle(color: Colors.redAccent)),
        ],
      ),
    );
  }

  Widget _buildNumericInputRow(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
            flex: 5,
            child: Text(widget.user.credits.toString()),
          ),
        ],
      ),
    );
  }

  Widget _buildListRow(String title, List<dynamic> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 8),
          items.isNotEmpty
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.map((item) {
              String location = item['location'] ?? 'Unknown Location';
              String postalCode = item['postalCode'] ?? 'N/A';
              String miles = item['miles'] ?? 'N/A';
              String driveTime = item['driveTime'] ?? 'N/A';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("📍 Location: $location", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text("📌 Postal Code: $postalCode", style: const TextStyle(color: Colors.black87)),
                    if (miles != 'N/A') Text("🛣 Miles: $miles", style: const TextStyle(color: Colors.black87)),
                    if (driveTime != 'N/A') Text("⏳ Drive Time: $driveTime", style: const TextStyle(color: Colors.black87)),
                    const Divider(), // Adds a separator between locations
                  ],
                ),
              );
            }).toList(),
          )
              : const Text('No data available', style: TextStyle(color: Colors.redAccent)),
        ],
      ),
    );
  }


  Widget _buildMapRow(String title, Map<String, dynamic> data) {
    // Separate questions and answers
    List<MapEntry<String, dynamic>> questions = [];
    List<MapEntry<String, dynamic>> answers = [];

    data.entries.forEach((entry) {
      if (entry.key.startsWith('question')) {
        questions.add(entry);
      } else if (entry.key.startsWith('answer')) {
        answers.add(entry);
      }
    });

    // Sort questions and answers separately based on number
    questions.sort((a, b) => a.key.compareTo(b.key));
    answers.sort((a, b) => a.key.compareTo(b.key));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          questions.isNotEmpty
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(questions.length, (index) {
              String questionText = questions[index].value.toString();
              String answerText = (index < answers.length) ? answers[index].value.toString() : "No answer provided";

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Question No ${index + 1}",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                    const SizedBox(height: 4),
                    Text(questionText, style: const TextStyle(fontWeight: FontWeight.bold)), // Question
                    const SizedBox(height: 4),
                    Text(answerText, style: const TextStyle(color: Colors.black87)), // Answer
                  ],
                ),
              );
            }),
          )
              : const Text('No data available', style: TextStyle(color: Colors.redAccent)),
        ],
      ),
    );
  }





  // Widget _buildUpdateButton() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 16.0),
  //     child: ElevatedButton(
  //       onPressed: () async {
  //         int updatedCredits = int.tryParse(_creditsController.text) ?? widget.user.credits;
  //
  //         await FirebaseFirestore.instance.collection('users').doc(widget.user.uid).update({
  //           'credits': updatedCredits,
  //         });
  //
  //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User details updated successfully!')));
  //       },
  //       child: const Text('Update User Details'),
  //     ),
  //   );
  // }
}
