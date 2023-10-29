import 'package:flutter/material.dart';
import 'package:login_mvvm/screens/sign_in_page.dart';
import 'package:login_mvvm/screens/users_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/users_database.dart';
import '../models/user_sign_in.dart';
import '../utils/style.dart';
import 'callLogs/call_logs_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  static addStringToSF(int status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('sign_id', status);
  }

  @override
  State<StatefulWidget> createState() => _SignupScreen();
}

class _SignupScreen extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  String Name = "";
  String Email = "";
  String Password = "";
  String conPassword = "";

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final conPasswordController = TextEditingController();

  bool isLoggedIn = false;
  int userId = 1;

  @override
  void initState() {
    super.initState();

    checkSignInStatus();
  }

  Future checkSignInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('sign_id') ?? 0;
      isLoggedIn = ((userId) == 0) ? false : true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn
        ? CallLogsScreen(
            userId: userId,
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text("Sign Up"),
            ),
            backgroundColor: Colors.white,
            body: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: ListView(
                    children: [
                      TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Name',
                            labelStyle: TextStyle(fontSize: 20),
                          ),
                          controller: nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Name';
                            }
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Email',
                            labelStyle: const TextStyle(fontSize: 20),
                          ),
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Email';
                            } else if (!value.contains('@') ||
                                !value.contains('.')) {
                              return 'Please Enter Valid Email';
                            }
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(fontSize: 20),
                          ),
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter password';
                            } else if (value.length < 6) {
                              return 'At least 6 character Require';
                            }
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(fontSize: 20),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Confirm password';
                            } else if (value != passwordController.text) {
                              return 'Confirm password not matched';
                            }
                          }),
                      SizedBox(height: 10),
                      ElevatedButton(
                          // style: ElevatedButton.styleFrom(
                          //   backgroundColor: Colors.black54
                          // ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                Name = nameController.text;
                                Email = emailController.text;
                                Password = passwordController.text;
                                addUser();
                              });
                            }
                          },
                          child: const Text('Sign Up')),
                      // Text('Name: $Name'),
                      // Text('Email: $Email'),
                      // Text('Password: $Password'),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                                height: 30,
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignInPage()),
                                      );
                                    },
                                    child: const Text(
                                        "Already have Credentials",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: teal_700)))),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            //Check out home_statefulwidget.dart to check why i write name stateful widget
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserListPage()),
                );
              },
              child: const Icon(Icons.list),
            ),
          );
  }

  Future addUser() async {
    final user = User(
      name: Name.trim(),
      email: Email.trim(),
      password: Password,
      createdTime: DateTime.now(),
    );

    User userData = await UsersDatabase.instance.create(user);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = userData.id ?? 1;

    prefs.setInt('sign_id', userId);
    debugPrint("User is created & his id is: ${userId}");

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => CallLogsScreen(userId: userId)),
        (Route<dynamic> route) => false);
  }
}
