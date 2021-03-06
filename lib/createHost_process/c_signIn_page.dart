import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../not-logged-in.dart';
import '../phoneCertification.dart';
import 'c_phoneCertification.dart';

class c_SingInPage extends StatefulWidget {
  @override
  _c_SingInPageState createState() => _c_SingInPageState();
}

class _c_SingInPageState extends State<c_SingInPage> {
  final myControllerGroup = TextEditingController();
  final myControllerEmail = TextEditingController();
  final myControllerPW1 = TextEditingController();
  final myControllerPW2 = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: GestureDetector(
          child: GestureDetector(
              onTap: (){
                myControllerGroup.clear();
                myControllerEmail.clear();
                myControllerPW1.clear();
                myControllerPW2.clear();

                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (BuildContext context) =>
                        NotLoggedIn()), (route) => false);
              },
              child: Icon(Icons.arrow_back)),
        ),
        elevation: 0,
        title:Image.asset('assets/text2.png',width: 100,) ,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_circle,color:    Color(0xFF0D47A1),),
                  Icon(Icons.keyboard_arrow_right,color: Colors.grey),
                  Icon(Icons.phone_android_rounded,color: Colors.grey),
                  Icon(Icons.keyboard_arrow_right,color: Colors.grey),
                  Icon(Icons.check_circle,color: Colors.grey)
                ],
              ),
              SizedBox(
                height: 20,
              ),


              Center(child: Text("?????? ?????? ??????",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),)),
              SizedBox(
                height: 40,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10,2,10,2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.blue)
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "?????? ??? (?????? ???)",
                  ),
                  controller: myControllerGroup,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text('?????? ??? ?????? ?????? ?????? ??? ??? ????????????.',style: TextStyle(fontSize: 12),),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10,2,10,2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.blue)
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "?????????(?????????)",
                  ),
                  controller: myControllerEmail,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(

                padding: EdgeInsets.fromLTRB(10,2,10,2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.blue)
                ),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "????????????",
                  ),
                  controller: myControllerPW1,
                ),
              ),
              SizedBox(
                height:10,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10,2,10,2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.blue)
                ),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(

                    border: InputBorder.none,
                    labelText: "???????????? ??????",
                  ),
                  controller: myControllerPW2,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              RaisedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  snack();
                  signIn();
                },
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                child: Container(

                  height: 50,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        // Colors.blue,
                        Color(0xFF0D47A1),
                        Color(0xFF1976D2),
                        // Colors.blueAccent
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Center(child: const Text('?????? ??????',style: TextStyle(fontWeight: FontWeight.bold),)),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
  Future<FirebaseUser> signIn() async {
    if(myControllerGroup.text == "" ){
      scaffoldKey.currentState.hideCurrentSnackBar();
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message:
          "?????? ?????? ??????????????????",
        ),
      );

    }
    else if(myControllerPW1.text != myControllerPW2.text ){
      scaffoldKey.currentState.hideCurrentSnackBar();
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message:
          "??????????????? ???????????? ????????????.",
        ),
      );

    }
    else if( myControllerEmail.text == ""){
      scaffoldKey.currentState.hideCurrentSnackBar();
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message:
          "???????????? ???????????????",
        ),
      );
    }
    else if( myControllerGroup.text == ""){
      scaffoldKey.currentState.hideCurrentSnackBar();
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message:
          "???????????? ???????????????",
        ),
      );
    }
    else{
      try {
        await FirebaseAuth.instance.
        createUserWithEmailAndPassword(
            email: myControllerEmail.text,
            password: myControllerPW1.text
        ).then((value0) {

          //myControllerGroup.text
          var data ={
            'createDate': new DateTime.now(),
            'name' : myControllerGroup.text,
            'plan' :'trial'
          };
          Firestore.instance
              .collection('main_data')
              .add(data).then((value1) {
            scaffoldKey.currentState.hideCurrentSnackBar();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>
                    c_PhoneCertification (value0.user,value1.documentID,myControllerGroup.text)
                ));

          });



        });
      } catch (e) {
        scaffoldKey.currentState.hideCurrentSnackBar();
        print(e.code);
        if (e.code == 'ERROR_WEAK_PASSWORD') {
          showTopSnackBar(
            context,
            CustomSnackBar.error(
              message:
              "?????? 6??? ????????? ??????????????? ???????????????.",
            ),
          );
        }
        else if( e.code == 'ERROR_INVALID_EMAIL'){
          showTopSnackBar(
            context,
            CustomSnackBar.error(
              message:
              "????????? ????????? ???????????????.",
            ),
          );

        }
        else if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          showTopSnackBar(
            context,
            CustomSnackBar.error(
              message:
              "?????? ?????????????????? ???????????????.",
            ),
          );

        }
        else{
          showTopSnackBar(
            context,
            CustomSnackBar.error(
              message:
              e.code,
            ),
          );
        }
      }
    }


  }

  Widget snack(){
    // scaffoldKey.currentState.hideCurrentSnackBar();
    scaffoldKey.currentState
        .showSnackBar(
        SnackBar(
            duration: Duration(seconds: 5),
            backgroundColor: Colors.white.withOpacity(0),
            content:
            Center(child: CircularProgressIndicator()
            )));
  }
}
