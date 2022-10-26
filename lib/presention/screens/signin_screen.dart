import 'package:demo_project/business_logic/cubit/auth_cubit.dart';
import 'package:demo_project/presention/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);
  static const routeName = "/sign-in";
  //final GlobalKey<FormState> key =/ GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var authCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "SignIn",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: authCubit.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyTextField(
                  controller: authCubit.email,
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
                  password: true,
                  validator: authCubit.passwordValidate,
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(onPressed: () {
                  var validate = authCubit.formKey.currentState!.validate();
                  if (validate) {
                    //TODO : sign in
      
                   authCubit.signIn(
                    context
                   );
                  }
                }, child: Text('Sign In')),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, SignUpScreen.routeName);
                    },
                    child: Text(
                      "don't have account !?\n Create New  Account",
                      textAlign: TextAlign.center,
                    ))
                // MyTextField(
                //   controller: authCubit.email,
                //   hintText: "Please Enter Your password ",
                //   labelText: "Confirm Password",
                //   type: TextInputType.text,
                //   password: true,
                //   validator: authCubit.conPasswordValidate,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.type,
    this.password = false,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? labelText, hintText;
 
  final String? Function(String?)? validator;
  final TextInputType? type;
  final bool password;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
      ),
      validator: validator,
      controller: controller,
      keyboardType: type,
      obscureText: password,
    );
  }
}
