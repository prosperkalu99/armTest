import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Helpers/flush_bar_helper.dart';
import 'Helpers/progres_dialog_helper.dart';
import 'constants.dart';
import 'dummy_data.dart';
import 'home.dart';

final fireStoreInstance = FirebaseFirestore.instance;

class LoginSignUp extends StatefulWidget {
  const LoginSignUp({Key? key}) : super(key: key);

  @override
  _LoginSignUpState createState() => _LoginSignUpState();
}

class _LoginSignUpState extends State<LoginSignUp> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  
  final _formKeySignUpSignIn = GlobalKey <FormState>();

  bool _togglePassword = true;
  bool _signIn = true;

  final surnameController = TextEditingController();
  final firstNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late String _firstName;
  late String _surname;
  late String _email;
  late String _password;

  final _emailRegExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");


  @override
  void dispose() {
    surnameController.dispose();
    firstNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget _firstNameForm (){
    return TextFormField(
      textInputAction: TextInputAction.next, keyboardType: TextInputType.name,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: kGrayScale1, width: 0.7)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: kGrayScale1, width: 0.7)
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: kGrayScale1, width: 0.7)
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: kGrayScale1, width: 0.7)
        ),
        fillColor: kGrayScale1,
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.all(15),
      ),
      cursorColor: kPrimaryColor,
      controller: firstNameController,
      onSaved: (value){
        setState(() {
          _firstName = value!;
        });
      },
      validator: (value) => (value!.isEmpty? "Please enter your first name" : null),
    );
  }

  Widget _surnameForm (){
    return TextFormField(
      textInputAction: TextInputAction.next, keyboardType: TextInputType.name,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: kGrayScale1, width: 0.7)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: kGrayScale1, width: 0.7)
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: kGrayScale1, width: 0.7)
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: kGrayScale1, width: 0.7)
        ),
        fillColor: kGrayScale1,
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.all(15),
      ),
      cursorColor: kPrimaryColor,
      controller: surnameController,
      onSaved: (value){
        setState(() {
          _surname = value!;
        });
      },
      validator: (value) => (value!.isEmpty? "Please enter your surname name" : null),
    );
  }

  Widget _emailForm (){
    return TextFormField(
      textInputAction: TextInputAction.next, keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: kGrayScale1, width: 0.7)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: kGrayScale1, width: 0.7)
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: kGrayScale1, width: 0.7)
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: kGrayScale1, width: 0.7)
        ),
        fillColor: kGrayScale1,
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.all(15),
      ),
      cursorColor: kPrimaryColor,
      controller: emailController,
      onSaved: (value){
        setState(() {
          _email = value!;
        });
      },
      validator: (value) {
        if(value!.isEmpty){
          return "Please enter your email";
        }else if (!_emailRegExp.hasMatch(value)) {
          return 'Invalid email address!';
        }
        return null;
      },
    );
  }

  Widget _passwordForm (){
    return TextFormField(
      textInputAction: TextInputAction.next, keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: kGrayScale1, width: 0.7)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: kGrayScale1, width: 0.7)
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: kGrayScale1, width: 0.7)
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: kGrayScale1, width: 0.7)
        ),
        fillColor: kGrayScale1,
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.all(15),
      ),
      obscureText: _togglePassword,
      cursorColor: kPrimaryColor,
      controller: passwordController,
      onSaved: (value){
        setState(() {
          _password = value!;
        });
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter password';
        }else if (value.length < 8) {
          return 'Password must be up to 8 characters';
        }else if (!value.contains(RegExp(r"[A-Z]"))){
          return 'Password must contain at least one uppercase';
        }else if (!value.contains(RegExp(r"[a-z]"))){
          return 'Password must contain at least one lowercase';
        }else if (!value.contains(RegExp(r"[0-9]"))){
          return 'Password must contain at least one number';
        }
        return null;
      },
    );
  }

  _proceed() async {
    if(_formKeySignUpSignIn.currentState!.validate()){
      _formKeySignUpSignIn.currentState!.save();
      var connectivityResult = await Connectivity().checkConnectivity();
      if (!(connectivityResult == ConnectivityResult.none)) {
        ProgressDialogHelper().showProgressDialog(context, _signIn? "Signing in" : "Signing Up");
        _signIn ? _login() : _signUp();
      }else FlushBarHelper(context).showFlushBar("No Internet Connection");
    }
  }

  _login() async {
    firebaseAuth.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    ).then((value) {
      ProgressDialogHelper().hideProgressDialog(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
    }).catchError((err){
      ProgressDialogHelper().hideProgressDialog(context);
      FlushBarHelper(context).showFlushBar(err.message, color: Colors.red);
    });
  }

  _signUp(){
    firebaseAuth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text).then((result) {
      fireStoreInstance.collection("user_details").doc(result.user!.uid).set(
          {
            "surname" : surnameController.text,
            "firstname" : firstNameController.text,
            "email" : emailController.text,
          }).then((_){
        print("success!");
        ProgressDialogHelper().hideProgressDialog(context);
        setState(() {
          _signIn = true;
        });
        FlushBarHelper(context).showFlushBar("Registration Successful", color: Colors.green);
      }).catchError((err) {
        ProgressDialogHelper().hideProgressDialog(context);
        FlushBarHelper(context).showFlushBar(err.message, color: Colors.red);
      });
    }).catchError((err) {
      ProgressDialogHelper().hideProgressDialog(context);
      FlushBarHelper(context).showFlushBar(err.message, color: Colors.red);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20,10,20,30),
            child: Form(
              key: _formKeySignUpSignIn,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 36,),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: kPrimaryColor, width: 0.5)
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: (){
                                if (_signIn == false) {
                                  setState(() {
                                    _signIn = !_signIn;
                                    surnameController.clear();
                                    firstNameController.clear();
                                    emailController.clear();
                                    passwordController.clear();
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: _signIn? kPrimaryColor : Colors.transparent
                                ),
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                child: Text(DummyData.authType[0], style: TextStyle(color: _signIn? Colors.white : kPrimaryColor, fontSize: 18,
                                    fontWeight: FontWeight.bold),),),
                            ),
                            InkWell(
                              onTap: (){
                                if (_signIn == true) {
                                  setState(() {
                                    _signIn = !_signIn;
                                    surnameController.clear();
                                    firstNameController.clear();
                                    emailController.clear();
                                    passwordController.clear();
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: !_signIn? kPrimaryColor : Colors.transparent
                                ),
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                child: Text(DummyData.authType[1], style: TextStyle(color: _signIn? kPrimaryColor : Colors.white, fontSize: 18,
                                    fontWeight: FontWeight.bold),),),
                            ),
                          ]
                      ),
                    ),
                  ),
                  SizedBox(height: 36,),
                  Text(_signIn? "Sign In" : "Sign Up", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),),
                  SizedBox(height: 36,),
                  _signIn ? SizedBox() : Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Surname", style: TextStyle(color: Colors.black, fontSize: 14),),
                      SizedBox(height: 5,),
                      _surnameForm(),
                      SizedBox(height: 24,),
                      Text("First Name", style: TextStyle(color: Colors.black, fontSize: 14),),
                      SizedBox(height: 5,),
                      _firstNameForm(),
                      SizedBox(height: 24,),
                    ],
                  ),
                  Text("Email", style: TextStyle(color: Colors.black, fontSize: 14),),
                  SizedBox(height: 5,),
                  _emailForm(),
                  SizedBox(height: 24,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Password", style: TextStyle(color: Colors.black, fontSize: 14),),
                      InkWell(
                        child: Text(_togglePassword ? "Show" : "Hide", style: TextStyle(color: kPrimaryColor, fontSize: 14),),
                        onTap: (){
                          setState(() {
                            _togglePassword = !_togglePassword;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  _passwordForm(),
                  SizedBox(height: 48,),
                  Container(height: 48, width: double.maxFinite,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(elevation: 0, onPrimary: Colors.white),
                        child: Text(_signIn? "Login" : "Create an account", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                        onPressed: (){
                          _proceed();
                        },
                      )
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
