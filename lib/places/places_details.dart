 import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore_ns/places/places_screen.dart';
import 'package:explore_ns/search/place_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import '../services/global_methods.dart';
                import '../services/global_variables.dart';
import '../widgets/comments_widget.dart';

class PlaceDetailsScreen extends StatefulWidget {

  final String uploadedBy;
  final String placeId;

  const PlaceDetailsScreen({
    required this.uploadedBy,
    required this.placeId
  });

  @override
  PlacesDetailsScreenState createState() => PlacesDetailsScreenState();
  }




class PlacesDetailsScreenState extends State<PlaceDetailsScreen> {


  File? UserImage;


  Timestamp? postedDateTimeStamp;

  var userImageUrl;

  var authorName;

  bool isSameUser=false;

  var placeDescription;

  var placeTitle;

  String? postedDate;

  var email;

  var _commentController;

  bool showComment=false;




  void initState() {
    super.initState();
    getPlaceData();
  }

  void getPlaceData() async {

    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uploadedBy)
        .get();
    final DocumentSnapshot userDoc2 =await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if(userDoc==null)
    {
      return;
    }else {
      ()=>  setState(() {
        name=userDoc2.get('name');
        UserImage = userDoc2.get('userImage');
        authorName= userDoc.get('name');
        userImageUrl=userDoc.get('userImage');

      });
    }
    final DocumentSnapshot placeDatabase = await FirebaseFirestore.instance
        .collection('places')
        .doc(widget.placeId)
        .get();

    isSameUser=FirebaseAuth.instance.currentUser!.uid ==widget.uploadedBy;

