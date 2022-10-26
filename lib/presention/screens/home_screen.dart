import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = "home-screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: InkWell(
            onTap: () {
              FirebaseAuth.instance.signOut();
            
            },
            child: Text('Home Screen'),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(FirebaseAuth.instance.currentUser!.metadata.creationTime!.toIso8601String()),
      ),
    );
  }
}
