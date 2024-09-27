import 'package:admin_dashboard/src/models/user_model.dart';
import 'package:admin_dashboard/src/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String _errorMessage = '';
  List<UserModel> allUsers = [];

  UserProvider() {
    fetchUserData();
    fetchAllUsers();
  }

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> makeExchange(int coins, int frags) async {
    _isLoading = true;
    notifyListeners();

    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore db = FirebaseFirestore.instance;
      var userId = auth.currentUser!.uid;
      await db.collection('users').doc(userId).update({
        'elCoins': FieldValue.increment(coins),
        'elFrags': FieldValue.increment(-frags),
      });
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print(e.toString());
    }
  }

  Future<void> fetchUserData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await FirestoreServices().fetchUserData();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Error fetching user data: $e';
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllUsers() async {
    allUsers = await FirestoreServices().getLeaderBoardData();
    for (var user in allUsers) {
      print(user.toJson());
    }
  }

  void updateProfilePic(String profilePicUrl) {
    if (_user != null) {
      _user!.profilePicUrl = profilePicUrl;
      notifyListeners();
    }
  }

  void updateCoverPic(String coverPicUrl) {
    if (_user != null) {
      _user!.coverPicUrl = coverPicUrl;
      notifyListeners();
    }
  }
}
