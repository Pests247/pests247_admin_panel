import 'package:admin_dashboard/src/models/user_model.dart';
import 'package:admin_dashboard/src/pages/users/components/user_detail.dart';
import 'package:flutter/material.dart';

class AllUsers extends StatelessWidget {
  const AllUsers({super.key, required this.users});

  final List<UserModel> users;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 800,
      width: double.maxFinite,
      child: Column(
        children: [
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
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
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
