import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubit/auth_cubit.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static const routeName = "/sign-up";
  @override
  Widget build(BuildContext context) {
    var authCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: authCubit.formKey2,
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
                MyTextField(
                  controller: authCubit.confirmPasssword,
                  hintText: "Please Enter Your password ",
                  labelText: "Confirm Password",
                  type: TextInputType.text,
                  password: true,
                  validator: authCubit.conPasswordValidate,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      authCubit.signUp(context);
                    }
                    ,
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
    );
  }
}
