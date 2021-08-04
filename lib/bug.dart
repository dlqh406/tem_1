import 'dart:io';

import 'package:flutter/material.dart';

class bug extends StatefulWidget {


  @override
  _bugState createState() => _bugState();
}

class _bugState extends State<bug> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarBuild(),
      body:
      Center(
        child: Container(
          child: Platform.isIOS?Image.asset('assets/guide/permission/ios.png',fit: BoxFit.cover,)
              :Image.asset('assets/guide/permission/and.png',fit: BoxFit.cover),
        ),
      )

    );
  }
  Widget appBarBuild() {
    return
      PreferredSize(preferredSize: Size.fromHeight(40.0),
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
                    child: Text('필수 권한 설정 확인')),
              ),
            ),
          )
      );
  }

}
