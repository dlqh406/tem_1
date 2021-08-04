import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_call/InvitedUser_process/agreement_for_inviteduser.dart';
import 'package:team_call/InvitedUser_process/loggedUser_page.dart';
import 'package:team_call/InvitedUser_process/signIn_page.dart';
import 'package:team_call/createHost_process/c_signIn_page.dart';

import 'InvitedUser_process/invitedUser_page.dart';
import 'InvitedUser_process/login_page.dart';
import 'createHost_process/agreement_for_createuser.dart';

class NotLoggedIn extends StatefulWidget {
  @override
  _NotLoggedInState createState() => _NotLoggedInState();
}

class _NotLoggedInState extends State<NotLoggedIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: StreamBuilder<FirebaseUser>(
              stream : FirebaseAuth.instance.onAuthStateChanged,
            builder: (context, snapshot) {

              return Container(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 96,
                        ),
                        Image.asset('assets/text2.png',width: 350,),
                        SizedBox(
                          height:25,
                        ),
                        Text('우리팀 클라우드 전화번호부, 팀콜',style: TextStyle(fontWeight: FontWeight.w500,fontSize:16),),
                        SizedBox(
                          height:55,
                        ),
                        RaisedButton(
                          onPressed: () {
                            if(!snapshot.hasData){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>
                                      AgreementForInvitedUser()
                                  ));
                            }
                            else{
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>
                                      LoggedUserIn(snapshot.data)
                                  ));

              }},
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            // width: 220,
                            height: 60,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color(0xFF0D47A1),
                                  Color(0xFF1976D2),
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: Center(child: const Text('팀콜에 초대 되었습니다 (신규)',style: TextStyle(fontWeight: FontWeight.bold),)),
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        RaisedButton(
                          onPressed: () {
                              if(!snapshot.hasData){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) =>
                                        LoginPage()
                                    ));
                              }
                              else{
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) =>
                                        LoggedUserIn(snapshot.data)
                                    ));
                              }

                          },
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0.0),
                          child: Container(

                            height: 60,
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
                            child: Center(child: const Text('기존 회원입니다',style: TextStyle(fontWeight: FontWeight.bold),)),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Visibility(
                           visible: snapshot.hasData,
                            child: GestureDetector(
                                onTap: () async {
                                  await FirebaseAuth.instance.signOut();
                                },
                                child: Text('로그아웃'))),
                        SizedBox(
                          height: 83,
                        ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  AgreementForCreateUser()
                              ));
                        },
                        child: Container(
                          child:  Center(child:
                          Column(
                            children: [
                              Text('"조직에서 팀콜 솔루션을 이용해 보고싶습니다"',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              SizedBox(height: 9,),
                              Visibility(
                                // visible: Platform.isAndroid,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 4.0),
                                          child: Row(
                                            children: [
                                              Text("팀콜 그룹 계정 만들기",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold)),
                                              Icon(Icons.arrow_forward,size: 15,color:Colors.white),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),


                                  ],
                                ),
                              ),

                            ],
                          )),
                        ),
                      ),
                      ],
                    ),
                  ),
                ),
              );
            }
          ),
        ),
      ),
    );
  }


  Future<FirebaseUser> signIn() async {
    try {
     await FirebaseAuth.instance.
      createUserWithEmailAndPassword(
          email: "teamcall@teamcall.kr",
          password: "123123"
      );
    } catch (e) {
      print(e.code);
      if (e.code == 'ERROR_WEAK_PASSWORD') {
        print('최소 6자 이상의 패스워드를 입력하세요.');
      }
      if( e.code == 'ERROR_INVALID_EMAIL'){
        print('잘못된 이메일 형식입니다.');
      }
      else if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        print('이미 등록되어있는 계정입니다.');
      }
    }

  }

  Future<FirebaseUser> logIn() async {
    try {
     await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "teamcall@teamcall.kr",
          password: "123123"
      );
    } catch (e) {
      print(e.code);
      if (e.code == 'ERROR_USER_NOT_FOUND') {
        print('등록되지 않은 계정입니다.');
      } else if (e.code == 'ERROR_WRONG_PASSWORD') {
        print('잘못된 패스워드입니다.');
      }
    }

  }


}