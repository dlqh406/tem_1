import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_call/InvitedUser_process/signIn_page.dart';
import 'package:team_call/agree/data.dart';
import 'package:team_call/agree/use.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../setting.dart';
import 'loggedUser_page.dart';


class AgreementForInvitedUser extends StatefulWidget {
  var totalCheck = false;
  var useCheck = false;
  var dataCheck = false;


  @override
  _AgreementForInvitedUserState createState() => _AgreementForInvitedUserState();
}

class _AgreementForInvitedUserState extends State<AgreementForInvitedUser> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 100,
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Container(
                color: Colors.transparent,
                child: Icon(Icons.arrow_back , size: 25,),
              ),
            ),
          ),
        ),
      ) ,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Image.asset('assets/text2.png',width: 120,),
            SizedBox(
              height: 15,
            ),
            Text('약관에 동의 해주세요',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
            SizedBox(
              height: 15,
            ),
            Text('팀콜에 오신걸 환영합니다.'),
            SizedBox(
              height: 8,
            ),
            Text('서비스를 사용하기 위해 동의 부탁드립니다.'),

            SizedBox(
              height: 55,
            ),
            totalCheckBtn('모든 약관에 동의'),
            use(),
            SizedBox(height: 30,),
            Visibility(
              visible: widget.useCheck == true &&widget.dataCheck == true ? false : true,
              child: StreamBuilder<FirebaseUser>(
                  stream : FirebaseAuth.instance.onAuthStateChanged,
                  builder: (context, snapshot) {
                    return RaisedButton(
                      color: Colors.transparent,
                      elevation: 0,
                      onPressed: () {

                      },
                      textColor: Colors.transparent,
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        color: Colors.transparent,
                        // width: 220,
                        height: 60,
                        padding: const EdgeInsets.all(10.0),
                        child: Center(child: const Text('다음 ',style: TextStyle(fontWeight: FontWeight.bold),)),
                      ),
                    );
                  }
              ),
            ),
            Visibility(
              visible: widget.useCheck == true &&widget.dataCheck == true ? true : false,
              child: StreamBuilder<FirebaseUser>(
                  stream : FirebaseAuth.instance.onAuthStateChanged,
                builder: (context, snapshot) {
                  return RaisedButton(
                    onPressed: () {

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                                Setting('invitedUser')
                            ));


                      },
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
                      child: Center(child: const Text('다음 ',style: TextStyle(fontWeight: FontWeight.bold),)),
                    ),
                  );
                }
              ),
            ),
            SizedBox(height: 40,),

          ],
        ),
      ),
    );
  }

  Widget totalCheckBtn(text){
    return InkWell(
      onTap: (){
        setState(() {
          if(!widget.totalCheck){
            widget.totalCheck = true;
            widget.dataCheck = true;
            widget.useCheck = true;
          }
          else{
            widget.totalCheck = !widget.totalCheck;
            widget.dataCheck = !widget.dataCheck;
            widget.useCheck = !widget.useCheck;
          }

        });
      },
      child: Container(
        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(10),
          color:  widget.totalCheck?_getColorFromHex('051841'):Colors.grey.withOpacity(0.2),

          boxShadow: [
            BoxShadow(
              offset: Offset(10,23),
              blurRadius: 40,
              color: Colors.black12,
            ),
          ],
        ),
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left:18.0),
              child:
              Row(
                children: [
                  Text("$text",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: widget.totalCheck? Colors.white:Colors.black )),
                  Spacer(),
                  widget.totalCheck?Stack(
                    children: [
                      Icon(Icons.circle ,size: 27, color:Colors.white ),
                      Icon(Icons.check_circle,size: 27, color:Colors.blue ),
                    ],
                  )
                  :Icon(Icons.check_circle,size: 27, color:Colors.grey ),
                  SizedBox(
                    width: 15,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:20),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );


  }

  Widget use(){
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),

        Row(
          children: [
            GestureDetector(
                onTap: (){

                  setState(() {
                    // widget.dataCheck = !widget.dataCheck;
                    widget.useCheck = !widget.useCheck;
                  });
                },

                child: Row(
                  children: [
                    Icon(Icons.check_circle,color: widget.useCheck?Colors.blue:Colors.grey,),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                )),

            Text(
              '(필수) 팀콜 서비스 이용약관'
            ),
            Spacer(),
            GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          UseInfo()
                  ));

                },
                child: Container(
                    color: Colors.transparent,
                    child: Icon(Icons.arrow_forward_ios,color: Colors.grey,size: 18,))),

          ],
        ),
        SizedBox(
          height: 18,
        ),
        Row(
          children: [
            GestureDetector(
              onTap: (){

                setState(() {

                  widget.dataCheck = !widget.dataCheck;
                 //widget.useCheck = !widget.useCheck;
                });
              },
              child: Row(
                children: [
                  Icon(Icons.check_circle,color: widget.dataCheck?Colors.blue:Colors.grey,),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),

            Text(
                '(필수) 팀콜 개인정보 처리 약관'
            ),
            Spacer(),
            GestureDetector(
                onTap: (){

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          DataInfo()
                      ));

                },
                child: Container(
                    color: Colors.transparent,
                    child: Icon(Icons.arrow_forward_ios,color: Colors.grey,size: 18,))),

          ],
        ),
      ],
    );
  }
  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }

}


