import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../business_logic/cubit/auth_cubit.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static const routeName = "/sign-up";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  File? image;
  @override
  Widget build(BuildContext context) {
    var authCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "SignUp",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: authCubit.formKey2,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue,
                    backgroundImage: image != null ? FileImage(image!) : null,
                  ),
                  
                  //Elevted 
                  //Text Button 
                  //Floating Action 
                  //Material Button 
                  //Outlind Button
                  TextButton(
                    onPressed: () async{
                     var file = await ImagePicker.platform.getImage(source: ImageSource.camera);
                     if( file!=null){
                      setState(() {
                        image=File(file.path);
                      });
                     }
                    },
                    child: Text("Chose Image"),
                  ),
                  MyTextField(
                    controller: authCubit.email,
                    hintText: "Please Enter Your Name ",
                    labelText: "email",
                    type: TextInputType.text,
                    password: false,
                    validator: authCubit.nameValdation,
                  ),
                  MyTextField(
                    controller: authCubit.adress,
                    hintText: "Please Enter Your Name ",
                    labelText: "Adress",
                    type: TextInputType.text,
                    password: false,
                    validator: authCubit.nameValdation,
                  ),
                  MyTextField(
                    controller: authCubit.birthDate,
                    hintText: "Please Enter Your Name ",
                    labelText: "BirthDate",
                    type: TextInputType.text,
                    password: false,
                    validator: authCubit.nameValdation,
                  ),
                  MyTextField(
                    controller: authCubit.name,
                    hintText: "Please Enter Your Name ",
                    labelText: "Name",
                    type: TextInputType.text,
                    password: false,
                    validator: authCubit.nameValdation,
                  ),
                  MyTextField(
                    controller: authCubit.password,
                    hintText: "Please Enter Your Password ",
                    labelText: "Password",
                    type: TextInputType.text,
                    minLines: 1,
                    password: true,
                    validator: authCubit.passwordValidate,
                  ),
                  MyTextField(
                    controller: authCubit.confirmPasssword,
                    hintText: "Please Enter Your password ",
                    labelText: "Confirm Password",
                    type: TextInputType.text,
                    password: true,
                    minLines: 1,
                    validator: authCubit.conPasswordValidate,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        authCubit.signUp(context,image);
                      },
                      child: const Text('Sign Up')),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, SignInScreen.routeName);
                      },
                      child: const Text(
                        "Are you already have an account ?!",
                        textAlign: TextAlign.center,
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
