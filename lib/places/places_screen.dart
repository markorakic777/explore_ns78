//import 'dart:html';

//import 'dart:html';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore_ns/search/search_places.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../persistent/persistent.dart';
import '../widgets/bottom_navbar_widget.dart';
import '../widgets/place_widget.dart';
class PlacesScreen extends StatefulWidget {
  const PlacesScreen({Key? key}) : super(key: key);

  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {

  String? placesCategoryFilter;




  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum:0,),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.filter_list_outlined,color: Colors.grey,),
            onPressed: (){
              _showTaskCategoriesDialog(size: size);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search_outlined,color: Colors.grey,),
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => SearchPlaces()));
              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('places')
              .where('placesCategory',isEqualTo: placesCategoryFilter)
              .orderBy('createdAt',descending: false)
              .snapshots(),
          builder:(context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child:CircularProgressIndicator());
            }
            else if(snapshot.connectionState==ConnectionState.active) {
              if(snapshot.data?.docs.isNotEmpty==true){
                return  ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context,int index) {
                    return
                    Builder(
                      builder: (context) {
                        return (
                            PlaceWidget(
                          placeName: snapshot.data?.docs[index]['name'],
                          placeDescription: snapshot.data
                              ?.docs[index]['description'],
                          placeId: snapshot.data?.docs[index]['id'],
                          uploadedBy: snapshot.data
                              ?.docs[index]['uploadedBy'],
                          placeImageUrl: snapshot.data
                              ?.docs[index]['userImage'],
                          placeLocation: snapshot.data
                              ?.docs[index]['location'],
                          placeEmail: snapshot.data?.docs[index]['email'],

                        )
                        );
                      },
                    );
              
                    },
                );




                
              }else {
                return Center(
                  child: Text('There is no places'),
                );
              }
            }
            return Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),
              ),

            );
          } ,
        )
    );

  }

  _showTaskCategoriesDialog({required Size size}){
    showDialog(
        context: context,
        builder: (ctx){
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              'place Category',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize:20,color:Colors.white),
            ),
            content: Container(
              width: size.width*0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Persistent.placesCategoryList.length,
                  itemBuilder: (ctx,index){
                    return InkWell(
                      onTap: (){
                        setState(() {
                          placesCategoryFilter=Persistent.placesCategoryList[index];
                        });
                        Navigator.canPop(ctx)? Navigator.pop(ctx):null;
                        print(
                            'placesCategoryList[index], ${Persistent.placesCategoryList[index]}'

                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                              Icons.arrow_right_outlined,
                              color:Colors.grey
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              Persistent.placesCategoryList[index],
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
              ),
            ),
            actions: [
              TextButton(onPressed:  () {
                Navigator.canPop(ctx) ? Navigator.pop(ctx) : null;
              } ,
                  child: Text('Close',style:TextStyle(color: Colors.white))
              ),
              TextButton(onPressed:  () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PlacesScreen()));
              } ,
                  child: Text('Cancel Filter',style:TextStyle(color: Colors.white))
              ),
            ],
          );
        }
    );
  }
}