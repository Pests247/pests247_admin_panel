import 'package:admin_dashboard/src/pages/audio_background/add_audio_background.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:admin_dashboard/src/services/firestore_service.dart';

class AudioBackground extends StatefulWidget {
  const AudioBackground({super.key});

  @override
  AudioBackgroundState createState() => AudioBackgroundState();
}

class AudioBackgroundState extends State<AudioBackground> {
  /// Function to fix Google Drive URLs for direct access
  String fixGoogleDriveUrl(String url) {
    if (url.contains("drive.google.com") &&
        url.contains("uc?export=view&id=")) {
      return url.replaceAll("uc?export=view", "uc?export=download");
    }
    return url;
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

          return ListView.builder(
            itemCount: audioBackgrounds.length,
            itemBuilder: (context, index) {
              final background = audioBackgrounds[index];
              final fixedUrl = fixGoogleDriveUrl(background['url']);
              print("Loading image from URL: $fixedUrl");

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: fixedUrl,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(), // Placeholder while loading
                      errorWidget: (context, url, error) {
                        print(
                            "Error loading image from URL: $url, Error: $error");
                        return const Icon(Icons.broken_image, size: 50);
                      },
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    "Price: \$${background['price'].toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Owners: ${background['owners'].isNotEmpty ? background['owners'].join(', ') : 'None'}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text("Selected Background ID: ${background['id']}"),
                    ));
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddAudioBackground(),
            ),
          );
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
        tooltip: 'Add Background',
      ),
    );
  }
}
