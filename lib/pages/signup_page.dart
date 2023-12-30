// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_add_friends/components/my_button.dart';
import 'package:flutter_add_friends/components/my_textfield.dart';
import 'package:flutter_add_friends/model/db_model.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignUpPage({super.key, required this.showLoginPage});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final fullNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  DatabaseModel model = DatabaseModel();

  Future signUp() async {
    try {
      if (passwordController.text.trim() ==
          confirmPasswordController.text.trim()) {
        setState(() {
          _isLoading = true;
        }); // added a loading widget
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim())
            .then((value) async {
          model.dbAddUserDetails(fullNameController.text.trim(),
              emailController.text.trim(), value.user!.uid);
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false; // added loading
      });
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Colors.grey[300],
            body: SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),

                      // logo
                      const Icon(
                        Icons.lock,
                        size: 100,
                      ),

                      const SizedBox(height: 50),

                      // welcome back, you've been missed!
                      Text(
                        'Sign up!',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // email textfield
                      MyTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                      ),

                      const SizedBox(height: 10),

                      // email textfield
                      MyTextField(
                        controller: fullNameController,
                        hintText: 'Name',
                        obscureText: false,
                      ),

                      const SizedBox(height: 10),

                      // email textfield
                      MyTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: true,
                      ),

                      const SizedBox(height: 10),

                      // password textfield
                      MyTextField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm Password',
                        obscureText: true,
                      ),

                      const SizedBox(height: 25),

                      // sign up button
                      MyButton(
                        text: "Sign up",
                        onTap: signUp,
                      ),

                      const SizedBox(height: 50),

                      // not a member? register now
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already a member?',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: widget.showLoginPage,
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
