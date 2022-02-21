import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore_ns/widgets/all_places_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/bottom_navbar_widget.dart';

class SearchPlaces extends StatefulWidget {


  @override
  SearchPlacesState createState() =>SearchPlacesState();
}

class SearchPlacesState extends State<SearchPlaces> {

  TextEditingController _searchQueryController = TextEditingController();
  String searchQuery= "Search query";


  Widget _buildSearchField(){
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: InputDecoration(
          hintText:"Search for places...",
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white30)
      ),
      style: TextStyle(color: Colors.white,fontSize: 16.0),
      onChanged: (query) =>  updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: (){
          _clearSearchQuery();
        },
      ),
    ];
  }
  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery=newQuery;
    });
  }
  @override
  void initState() {
    _clearSearchQuery();
    super.initState();
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBarForApp(indexNum:1,),
      appBar: AppBar(
        backgroundColor: Colors.white10,
        automaticallyImplyLeading: false,
        title: _buildSearchField(),
        actions: _buildActions(),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('places')
            .where('name',isGreaterThanOrEqualTo: searchQuery)
            .where('name', isLessThan: searchQuery +'z')
            .snapshots(),

        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }else if(snapshot.connectionState==ConnectionState.active) {
            if(snapshot.data!.docs.isNotEmpty){
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context,int index){

                    return Place(
                      placeName:snapshot.data!.docs[index]['name'],
                      placeDescription: snapshot.data!.docs[index]['description'],
                      placeEmail: snapshot.data!.docs[index]['email'],
                      placeID: snapshot.data!.docs[index]['id'],
                      placeImageUrl: snapshot.data!.docs[index]['userImage'],
                      uploadedBy: snapshot.data!.docs[index]['uploadedBy'],
                    );
                  }
              );
            }
            else {
              return Center(
                child: Text(
                  'There is no places',
                ),
              );
            }
          }
          return Center(
            child: Text(
              'Something went wrong',
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),
            ),
          );

        },
      )
      ,


    );
  }
}