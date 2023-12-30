import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_add_friends/friends_activities/friends_page.dart';
import 'package:flutter_add_friends/model/db_model.dart';

class ProfilePage extends StatefulWidget {
  final String viewedUserId;

  const ProfilePage({super.key, required this.viewedUserId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  late final DatabaseModel _databaseModel; // Instance of DatabaseModel

  @override
  void initState() {
    super.initState();
    _databaseModel = DatabaseModel(); // Initialize DatabaseModel
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.viewedUserId)
            .snapshots(),
        builder: (context, snapshot) {
          // ... Error and loading checks ...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData ||
              snapshot.data == null ||
              !snapshot.data!.exists) {
            return const Text("User not found");
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          var receivedFriendRequests =
              userData.containsKey('receivedFriendRequests')
                  ? List.from(userData['receivedFriendRequests'])
                  : [];
          var sentFriendRequests = userData.containsKey('sentFriendRequests')
              ? List.from(userData['sentFriendRequests'])
              : [];
          var friends = userData.containsKey('friends')
              ? List.from(userData['friends'])
              : [];

          bool isFriend = friends.contains(currentUserId);
          bool isFriendRequestSent = sentFriendRequests.contains(currentUserId);
          bool isFriendRequestReceived =
              receivedFriendRequests.contains(currentUserId);

          return Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(userData['profilePhoto'] ?? ''),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(userData['fullname'] ?? 'No Name'),
                const SizedBox(
                  height: 10,
                ),
                if (isFriendRequestReceived)
                  ElevatedButton(
                    onPressed: () => _databaseModel.dbCancelFriendRequest(
                        currentUserId, widget.viewedUserId),
                    child: const Text('Cancel Friend Request'),
                  )
                else if (isFriendRequestSent)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _databaseModel.dbAcceptFriendRequest(
                              currentUserId, widget.viewedUserId);
                        },
                        child: const Text('Accept'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _databaseModel.dbRejectFriendRequest(
                              currentUserId, widget.viewedUserId);
                        },
                        child: const Text('Reject'),
                      ),
                    ],
                  )
                else if (isFriend)
                  ElevatedButton(
                    onPressed: () => _databaseModel.dbRemoveFriend(
                        currentUserId, widget.viewedUserId),
                    child: const Text('Remove'),
                  )
                else if (currentUserId == widget.viewedUserId)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FriendsPage(
                                myId: currentUserId,
                              )));
                    },
                    child: const Text('Friends'),
                  )
                else
                  ElevatedButton(
                    onPressed: () => _databaseModel.dbSendFriendRequest(
                        currentUserId, widget.viewedUserId),
                    child: const Text('Add Friend'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
