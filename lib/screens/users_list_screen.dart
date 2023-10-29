import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/users_database.dart';
import '../models/user_sign_in.dart';
import '../utils/style.dart';

class UserListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UserListPageDesign();
}

class UserListPageDesign extends State<UserListPage> {
  String Username = "";
  late List<User> usersList;

  late User user;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);
    usersList = await UsersDatabase.instance.readAllUsers();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Users List"),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : UserListPageWidget());
  }

  Widget UserListPageWidget() {
    return (usersList.length != 0)
        ? ListView.builder(
            itemCount: usersList.length,
            itemBuilder: (context, i) {
              return Padding(
                  padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
                  child: InkWell(
                    onDoubleTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            'Item Double Clicked',
                            style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )));
                    },
                    onLongPress: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            'Item Long Pressed',
                            style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )));
                    },
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            'Password: ${usersList[i].password}',
                            style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )));
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Container(
                                width: (MediaQuery.of(context).size.width) *
                                    15 /
                                    100,
                                height: (MediaQuery.of(context).size.width) *
                                    15 /
                                    100,
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "${usersList[i].name[0].toUpperCase()}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              width: (MediaQuery.of(context).size.width) *
                                  83 /
                                  100,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${usersList[i].name}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${usersList[i].email}',
                                        style: const TextStyle(
                                            color: teal_700),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Spacer(),
                                      Text(
                                        'Created at: ${DateFormat.yMMMEd().format(usersList[i].createdTime)}',
                                        style: const TextStyle(
                                            color: Colors.black54),
                                      ),
                                      // Text('${DateFormat.yMMMd().format(usersList[i].createdTime)}',style:const TextStyle(color: Colors.black54),),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 5),
                        Divider(
                          height: 1,
                        ),
                      ],
                    ),
                  ));
            },
          )
        : const Center(
            child: Text(
              "No Data Found please make some users",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          );
  }
}
