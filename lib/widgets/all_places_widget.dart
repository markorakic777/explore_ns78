import 'package:explore_ns/search/place_profile.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Place extends StatefulWidget {

  final String placeID;
  final String placeName;
  final String placeImageUrl;
  final String placeEmail;
  final String placeDescription;

  const Place({

   required this.placeID,
   required this.placeName,
   required this.placeDescription,
    required this.placeImageUrl,
    required this.placeEmail, placeUploadedBy, uploadedBy
});



  @override
  _PlaceState createState() => _PlaceState();
}

class _PlaceState extends State<Place> {
  @override
  Widget build(BuildContext context) {
    return Card(

      elevation: 8,
      color: Colors.white10,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) =>
              PlaceProfileScreen(
                 placeID: widget.placeID
              )));
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
            padding: EdgeInsets.only(right:12),
        decoration : BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            ),
        ),
        child:CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 20,
        child: Image.network(widget.placeImageUrl == null
            ? 'https://cdn-icons-png.flaticon.com/512/149/149071.png'
            : widget.placeImageUrl),
      ),
    ),
    title: Text(
    widget.placeName,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
    subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
    Text(
    "VisitPlace",
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),

    )
    ],

    ),
    trailing: IconButton(
    icon: Icon(
    Icons.mail_outline_rounded,
    size: 30,
    color:Colors.grey
    ),
    onPressed: _mailTo,
    
    ),
    ), //listTile

    );
  }


 void _mailTo() async {

   var mainUrl = 'mainto: ${widget.placeEmail}' ;
   print ('widget.userEmail ${widget.placeEmail}');
   if(await canLaunch(mainUrl)) {
     await launch(mainUrl);
   }else{print('Error'); throw 'Error occured';}
   }
    }


