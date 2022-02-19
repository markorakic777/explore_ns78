import 'dart:io';

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
  const UploadPlace({Key? key}) : super(key: key);

  @override
  _UploadPlaceState createState() => _UploadPlaceState();
}

class _UploadPlaceState extends State<UploadPlace> {

  late File ImageFile;
  TextEditingController _placeCategoryController = TextEditingController(
      text: 'Select Place Type');
  TextEditingController _placeNameController = TextEditingController();
  TextEditingController _placeDescriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  DateTime? picked;

  bool _isLoading = false;

  String? ImageURL;


  void dispose() {
    super.dispose();
    _placeCategoryController.dispose();
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
                                    : Image.file(ImageFile),
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
                            enabled: false,
                            fct: () {},
                            maxLength: 2000,
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
                          onPressed: UploadDataAboutPlace(),
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
              if (value!.isEmpty) {
                return "value is missing";
              }
              return null;
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

  UploadDataAboutPlace() {

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

        return;
      } //If image file is null



      try {




         final placeID = Uuid().v4();
         _uploadImageToStorage( placeID) ;
         User? user = FirebaseAuth.instance.currentUser;
         final _uid = user!.uid;
         final isValid =_formKey.currentState!.validate();

        FirebaseFirestore.instance.collection('places').doc(placeID).set({
          'id': placeID,
          'userImage': ImageURL,
          'name': _placeNameController.text,
          'description': _placeDescriptionController.text,
          'category': _placeCategoryController.text,
          'createdAt': Timestamp.now()
        });
        Navigator.canPop(context)
            ? Navigator.pop(context)
            : null;
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

  void _uploadImageToStorage(String placeID) async {
   final  _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final _uid = user!.uid;
    final ref=FirebaseStorage.instance.ref().child('userImages').child(_uid+'.jpg');
    await ref.putFile(ImageFile);
    ImageURL= await ref.getDownloadURL();

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

