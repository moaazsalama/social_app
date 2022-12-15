import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:demo_project/presention/screens/home_screen.dart';
import 'package:demo_project/presention/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  var formKey = GlobalKey<FormState>(); //sign in
  var formKey2 = GlobalKey<FormState>(); //sign up
  var email = TextEditingController();
  var name = TextEditingController();
  var adress = TextEditingController();
  var birthDate = TextEditingController();
  var password = TextEditingController();
  var confirmPasssword = TextEditingController();
  AuthCubit() : super(AuthInitial());

  String? nameValdation(String? value) {
    if (value == null || value.isEmpty) {
      return "please enter your Name";
    }
  }

  String? passwordValidate(String? value) {
    if (value == null || value.isEmpty) {
      return "please enter your password";
    }
  }

  String? conPasswordValidate(String? value) {
    if (value == null || value.isEmpty) {
      return "please enter your password";
    } else if (password.text != confirmPasssword.text) {
      return "Passwords doesn't Match";
    }
  }

  Future<http.Response> signUpApi(String email, String password)async {
    http.Client client = http.Client();
   var response = await client.post(
    
        Uri.parse(
            "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyANjHRPdDbIxqAtC6hEDeH5wYMy24-LSbQ"),
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": false,
        }),headers: {
          "Content-Type": "application/json"
        });
        print(response.body);
        return response;
  }

  void signUp(BuildContext context, File? image) async {
      // signUpApi(email.text, password.text);
    var res = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text, password: password.text);
    if (res.user != null) {
      // code upload data in firebase
     await FirebaseFirestore.instance.collection('users').doc(res.user!.uid).set({
        'name': name.text,
        'email': email.text,
        'adress': adress.text,
        'birthDate': birthDate.text,
      }, SetOptions(merge: true)
      );
      var storage = FirebaseStorage.instance;
      if(image!=null) {
        var putFile = storage.ref("users/${res.user?.uid}").putFile(image);
        putFile.asStream().listen((event) {
          print(event.bytesTransferred);
        });
      }
      Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
    } else {
      print("error");
    }
  }

  void signIn(BuildContext context) async {
    var userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email.text, password: password.text);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>HomeScreen()));
  }
}
