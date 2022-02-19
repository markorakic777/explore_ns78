



//import 'dart:html';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../services/global_methods.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  late TextEditingController _fullNameController =
  TextEditingController(text: '');
  late TextEditingController _emailTextController =
  TextEditingController(text: '');
  late TextEditingController _passTextController =
  TextEditingController(text: '');
  late TextEditingController _locationTextController =
  TextEditingController(text: '');
  late TextEditingController _phoneNumberController =
  TextEditingController(text: '');

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passFocusNode = FocusNode();
  FocusNode _positionFocusNode = FocusNode();
  FocusNode _phonenumberFocusNode = FocusNode();

  bool _obscureText = true;
  final _singUpForKey = GlobalKey<FormState>();

  String? ImageURL;
  File? ImageFile;
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  void dispose() {
    _fullNameController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _locationTextController.dispose();
    _phoneNumberController.dispose();
    _animationController.dispose();
    _passFocusNode.dispose();
    _positionFocusNode.dispose();
    _phonenumberFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration (seconds: 20));
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.linear)
    ..addListener(() {
    setState(() {});
    })..addStatusListener((animationStatus) {
      if(animationStatus==AnimationStatus.completed)
      {_animationController.reset();
  _animationController.forward();}
    });
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: 'https://i.pinimg.com/564x/86/b9/5b/86b95b328ba9bebc5fa3431b052bf3b7.jpg',
          placeholder: (context, url) =>
                Image.asset(
                  'assets/images/1.jpg',
                  fit: BoxFit.fill,
                ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Container(
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 88),
              child:
                ListView(
              children: [
                Form(
                  key: _singUpForKey, //check

                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showImageDialog();
                        },
                        child: Container(
                          width: size.width * 0.24,
                          height: size.height * 0.24,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white10),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRect(
                            child: ImageFile == null
                                ? Icon(Icons.camera_enhance, color: Colors.blue, size: 30)
                                : Image.file(ImageFile!),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context)
                                .requestFocus(_emailFocusNode),
                        keyboardType: TextInputType.name,
                        controller: _fullNameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "This Field is Missing";
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Full name",
                          hintStyle: TextStyle(color: Colors.white),
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
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_passFocusNode),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailTextController,
                        focusNode: _emailFocusNode,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains("@")) {
                            return "Enter an valid email adress";
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.white),
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
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context)
                                .requestFocus(_phonenumberFocusNode),
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passTextController,
                        focusNode: _passFocusNode,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return "Password must be a minimum 8 charachter long";
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white10),
                          ),
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.white),
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
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context)
                                .requestFocus(_positionFocusNode),
                        keyboardType: TextInputType.phone,
                        controller: _phoneNumberController,
                        focusNode: _phonenumberFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "This field is missing";
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Phone number",
                          hintStyle: TextStyle(color: Colors.white),
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
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        controller: _locationTextController,
                        focusNode: _positionFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "This field is missing";
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Location",
                          hintStyle: TextStyle(color: Colors.white),
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
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _isLoading
                          ? Center(
                        child: Container(
                          width: 70,
                          height: 70,
                          child: CircularProgressIndicator(),
                        ),
                      )
                          : MaterialButton(
                        color: Colors.blue,
                        onPressed: _onButtonSignUpClicked,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                        child: Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20), // textStyle
                              ), //Text
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Already have an account?',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              TextSpan(text: "      "),
                              TextSpan(

                                recognizer: TapGestureRecognizer()..onTap = () => Navigator.canPop(context)
                                  ? Navigator.pop(context)
                                  : null,
                                text: 'LogIn',
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

            ),
            ],
          ),

                ),
            ),
          ]
      ),
      );

  }

  void _showImageDialog() {
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

  void _cropImage(filePath) async{
    File? croppedImage = (await ImageCropper.cropImage(
      sourcePath: filePath, maxHeight:1080, maxWidth:1080
    )) as File?;
    if(croppedImage!=null) {
      setState(() {ImageFile=croppedImage;});
    }


  }

  void _onButtonSignUpClicked() async {
    final isValid= _singUpForKey.currentState!.validate();
    if(isValid){

      setState(() {

        _isLoading=true;
      });

      if(ImageFile==null)
      {

        GlobalMethod.showErrorDialog(
            error: ("Error"), ctx:context
        );

        setState(() {

          _isLoading=false;
        });


        return;

      } //If image file is null


      try{
        await _auth.createUserWithEmailAndPassword(
            email: _emailTextController.text.trim().toLowerCase(),
            password: _passTextController.text.trim()
        );
        final User? user = _auth.currentUser;
        final _uid = user!.uid;
        final ref=FirebaseStorage.instance.ref().child('userImages').child(_uid+'.jpg');
        await ref.putFile(ImageFile!);
        ImageURL= await ref.getDownloadURL();
        FirebaseFirestore.instance.collection('users').doc(_uid).set( {
          'id': _uid,
          'email': _emailTextController.text,
          'userImage': ImageURL,
          'phoneNumber': _phoneNumberController.text,
          'location': _locationTextController.text,
          'name': _fullNameController.text,
          'createdAt': Timestamp.now()
        });
        Navigator.canPop(context)
            ? Navigator.pop(context)
            : null;
      } catch(error) {

    setState(() {
    _isLoading: false;
    });
    
    GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
    
        } finally {
    setState(() {
    _isLoading: false;
    });

    }
  }//ifIsValid
  }
}






