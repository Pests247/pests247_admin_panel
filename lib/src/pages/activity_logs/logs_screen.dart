import 'package:flutter/material.dart';
import 'package:admin_dashboard/src/services/firestore_service.dart';
import 'package:admin_dashboard/src/models/moments/activity_log_model.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({Key? key}) : super(key: key);

  @override
  LogsScreenState createState() => LogsScreenState();
}

class LogsScreenState extends State<LogsScreen> {
  late Future<List<ActivityLog>> _logsFuture;

  @override
  void initState() {
    super.initState();
    fetchLogs();
  }

  fetchLogs() async {
    _logsFuture = FirestoreService().fetchAllLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<ActivityLog>>(
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
              final logs = snapshot.data!;

              return SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Action')),
                    DataColumn(label: Text('Details')),
                    DataColumn(label: Text('Timestamp')),
                  ],
                  rows: logs.map((log) {
                    return DataRow(
                      cells: [
                        DataCell(Text(log.action)),
                        DataCell(Text(log.details)),
                        DataCell(Text(log.timestamp.toDate().toString())),
                      ],
                    );
                  }).toList(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
