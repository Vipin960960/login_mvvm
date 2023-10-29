import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../database/users_database.dart';
import '../../main.dart';
import '../../models/user_sign_in.dart';
import '../signup_screen.dart';

class CallLogsScreen extends StatefulWidget {
  final int userId;

  const CallLogsScreen({super.key, required this.userId});

  @override
  State<CallLogsScreen> createState() => _CallLogsScreenState();
}

class _CallLogsScreenState extends State<CallLogsScreen> {
  final EventChannel _eventChannel = EventChannel('callLogStream');

  static const androidMethod = MethodChannel(MyApp.androidMethodChannel);
  String Username ="";
  late User user;
  bool isLoading = false;

  Future getUserDetail() async {
    setState(() => isLoading = true);
    user = await UsersDatabase.instance.readUser(widget.userId);
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getUserDetail();

      dynamic data = await androidMethod.invokeMethod('readPhoneCall', <String, dynamic>{
        'userName': user.name,
      });

      if(data=="backButtonPressed"){
        SystemNavigator.pop();
        //or you can use
        // exit(0);
      }else if(data=="logoutUser"){
        SignupScreen.addStringToSF(0);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignupScreen()),
                (Route<dynamic> routes)=>false
        );
      }

    });
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text("Home page"),
        ),
        body:Container()
    );
  }



}
