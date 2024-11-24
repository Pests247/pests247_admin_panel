import 'package:admin_dashboard/src/models/moments/moment_model.dart';
import 'package:admin_dashboard/src/services/firestore_service.dart';
import 'package:admin_dashboard/src/widgets/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AllMedia extends StatefulWidget {
  const AllMedia({super.key});

  @override
  State<AllMedia> createState() => _AllMediaState();
}

class _AllMediaState extends State<AllMedia> {
  final FirestoreService firestoreService = FirestoreService();
  String searchQuery = '';
  String? selectedUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Media'),
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by user name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<MomentModel>>(
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

                final moments = snapshot.data!
                    .where((moment) => moment.userName != null)
                    .toList();

                // Apply search filter
                final filteredMoments = moments.where((moment) {
                  if (searchQuery.isEmpty) return true;
                  return moment.userName.toLowerCase().contains(searchQuery);
                }).toList();

                // Group moments by user
                final usersWithMoments = {
                  for (var moment in filteredMoments) moment.userName: moment
                }.keys.toList();

                return ListView.builder(
                  itemCount: usersWithMoments.length,
                  itemBuilder: (context, index) {
                    final userName = usersWithMoments[index];
                    final userMoments = filteredMoments
                        .where((moment) => moment.userName == userName)
                        .toList();

                    // Assuming each user has the same profile picture across all moments
                    final userProfilePicture =
                        userMoments.first.userProfilePicture;

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          userName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: userProfilePicture != null &&
                                  userProfilePicture.isNotEmpty
                              ? NetworkImage(userProfilePicture)
                              : const AssetImage('assets/png/user.png')
                                  as ImageProvider,
                        ),
                        trailing: Text(
                          'Moments: ${userMoments.length}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        onTap: () {
                          setState(() {
                            selectedUser = userName;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserMediaScreen(
                                userName: userName,
                                userMoments: userMoments,
                                firestoreService: firestoreService,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Screen to display selected user's moments
class UserMediaScreen extends StatelessWidget {
  final String userName;
  final List<MomentModel> userMoments;
  final FirestoreService firestoreService;

  const UserMediaScreen({
    super.key,
    required this.userName,
    required this.userMoments,
    required this.firestoreService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$userName\'s Moments'),
      ),
      body: ListView.builder(
        itemCount: userMoments.length,
        itemBuilder: (context, index) {
          final moment = userMoments[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: moment.userProfilePicture != null &&
                                moment.userProfilePicture.isNotEmpty
                            ? NetworkImage(moment.userProfilePicture)
                            : const AssetImage('assets/png/user.png')
                                as ImageProvider,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              moment.userName ?? 'Unknown User',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(moment.content ?? ''),
                          ],
                        ),
                      ),
                      IconButton(
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
                    ],
                  ),
                ),
                if (moment.mediaType != null && moment.mediaUrl != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildMediaPreview(context, moment),
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
      ),
    );
  }

  Widget _buildMediaPreview(BuildContext context, MomentModel moment) {
    final urls =
        moment.mediaUrl?.split(',').map((url) => url.trim()).toList() ?? [];
    final firstThreeUrls = urls.take(3).toList();

    return Column(
      children: [
        Row(
          children: firstThreeUrls.map((url) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: SizedBox(
                height: 100,
                width: 100,
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
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
              ),
            );
          }).toList(),
        ),
        if (urls.length > 3)
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullMediaView(mediaUrls: urls),
                ),
              );
            },
            child: const Text('See All Media'),
          ),
      ],
    );
  }
}

class FullMediaView extends StatelessWidget {
  final List<String> mediaUrls;

  const FullMediaView({super.key, required this.mediaUrls});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Media'),
      ),
      body: ListView.builder(
        itemCount: mediaUrls.length,
        itemBuilder: (context, index) {
          final url = mediaUrls[index];
          return GestureDetector(
            onTap: () {
              print('myurl: $url');
              // Navigate to FullScreenMediaView on tap
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenMediaView(mediaUrl: url),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 300,
                child: url.contains('.mp4')
                    ? VideoPlayerWidget(url: url)
                    : CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FullScreenMediaView extends StatelessWidget {
  final String mediaUrl;

  const FullScreenMediaView({super.key, required this.mediaUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: mediaUrl.contains('.mp4')
            ? VideoPlayerWidget(url: mediaUrl)
            : CachedNetworkImage(
                imageUrl: mediaUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: Colors.white),
              ),
      ),
    );
  }
}
