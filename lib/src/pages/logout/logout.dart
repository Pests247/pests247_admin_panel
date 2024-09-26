import 'package:admin_dashboard/src/pages/login/log_in_page.dart';
import 'package:admin_dashboard/src/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  bool loading = false;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      width: width * 0.3,
      constraints: BoxConstraints(
        minHeight: height * 0.7,
        maxHeight: height * 0.8,
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: width * 0.15,
            width: width * 0.15,
            child: Image.asset(
              "assets/png/logout.png",
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: height * 0.05),
          Text(
            "Oh no! You're leaving...\nAre you sure?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: width * 0.02,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
          SizedBox(height: height * 0.05),
          CustomButton(
            title: "Yes, Log Me Out",
            loading: loading,
            onTap: () async {
              setState(() {
                loading = true;
              });
              await Future.delayed(const Duration(seconds: 2), () async {
                await auth.signOut();
              });
              setState(() {
                loading = false;
              });

              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}
