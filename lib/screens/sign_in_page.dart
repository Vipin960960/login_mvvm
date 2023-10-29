import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/users_database.dart';
import '../models/user_sign_in.dart';
import 'callLogs/call_logs_screen.dart';

class SignInPage extends StatefulWidget {
  static addStringToSF(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('sign_status', true);
  }

  const SignInPage({super.key});

//we have made this statefulwidget cause of here we are going to use TextField whose values changes again & again

  @override
  State<SignInPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  String Name = "";
  String Password = "";

  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Sign In"),
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
                        errorStyle:
                            TextStyle(color: Colors.deepOrange, fontSize: 15),
                      ),
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Name';
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
                          labelStyle: TextStyle(fontSize: 20)),
                      controller: passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter password';
                        }
                      }),
                  ElevatedButton(
                      // style: ElevatedButton.styleFrom(//Color will be taken from theme defined in main.dart
                      //     backgroundColor: Colors.black54
                      // ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            Name = nameController.text;
                            Password = passwordController.text;

                            checkUser(Name, Password);
                          });
                        }
                      },
                      child: const Text('Sign In')),
                ],
              ),
            )));
  }

  Future checkUser(String name, String password) async {
    late User userData;
    try {
      userData = await UsersDatabase.instance.checkCredentials(name);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("User not found"),
      ));
    }
    if (password == userData.password) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = userData.id ?? 1;

      prefs.setInt('sign_id', userId);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => CallLogsScreen(userId: userId)),
          (Route<dynamic> route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Password not matched"),
      ));
    }
  }
}
