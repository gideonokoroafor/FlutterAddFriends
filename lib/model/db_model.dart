import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> dbAddUserDetails(
      String? fullname, String? email, String? uid) async {
    await _firestore.collection('users').doc(uid).set({
      'fullname': fullname,
      'userId': uid,
      'userEmail': email,
      'friends': [], // Initialize friends array
      'sentFriendRequests': [], // Initialize sent requests array
      'recievedFriendRequests': [], // Initialize received requests array
    });
  }

  Future<void> dbSendFriendRequest(String senderID, String receiverID) async {
    // Add senderID to receiver's receivedFriendRequests array
    // and receiverID to sender's sentFriendRequests array
    await _firestore.collection('users').doc(receiverID).update({
      'receivedFriendRequests': FieldValue.arrayUnion([senderID])
    });

    await _firestore.collection('users').doc(senderID).update({
      'sentFriendRequests': FieldValue.arrayUnion([receiverID])
    });
  }

  Future<void> dbCancelFriendRequest(String senderID, String receiverID) async {
    // Remove senderID from receiver's receivedFriendRequests array
    // and receiverID from sender's sentFriendRequests array
    await _firestore.collection('users').doc(receiverID).update({
      'receivedFriendRequests': FieldValue.arrayRemove([senderID])
    });

    await _firestore.collection('users').doc(senderID).update({
      'sentFriendRequests': FieldValue.arrayRemove([receiverID])
    });
  }

  Future<void> dbAcceptFriendRequest(String senderID, String receiverID) async {
    try {
      DocumentReference senderDocRef =
          _firestore.collection('users').doc(senderID);
      DocumentReference receiverDocRef =
          _firestore.collection('users').doc(receiverID);

      // Transaction ensures that all operations are executed atomically
      await _firestore.runTransaction((transaction) async {
        // Add receiver to sender's friends array and clear receiver from sender's sentFriendRequests
        transaction.update(senderDocRef, {
          'friends': FieldValue.arrayUnion([receiverID]),
          'receivedFriendRequests': FieldValue.arrayRemove([receiverID]),
        });

        // Add sender to receiver's friends array and clear sender from receiver's receivedFriendRequests
        transaction.update(receiverDocRef, {
          'friends': FieldValue.arrayUnion([senderID]),
          'sentFriendRequests': FieldValue.arrayRemove([senderID])
        });
      });
    } catch (e) {
      // print("Error accepting friend request: $e");
    }
  }

  Future<void> dbRejectFriendRequest(String senderID, String receiverID) async {
    // Remove senderID from receiver's friendRequests array
    await _firestore.collection('users').doc(receiverID).update({
      'sentFriendRequests': FieldValue.arrayRemove([senderID])
    });
    await _firestore.collection('users').doc(senderID).update({
      'receivedFriendRequests': FieldValue.arrayRemove([receiverID])
    });
  }

  Future<void> dbRemoveFriend(String userID, String friendID) async {
    // Remove the friend relationship from each user's document
    await _firestore.collection('users').doc(userID).update({
      'friends': FieldValue.arrayRemove([friendID]),
    });

    await _firestore.collection('users').doc(friendID).update({
      'friends': FieldValue.arrayRemove([userID]),
    });
  }
}
