import 'package:admin_dashboard/src/pages/homepage/homepage.dart';
import 'package:admin_dashboard/src/res/colors.dart';
import 'package:admin_dashboard/src/shared/exc_button.dart';
import 'package:admin_dashboard/src/shared/input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String email = '';
  String password = '';
  bool isPassHidden = true;

  void togglePasswordVisibility() {
    setState(() {
      isPassHidden = !isPassHidden;
    });
  }

  Future<void> login() async {
    try {
      // Check Firestore for admin access
      DocumentSnapshot adminDoc =
          await _firestore.collection('admins').doc(email).get();

      if (adminDoc.exists && adminDoc['haveAccess'] == true) {
        // Proceed with Firebase Authentication
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        // Navigate to homepage if login is successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()),
        );
      } else {
        // Show error if the admin does not exist or does not have access
        _showErrorDialog("Access denied. You are not authorized.");
      }
    } on FirebaseAuthException catch (e) {
      // Handle errors from Firebase Authentication
      _showErrorDialog(e.message ?? "An error occurred during login.");
    } catch (e) {
      // Handle any other errors
      _showErrorDialog("An unexpected error occurred.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                FormSection(
                  isPassHidden: isPassHidden,
                  onEmailChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  onPasswordChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  togglePasswordVisibility: togglePasswordVisibility,
                  onLogin: login,
                ),
                const _ImageSection(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FormSection extends StatelessWidget {
  const FormSection({
    super.key,
    required this.isPassHidden,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.togglePasswordVisibility,
    required this.onLogin,
  });

  final bool isPassHidden;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback togglePasswordVisibility;
  final Future<void> Function() onLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.neutral,
      width: 448,
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/png/logo.png',
            filterQuality: FilterQuality.high,
            width: 200,
            height: 150,
          ),
          const SizedBox(height: 30),
          const Text(
            "Log in",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25.63),
          ),
          const SizedBox(height: 41),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Email Address",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          const SizedBox(height: 9),
          InputText(
            labelText: "example@gmail.com",
            keyboardType: TextInputType.emailAddress,
            onChanged: onEmailChanged,
            onSaved: (val) {},
            textInputAction: TextInputAction.next,
            isPassword: false,
            enabled: true,
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Password",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          const SizedBox(height: 9),
          InputText(
            labelText: "********",
            keyboardType: TextInputType.visiblePassword,
            onChanged: onPasswordChanged,
            onSaved: (val) {},
            textInputAction: TextInputAction.done,
            isPassword: isPassHidden,
            enabled: true,
            suffixIcon: IconButton(
              icon: Icon(
                isPassHidden ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: togglePasswordVisibility,
            ),
          ),
          const SizedBox(height: 25),
          // Row(
          //   children: [
          //     SizedBox(
          //         width: 20,
          //         child: Checkbox(value: false, onChanged: (newValue) {})),
          //     const SizedBox(width: 10),
          //     const Text(
          //       "Remember me",
          //       style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          //     ),
          //     const Spacer(),
          //     const Text(
          //       "Reset Password?",
          //       style: TextStyle(
          //           color: AppColors.primary,
          //           fontWeight: FontWeight.w500,
          //           fontSize: 16),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 40),
          AppButton(
            height: 50,
            width: 348,
            verticalPadding: 0,
            color: AppColors.primary,
            onPressed: onLogin,
            child: const Text(
              "Log in",
              style: TextStyle(
                  color: AppColors.neutral,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ),
          const SizedBox(height: 30),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     const Text(
          //       "Don’t have account yet?",
          //       style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          //     ),
          //     TextButton(
          //       style: TextButton.styleFrom(
          //         backgroundColor: Colors.transparent,
          //         foregroundColor: Colors.transparent,
          //       ),
          //       onPressed: () {
          //         GetIt.I
          //             .get<NavigationService>()
          //             .to(routeName: PageRoutes.signup);
          //       },
          //       child: const Text(
          //         " New Account",
          //         style: TextStyle(
          //             color: AppColors.primary,
          //             fontWeight: FontWeight.w500,
          //             fontSize: 16),
          //       ),
          //     )
          //   ],
          // ),
        ],
      ),
    );
  }
}

class _ImageSection extends StatelessWidget {
  const _ImageSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: SvgPicture.asset(
          "assets/svg/login.svg",
          width: 647,
          height: 602,
        ),
      ),
    );
  }
}
