import 'package:admin_dashboard/src/models/user_model.dart';
import 'package:admin_dashboard/src/pages/activity_logs/logs_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_dashboard/src/models/moments/activity_log_model.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({Key? key}) : super(key: key);

  @override
  LogsScreenState createState() => LogsScreenState();
}

class LogsScreenState extends State<LogsScreen> {
  late Future<Map<UserModel, List<ActivityLog>>> _logsFuture;

  @override
  void initState() {
    super.initState();
    _logsFuture = fetchLogs();
  }

  Future<Map<UserModel, List<ActivityLog>>> fetchLogs() async {
    final logsSnapshot = await FirebaseFirestore.instance
        .collection('activityLogs')
        .orderBy('timestamp', descending: true)
        .get();

    final usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    // Map userId to UserModel
    final usersMap = {
      for (var doc in usersSnapshot.docs) doc.id: UserModel.fromMap(doc.data()),
    };

    // Group logs by userId
    final Map<UserModel, List<ActivityLog>> groupedLogs = {};
    for (var doc in logsSnapshot.docs) {
      final log = ActivityLog.fromMap(doc.data());
      final user = usersMap[log.userId];

      if (user != null) {
        groupedLogs.putIfAbsent(user, () => []).add(log);
      }
    }

    return groupedLogs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<UserModel, List<ActivityLog>>>(
          future: _logsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No logs available'),
              );
            } else {
              final groupedLogs = snapshot.data!;

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 14 / 10,
                ),
                itemCount: groupedLogs.keys.length,
                itemBuilder: (context, index) {
                  final user = groupedLogs.keys.elementAt(index);
                  final logs = groupedLogs[user]!;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LogsDetailsScreen(user: user, logs: logs),
                        ),
                      );
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: user.profilePicUrl != null
                                  ? NetworkImage(user.profilePicUrl!)
                                  : null,
                              radius: 40,
                              child: user.profilePicUrl == null
                                  ? const Icon(Icons.person, size: 40)
                                  : null,
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              user.userName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              user.email,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
