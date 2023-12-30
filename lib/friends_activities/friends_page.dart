import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_add_friends/pages/profile.dart';

class FriendsPage extends StatefulWidget {
  final String myId;

  const FriendsPage({super.key, required this.myId});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  // DatabaseModel model = DatabaseModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.myId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          var friends = userData['friends'] as List<dynamic>;

          if (friends.isEmpty) {
            return const Center(
              child: Text('You have no friends.'),
            );
          }

          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(friends[index])
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox(); // You can show a loading indicator here if needed
                  }

                  var friendData =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfilePage(
                                viewedUserId: friendData['userId'],
                              )));
                    },
                    child: ListTile(
                      title: Text(friendData['fullname']),
                      subtitle: Text(friendData['userEmail']),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            NetworkImage(friendData['profilePhoto']),
                      ),
                      // Add more details about the friend as needed
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
