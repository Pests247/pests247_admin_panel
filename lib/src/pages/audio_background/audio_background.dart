import 'package:admin_dashboard/src/pages/audio_background/add_audio_background.dart';
import 'package:admin_dashboard/src/pages/audio_background/audio_bg_detail.dart';
import 'package:admin_dashboard/src/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AudioBackground extends StatefulWidget {
  const AudioBackground({super.key});

  @override
  AudioBackgroundState createState() => AudioBackgroundState();
}

class AudioBackgroundState extends State<AudioBackground> {
  /// Fix Google Drive URLs for direct access
  // String fixGoogleDriveUrl(String url) {
  //   if (url.contains("drive.google.com") &&
  //       url.contains("uc?export=view&id=")) {
  //     return url.replaceAll("uc?export=view", "uc?export=download");
  //   }
  //   return url;
  // }

  /// Fetch user details by owner IDs
  Future<List<Map<String, dynamic>>> fetchUserDetails(
      List<String> ownerIds) async {
    List<Map<String, dynamic>> userDetails = [];
    for (String userId in ownerIds) {
      final user = await FirestoreService().fetchUserById(userId);
      if (user != null) {
        userDetails.add(user);
      }
    }
    return userDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: FirestoreService().fetchAudioBackgrounds(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No audio backgrounds available."));
          }

          final audioBackgrounds = snapshot.data!;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 3 / 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            padding: const EdgeInsets.all(16),
            itemCount: audioBackgrounds.length,
            itemBuilder: (context, index) {
              final background = audioBackgrounds[index];
              // final fixedUrl = fixGoogleDriveUrl(background['url']);
              final fixedUrl = background['url'];
              final ownerIds = List<String>.from(background['owners']);

              return GestureDetector(
                onTap: () async {
                  final ownerDetails = await fetchUserDetails(ownerIds);
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AudioBackgroundDetail(
                          background: background,
                          ownerDetails: ownerDetails,
                        ),
                      ),
                    );
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: fixedUrl,
                          height: 150,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.broken_image,
                            size: 50,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Price: \$${background['price'].toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Owners: ${ownerIds.length}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddAudioBackground(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
