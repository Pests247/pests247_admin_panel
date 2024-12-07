import 'package:admin_dashboard/src/models/message_model.dart';
import 'package:admin_dashboard/src/models/moments/activity_log_model.dart';
import 'package:admin_dashboard/src/models/moments/moment_model.dart';
import 'package:admin_dashboard/src/models/promotion_model.dart';
import 'package:admin_dashboard/src/models/query_model.dart';
import 'package:admin_dashboard/src/models/rank_model.dart';
import 'package:admin_dashboard/src/models/room_model.dart';
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
        users.add(UserModel.fromJson(data.data() as Map<String, dynamic>));
      }

      return users;
    } catch (e) {
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

  static Stream<List<MessageModel>> fetchMessages(String roomId) {
    return _db
        .collection('room')
        .doc(roomId)
        .collection('message')
        .snapshots()
        .map((QuerySnapshot query) {
      return query.docs.map((doc) => MessageModel.fromDocument(doc)).toList();
    });
  }

  static Future<void> sendMessage(String message, senderId, roomId) async {
    try {
      var id = const Uuid().v4();
      MessageModel messageModel = MessageModel(
          messageId: id,
          senderId: senderId,
          message: message,
          timeStamp: Timestamp.now());
      await _db
          .collection('room')
          .doc(roomId)
          .collection('message')
          .doc(id)
          .set(messageModel.toJson());
    } catch (e) {
      print(e.toString);
      Get.snackbar('Error', e.toString());
    }
  }

  static Future<void> createRoom(String title, type, tag, createdBy,
      List<String> participants, videoId) async {
    try {
      final db = FirebaseFirestore.instance;
      var id = const Uuid().v4();
      RoomModel room = RoomModel(
        title: title,
        roomType: type,
        tag: tag,
        createdBy: createdBy,
        participants: participants,
        videoId: videoId,
        roomID: id,
        views: 0,
      );
      await db.collection('room').doc(id).set(room.toJson());
    } catch (e) {
      print(e.toString());
      Get.snackbar('Error', e.toString());
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
        return UserModel.fromJson(data);
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
  Future<void> logUserActivity(
      String userId, String action, String details) async {
    await FirebaseFirestore.instance.collection('activityLogs').add({
      'userId': userId,
      'action': action,
      'details': details,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  final CollectionReference momentsCollection =
      FirebaseFirestore.instance.collection('moments');

  // Fetch all moments
  Stream<List<MomentModel>> getMoments() {
    return momentsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        print(doc.data() as Map<String, dynamic>);
        return MomentModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Delete a moment by momentId
  Future<void> deleteMoment(String momentId) async {
    try {
      await momentsCollection.doc(momentId).delete();
    } catch (e) {
      print('Failed to delete moment: $e');
    }
  }

  // Reference to the 'promotions' collection in Firestore
  final CollectionReference promotionsCollection =
      FirebaseFirestore.instance.collection('promotions');

  // Add a new promotion to Firestore
  Future<void> addPromotion(Promotion promotion) async {
    try {
      // Create a new document in the 'promotions' collection prmotion ID
      await promotionsCollection.doc(promotion.id).set(promotion.toJson());
      print('Promotion added successfully');
    } catch (e) {
      print('Error adding promotion: $e');
      rethrow;
    }
  }

  // Update an existing promotion in Firestore
  Future<void> updatePromotion(String id, Promotion updatedPromotion) async {
    try {
      // Update the document with the given ID
      await promotionsCollection.doc(id).update(updatedPromotion.toJson());
      print('Promotion updated successfully');
    } catch (e) {
      print('Error updating promotion: $e');
      rethrow;
    }
  }

  // Delete a promotion from Firestore and Firebase Storage
  Future<void> deletePromotion(String id) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    try {
      // Delete the document with the given ID from Firestore
      await promotionsCollection.doc(id).delete();
      print('Promotion deleted successfully from Firestore');

      // Delete the image from Firebase Storage
      await storage.refFromURL('promotions/$id').delete();
      print('Image deleted successfully from Firebase Storage');
    } catch (e) {
      print('Error deleting promotion: $e');
      rethrow;
    }
  }

  // Fetch all promotions from Firestore
  Stream<List<Promotion>> getPromotions() {
    return promotionsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Promotion.fromJson(doc.data() as Map<String, dynamic>)
            .copyWith(id: doc.id);
      }).toList();
    });
  }

  // Fetch a single promotion by its ID
  Future<Promotion?> getPromotionById(String id) async {
    try {
      final doc = await promotionsCollection.doc(id).get();
      if (doc.exists) {
        return Promotion.fromJson(doc.data() as Map<String, dynamic>)
            .copyWith(id: doc.id);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching promotion by ID: $e');
      rethrow;
    }
  }

  Future<List<ActivityLog>> fetchAllLogs() async {
    List<ActivityLog> allLogs = [];

    print('Fetching all logs from all users');

    try {
      // Fetching all documents from the 'activityLogs' collection
      final logDocs =
          await FirebaseFirestore.instance.collection('activityLogs').get();

      // Check if logDocs is empty
      if (logDocs.docs.isEmpty) {
        print('No user documents found in activityLogs');
        return allLogs; // Return empty list if no user documents
      }

      // Iterate through each document in the 'activityLogs' collection
      for (var logDoc in logDocs.docs) {
        // Fetch logs for each user
        final userLogsSnapshot =
            await FirebaseFirestore.instance.collection('activityLogs').get();

        // Ensure userLogsSnapshot is not empty
        if (userLogsSnapshot.docs.isNotEmpty) {
          allLogs.addAll(userLogsSnapshot.docs
              .map((logDoc) => ActivityLog.fromMap(logDoc.data())));
          print(
              'Fetched logs for userDoc (email): ${logDoc.id}, logs: ${userLogsSnapshot.docs.length}');
        } else {
          print('No logs found for userDoc (email): ${logDoc.id}');
        }
      }

      print('Total logs fetched: ${allLogs.length}');
      return allLogs;
    } catch (e) {
      print('Error fetching all logs: $e');
      return [];
    }
  }

  /// Fetches all logs for a specific user identified by their [email].
  Future<List<ActivityLog>> fetchUserLogs(String email) async {
    try {
      final userLogsSnapshot = await _db
          .collection('activityLogs') // Collection for all activity logs
          .doc(
              email) // Document for the specific user identified by their email
          .collection('logs') // Collection for the user's logs
          .orderBy('timestamp', descending: true) // Order by timestamp
          .get();

      // Convert each document snapshot into an ActivityLog model
      return userLogsSnapshot.docs
          .map((doc) => ActivityLog.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching logs: $e');
      return [];
    }
  }

  /// Deletes a specific log for a user identified by [email] and [logId].
  Future<void> deleteUserLog(String email, String logId) async {
    try {
      await _db
          .collection('activityLogs') // Collection for all activity logs
          .doc(
              email) // Document for the specific user identified by their email
          .collection('logs') // Collection for the user's logs
          .doc(logId) // Specific log document identified by logId
          .delete();

      print('Log with ID: $logId deleted successfully.');
    } catch (e) {
      print('Error deleting log: $e');
    }
  }

  /// Deletes all logs for a specific user identified by their [email].
  Future<void> deleteAllUserLogs(String email) async {
    try {
      final userLogsSnapshot = await _db
          .collection('activityLogs')
          .doc(email)
          .collection('logs')
          .get();

      final batch = _db.batch();

      for (var doc in userLogsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      print('All logs for user with email: $email deleted successfully.');
    } catch (e) {
      print('Error deleting all logs: $e');
    }
  }

  Future<Map<String, String?>> fetchContactInfo() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('contacts')
          .doc('contact_info')
          .get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        // Retrieve the fields
        String? email = documentSnapshot.get('email');
        String? phone = documentSnapshot.get('phone');

        // Return the values in a Map
        return {'email': email, 'phone': phone};
      } else {
        print('Document does not exist.');
        return {'email': null, 'phone': null};
      }
    } catch (e) {
      print('Error fetching contact info: $e');
      return {'email': null, 'phone': null};
    }
  }

  Future<void> updateContactInfo(
      {required String email, required String phone}) async {
    try {
      await FirebaseFirestore.instance
          .collection('contacts')
          .doc('contact_info')
          .update({
        'email': email,
        'phone': phone,
      });
      print('Contact info updated successfully!');
    } catch (e) {
      print('Error updating contact info: $e');
    }
  }

  // Method to fetch all FAQs from Firestore
  Future<List<Map<String, String>>> fetchFAQs() async {
    List<Map<String, String>> faqs = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('frequent_questions')
          .get();

      // Iterate through the documents in the collection
      for (var doc in querySnapshot.docs) {
        faqs.add({
          'question': doc.get('question'),
          'answer': doc.get('answer'),
          'id': doc.get('id'),
        });
      }
    } catch (e) {
      print('Error fetching FAQs: $e');
    }

    return faqs;
  }

// Method to add a new FAQ with a custom document ID
  Future<void> addFAQ(String question, String answer) async {
    try {
      // Generate a unique ID using the uuid package
      String docId = const Uuid().v4();

      // Add the new FAQ to Firestore with the custom document ID
      await FirebaseFirestore.instance
          .collection('frequent_questions')
          .doc(docId)
          .set({
        'id': docId, // Store the document ID in the 'id' field
        'question': question,
        'answer': answer,
      });

      print('FAQ added successfully with ID: $docId');
    } catch (e) {
      print('Error adding FAQ: $e');
    }
  }

  // Method to delete an FAQ by document ID
  Future<void> deleteFAQ(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('frequent_questions')
          .doc(docId)
          .delete();
      print('FAQ deleted successfully');
    } catch (e) {
      print('Error deleting FAQ: $e');
    }
  }

  // Method to fetch all queries from Firestore
  Future<List<QueryModel>> fetchAllQueries() async {
    try {
      // Fetch all documents in the 'queries' collection
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('queries').get();

      // Convert each document to a QueryModel and return as a list
      return snapshot.docs
          .map((doc) => QueryModel.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      print('Error fetching queries: $e');
      return [];
    }
  }

  // Ranks
  final CollectionReference _rankCollection =
      FirebaseFirestore.instance.collection('ranks');
  // Add a new rank to Firestore
  Future<void> addRank(RankModel rank) async {
    try {
      await _rankCollection.doc(rank.id).set(rank.toMap());
    } catch (e) {
      print('Error adding rank: $e');
      rethrow;
    }
  }

  // Fetch all ranks from Firestore
  Future<List<RankModel>> fetchRanks() async {
    try {
      QuerySnapshot querySnapshot = await _rankCollection.get();
      return querySnapshot.docs
          .map((doc) => RankModel.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      print('Error fetching ranks: $e');
      rethrow;
    }
  }

  // Delete a rank from Firestore by id and its image from Storage
  Future<void> deleteRank(String id) async {
    try {
      // Delete the rank's image from Firebase Storage
      final storageRef =
          FirebaseStorage.instance.ref().child('rank_badges/$id.jpg');
      await storageRef.delete();

      // Then delete the rank document from Firestore
      await _rankCollection.doc(id).delete();

      print('Rank deleted successfully.');
    } catch (e) {
      print('Error deleting rank or image: $e');
      rethrow;
    }
  }

  final CollectionReference audioBackgroundCollection =
      FirebaseFirestore.instance.collection('audioBackground');

  // Method to create a new audioBackground document
  Future<void> createAudioBackground({
    required String id,
    required List<String> owners,
    required double price,
    required String url,
  }) async {
    try {
      await audioBackgroundCollection.doc(id).set({
        'id': id,
        'owners': owners,
        'price': price,
        'url': url,
      });
      print("Audio background added successfully!");
    } catch (e) {
      print("Failed to add audio background: $e");
    }
  }

  // Method to fetch all audioBackground documents
  Future<List<Map<String, dynamic>>> fetchAudioBackgrounds() async {
    try {
      QuerySnapshot querySnapshot = await audioBackgroundCollection.get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Failed to fetch audio backgrounds: $e");
      return [];
    }
  }

  // Fetch user details by ID
  Future<Map<String, dynamic>?> fetchUserById(String userId) async {
    try {
      final docSnapshot = await _db.collection('users').doc(userId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching user by ID: $e");
      return null;
    }
  }
}
