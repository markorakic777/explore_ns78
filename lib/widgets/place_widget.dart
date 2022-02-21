
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore_ns/places/places_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/global_methods.dart';

class PlaceWidget extends StatefulWidget {

  final String placeId;
  final String uploadedBy;
  final String placeImageUrl;
  final String placeName;
  final String placeEmail;
  final String placeLocation;
  final String placeDescription;


  const PlaceWidget({
    required this.placeId,
  required this.uploadedBy,
    required this.placeImageUrl,
  required this.placeName,
  required this.placeEmail,
  required this.placeLocation,
  required this.placeDescription
}) ;

  @override
  _PlaceWidgetState createState() => _PlaceWidgetState();
}

class _PlaceWidgetState extends State<PlaceWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10,
      elevation: 8,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ListTile(
        onTap: () =>
            () {
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) =>
                  PlaceDetailsScreen(
                      uploadedBy: widget.uploadedBy,
                      placeId: widget.placeId)),
          );
        },
        onLongPress: _deleteDialog(),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            ),
          ),
        ),
        title: Text(
          widget.placeName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white10,),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.placeDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,

                color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.grey,
        ),
      ),
    );
  }
  _deleteDialog() {
    User? user = _auth.currentUser;
    final _uid=user!.uid;
    showDialog(context: context, builder: (ctx) {
      return AlertDialog(

        actions: [
          TextButton(onPressed: ()=> ()async{
            try{
        if (widget.uploadedBy == _uid) {
          await FirebaseFirestore.instance
              .collection('places')
              .doc(widget.placeId)
              .delete();
          await Fluttertoast.showToast(
            msg: "Place has been deleted",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.grey,
            fontSize: 18.0,
          );
          Navigator.canPop(ctx) ? Navigator.pop(ctx) : null;
        } else {
           GlobalMethod.showErrorDialog(
              error: "You cannot perfom this action", ctx: ctx );
        }  } catch (error) {
              GlobalMethod.showErrorDialog(error:"this place cannot be deleted", ctx: ctx);
          } finally  {}
    },

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete,
        color:Colors.red),
          Text ("Delete", style: TextStyle(color:Colors.red),),


        ],
      ),
    ),
        ],
      );

    });
  }
}