import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeadPricesScreen extends StatefulWidget {
  const LeadPricesScreen({super.key});

  @override
  LeadPricesScreenState createState() => LeadPricesScreenState();
}

class LeadPricesScreenState extends State<LeadPricesScreen> {
  final TextEditingController _credit1Controller = TextEditingController();
  final TextEditingController _credit2Controller = TextEditingController();
  final TextEditingController _credit3Controller = TextEditingController();
  final TextEditingController _credit4Controller = TextEditingController();
  final TextEditingController _credit5Controller = TextEditingController();

  bool _isLoading = true;
  Map<String, dynamic> leadPrices = {};

  @override
  void initState() {
    super.initState();
    _fetchLeadPrices();
  }

  // Fetch lead prices from Firestore
  Future<void> _fetchLeadPrices() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('leadsPrices')
          .doc('leadsCredits')
          .get();

      if (doc.exists) {
        setState(() {
          leadPrices = doc.data() as Map<String, dynamic>;

          // Set the fetched values to the controllers
          _credit1Controller.text = leadPrices['credit1'].toString();
          _credit2Controller.text = leadPrices['credit2'].toString();
          _credit3Controller.text = leadPrices['credit3'].toString();
          _credit4Controller.text = leadPrices['credit4'].toString();
          _credit5Controller.text = leadPrices['credit5'].toString();

          _isLoading = false;
        });
      } else {
        print('Document does not exist.');
      }
    } catch (e) {
      print('Error fetching lead prices: $e');
    }
  }

  // Update credits in Firestore
  Future<void> _updateCredits() async {
    try {
      await FirebaseFirestore.instance.collection('leadsPrices').doc('leadsCredits').update({
        'credit1': int.tryParse(_credit1Controller.text) ?? 0,
        'credit2': int.tryParse(_credit2Controller.text) ?? 0,
        'credit3': int.tryParse(_credit3Controller.text) ?? 0,
        'credit4': int.tryParse(_credit4Controller.text) ?? 0,
        'credit5': int.tryParse(_credit5Controller.text) ?? 0,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credits updated successfully!')),
      );
    } catch (e) {
      print('Error updating credits: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update credits')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lead Prices')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildRow('decision1', _credit1Controller),
                  _buildRow('decision2', _credit2Controller),
                  _buildRow('decision3', _credit3Controller),
                  _buildRow('decision4', _credit4Controller),
                  _buildRow('decision5', _credit5Controller),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateCredits,
              child: const Text('Update Credits'),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a row with decision and credit input field
  Widget _buildRow(String decisionKey, TextEditingController creditController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              leadPrices[decisionKey] ?? 'Unknown Decision',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: TextField(
              controller: creditController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
