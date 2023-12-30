import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_add_friends/components/my_button.dart';
import 'package:flutter_add_friends/friends_activities/friends_page.dart';
import 'package:flutter_add_friends/friends_activities/friends_requests_page.dart';
import 'package:flutter_add_friends/model/user_model.dart';
import 'package:flutter_add_friends/pages/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  UserModel? userProfile;
  List<UserModel> allUsers = [];
  bool _isLoading = false;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  // Load user profile
  void loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    final userInfo = await UserModel.getUserProfile(user.uid);
    final users = await UserModel.getAllUsers();

    setState(() {
      userProfile = userInfo;
      allUsers = users;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var name = userProfile?.fullname ?? '';
    var email = userProfile?.email ?? '';
    var pic = userProfile?.profilePhoto ?? '';
    var myId = userProfile?.userId;
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Colors.grey[300],
            appBar: AppBar(
              backgroundColor: Colors.grey[900],
              title: Text(
                email,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
              actions: [
                IconButton(
                  onPressed: signUserOut,
                  icon: const Icon(Icons.logout),
                )
              ],
            ),
            body: Center(
                child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(pic),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  email,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  name,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyButton(
                      text: 'Friend',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FriendsPage(
                                  myId: myId!,
                                )));
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyButton(
                      text: 'Friend requests',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FriendsRequestPage(
                                  myId: myId!,
                                )));
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyButton(
                      text: 'Userss',
                      onTap: () {
                        // Display all users
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('All Users'),
                              content: Column(
                                children: allUsers
                                    .map((user) => GestureDetector(
                                          onTap: () {
                                            print(user.fullname);
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProfilePage(
                                                            viewedUserId:
                                                                user.userId)));
                                          },
                                          child: ListTile(
                                            title: Text(user.fullname),
                                            subtitle: Text(user.email),
                                            leading: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  user.profilePhoto),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                )
              ],
            )),
          );
  }
}
