import 'dart:convert';

class UserModel {
  final String accountType;
  final String cardExpiry;
  final String cardNumber;
  final Map<String, dynamic>? companyInfo;
  final int? completedServices;
  final String country;
  final List<dynamic> creditHistoryList;
  final int credits;
  final String deviceToken;
  final String email;
  final String emailTemplate;
  final String lastSeen;
  final List<dynamic> leadLocations;
  final String phone;
  final String? profilePicUrl;
  final Map<String, dynamic> questionAnswerForm;
  final List<dynamic> reviews;
  final String smsTemplate;
  final String uid;
  final String userName;

  UserModel({
    required this.accountType,
    required this.cardExpiry,
    required this.cardNumber,
    this.companyInfo,
    this.completedServices,
    required this.country,
    required this.creditHistoryList,
    required this.credits,
    required this.deviceToken,
    required this.email,
    required this.emailTemplate,
    required this.lastSeen,
    required this.leadLocations,
    required this.phone,
    this.profilePicUrl,
    required this.questionAnswerForm,
    required this.reviews,
    required this.smsTemplate,
    required this.uid,
    required this.userName,
  });

  /// Factory constructor to create `UserModel` from a `Map<String, dynamic>`
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      accountType: map['accountType']?.toString() ?? '',
      cardExpiry: map['cardExpiry']?.toString() ?? '',
      cardNumber: map['cardNumber']?.toString() ?? '',
      companyInfo: map['companyInfo'] is String
          ? jsonDecode(map['companyInfo']) // Convert String JSON to Map
          : map['companyInfo'] as Map<String, dynamic>?, // Already a Map
      completedServices: map['completedServices'] is int
          ? map['completedServices']
          : int.tryParse(map['completedServices']?.toString() ?? '0'),
      country: map['country']?.toString() ?? '',
      creditHistoryList: List<dynamic>.from(map['creditHistoryList'] ?? []),
      credits: map['credits'] is int
          ? map['credits']
          : int.tryParse(map['credits']?.toString() ?? '0') ?? 0,
      deviceToken: map['deviceToken']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      emailTemplate: map['emailTemplate']?.toString() ?? '',
      lastSeen: map['lastSeen']?.toString() ?? '',
      leadLocations: List<dynamic>.from(map['leadLocations'] ?? []),
      phone: map['phone']?.toString() ?? '',
      profilePicUrl: map['profilePicUrl']?.toString(),
      questionAnswerForm: Map<String, dynamic>.from(map['questionAnswerForm'] ?? {}),
      reviews: List<dynamic>.from(map['reviews'] ?? []),
      smsTemplate: map['smsTemplate']?.toString() ?? '',
      uid: map['uid']?.toString() ?? '',
      userName: map['userName']?.toString() ?? '',
    );
  }

  /// Convert `UserModel` to a `Map<String, dynamic>`
  Map<String, dynamic> toMap() {
    return {
      'accountType': accountType,
      'cardExpiry': cardExpiry,
      'cardNumber': cardNumber,
      'companyInfo': companyInfo, // Now properly storing as a Map
      'completedServices': completedServices,
      'country': country,
      'creditHistoryList': creditHistoryList,
      'credits': credits,
      'deviceToken': deviceToken,
      'email': email,
      'emailTemplate': emailTemplate,
      'lastSeen': lastSeen,
      'leadLocations': leadLocations,
      'phone': phone,
      'profilePicUrl': profilePicUrl,
      'questionAnswerForm': questionAnswerForm,
      'reviews': reviews,
      'smsTemplate': smsTemplate,
      'uid': uid,
      'userName': userName,
    };
  }
}
