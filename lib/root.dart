import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:team_call/home.dart';
import 'package:team_call/not-logged-in.dart';
import 'package:team_call/root2.dart';


class Root extends StatefulWidget {
  bool _visible = true;

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {

  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }
  void navigationPage() {
    setState(() {
      widget._visible = !widget._visible;
    });

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          StreamBuilder <FirebaseUser>(
            stream : FirebaseAuth.instance.onAuthStateChanged,
            builder: ( context, snapshot){
              // FirebaseAuth.instance.signOut();
              if(!snapshot.hasData){
                return  NotLoggedIn();
              }
              return Root2(snapshot.data);
              }

          ),
        ],
      ),
    );
  }

}