    if(placeDatabase==null){
      return;
    }
    else {
      ()=> setState(() {
        placeTitle=placeDatabase.get('name');
        placeDescription=placeDatabase.get('description');
        email=placeDatabase.get('email');
        location=placeDatabase.get('location');
        postedDateTimeStamp=placeDatabase.get('createdAt');
        var postDate = postedDateTimeStamp!.toDate();
        postedDate='${postDate.year}-${postDate.month}-${postDate.weekday}';

      });



    }

  }

  @override
  Widget build(BuildContext context) {
    var _isCommenting;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.close,size: 40,color: Colors.grey,),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PlacesScreen())),

        ),
      ),
      body: SingleChildScrollView(
        child:

        Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                color: Colors.white38,
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left:4),
                          child: Text(
                            placeTitle==null? '':placeTitle!,
                            maxLines: 3,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                              ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PlaceProfileScreen(placeID: widget.placeId)));
                        },
                        child:
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: Colors.grey,
                              ),
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image:NetworkImage(
                                  userImageUrl==null
                                      ? 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png'
                                      : userImageUrl!,


                                ),
                                fit: BoxFit.fill,

                              )
                          ),
                        ),
                      ),
                      SizedBox(height: 14,),

                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authorName == null ? '':authorName!,
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              location,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),


                      dividerWidget(),

                      FirebaseAuth.instance.currentUser!.uid != widget.uploadedBy
                          ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          dividerWidget(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: (){
                                  var _auth;
                                  User? user =_auth.currentUser;
                                  final _uid = user!.uid;
                                  if(_uid==widget.uploadedBy){
                                    try {
                                      FirebaseFirestore.instance
                                          .collection('places')
                                          .doc(widget.placeId);
                                    }catch (err){
                                      GlobalMethod.showErrorDialog(
                                          error: 'Action cant be performed',
                                          ctx: context
                                      );
                                    }
                                  } else {
                                    GlobalMethod.showErrorDialog(
                                        error: 'You cant be performed',
                                        ctx: context
                                    );
                                  }
                                  getPlaceData();
                                },
                                child: Text(
                                  'ON',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight:FontWeight.normal,
                                  ),
                                ),
                              ),

                              TextButton(
                                onPressed: (){
                                  var _auth;
                                  User? user =_auth.currentUser;
                                  final _uid = user!.uid;
                                  if(_uid==widget.uploadedBy){
                                    try {
                                      FirebaseFirestore.instance
                                          .collection('places')
                                          .doc(widget.placeId);

                                    }catch (err){
                                      GlobalMethod.showErrorDialog(
                                          error: 'Action cant be performed',
                                          ctx: context
                                      );
                                    }
                                  } else {
                                    GlobalMethod.showErrorDialog(
                                        error: 'You cant be performed',
                                        ctx: context
                                    );
                                  }

                                  getPlaceData();
                                },
                                child: Text(
                                  'OFF',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight:FontWeight.normal,
                                  ),
                                ),
                              ),


                            ],
                          )
                        ],
                      ):

                      dividerWidget(),
                      Text(
                        'Place description',
                        style: TextStyle(fontSize: 18,color:
                        Colors.white,fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        placeDescription==null? '' : placeDescription!,
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 14,color: Colors.grey),
                      ),



                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Uploaded on',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                          Text(
                            postedDate==null? '':postedDate!,
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12,),

                    ],
                  ),
                ),
              ),
            ),



            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                color: Colors.white38,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedSwitcher(
                          duration: Duration(milliseconds: 500),
                          child: _isCommenting?
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                  flex:3
                                  ,child: TextField(
                                controller: _commentController,
                                style: TextStyle(color: Colors.white),
                                maxLength: 200,
                                keyboardType: TextInputType.text,
                                maxLines: 6,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color:Colors.white),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.pink),
                                    )
                                ),
                              )
                              ),
                              Flexible(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: MaterialButton(
                                        onPressed: () async {
                                          if(_commentController.text.length<7){
                                            GlobalMethod.showErrorDialog(
                                                error: 'Comment cant be less than 7 characters',
                                                ctx: context
                                            );
                                          }else {
                                            final _generatedId = Uuid().v4();
                                            await FirebaseFirestore.instance
                                                .collection('placeComments')
                                                .doc(widget.placeId)
                                                .update(
                                                {'placeComments':
                                                FieldValue.arrayUnion([
                                                  {
                                                    'placeId': FirebaseAuth
                                                        .instance.currentUser!
                                                        .uid,
                                                    'commentId': _generatedId,
                                                    'name': name,
                                                    'time':Timestamp.now(),
                                                    'userImageUrl':UserImage,
                                                    'commentBody':_commentController.text,
                                                  }
                                                ])
                                                });
                                            await Fluttertoast.showToast(
                                              msg: "Your comment has been added",
                                              toastLength: Toast.LENGTH_LONG,
                                              backgroundColor: Colors.grey,
                                              fontSize: 18,
                                            );
                                            _commentController.clear();
                                          }
                                          setState(() {
                                            showComment=true;
                                          });
                                        },
                                        color: Colors.blueAccent,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: Text(
                                          'Post',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14
                                          ),
                                        ),
                                      ),
                                    ),

                                    TextButton(
                                      onPressed: (){
                                        setState(() {
                                          _isCommenting=!_isCommenting;
                                          showComment=false;
                                        });
                                      },
                                      child: Text('Cancel'),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isCommenting=!_isCommenting;
                                  });
                                },
                                icon: Icon(
                                  Icons.add_comment,
                                  color: Colors.blueAccent,
                                  size: 40,
                                ),
                              ),
                              SizedBox(width: 10,),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    showComment=true;
                                  });
                                },
                                icon: Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: Colors.blueAccent,
                                  size: 40,
                                ),
                              ),
                            ],
                          )
                      ),
                      if (showComment==false) Container() else Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('placeComments')
                              .doc(widget.placeId)
                              .get(),
                          builder: (context,snapshot){
                            if(snapshot.connectionState==ConnectionState.waiting){
                              return Center(child:CircularProgressIndicator());
                            }else {
                              if(snapshot.data==null) {
                                Center(child: Text('No comment for this place'));
                              }
                            }
                            return ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context,index){

                                  return CommentWidget(
                                    commentId: snapshot.data!['placeComments'][index]['commentId'],
                                    commenterId:  snapshot.data!['placeComments'][index]['userId'],
                                    commenterName: snapshot.data!['placeComments'][index]['name'],
                                    commentBody: snapshot.data!['placeComments'][index]['commentBody'],
                                    commenterImageUrl: snapshot.data!['placeComments'][index]['userImageUrl'],
                                  );
                                },
                                separatorBuilder: (context,index){
                                  return Divider(
                                    thickness: 1,
                                    color: Colors.grey,
                                  );
                                },
                                itemCount: snapshot.data!['placeComments'].length
                            );
                          },

                        ),
                      ),

                    ],
                  ),
                ),

              ),
            ),



          ],
        ),
      ),
    );


  }

  Widget dividerWidget() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}






