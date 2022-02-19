
import 'package:explore_ns/places/places_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth/login.dart';


class UserState extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (ctx, userSnapshot){
      if(userSnapshot.data==null) {
   print('user is not logged in yet');
   return LogIn();
  }
  else if(userSnapshot.hasData) {
  print('user is alredy logged in');
  return PlacesScreen();
  }
  else if(userSnapshot.hasError) {

  return Scaffold( body:Center(
  child: Text("An error has been occured"),
  )
  );
  }
  else if(userSnapshot.connectionState==ConnectionState.waiting) {
  return Scaffold( body:Center(
  child: CircularProgressIndicator(),
  )
  );
  }

  return Scaffold( body:Center(
  child: Text("Something went wrong"),
  )
  );


  }
    );
  }
}
