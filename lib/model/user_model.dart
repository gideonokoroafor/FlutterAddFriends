import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String userId;
  late String fullname;
  late String email;
  late String profilePhoto;

  UserModel(
      {required this.userId,
      required this.fullname,
      required this.email,
      required this.profilePhoto});

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String userId = doc.id; // Use the document ID as the user ID
    String fullname = data['fullname'] ?? '';
    String email = data['userEmail'] ?? '';
    String profilePhoto = data['profilePhoto'] ?? '';
    return UserModel(
        userId: userId,
        fullname: fullname,
        email: email,
        profilePhoto: profilePhoto);
  }

  static Future<UserModel?> getUserProfile(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (snapshot.exists) {
        return UserModel.fromFirestore(snapshot);
      }
    } catch (e) {
      print('Error retrieving user info: $e');
    }
    return null;
  }

  static Future<List<UserModel>> getAllUsers() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error retrieving all users: $e');
      return [];
    }
  }
  
}
