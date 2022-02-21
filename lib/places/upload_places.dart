import 'dart:io';
import '../persistent/persistent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore_ns/widgets/bottom_navbar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../services/global_methods.dart';
import '../services/global_variables.dart';

class UploadPlace extends StatefulWidget {
  const UploadPlace();

  @override
  _UploadPlaceState createState() => _UploadPlaceState();
}

class _UploadPlaceState extends State<UploadPlace> {

   File? ImageFile;
  TextEditingController _placesCategoryController = TextEditingController();
  TextEditingController _placeNameController = TextEditingController();
  TextEditingController _placeDescriptionController = TextEditingController();
   TextEditingController _placeLocationController = TextEditingController();
   TextEditingController _placeEmailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  DateTime? picked;

  bool _isLoading = false;

  String? ImageURL;


  void dispose() {
    super.dispose();
    _placesCategoryController.dispose();
    _placeDescriptionController.dispose();
    _placeNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBarForApp(indexNum: 2,),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Card(
            color: Colors.white10,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Please fill all fields",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child:
                      Column(
                        children: [

                          _textTitles(label: "Place category: "),
                          _textFormFields(
                              valueKey: 'category',
                              controller: _placesCategoryController,
                              enabled: false,
                              fct: (){
                                _showPlacesCategoriesDialog(size: size);
                              },
                              maxLength: 100
                          ),
                          GestureDetector(
                            onTap: ()=> _showImageDialog(),
                            child: Container(
                              width: size.width * 0.24,
                              height: size.height * 0.24,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: Colors.white10),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ClipRect(
                                child: ImageFile == null
                                    ? Icon(
                                    Icons.camera_enhance, color: Colors.blue,
                                    size: 30)
                                    : Image.file(ImageFile!),
                              ),
                            ),
                          ),
                          _textTitles(label: "Insert Place Name"),
                          _textFormFields(
                            valueKey: "PlaceName",
                            controller: _placeNameController,
                            enabled: true,
                            fct: () {},
                            maxLength: 100,
                          ),

                          _textTitles(label: "Insert Place Description"),
                          _textFormFields(
                            valueKey: "PlaceDescription",
                            controller: _placeDescriptionController,
                            enabled: true,
                            fct: () {},
                            maxLength: 2000,
                          ),

                          _textTitles(label: "Insert email"),
                          _textFormFields(
                            valueKey: "email",
                            controller: _placeEmailController,
                            enabled: true,
                            fct: () {},
                            maxLength: 100,
                          ),



                          _textTitles(label: "Insert location"),
                          _textFormFields(
                            valueKey: "location",
                            controller: _placeLocationController,
                            enabled: true,
                            fct: () {},
                            maxLength: 500,
                          ),


                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : MaterialButton(
                          onPressed: UploadDataAboutPlace,
                          color: Colors.amber,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child:
                                  Text(
                                    "Post Now",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        )

                    ),
                  ),

                ],

              ),
            ),
          ),
        ),

      ),
    ); //Scaffold
  }


  void _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxHeight: 1000,
      maxWidth: 1000,
    );
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }


  void _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 1000,
      maxWidth: 1000,
    );
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    File? croppedImage = (await ImageCropper.cropImage(
        sourcePath: filePath, maxHeight: 1080, maxWidth: 1080
    )) as File?;
    if (croppedImage != null) {
      setState(() {
        ImageFile = croppedImage;
      });
    }
  }




  Widget _textFormFields({
    required String valueKey,
    required TextEditingController controller,
    required bool enabled,
    required Function fct,
    required int maxLength
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
          onTap: () {
            fct();
          },
          child: TextFormField(
            validator: (value) {
              if (value=="") {
                color: Colors.red;
              }

            },


            controller: controller,
            enabled: enabled,
            key: ValueKey(valueKey),
            style: TextStyle(
              color: Colors.white,),
            maxLines: valueKey == "TaskDescription" ? 3 : 1,
            maxLength: maxLength,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
          )
      ),
    );
  }


  Widget _textTitles({
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

 UploadDataAboutPlace() async {

   final isValid = _formKey.currentState!.validate();

    if (isValid) {

      setState(() {
        _isLoading = true;
      });

      if (ImageFile == null) {
        GlobalMethod.showErrorDialog(
            error: ("Error, Upload image"), ctx: context

        );

        setState(() {
          _isLoading = false;
        });


      } //If image file is null



      try {




         final placeID = Uuid().v4();
         final ref=FirebaseStorage.instance.ref().child('placesImages').child(placeID + '.jpg');
         await ref.putFile(ImageFile!);
         ImageURL= await ref.getDownloadURL();
         User? user = FirebaseAuth.instance.currentUser;
         final _uid = user!.uid;

        FirebaseFirestore.instance.collection('places').doc(placeID).set({
          'id': placeID,
          'userImage': ImageURL,
           'location': _placeLocationController.text,
          'email': _placeEmailController.text,
          'name': _placeNameController.text,
          'description': _placeDescriptionController.text,
          'category': _placesCategoryController.text,
          'createdAt': Timestamp.now(),
          'uploadedBy': _uid,
        });

      } catch (error) {
        setState(() {
          _isLoading:
          false;
        });

        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
      } finally {
        setState(() {
          _isLoading:
          false;
        });
      }
    }
  }



   _showPlacesCategoriesDialog({required Size size}){
     showDialog(context: context,
         builder: (ctx){
           return AlertDialog(
             backgroundColor: Colors.black,
             title: Text(
               'Place category',
               textAlign: TextAlign.center,
               style: TextStyle(fontSize: 20,color: Colors.white),
             ),
             content:Container (
               width: size.width*0.9,
               child: ListView.builder(
                   shrinkWrap: true,
                   itemCount: Persistent.placesCategoryList.length,
                   itemBuilder: (ctxx,index) {

                     return InkWell(
                         onTap: (){
                           setState(() {
                             _placesCategoryController.text=Persistent.placesCategoryList[index];
                           });
                           Navigator.pop(context);
                         },
                         child: Row(

                           children: [
                             Icon(
                               Icons.arrow_right_outlined,
                               color: Colors.grey,
                             ),
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Text(
                                 Persistent.placesCategoryList[index],
                                 style: TextStyle(
                                   color: Colors.grey,
                                   fontSize: 16,
                                 ),
                               ),
                             )
                           ],

                         )
                     );
                   }
               ),
             ),
             actions: [
               TextButton(
                 onPressed:  () {
                   Navigator.canPop(context)? Navigator.pop(context):null;
                 },
                 child: Text(
                   'Cancel',
                   style: TextStyle(color: Colors.white,fontSize: 16),
                 ),
               )
             ],
           );
         }
     );
   }


  _showImageDialog() {

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Please chose an option"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: (){
                    _getFromCamera();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child:Icon(
                          Icons.camera,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        "Camera",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                InkWell(
                  onTap: (){
                    _getFromGallery();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child:Icon(
                          Icons.image,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        "Gallery",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );

        }
    );
  }




}

