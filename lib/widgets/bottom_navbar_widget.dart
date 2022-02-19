import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:explore_ns/places/places_screen.dart';
import 'package:explore_ns/places/upload_places.dart';
import 'package:explore_ns/search/search_places.dart';
import 'package:explore_ns/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BottomNavigationBarForApp extends StatelessWidget {

  int indexNum=0;
  BottomNavigationBarForApp({required this.indexNum});




  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: Colors.white,
      backgroundColor: Colors.black,
      buttonBackgroundColor: Colors.white,
      height: 52,
      index:indexNum,
      items: <Widget>[
      Icon(Icons.list,size:18,color: Colors.blue,),
        Icon(Icons.search,size:18,color: Colors.blue,),
        Icon(Icons.add,size:18,color: Colors.blue,),
        Icon(Icons.map_outlined,size:18,color: Colors.blue,),
        ],
      animationDuration: Duration(
        milliseconds: 300
      ),
      animationCurve: Curves.bounceInOut,
      onTap: (index){
        if(index==0) {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PlacesScreen()) );
  }  else  if(index==1) {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SearchPlaces()) );
    }else  if(index==2) {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UploadPlace())) ;};
    }); //onTap





    }}
