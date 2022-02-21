import 'package:explore_ns/auth/login.dart';
import 'package:explore_ns/places/upload_places.dart';
import 'package:explore_ns/user_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'auth/register.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widgets is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(

              debugShowCheckedModeBanner: false,

              home: Scaffold(
                body: Center(
                  child: Center(
                    child: Text("App is being initialized"),
                  ),
                ),
              ), // Scaffold

            );
          } else if (snapshot.hasError) {
            return MaterialApp(

              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Center(
                      child: Text("Error Occured")
                  ),
                ),
              ), // Scaffold
            );
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ExploreNS',
            theme: ThemeData(
                scaffoldBackgroundColor: Colors.white10,
                primarySwatch: Colors.amber
            ),
            home: UserState(),
          );
        }

        );
  }
}
