import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_call/InvitedUser_process/signIn_page.dart';
import 'package:team_call/phoneCertification.dart';
import 'package:team_call/root.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final myControllerEmail = TextEditingController();
  final myControllerPW = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: GestureDetector(
          child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
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
                height: 40,
              ),
              Center(child: Text("로그인",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),)),
              SizedBox(
                height: 60,
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
                    labelText: "아이디(이메일)",
                  ),
                  controller: myControllerEmail,
                ),
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
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "패스워드",
                  ),
                  controller: myControllerPW,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              RaisedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();

                  snack();

                  logIn();
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
                  child: Center(child: const Text('로그인',style: TextStyle(fontWeight: FontWeight.bold),)),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: (){
                        launchURL() {
                          launch('http://pf.kakao.com/_JxoxexnK/chat');
                        }
                        launchURL();
                      }
                      , child: Text('고객 센터')),
                  Text('   |   '),
                  GestureDetector(
                      onTap: (){
                        showTopSnackBar(
                          context,
                          CustomSnackBar.info(
                            message:
                            "고객 센터로 문의바랍니다",
                          ),
                        );
                      }
                      , child: Text('계정 분실')),
                  Text('   |   '),
                  GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                                SingInPage()
                            ));
                      },
                      child: Text('회원 가입')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  Future<FirebaseUser> logIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: myControllerEmail.text,
          password: myControllerPW.text
      ).then((value) {

        Firestore.instance.collection("user_data")
            .document(value.user.uid)
            .get().then((docs){
              if(docs.exists){
                Firestore.instance
                    .collection("id_data")
                    .where('phoneNumber',
                    isEqualTo: '${docs.data['phoneNumber']}')
                    .getDocuments().then((querySnapshot) {

                  void check(){
                    if (querySnapshot.documents.length == 0) {
                      scaffoldKey.currentState.hideCurrentSnackBar();

                      showTopSnackBar(
                        context,
                        CustomSnackBar.error(
                          message:
                          "고객님 정보로 초대된 정보가 없습니다.",
                        ),
                      );
                    }
                    else {
                      scaffoldKey.currentState.hideCurrentSnackBar();
                      if( querySnapshot.documents[0]['uid']==""){
                        querySnapshot.documents.forEach((result) {
                          _showAlert(result,value.user,docs.data['phoneNumber'],docs.data['name']);
                        });
                      }else{

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                                Root()
                            ));
                      }
                    }
                  }
                  startTime() async {
                    var _duration = new Duration(milliseconds: 600);
                    return new Timer(_duration, check);
                  }
                  startTime();

                });
              }else{
                scaffoldKey.currentState.hideCurrentSnackBar();
                // 회원가입은 했지만 핸드폰 인증을 안했음 -> 초대여부 확인 할 수 없음 -> 폰 인증하면서 초대여부 확인할 수 있음
                showTopSnackBar(
                  context,
                  CustomSnackBar.error(
                    message:
                    "본인 인증을 먼저 진행해주세요",
                  ),
                );
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>
                        PhoneCertification (value.user)
                    ));
              }

        });


      });
    } catch (e) {
      scaffoldKey.currentState.hideCurrentSnackBar();
      print(e.code);
      if (e.code == 'ERROR_USER_NOT_FOUND') {


        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message:
            "등록되지 않은 계정입니다",
          ),
        );
      } else if (e.code == 'ERROR_WRONG_PASSWORD') {
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message:
            "잘못된 패스워드입니다",
          ),
        );
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

  Widget _showAlert(var data,user,phoneNumber,name) {
    var doc = data.data;

    print(data.documentID);
    AlertDialog dialog = new AlertDialog(
      content: new Container(
        width: 260.0,
        height: 360.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // dialog top
            new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:5.3),
                  child: Icon(Icons.check_circle,color: Colors.blue,),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:5.3),
                  child: Text(' 초대 되었습니다.',style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Spacer(),
                GestureDetector(
                    onTap: () {

                      Navigator.pop(context, true);
                    },
                    child: Icon(Icons.clear))
              ],
            ),
            // dialog centre
            SizedBox(
              height: 10,
            ),
            StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance.collection('main_data')
                    .document('${doc['companyID']}').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(),);
                  }
                  return StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance.collection('main_data')
                          .document('${doc['companyID']}').collection(
                          'main_collection')
                          .document('${doc['docID']}')
                          .snapshots(),
                      builder: (context, _snapshot) {
                        if (!_snapshot.hasData) {
                          return Center(child: CircularProgressIndicator(),);
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Padding(
                              padding: const EdgeInsets.only(top:25.0),
                              child: Text('초대 그룹명', style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text('${snapshot.data.data['name'] ?? "" }'),
                            SizedBox(
                              height: 13,
                            ),
                            Text('소속', style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),),
                            SizedBox(
                              height: 3,
                            ),
                            Text('${_snapshot.data.data['group'] + " " + _snapshot.data.data['department'] + " " + _snapshot.data.data['team'] }'),
                            SizedBox(
                              height: 13,
                            ),
                            Text('직책', style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),),
                            SizedBox(
                              height: 3,
                            ),
                            Text('${_snapshot.data.data['position']==null?"":_snapshot.data.data['position']}'),
                            SizedBox(
                              height: 13,
                            ),
                            Text('이름', style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),),
                            SizedBox(
                              height: 3,
                            ),
                            Text('${_snapshot.data.data['name']==null?"":_snapshot.data.data['name']}',),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        );
                      }
                  );
                }
            ),
            Spacer(),
            // dialog bottom
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: ()  {
                      print('aa');

                      var doc = data.data;
                      var id = data.documentID;
                      Firestore.instance.collection("main_data").document('${doc['companyID']}').collection('main_collection')
                          .document('${doc['docID']}').get().then((value){

                        var data ={
                          'uid' : user.uid,
                          'registerDate' : DateTime.now(),
                          'state' : true
                        };
                        Firestore.instance.collection("main_data").document('${doc['companyID']}')
                            .collection('main_collection')
                            .document('${doc['docID']}').updateData(data).then((value) {

                          var data1 ={
                            'uid' : user.uid,
                          };

                          Firestore.instance.collection("id_data")
                              .document(id)
                              .updateData(data1)
                              .then((value) {


                              // Root에 파라미터를 넣어서 root 맨아래있는 스플래시 뷰가 안보이게 처리하자
                              // home에도 파라미터를 넣어서 처음 접속자는 welcome문자 넣기

                              Navigator.push(context,
                                  MaterialPageRoute(builder: (BuildContext context) =>
                                      Root()));
                          });

                        });
                      });

                    },
                    child: new Container(
                      padding: new EdgeInsets.all(16.0),
                      decoration: new BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: new Text(
                        '초대 수락',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 17.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // ignore: missing_return
          return dialog;
        });
  }
  // ignore: missing_return

}
