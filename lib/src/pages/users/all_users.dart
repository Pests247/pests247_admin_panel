import 'package:admin_dashboard/src/models/user_model.dart';
import 'package:admin_dashboard/src/pages/users/components/user_detail.dart';
import 'package:flutter/material.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key, required this.users});

  final List<UserModel> users;

  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  TextEditingController searchController = TextEditingController();
  List<UserModel> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    filteredUsers = widget.users; // Initialize with all users
  }

  // Method to filter users by username
  void _filterUsers(String query) {
    final results = widget.users.where((user) {
      return user.userName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 800,
      width: double.maxFinite,
      child: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by Username',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _filterUsers(value); // Call filter method on every change
              },
            ),
          ),
          const SizedBox(height: 10),

          // Header Row
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 2, child: Text('Username', style: _headerStyle())),
                Expanded(flex: 3, child: Text('Email', style: _headerStyle())),
                Expanded(
                    flex: 2, child: Text('Country', style: _headerStyle())),
                Expanded(
                    flex: 1, child: Text('Followers', style: _headerStyle())),
              ],
            ),
          ),
          const Divider(thickness: 2),

          // User List
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return MouseRegion(
                  cursor: SystemMouseCursors.click, // Change cursor on hover
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the UserDetailPage and pass the selected user
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetail(user: user),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 2,
                                  child:
                                      Text(user.userName, style: _boldStyle())),
                              Expanded(flex: 3, child: Text(user.email)),
                              Expanded(flex: 2, child: Text(user.country)),
                              Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.people,
                                          color: Colors.grey[600]),
                                      const SizedBox(width: 5),
                                      Text('${user.followers}',
                                          style: TextStyle(
                                              color: Colors.grey[800])),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _boldStyle() =>
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

  TextStyle _headerStyle() => const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.black87,
      );
}
