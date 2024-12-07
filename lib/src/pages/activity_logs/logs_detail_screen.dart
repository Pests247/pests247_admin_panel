import 'package:flutter/material.dart';
import 'package:admin_dashboard/src/models/user_model.dart';
import 'package:admin_dashboard/src/models/moments/activity_log_model.dart';

class LogsDetailsScreen extends StatelessWidget {
  final UserModel user;
  final List<ActivityLog> logs;

  const LogsDetailsScreen({Key? key, required this.user, required this.logs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${user.userName} Logs')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final log = logs[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12.0),
              child: ListTile(
                title: Text(log.action),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(log.details),
                    const SizedBox(height: 4.0),
                    Text(
                      log.timestamp.toDate().toString(),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
