import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequest {
  final String senderID;
  final String receiverID;
  final String status;

  FriendRequest({
    required this.senderID,
    required this.receiverID,
    required this.status,
  });
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFriend(String userID, String friendID) async {
    // Add the friend relationship to each user's document
    await _firestore.collection('users').doc(userID).update({
      'friends': FieldValue.arrayUnion([friendID]),
    });

    await _firestore.collection('users').doc(friendID).update({
      'friends': FieldValue.arrayUnion([userID]),
    });
  }

  Future<void> sendFriendRequest(String senderID, String receiverID) async {
    // Check if a friend request already exists
    final existingRequest = await _firestore
        .collection('friendRequests')
        .where('senderID', isEqualTo: senderID)
        .where('receiverID', isEqualTo: receiverID)
        .get();

    if (existingRequest.docs.isEmpty) {
      // If no existing request, create a new one
      await _firestore.collection('friendRequests').add({
        'senderID': senderID,
        'receiverID': receiverID,
        'status': 'pending',
      });
    }
  }
}
