import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../not-logged-in.dart';
import '../phoneCertification.dart';

class SingInPage extends StatefulWidget {
  @override
  _SingInPageState createState() => _SingInPageState();
}

class _SingInPageState extends State<SingInPage> {
  final myControllerEmail = TextEditingController();
  final myControllerPW1 = TextEditingController();
  final myControllerPW2 = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myControllerEmail.clear();
    myControllerPW1.clear();
    myControllerPW2.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: GestureDetector(
          child: GestureDetector(
              onTap: (){
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


              Center(child: Text("?????? ??????",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),)),
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
    if(myControllerPW1.text != myControllerPW2.text ){
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
    else{
      try {
        await FirebaseAuth.instance.
        createUserWithEmailAndPassword(
            email: myControllerEmail.text,
            password: myControllerPW1.text
        ).then((value) {
          scaffoldKey.currentState.hideCurrentSnackBar();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                  PhoneCertification (value.user)
              ));

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
            duration: Duration(seconds: 4),
            backgroundColor: Colors.white.withOpacity(0),
            content:
            Center(child: CircularProgressIndicator()
            )));
  }
}
