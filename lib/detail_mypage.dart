import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:team_call/root.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'detail_info.dart';
import 'not-logged-in.dart';

class DetailMypage extends StatefulWidget {
  var planCount;
  final FirebaseUser user;
  var userData;
  DetailMypage(this.user,this.userData);
  @override
  _DetailMypageState createState() => _DetailMypageState();
}

class _DetailMypageState extends State<DetailMypage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
@override
  void initState() {

    planCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: appBarBuild(),
      body: ListView(
        children: [
          SizedBox(
            height: 15,
          ),
          _buildHeader(),
          SizedBox(
            height: 15,
          ),
          modifyPlan(),
          SizedBox(
            height: 15,
          ),
          deleteMyself(),
          SizedBox(
            height: 15,
          ),
          logout(),

        ],
      ),
    );
  }



  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(10,23),
              blurRadius: 40,
              color: Colors.black12,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 30),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.userData['user']['state']?
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 2.0),
                              child: Text("?????? ????????? ??????",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text("??????????????? ????????? ????????? ??????????????????.",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.blue),),
                      ],
                    ):Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 2.0),
                              child: Text("?????? ???????????? ??????",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text("???????????? ?????? ????????? ????????? ????????????",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.redAccent),),
                      ],
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    myInfo(),
                    SizedBox(
                      height: 7,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*1,
                      child: RaisedButton(
                        color: Colors.blue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),),
                        child: Text("??? ?????? ????????????",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                        onPressed:(){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  DetailInfo(widget.user,widget.userData,widget.userData['user'])));

                        },
                      ),
                    ),

                    Visibility(
                      visible: widget.userData['user']['state'] == 'super' ?true:false,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance.collection('main_data').document(widget.userData['companyUid']).collection('main_collection').snapshots() ,
                        builder: (context, snapshot) {
                          if(!snapshot.hasData){
                            return Center(child: CircularProgressIndicator(),);
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top:8.0),
                            child: Text('?????? ?????? ?????? ???: ${widget.planCount} / ??? ?????? ?????? ??? : ${snapshot.data.documents.length}',style: TextStyle(fontWeight : FontWeight.bold),),
                          );
                        }
                      ),
                    )
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  String planCount() {

    var plan = widget.userData['companyDoc']['plan'];
    var count;
    if( plan == 'trial'){
      count = '15';
    }
    else if( plan == 'standard'){
      count = '150';
    }
    else if( plan == 'pro'){
      count = '550';
    }

    else if( plan == 'enterprise'){
      count = '1000';
    }
    else if( plan == 'superTrial'){
      count = '???????????????';
    }
    else{
      count = '??? ??? ??????';
    }

    setState(() {
      widget.planCount = count;
    });

  }

  Widget myInfo() {
    return Container(

      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [

              _buildMyInFoElement(),



            ],
          ),

        ],
      ),
    );
  }

  Widget _buildMyInFoElement() {
    return Column(
      children: [
        Row(
            children: [
              Container(

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 13,),
                    Row (
                        children:[
                          Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text('${widget.userData['user']['group'] +" "+ widget.userData['user']['department']+" "+ widget.userData['user']['team']}')),
                        ]
                    ),
                    SizedBox(height: 8,),
                    Row (
                        children:[
                          Text('${widget.userData['user']['name']}',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                          SizedBox(width: 6,),
                          Text('${widget.userData['user']['position']}',style: TextStyle(fontSize: 15),),
                          SizedBox(width: 6,),
                        ]
                    ),
                    SizedBox(height: 8,),
                    Text('${numberWithComma(widget.userData['user']['phoneNumber']) }',style: TextStyle(fontSize: 15)),
                    SizedBox(height: 8,),
                    Text(widget.user.email,style: TextStyle(fontSize: 15)),
                    SizedBox(height: 8,),

                  ],
                ),
              ),

            ]
        ),

      ],
    );
  }

  Widget appBarBuild() {
    return
      PreferredSize(preferredSize: Size.fromHeight(60.0),
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
                          child: Icon(Icons.arrow_back ,color: Colors.black ),
                        ))),
                title: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Text('?????? ??????')),
              ),
            ),
          )
      );
  }

  Widget logout() {
    return InkWell(
      onTap: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (BuildContext context) =>
                Root()), (route) => false);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
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
                    Text("????????????",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Spacer(),

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
      ),
    );
  }

  Widget deleteMyself() {
    return GestureDetector(
      onTap: (){
        snackForDelete();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
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
                height: 17,
              ),
              Padding(
                padding: const EdgeInsets.only(left:18.0),
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.cancel,size: 20,color: Colors.redAccent,),
                        SizedBox(width: 6,),
                        Text("?????? ?????????",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        Spacer(),

                        SizedBox(
                          width: 15,
                        )
                      ],
                    ),
                    SizedBox(height:10,),
                    Text('?????? ??? ???????????? ????????? ?????? ???????????? ???????????? ???????????????.',style: TextStyle(fontSize: 12),),
                    SizedBox(
                      height: 5,
                    ),
                    Text('?????? ????????? ?????? ???????????? ?????? ?????? ??? ????????? ????????? ?????????.',style: TextStyle(fontSize: 12),),
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
                height: 17,
              )
            ],
          ),
        ),
      ),
    );
  }


  bool superTrialState() {
    var state =false;
    if( widget.userData['user']['access'] == 'super' ){
      if(widget.userData['companyDoc']['superTrial'] == false || widget.userData['companyDoc']['superTrial'] == null){
        state = true;
      }
    }
    return state;
  }


  Widget modifyPlan() {
    return
      StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('setting').document('superTrial').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }
          return Visibility(
          visible: snapshot.data['state'],
          child: Visibility(
            visible: Platform.isIOS?false:true,
            child: Visibility(
              visible :  superTrialState(),
              child: InkWell(
                onTap: () async {
                  snackForSuperTrial();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.star,size: 20,color: Colors.blueAccent,),
                                  SizedBox(width: 6,),
                                  Text("?????? ????????? ??????",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  Spacer(),

                                  SizedBox(
                                    width: 15,
                                  )
                                ],
                              ),
                              SizedBox(height:10,),
                              Text('?????? ???????????? ????????? ?????? ????????? ???????????? ????????? ??? ????????????. ',style: TextStyle(fontSize: 12),),
                              SizedBox(
                                height: 5,
                              ),
                              Text('?????? ?????? ?????? ????????? ?????????, ?????? ????????? ????????? ?????? ?????????.',style: TextStyle(fontSize: 12),),
                              SizedBox(
                                height: 5,
                              ),
                              Text('?????????????????? ??????????????? ????????? ???????????????.',style: TextStyle(fontSize: 12),),
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
                ),
              ),
            ),
          ),
    );
        }
      );
  }
  Widget snackForSuperTrial(){
    var date = new DateTime.now();
    var newDate = new DateTime(date.year, date.month + 1, date.day);

    scaffoldKey.currentState
        .showSnackBar(
        SnackBar(
            duration: Duration(seconds: 120),
            backgroundColor: Colors.white.withOpacity(0.98),
            content:
            Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle,color: _getColorFromHex('051841'),size: 70,),
                SizedBox(height: 24,),
                Text('?????????????????? ?????????????????????????',style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold,color: Colors.black),),
                SizedBox(height: 10,),
                Text('?????? ?????? ????????? ?????? ????????? ??????????????????!',style: TextStyle(fontSize: 15, color: Colors.black),),
                SizedBox(height: 10,),
                Text('??????????????? ???????????? : ${newDate.year}??? ${newDate.month}??? ${newDate.day}???',style: TextStyle(fontSize: 15, color: Colors.black),),

                SizedBox(
                  height: 25,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      color: Colors.grey,
                      onPressed: (){
                        scaffoldKey.currentState.hideCurrentSnackBar();
                      },
                      child: Text('??????',style: TextStyle(color: Colors.white),
                      ),

                    ),
                    SizedBox(
                      width: 20,
                    ),
                    RaisedButton(
                      color: _getColorFromHex('051841'),
                        onPressed: (){
                          var date = new DateTime.now();
                          var newDate = new DateTime(date.year, date.month + 1, date.day);

                          var data = {
                            'plan' : 'superTrial',
                            'superTrial' : true,
                            'expire_superTrial' : newDate,
                          };
                          // ?????? ??????

                          Firestore.instance
                              .collection('main_data')
                              .document(widget.userData['companyUid'])
                              .updateData(data).then((value) {
                            scaffoldKey.currentState.hideCurrentSnackBar();
                            showTopSnackBar(
                              context,
                              CustomSnackBar.info(
                                message:
                                "?????? ???????????? ?????????????????????. \n${newDate.year}??? ${newDate.month}??? ${newDate.day}?????? ???????????????.",
                              ),
                            );
                          });


                        },
                        child: Text('??????????????? ?????? ??????',style: TextStyle(color: Colors.white),
                        ),

                    ),
                  ],
                )
              ],
            )
            )));
  }

  Widget snackForDelete(){
    var date = new DateTime.now();
    var newDate = new DateTime(date.year, date.month + 1, date.day);


    scaffoldKey.currentState
        .showSnackBar(
        SnackBar(
            duration: Duration(seconds: 120),
            backgroundColor: Colors.white.withOpacity(0.98),
            content:
            Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle,color: Colors.red,size: 70,),
                SizedBox(height: 24,),
                Text('????????? ??????????????????????',style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold,color: Colors.black),),
                SizedBox(height: 10,),
                Text('?????? ??? ???????????? ????????? ?????? ???????????????.',style: TextStyle(fontSize: 15, color: Colors.black),),
                SizedBox(height: 5,),
                Text('?????? ????????? ???????????? ????????? ?????? ??? ????????? ????????? ?????????.',style: TextStyle(fontSize: 15, color: Colors.black),),


                SizedBox(
                  height: 25,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      color: Colors.grey,
                      onPressed: (){
                        scaffoldKey.currentState.hideCurrentSnackBar();
                      },
                      child: Text('??????',style: TextStyle(color: Colors.white),
                      ),

                    ),
                    SizedBox(
                      width: 20,
                    ),
                    RaisedButton(
                      color: Colors.red,
                      onPressed: (){
                        scaffoldKey.currentState.hideCurrentSnackBar();

                         //  ????????? ?????? ??????
                        scaffoldKey.currentState
                            .showSnackBar(
                            SnackBar(
                                backgroundColor: Colors.white,
                                duration: const Duration(seconds: 30),
                                content:
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .center,
                                    children: [
                                      Text('????????? ?????????', style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.black),),
                                      SizedBox(height: 24,),
                                      Center(
                                          child: CircularProgressIndicator(
                                              valueColor: new AlwaysStoppedAnimation<
                                                  Color>(Colors.blue)))
                                    ],
                                  ),
                                )));
                        void delete_bookmark(){
                          Firestore.instance
                              .collection('main_data')
                              .document(widget.userData['companyUid'])
                              .collection('main_collection')
                              .getDocuments().then((value) {
                            value.documents.forEach((element0) {
                              print('element0');
                              Firestore.instance
                                  .collection('main_data')
                                  .document(widget.userData['companyUid'])
                                  .collection('main_collection')
                                  .document(element0.documentID)
                                  .collection('bookmark')
                                  .getDocuments().then((value) {
                                value.documents.forEach((element1) {

                                  if (element1.data['docID'] == widget.userData['docID']) {

                                    print(element1.documentID);
                                    Firestore.instance
                                        .collection('main_data')
                                        .document(
                                        widget.userData['companyUid'])
                                        .collection('main_collection')
                                        .document(element0.documentID)
                                        .collection('bookmark')
                                        .document(element1.documentID)
                                        .delete();
                                  }
                                });

                              });
                            });
                            //
                            // print( 'doc??????');
                          });
                        }
                        void delete_doc(){
                          Firestore.instance.collection('id_data').getDocuments().then((querySnapshot) {
                            querySnapshot.documents.forEach((element) {
                              if(element.data['phoneNumber'] == widget.userData['user']['phoneNumber']){
                                Firestore.instance.collection('id_data').document(element.documentID)
                                    .delete().then((value) {
                                });
                              }
                            });
                          });
                          Future.delayed(Duration(seconds: 3), () {
                            Firestore.instance.collection('main_data').document(widget.userData['companyUid'])
                                .collection('main_collection').document(widget.userData['docID']).delete().then((value) {

                              showTopSnackBar(
                                context,
                                CustomSnackBar.info(
                                  message:
                                  '?????? ?????????',
                                ),
                              );
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      NotLoggedIn()), (route) => false);
                            });
                          });
                        }
                        delete_bookmark();
                        Future.delayed(Duration(milliseconds:2500), () => delete_doc());
                      },
                      child: Text('?????? ?????????',style: TextStyle(color: Colors.white),
                      ),

                    ),
                  ],
                )
              ],
            )
            )));
  }

  String numberWithComma(param){
    var phoneNum;
    if(param.length != 11){
      phoneNum=param;
    }else{
      phoneNum=  param.substring(0, 3) + "-" + param.substring(3, 7)+ "-" + param.substring(7, 11);
    }



    return phoneNum;
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
