import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_add_friends/model/db_model.dart';
import 'package:flutter_add_friends/pages/profile.dart';

class FriendsRequestPage extends StatefulWidget {
  final String myId;

  const FriendsRequestPage({super.key, required this.myId});

  @override
  State<FriendsRequestPage> createState() => _FriendsRequestPageState();
}

class _FriendsRequestPageState extends State<FriendsRequestPage> {
  DatabaseModel model = DatabaseModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend Requests'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.myId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No friend requests.'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          List<dynamic> friendRequests =
              userData['receivedFriendRequests'] ?? [];

          if (friendRequests.isEmpty) {
            return const Center(child: Text('No friend requests.'));
          }

          return ListView.builder(
            itemCount: friendRequests.length,
            itemBuilder: (context, index) {
              String senderId = friendRequests[index];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(senderId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const SizedBox(); // Show a loading indicator if needed
                  }

                  var senderData =
                      userSnapshot.data!.data() as Map<String, dynamic>;

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfilePage(
                                viewedUserId: senderData['userId'],
                              )));
                    },
                    child: ListTile(
                      title: Text('${senderData['fullname']}'),
                      subtitle: Text('${senderData['userEmail']}'),
                      leading: CircleAvatar(
                        radius: 30,
                        // Replace with actual image fetching logic
                        backgroundImage: NetworkImage(
                            senderData['profilePhoto'] ?? 'default_image_url'),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () {
                              // Accept friend request logic
                              model.dbAcceptFriendRequest(
                                  widget.myId, senderId);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              // Decline friend request logic
                              model.dbRejectFriendRequest(
                                  widget.myId, senderId);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
