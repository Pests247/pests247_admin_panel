import 'package:admin_dashboard/src/pages/ranks/add_rank_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:admin_dashboard/src/models/rank_model.dart';
import 'package:admin_dashboard/src/services/firestore_service.dart';

class RanksScreen extends StatefulWidget {
  const RanksScreen({super.key});

  @override
  RanksScreenState createState() => RanksScreenState();
}

class RanksScreenState extends State<RanksScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;
  List<RankModel> _ranks = [];

  @override
  void initState() {
    super.initState();
    _fetchRanks();
  }

  // Method to fetch ranks from Firestore
  Future<void> _fetchRanks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch ranks from Firestore
      final ranks = await _firestoreService.fetchRanks();
      setState(() {
        _ranks = ranks;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load ranks: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method to delete a rank with confirmation dialog
  Future<void> _deleteRank(String rankId) async {
    bool? confirmation = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this rank?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmation == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Delete rank from Firestore
        await _firestoreService.deleteRank(rankId);

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rank deleted successfully!')),
        );

        // Refresh the rank list after deletion
        _fetchRanks();
      } catch (e) {
        // Show error message if deletion fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete rank: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _fetchRanks,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _ranks.isEmpty
              ? const Center(child: Text('No ranks available'))
              : ListView.builder(
                  itemCount: _ranks.length,
                  itemBuilder: (context, index) {
                    RankModel rank = _ranks[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: ListTile(
                        title: Text(
                          rank.name ?? 'Unnamed Rank',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (rank.badge != null && rank.badge.isNotEmpty)
                              CachedNetworkImage(
                                imageUrl: rank.badge,
                                height: 100,
                                width: 100,
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.image_not_supported),
                              ),
                            const SizedBox(height: 8.0),
                            Text('Points: ${rank.points.toString()}'),
                            const SizedBox(height: 8.0),
                            Text('Benefits: ${rank.benefits ?? "None"}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteRank(rank.id ?? ''),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: IconButton(
        onPressed: () async {
          var isRankAdded = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddRankScreen(),
            ),
          );
          if (isRankAdded == true) {
            await _fetchRanks();
            setState(() {});
          }
        },
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        tooltip: 'Add Rank',
      ),
    );
  }
}
