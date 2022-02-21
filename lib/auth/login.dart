import 'package:cached_network_image/cached_network_image.dart';
import 'package:explore_ns/auth/register.dart';
import 'package:explore_ns/places/places_screen.dart';
import 'package:explore_ns/services/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../services/global_methods.dart';
import 'forget_pass.dart';
class LogIn extends StatefulWidget {
  const LogIn() ;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LogIn> with TickerProviderStateMixin{

  late AnimationController _animationController;
  late Animation<double> _animation;

  late TextEditingController _emailTextController = new TextEditingController(text: '');
  late TextEditingController _passTextController = new TextEditingController(text: '');

  FocusNode _passFocusNode = FocusNode();

  bool _isLoading = false;
  bool _obscureText=false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _loginFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _animationController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  void initState() {

    _animationController = AnimationController(vsync: this,duration: Duration(seconds: 20));
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.linear)
      ..addListener(() {
        setState(() {});
      })..addStatusListener((animationStatus){
        if(animationStatus==AnimationStatus.completed){
          _animationController.reset();
          _animationController.forward();
        }
      });
    _animationController.forward();

    super.initState();

  }


  void _submitFormOnLogin() async {
    final _isValid = _loginFormKey.currentState!.validate();

    if(_isValid)
    {
      setState(() {
        _isLoading=true;
      });
      try{
        await _auth.signInWithEmailAndPassword(
          email: _emailTextController.text.trim().toLowerCase(),
          password: _passTextController.text.trim(),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PlacesScreen()));
      }
      catch(error) {
        setState(() {
          _isLoading=false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
        print('error occurred $error');
      }
    }
    setState(() {
      _isLoading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: signUpUrlImage,
            placeholder: (context,url) => Image.asset(
              'assets/image/4.jpg',
              fit: BoxFit.fill,
            ),
            errorWidget: (context,url,error) => Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value,0),
          ),
          Container(
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 80),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:80.0,right: 80,),
                    child: Image.asset("assets/images/signup.png"),
                  ),
                  Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>FocusScope.of(context).requestFocus(_passFocusNode),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailTextController,
                          validator: (value){
                            if(value!.isEmpty || !value.contains('@'))
                            {
                              return 'Please enter the valid email';
                            }
                            else
                            {
                              return null;
                            }
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
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
                          focusNode: _passFocusNode,
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passTextController,
                          validator: (value){
                            if(value!.isEmpty || value.length<7)
                            {
                              return 'Please enter the valid password';
                            }
                            else
                            {
                              return null;
                            }
                          },
                          style: TextStyle(color: Colors.white),
                          obscureText: _obscureText? false: true,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: (){
                                setState(() {
                                  _obscureText=!_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText ? Icons.visibility : Icons.visibility_off,
                                color: Colors.white,
                              ),
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgetPasswordScreen()));
                            },
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MaterialButton(
                          onPressed: _submitFormOnLogin,
                          color: Colors.blue,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Dont have an account?',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    )
                                ),
                                TextSpan(text: '     '),
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp())),
                                    text: 'Register here',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );  }
}



