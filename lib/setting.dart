import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'InvitedUser_process/loggedUser_page.dart';
import 'InvitedUser_process/signIn_page.dart';
import 'createHost_process/c_signIn_page.dart';

class Setting extends StatefulWidget {
  var from;

  Setting(this.from);
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            child: Platform.isIOS? Padding(
              padding: const EdgeInsets.only(top:15.0),
              child: Image.asset('assets/guide/permission/ios.png',fit: BoxFit.cover,),
            )

                :Padding(
                  padding: const EdgeInsets.only(top:50.0),
                  child: Image.asset('assets/guide/permission/and.png',fit: BoxFit.cover),
                ),
          ),
        ),
        floatingActionButton:
        StreamBuilder<FirebaseUser>(
          stream : FirebaseAuth.instance.onAuthStateChanged,
          builder: (context, snapshot) {
            return RaisedButton(
              elevation: 0,
              hoverElevation: 0,
              focusElevation: 0,
              highlightElevation: 0,
              color: Colors.transparent,
              onPressed: () {
              if( widget.from == 'invitedUser'){
                if(!snapshot.hasData){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          SingInPage()
                      ));
                }
                else{
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          LoggedUserIn(snapshot.data)
                      ));

                }
              }
              else{
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>
                        c_SingInPage()
                    ));
              }
              },
              textColor: Colors.white,
              padding: const EdgeInsets.only(left:30),
              // shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Container(

                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xFF0D47A1),
                        Color(0xFF1976D2),
                        Color(0xFF42A5F5),
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(80.0))
                ),
                padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                child: Icon(Icons.arrow_forward,size: 35,) ,

              ),
            );
          }
        )

    );
  }
  // StreamBuilder<FirebaseUser>(
  //     stream : FirebaseAuth.instance.onAuthStateChanged,
  //     builder: (context, snapshot) {
  //       return RaisedButton(
  //         onPressed: () {
  //           if( widget.from == 'invitedUser'){
  //             if(!snapshot.hasData){
  //               Navigator.push(context,
  //                   MaterialPageRoute(builder: (context) =>
  //                       SingInPage()
  //                   ));
  //             }
  //             else{
  //               Navigator.push(context,
  //                   MaterialPageRoute(builder: (context) =>
  //                       LoggedUserIn(snapshot.data)
  //                   ));
  //
  //             }
  //           }
  //           else{
  //             Navigator.push(context,
  //                 MaterialPageRoute(builder: (context) =>
  //                     c_SingInPage()
  //                 ));
  //           }
  //
  //         },
  //         textColor: Colors.white,
  //         padding: const EdgeInsets.all(0.0),
  //         child: Container(
  //           // width: 220,
  //           height: 60,
  //           decoration: const BoxDecoration(
  //             gradient: LinearGradient(
  //               colors: <Color>[
  //                 Color(0xFF0D47A1),
  //                 Color(0xFF1976D2),
  //               ],
  //             ),
  //           ),
  //           padding: const EdgeInsets.all(10.0),
  //           child: Center(child: const Text('다음 ',style: TextStyle(fontWeight: FontWeight.bold),)),
  //         ),
  //       );
  //     }
  // ),

  Widget appBarBuild() {
    return
      PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(top:15.0),
              child: AppBar(
                // automaticallyImplyLeading: false,
                titleSpacing: 0.0,
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                leading: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child:  Container(
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Icon(Icons.arrow_back ,color: Colors.black),
                        ))),
                title: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Text('필수 권한 설정 재 확인')),
              ),
            ),
          )
      );
  }
}
