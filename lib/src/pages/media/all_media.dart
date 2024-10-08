import 'package:admin_dashboard/main.dart';
import 'package:admin_dashboard/src/models/moments/moment_model.dart';
import 'package:admin_dashboard/src/services/firestore_service.dart';
import 'package:admin_dashboard/src/widgets/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AllMedia extends StatelessWidget {
  const AllMedia({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();
    return Scaffold(
      body: StreamBuilder<List<MomentModel>>(
        stream: firestoreService.getMoments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No moments found.'));
          }

          final moments = snapshot.data!;
          return ListView.builder(
            itemCount: moments.length,
            itemBuilder: (context, index) {
              final moment = moments[index];

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: moment.userProfilePicture != null &&
                                moment.userProfilePicture.isNotEmpty
                            ? NetworkImage(moment.userProfilePicture)
                            : const AssetImage('assets/png/user.png')
                                as ImageProvider,
                      ),
                      title: Text(moment.userName ?? 'Unknown User'),
                      subtitle: Text(moment.content ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final confirm = await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete Moment'),
                              content: const Text(
                                  'Are you sure you want to delete this moment?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop(false);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop(true);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await firestoreService
                                .deleteMoment(moment.momentId ?? '');
                          }
                        },
                      ),
                    ),
                    if (moment.mediaType != null && moment.mediaUrl != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildMediaWidget(context, moment.mediaUrl),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Likes: ${moment.likesCount ?? 0}  Comments: ${moment.commentsCount ?? 0}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMediaWidget(BuildContext context, String mediaUrl) {
    // Check if mediaUrl is an empty string or null
    if (mediaUrl.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'No media uploaded by the user.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    // Split the CSV into a list of URLs
    final urls = mediaUrl.split(',');

    return Column(
      children: urls.map((url) {
        url = url.trim();

        if (url.isEmpty) {
          return Container(); // Skip empty URLs
        }

        return GestureDetector(
          onTap: () {
            // Navigate to full-screen view
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreenMediaView(url: url),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 200, // Set a fixed height for media
              child: url.contains('.mp4')
                  ? AspectRatio(
                      aspectRatio: 16 / 9,
                      child: VideoPlayerWidget(url: url),
                    )
                  : CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) {
                        print('Error loading image: $error');
                        return const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error),
                            Text('Failed to load image.'),
                          ],
                        );
                      },
                    ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class FullScreenMediaView extends StatelessWidget {
  final String url;

  const FullScreenMediaView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: url.contains('.mp4')
            ? VideoPlayerWidget(url: url) // Use your video player widget
            : InteractiveViewer(
                child: CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.contain,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) {
                    print('Error loading image: $error');
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error),
                        Text('Failed to load image.'),
                      ],
                    );
                  },
                ),
              ),
      ),
    );
  }
}
