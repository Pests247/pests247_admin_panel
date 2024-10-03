import 'package:admin_dashboard/src/models/promotion_model.dart';
import 'package:admin_dashboard/src/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PromotionsScreen extends StatelessWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      body: StreamBuilder<List<Promotion>>(
        stream: firestoreService.getPromotions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No promotions available.'));
          } else {
            final promotions = snapshot.data!;

            return ListView.builder(
              itemCount: promotions.length,
              itemBuilder: (context, index) {
                final promotion = promotions[index];

                return PromotionCard(
                  promotion: promotion,
                  firestoreService: firestoreService,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class PromotionCard extends StatelessWidget {
  final Promotion promotion;
  final FirestoreService firestoreService;

  const PromotionCard({
    super.key,
    required this.promotion,
    required this.firestoreService,
  });

  // Function to show the full image in a dialog
  void _showFullImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: CachedNetworkImage(
            imageUrl: promotion.picture,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.contain,
            width: double.infinity,
            height: MediaQuery.of(context).size.height *
                0.7, // Adjust height as needed
          ),
        );
      },
    );
  }

  // Function to delete the promotion
  Future<void> _deletePromotion(
      String promotionId, BuildContext context) async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content:
              const Text('Are you sure you want to delete this promotion?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // No
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await FirestoreService().deletePromotion(promotionId);
                Navigator.of(context).pop(true); // Yes
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      // Call the delete method from FirestoreService
      await firestoreService.deletePromotion(promotion.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Promotion deleted successfully.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _showFullImage(context), // Show full image on tap
            child: CachedNetworkImage(
              imageUrl: promotion.picture,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
              height: 200.0,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              promotion.text ?? 'No text',
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              promotion.description ?? 'No description',
              style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Added on: ${promotion.dateAdded.toDate().toString()}',
              style: TextStyle(fontSize: 14.0, color: Colors.grey[500]),
            ),
          ),
          if (promotion.dateExpired != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Expires on: ${promotion.dateExpired!.toDate().toString()}',
                style: const TextStyle(fontSize: 14.0, color: Colors.red),
              ),
            ),
          // Delete button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _deletePromotion(promotion.id, context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Change the button color
              ),
              child: const Text(
                'Delete Promotion',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
