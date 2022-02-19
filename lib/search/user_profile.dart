import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../user_state.dart';
class   userProfileScreen extends StatefulWidget {

  final String userID;

  const userProfileScreen({
    required this.userID
  });

  void _logout(context)  async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    showDialog(context: context, builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.logout, color: Colors.white, size: 36,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Sign Out", style: TextStyle(color: Colors.grey, fontSize: 28,),
              ),
            ),
          ], //row's children
        ),
        content: Text(   //AlertDialog's content
            "Do you want to log out from exploreNS?",
            style: TextStyle(color: Colors.grey, fontSize: 20)
        ),

        actions: [   //AlertDialog's actions
          TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: Text(  //TextButton in AlertDialog's child. Gonna be displayed inside text button
                  "No", style: TextStyle(color: Colors.grey, fontSize: 18))
          ),
          TextButton(
            onPressed: () {
              _auth.signOut();
              Navigator.canPop(context) ? Navigator.pop(context) : null;
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => UserState()));
            },
            child: Text(
              "Yes", style: TextStyle(color: Colors.grey, fontSize: 18,),),
          )
        ],
      );
    }
    );

  }

  @override
  _userProfileScreenState createState() => _userProfileScreenState();
}

class _userProfileScreenState extends State<userProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
