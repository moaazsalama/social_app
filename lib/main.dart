import 'package:demo_project/business_logic/cubit/auth_cubit.dart';
import 'package:demo_project/presention/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';
import 'presention/screens/signin_screen.dart';
import 'presention/screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return const HomeScreen();
              } else {
                return const SignInScreen();
              }
            }),//
        //   home: //   FirebaseAuth.instance.currentUser ==null ?SignInScreen():HomeScreen(),
        routes: {
          SignInScreen.routeName: (context) => SignInScreen(),
          SignUpScreen.routeName: (context) => SignUpScreen(),
          HomeScreen.routeName: (context) => HomeScreen()
        },
      ),
    );
  }
}
