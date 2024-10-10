class UserModel {
  final String uid;
  final String? deviceToken;
  final String userName;
  final String email;
  final bool isAdmin;
  String? profilePicUrl;
  String? coverPicUrl;
  final String nativeLanguage;
  final List<String> preferredLanguages;
  final String country;
  final int followers;
  final int follow;
  final int visitors;
  final int rank;
  final bool isPremium;
  final String selfIntroduction;
  final int age;
  final String gender;
  final bool isOnline;
  final int giftReceived;
  final int giftSent;
  final String phone;
  final int elCoins;
  final int elFrags;
  final int rankPoints;
  String accountStatus;

  UserModel({
    required this.uid,
    required this.userName,
    required this.email,
    this.deviceToken,
    required this.isAdmin,
    this.profilePicUrl,
    this.coverPicUrl,
    required this.nativeLanguage,
    required this.preferredLanguages,
    required this.country,
    required this.followers,
    required this.follow,
    required this.visitors,
    required this.rank,
    required this.isPremium,
    required this.selfIntroduction,
    required this.age,
    required this.gender,
    required this.isOnline,
    required this.giftReceived,
    required this.giftSent,
    required this.phone,
    required this.elCoins,
    required this.elFrags,
    required this.rankPoints,
    this.accountStatus = 'active',
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'deviceToken': deviceToken,
      'email': email,
      'isAdmin': isAdmin,
      'profilePicUrl': profilePicUrl,
      'coverPicUrl': coverPicUrl,
      'nativeLanguage': nativeLanguage,
      'preferredLanguages': preferredLanguages,
      'country': country,
      'followers': followers,
      'follow': follow,
      'visitors': visitors,
      'rank': rank,
      'premium': isPremium,
      'selfIntroduction': selfIntroduction,
      'age': age,
      'gender': gender,
      'isOnline': isOnline,
      'giftSent': giftSent,
      'giftReceived': giftReceived,
      'uid': uid,
      'phone': phone,
      'elCoins': elCoins,
      'elFrags': elFrags,
      'rankPoints': rankPoints,
      'accountStatus': accountStatus,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      isAdmin: json['isAdmin'] ?? false,
      profilePicUrl: json['profilePicUrl'],
      coverPicUrl: json['coverPicUrl'],
      nativeLanguage: json['nativeLanguage'] ?? '',
      preferredLanguages: List<String>.from(json['preferredLanguages'] ?? []),
      country: json['country'] ?? '',
      followers: json['followers'] ?? 0,
      follow: json['follow'] ?? 0,
      visitors: json['visitors'] ?? 0,
      rank: json['rank'] ?? 0,
      isPremium: json['premium'] ?? false,
      selfIntroduction: json['selfIntroduction'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      isOnline: json['isOnline'] ?? false,
      giftReceived: json['giftReceived'] ?? 0,
      giftSent: json['giftSent'] ?? 0,
      phone: json['phone'] ?? '',
      deviceToken: json['deviceToken'],
      elCoins: json['elCoins'],
      elFrags: json['elFrags'],
      rankPoints: json['rankPoints'],
      accountStatus: json['accountStatus'],
    );
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
      profilePicUrl: map['profilePicUrl'],
      coverPicUrl: map['coverPicUrl'],
      nativeLanguage: map['nativeLanguage'] ?? '',
      preferredLanguages: List<String>.from(map['preferredLanguages'] ?? []),
      country: map['country'] ?? '',
      followers: map['followers'] ?? 0,
      follow: map['follow'] ?? 0,
      visitors: map['visitors'] ?? 0,
      rank: map['rank'] ?? 0,
      isPremium: map['premium'] ?? false,
      selfIntroduction: map['selfIntroduction'] ?? '',
      age: map['age'] ?? 0,
      gender: map['gender'] ?? '',
      isOnline: map['isOnline'] ?? false,
      giftReceived: map['giftReceived'] ?? 0,
      giftSent: map['giftSent'] ?? 0,
      phone: map['phone'] ?? '',
      deviceToken: map['deviceToken'],
      elFrags: map['elFrags'],
      elCoins: map['elCoins'],
      rankPoints: map['rankPoints'],
      accountStatus: map['accountStatus'],
    );
  }
}
