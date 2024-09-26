import 'package:admin_dashboard/src/pages/homepage/homepage.dart';
import 'package:admin_dashboard/src/utility/custom_snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInService {
  static void signInWithGoogle(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      GoogleSignIn googleSignIn = GoogleSignIn();

      await googleSignIn.signOut();

      GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return;
      }

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await auth.signInWithCredential(credential);

      var id = auth.currentUser!.uid;

      final userDoc = await firestore.collection('users').doc(id).get();
      // await FirestoreServices.storeToken();
      if (userDoc.exists) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        Get.to(const Homepage());
      }
      // else {
      //   Get.to(DetailScreen(
      //     userName: userCredential.user!.displayName ?? 'Unknown User',
      //     photoUrl: userCredential.user!.photoURL ?? 'https://example.com/default-photo.png',
      //     email: userCredential.user!.email ?? 'No Email',
      //     phone: userCredential.user!.phoneNumber ?? '',
      //   ));
      // }
    } catch (e) {
      print(e);
      CustomSnackbar.showSnackBar(
        'Error',
        e.toString(),
        const Icon(Icons.error_outline),
        Colors.black,
        context,
      );
    }
  }
}
