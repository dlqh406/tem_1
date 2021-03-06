import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_call/phoneCertification/screens/certification.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../not-logged-in.dart';

class c_PhoneCertification extends StatefulWidget {
  int paymentValue = 1;
  final FirebaseUser user;
  var groupDocID;
  var groupName;
  c_PhoneCertification(this.user,this.groupDocID,this.groupName);

  @override
  _c_PhoneCertificationState createState() => _c_PhoneCertificationState();
}
class _c_PhoneCertificationState extends State<c_PhoneCertification> {
  final myControllerName = TextEditingController();
  final myControllerBirth = TextEditingController();
  final myControllerPhone = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      appBar:  AppBar(
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, top: 10, right: 30),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_circle,color:Colors.grey,),
                Icon(Icons.keyboard_arrow_right,color: Colors.grey),
                Icon(Icons.phone_android_rounded,color: Color(0xFF0D47A1)),
                Icon(Icons.keyboard_arrow_right,color: Colors.grey),
                Icon(Icons.check_circle,color: Colors.grey)
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Center(child: Text("본인 인증",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),)),
            SizedBox(
              height: 40,
            ),
            Text('성함'),
            Theme(
              data: new ThemeData(
                  primaryColor: Colors.blueAccent,
                  accentColor: Colors.orange,
                  hintColor: Colors.black
              ),
              child: new TextField(
                controller: myControllerName,
                decoration: new InputDecoration(
                    hintText: "고객님의 성함을 입력해주세요",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: new UnderlineInputBorder(
                        borderSide: new BorderSide(
                            color: Colors.blueAccent
                        )
                    )
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text('생년월일 (8자리)'),
            Theme(
              data: new ThemeData(
                  primaryColor: Colors.blueAccent,
                  accentColor: Colors.orange,
                  hintColor: Colors.black
              ),
              child: new TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                controller: myControllerBirth,
                decoration: new InputDecoration(
                    hintText: "예) 19941031",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: new UnderlineInputBorder(
                        borderSide: new BorderSide(
                            color: Colors.blueAccent
                        )
                    )
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),

            Row(
              children: [
                Text('휴대폰 번호'),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Container(
                    child: DropdownButton(
                        value: widget.paymentValue,
                        items: [
                          DropdownMenuItem(
                            child: Text(
                              "SKT", style: TextStyle(fontWeight: FontWeight
                                .bold),),
                            value: 1,
                          ),
                          DropdownMenuItem(
                            child: Text(
                              "KT", style: TextStyle(fontWeight: FontWeight
                                .bold),),
                            value: 2,
                          ),
                          DropdownMenuItem(
                            child: Text(
                              "LGU+", style: TextStyle(fontWeight: FontWeight
                                .bold),),
                            value: 3,
                          ),
                          DropdownMenuItem(
                            child: Text(
                              "알뜰폰", style: TextStyle(fontWeight: FontWeight
                                .bold),),
                            value: 4,
                          ),

                        ],
                        onChanged: (value) {
                          setState(() {
                            widget.paymentValue = value;
                          });
                        }
                    ),
                  ),
                ),

              ],
            ),
            Theme(
              data: new ThemeData(
                  primaryColor: Colors.blueAccent,
                  accentColor: Colors.orange,
                  hintColor: Colors.black
              ),
              child: SizedBox(
                height: 35,
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  controller: myControllerPhone,
                  decoration: new InputDecoration(
                      hintText: "- 없이 번호만 입력해주세요",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: new UnderlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.blueAccent
                          )
                      )
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            RaisedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  snack();
                  if (myControllerName.text == "" ||
                      myControllerPhone.text == "" ||
                      myControllerBirth.text == "") {
                    scaffoldKey.currentState.hideCurrentSnackBar();
                    showTopSnackBar(
                      context,
                      CustomSnackBar.error(
                        message:
                        "모든 정보를 입력해주세요.",
                      ),
                    );
                  } else {
                    if (myControllerBirth.text.length == 8) {
                      var date = new DateTime.now().toString();
                      var dateParse = DateTime.parse(date);
                      var formattedDate = dateParse.year.toString();
                      var userBirth = myControllerBirth.text;
                      var currentY = formattedDate;
                      var equalY = int.parse(currentY) - int.parse(
                          userBirth[0] + userBirth[1] + userBirth[2] +
                              userBirth[3]);
                      var currentM = dateParse.month.toString();
                      var currentD = dateParse.day.toString();
                      var userMM = userBirth[4] + userBirth[5];
                      var userDD = userBirth[6] + userBirth[7];
                      if (int.parse(currentM) - int.parse(userMM) > 0 ==
                          false) {
                        if (int.parse(currentD) - int.parse(userDD) > 0 ==
                            false) {
                          equalY = equalY - 1;
                        }
                      }
                      print(equalY);

                      if (equalY >= 14) {

                        Firestore.instance
                            .collection("id_data")
                            .where('phoneNumber',
                            isEqualTo: '${myControllerPhone.text}')
                            .getDocuments().then((querySnapshot) {
                          if (querySnapshot.documents.length > 0) {
                            scaffoldKey.currentState.hideCurrentSnackBar();
                            showTopSnackBar(
                              context,
                              CustomSnackBar.error(
                                message:
                                "[이미 가입된 정보] 해당정보로 가입을 원할경우 그룹 나가기를 먼저 진행해주세요.",
                              ),
                            );
                          }
                          else {
                            var data ={
                              'creator': true,
                              'companyID' : widget.groupDocID,
                              'access' : "super",
                              'inviteDate' : new DateTime.now(),
                              'uid': widget.user.uid,
                              'registerDate' :new DateTime.now(),
                              'state' : true,
                              'inviter' : widget.user.uid,
                              'landlineNum' : '유선번호을 입력해 주세요',
                              'group' : widget.groupName,
                              'department' : '소속을 자세히',
                              'team' : '입력해 주세요',
                              'name' : myControllerName.text,
                              'position' : '직책을 입력해 주세요',
                              'phoneNumber' : myControllerPhone.text,
                            };
                            var carrier;
                            if (widget.paymentValue == 1) {
                              carrier = "SKT";
                            }
                            else if (widget.paymentValue == 2) {
                              carrier = "KTF";
                            }
                            else if (widget.paymentValue == 3) {
                              carrier = "LGT";
                            }
                            else {
                              carrier = "MVNO";
                            }
                            scaffoldKey.currentState.hideCurrentSnackBar();

                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) =>
                                    Certification(
                                        widget.user,carrier,myControllerName.text,myControllerPhone.text,myControllerBirth.text,data,'c'
                                    )));
                          }
                        });
                      }
                      else {
                        scaffoldKey.currentState.hideCurrentSnackBar();
                        showTopSnackBar(
                          context,
                          CustomSnackBar.error(
                            message:
                            "만 14세 미만 아동의 회원가입은\n고객센터 문의 바랍니다.",
                          ),
                        );
                      }
                    } else {
                      scaffoldKey.currentState.hideCurrentSnackBar();
                      showTopSnackBar(
                        context,
                        CustomSnackBar.error(
                          message:
                          "생년 월일을 8자리로 입력해주세요 \n예시)19941031",
                        ),
                      );
                    }
                  }
                },
              padding: const EdgeInsets.all(0.0),
              textColor: Colors.white,
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
                child: Center(child:
                const Text('본인 인증',style: TextStyle(fontWeight: FontWeight.bold),)),
              ),
            ),

          ],
        ),
      ),
    );
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


