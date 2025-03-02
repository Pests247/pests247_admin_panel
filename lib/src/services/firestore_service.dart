import 'package:admin_dashboard/src/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;

  static Future<void> deleteRoom(String roomId) async {
    try {
      DocumentReference roomReference = _db.collection('room').doc(roomId);
      await roomReference.delete();
      print("Room with ID $roomId deleted successfully.");
    } catch (e) {
      print("Failed to delete room: $e");
    }
  }

  static Future<void> exchangeFrags(int frags, int coins) async {}

  Future<List<UserModel>> getLeaderBoardData() async {
    try {
      List<UserModel> users = [];

      QuerySnapshot receivedSnapshot = await _db.collection('users').get();
      for (var data in receivedSnapshot.docs) {
        users.add(UserModel.fromMap(data.data() as Map<String, dynamic>));
      }

      print("Fetched users: $users"); // Debugging
      return users;
    } catch (e) {
      print("Error fetching leaderboard data: $e"); // Debugging
      return [];
    }
  }


  static Future<void> storeToken() async {
    try {
      var user = _auth.currentUser;
      if (user != null) {
        String? token = await user.getIdToken();
        String id = user.uid;
        print('$token----------------------------------------------------');
        await _db.collection('users').doc(id).update({
          'deviceToken': token,
        });

        print("Token stored successfully");
      } else {
        print("No user is currently signed in.");
      }
    } catch (e) {
      print("Failed to store token: $e");
    }
  }

  static Future<List<Map<String, dynamic>>> fetchLottie() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('gifts').get();

      List<Map<String, dynamic>> lottie = querySnapshot.docs.map((doc) {
        return {
          'id': doc['id'],
          'giftUrl': doc['giftUrl'],
          'price': doc['price']
        };
      }).toList();

      return lottie;
    } catch (e) {
      print(e);
      Get.snackbar('Error', "Error of lottie");
      return [];
    }
  }

  static Future<void> uploadLottie(String lottie) async {
    try {
      var id = const Uuid().v4();
      await _db.collection('gifts').doc(id).set({'id': id, 'giftUrl': lottie});
    } catch (e) {
      print(e);
    }
  }

  static Future<void> addLanguages(String nativeLang, preferredLang) async {
    try {
      var id = _auth.currentUser!.uid;
      await _db.collection('users').doc(id).update(
          {'nativeLanguage': nativeLang, 'preferredLanguages': preferredLang});
    } catch (e) {
      print(e.toString());
    }
  }


  Future<UserModel?> fetchUserData() async {
    try {
      var userId = _auth.currentUser!.uid;
      final DocumentSnapshot doc =
      await _db.collection('users').doc(userId).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        // print(UserModel.fromJson(data));
        return UserModel.fromMap(data);
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Method to log user activities
  Future<void> logUserActivity(String userId, String action,
      String details) async {
    await FirebaseFirestore.instance.collection('activityLogs').add({
      'userId': userId,
      'action': action,
      'details': details,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}