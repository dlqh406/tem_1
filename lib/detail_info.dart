import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:team_call/home.dart';
import 'package:team_call/root2.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


class DetailInfo extends StatefulWidget {

  int stateValue;
  int accessValue;
  final FirebaseUser user;
  var userData;
  var doc;
  DetailInfo(this.user,this.userData,this.doc);


  @override
  _DetailInfoState createState() => _DetailInfoState();

  //
}

class _DetailInfoState extends State<DetailInfo> {


  File _image;
  final picker = ImagePicker();

  Future _getImage() async {

    var image = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image.path);
    });
  }



  final myControllerName = TextEditingController();
  final myControllerPosition = TextEditingController();
  final myControllerGroup0 = TextEditingController();
  final myControllerGroup1 = TextEditingController();
  final myControllerGroup2 = TextEditingController();
  final myControllerPhoneNumber = TextEditingController();
  final myControllerLandlineNum = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    print( widget.doc.documentID);
    if (widget.doc['state'] == true) {
      setState(() {
        widget.stateValue = 1;
      });
    } else if (widget.doc['state'] == false) {
      setState(() {
        widget.stateValue = 2;
      });
    }
    if (widget.doc['access'] == 'super') {
      setState(() {
        widget.accessValue = 1;
      });
    } else if (widget.doc['access'] == 'manager') {
      setState(() {
        widget.accessValue = 2;
      });
    } else {
      setState(() {
        widget.accessValue = 3;
      });
    }


    myControllerName.text = widget.doc['name'];
    myControllerPosition.text = widget.doc['position'];
    myControllerGroup0.text = widget.doc['group'];
    myControllerGroup1.text = widget.doc['department'];
    myControllerGroup2.text = widget.doc['team'];
    myControllerPhoneNumber.text = numberWithComma(widget.doc['phoneNumber']);
    myControllerLandlineNum.text = numberWithLandline(widget.doc['landlineNum']);


    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(preferredSize: Size.fromHeight(60.0),
          child:
          AppBar(
            titleSpacing: 6.0,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Container(
                color: Colors.transparent,
                child: GestureDetector(
                    child: Icon(Icons.arrow_back , size: 25,),

                    onTap: () {


                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);
                    }),
              ),
            ),
            actions: [
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      FlutterPhoneDirectCaller.callNumber(widget.doc['phoneNumber']);
                    },
                    child: Container(
                      child: Icon(Icons.phone,color:  _getColorFromHex('051841'),),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 15.0,left: 20),
                    child: StreamBuilder(
                        stream: Firestore.instance.collection('main_data')
                            .document("${widget.userData['companyUid']}")
                            .collection('main_collection').document(
                            '${widget.userData['user'].documentID}')
                            .collection('bookmark').where(
                            'docID', isEqualTo: widget.doc.documentID)
                            .snapshots(),
                        builder: (context, snapshot) {
                          var bookmarkState = false;
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white)));
                          }

                          if (snapshot.data.documents.length == 0) {
                            bookmarkState = false;
                          } else {
                            bookmarkState = true;
                          }
                          return IconButton(onPressed: () {
                            if (bookmarkState) {
                              bookmarkState = false;
                              Firestore.instance
                                  .collection('main_data')
                                  .document(widget.userData['companyUid'])
                                  .collection('main_collection')
                                  .document(widget.userData['user'].documentID)
                                  .collection('bookmark')
                                  .getDocuments().then((value) {
                                value.documents.forEach((element) {
                                  if (element.data['docID'] ==
                                      widget.doc.documentID) {
                                    Firestore.instance
                                        .collection('main_data')
                                        .document(widget.userData['companyUid'])
                                        .collection('main_collection')
                                        .document(
                                        widget.userData['user'].documentID)
                                        .collection('bookmark')
                                        .document(element.documentID)
                                        .delete();
                                  }
                                });
                              });
                            }
                            else {
                              bookmarkState = true;
                              var data = {
                                'docID': widget.doc.documentID,
                                'date': new DateTime.now(),
                              };

                              Firestore.instance
                                  .collection('main_data')
                                  .document(widget.userData['companyUid'])
                                  .collection('main_collection')
                                  .document(widget.userData['user'].documentID)
                                  .collection('bookmark')
                                  .add(data);
                            }
                          },

                              icon: bookmarkState ? Icon(
                                  Icons.star, size: 30, color: _getColorFromHex(
                                  '051841'))
                                  : Icon(Icons.star_border, size: 30,
                                color: _getColorFromHex('051841'),)

                          );
                        }
                    ),
                  ),

                  Visibility(
                    visible: widget.userData['user']['access'] == 'super' ||
                        widget.userData['user']['access'] == 'manager' ||
                        widget.userData['docID'] == widget.doc.documentID,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: RaisedButton(
                          color: _getColorFromHex('051841'),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)
                          ),
                          onPressed: () {

                            FocusScope.of(context).unfocus();
                            scaffoldKey.currentState
                                .showSnackBar(
                                SnackBar(
                                    backgroundColor: Colors.white,
                                    duration: const Duration(seconds: 20),
                                    content:
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: [
                                          Center(
                                              child: CircularProgressIndicator(
                                                  valueColor: new AlwaysStoppedAnimation<
                                                      Color>(Colors.blue)))
                                        ],
                                      ),
                                    )));

                            var access;
                            var state;

                            if (widget.accessValue == 1) {
                              access = 'super';
                            } else if (widget.accessValue == 2) {
                              access = 'manager';
                            } else {
                              access = 'normal';
                            }

                            if (widget.stateValue == 1) {
                              state = true;
                            } else if (widget.stateValue == 2) {
                              state = false;
                            } else {
                              state = 'delete';
                            }


                            if (state == true || state == false) {
                              print('pasś`');
                              // id_data
                              if (myControllerGroup0.text != "" &&
                                  myControllerGroup1.text != "" &&
                                  myControllerName.text != "" &&
                                  myControllerPosition.text != ""
                              ) {
                                var _cN = sub(myControllerLandlineNum.text);
                                print( "_cN : $_cN");

                                if( _cN != widget.doc['landlineNum']){

                                  if( _cN[1] == "1" ){
                                    print('sdasdas123123d');
                                    scaffoldKey.currentState.hideCurrentSnackBar();
                                    showTopSnackBar(
                                      context,
                                      CustomSnackBar.info(
                                        message:
                                        '내선번호가 올바르지 않습니다.',
                                      ),
                                    );
                                  }
                                  else{
                                    Firestore.instance
                                        .collection('main_data')
                                        .document(widget.userData['companyUid'])
                                        .collection('main_collection')
                                        .where('landlineNum', isEqualTo: _cN)
                                        .getDocuments().then((value) {
                                      var docLength = value.documents.length;
                                      if(docLength == 0){
                                        print('sdasdasd');
                                        upload(state, access);
                                      }
                                      else{
                                        scaffoldKey.currentState.hideCurrentSnackBar();
                                        showTopSnackBar(
                                          context,
                                          CustomSnackBar.info(
                                            message:
                                            '입력한 유선번호는 타 그룹원이 이미 사용중입니다.',
                                          ),
                                        );
                                      }
                                    });
                                  }
                                }else{
                                  print('ok');
                                  upload(state, access);
                                }


                              }
                              else{
                                scaffoldKey.currentState.hideCurrentSnackBar();
                                showTopSnackBar(
                                  context,
                                  CustomSnackBar.info(
                                    message:
                                    '공백을 채워주세요(소속3, 내선번호 제외)',
                                  ),
                                );
                              }
                              //계정 삭제
                              if (state == 'delete') {
                                //  북마크 삭제 작업
                                void delete_bookmark() {
                                  Firestore.instance
                                      .collection('main_data')
                                      .document(widget.userData['companyUid'])
                                      .collection('main_collection')
                                      .getDocuments().then((value) {
                                    value.documents.forEach((element0) {
                                      print('element0');
                                      Firestore.instance
                                          .collection('main_data')
                                          .document(
                                          widget.userData['companyUid'])
                                          .collection('main_collection')
                                          .document(element0.documentID)
                                          .collection('bookmark')
                                          .getDocuments().then((value) {
                                        value.documents.forEach((element1) {
                                          print('element1');
                                          print(element1.documentID);
                                          if (element1.data['docID'] ==
                                              widget.doc.documentID) {
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
                                    // print( 'doc삭제');
                                  });
                                }
                                void delete_doc() {
                                  Firestore.instance
                                      .collection('main_data')
                                      .document(
                                      widget.userData['companyUid'])
                                      .collection('main_collection')
                                      .document(widget.doc.documentID)
                                      .delete().then((value) {
                                    if (widget.doc['uid'] != "" ||
                                        widget.doc['uid'] != null) {
                                      Firestore.instance
                                          .collection('id_data')
                                          .document(widget.doc['uid'])
                                          .delete().then((value) {
                                        Navigator.pushAndRemoveUntil(
                                            context, MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Home(widget.user,
                                                    widget.userData)), (
                                            route) => false);
                                      });
                                    }
                                  });
                                }

                                delete_bookmark();
                                Future.delayed(
                                    Duration(milliseconds: 2400), () =>
                                    delete_doc());
                              }
                            }
                          },
                          child:
                          Text('저장하기', style: TextStyle(fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold))),
                    ),
                  ),
                ],
              ),
            ],
          )),
      body: _buildBody(),
    );
  }
  void upload(state, access){

    var photo_url;

    void realUpload() {
      var data1 = {
        'img' : photo_url == null ? "" : photo_url,
        'state': state,
        'access': access,
        'name': myControllerName.text,
        'position': myControllerPosition.text,
        'group': myControllerGroup0.text,
        'department': myControllerGroup1.text,
        'team': myControllerGroup2.text,
        // 'phoneNumber': myControllerPhoneNumber.text.replaceAll(RegExp(r'[^0-9]'),"").replaceAll(' ', ''),
        'landlineNum': myControllerLandlineNum.text.replaceAll(RegExp(r'[^0-9]'),"").replaceAll(' ', '')
      };
      //
      var data2 = {
        'name': myControllerName.text,
        // 'phoneNumber': myControllerPhoneNumber.text.replaceAll(RegExp(r'[^0-9]'),"").replaceAll(' ', ''),
      };
      var data3 = {
        'name': myControllerName.text,
        // 'phoneNumber': myControllerPhoneNumber.text.replaceAll(RegExp(r'[^0-9]'),"").replaceAll(' ', ''),
      };
      //

      Firestore.instance
          .collection('id_data')
          .where('docID' , isEqualTo: widget.doc.documentID)
          .getDocuments()
          .then((value0) {
        var id_docId = value0.documents[0].documentID;
        Firestore.instance
            .collection('id_data')
            .document(id_docId)
            .updateData(data2)
            .then((value1) {
          // 본인인증을 한 고객이기 떄문에 user_data도 바꾸는 거임
          if(value0.documents[0]['uid'] != ""){
            print('ssss');
            Firestore.instance
                .collection('user_data')
                .document(value0.documents[0]['uid'])
                .updateData(data3).then((value){
              Firestore.instance
                  .collection('main_data')
                  .document(widget
                  .userData['companyUid'])
                  .collection(
                  'main_collection')
                  .document(
                  widget.doc.documentID)
                  .updateData(data1).then((
                  value2) {
                print('ss7777');
                showTopSnackBar(
                  context,
                  CustomSnackBar.info(
                    message:
                    '변경이 완료되었습니다',
                  ),
                );

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>
                        Root2(widget.user)
                    ));
              });

            });
          }else {
            print('ss757');
            // 본인인증을 안한 고객이기떄문에 main data 바꾸면 됨 -> 위에서 id_data는 변경했음
            Firestore.instance
                .collection('main_data')
                .document(widget
                .userData['companyUid'])
                .collection(
                'main_collection')
                .document(
                widget.doc.documentID)
                .updateData(data1).then((
                value2) {
              showTopSnackBar(
                context,
                CustomSnackBar.info(
                  message:
                  '변경이 완료되었습니다',
                ),
              );
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>
                      Root2(widget.user)
                  ));

            });
          }
        });
      });
    }

    if(_image != null ){
      print('1');
      final firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('user_photo_data')
          .child('${DateTime
          .now()
          .millisecondsSinceEpoch}.png');

      final task = firebaseStorageRef.putFile(
          _image, StorageMetadata(contentType: 'image/png')
      );
      task.onComplete.then((value){
        var downloadLink = value.ref.getDownloadURL();

        downloadLink.then((value)=>{
          photo_url = value.toString(),
          print('6666'),
          print(photo_url),
          realUpload()
        });
      });
    }
    else{
      realUpload();
    }


  }
  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 10, right: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: widget.userData['user']['access'] == 'super' ||
                  widget.userData['user']['access'] == 'manager',
              child: Row(
                children: [
                  Text('계정 상태'),
                  Visibility(
                    visible: widget.userData['user']['access'] == 'super' || widget.userData['user']['access'] == 'manager',
                    child: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child:
                        widget.userData['user']['access'] == 'super'?
                        Container(
                          child: DropdownButton(

                              value: widget.stateValue,
                              items: [
                                DropdownMenuItem(
                                  child: Text("활성", style: TextStyle(
                                      fontWeight: FontWeight.bold),),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Text("비활성", style: TextStyle(
                                      fontWeight: FontWeight.bold),),
                                  value: 2,
                                ),
                                DropdownMenuItem(
                                  child: Text("계정 삭제", style: TextStyle(
                                      fontWeight: FontWeight.bold),),
                                  value: 3,
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  widget.stateValue = value;
                                });
                              }
                          ),
                        )
                            :Container(
                          child: DropdownButton(

                              value: widget.stateValue,
                              items: [
                                DropdownMenuItem(
                                  child: Text("활성", style: TextStyle(
                                      fontWeight: FontWeight.bold),),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Text("비활성", style: TextStyle(
                                      fontWeight: FontWeight.bold),),
                                  value: 2,
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  widget.stateValue = value;
                                });
                              }
                          ),
                        )

                    ),
                  ),
                  Spacer(),
                  Visibility(
                    visible: widget.userData['user']['access'] == 'super',
                    child: Row(
                      children: [
                        Text('권한'),
                        Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child:

                            Container(
                              child: DropdownButton(
                                  value: widget.accessValue,
                                  items: [
                                    DropdownMenuItem(
                                      child: Text("슈퍼", style: TextStyle(
                                          fontWeight: FontWeight.bold),),
                                      value: 1,
                                    ),
                                    DropdownMenuItem(
                                      child: Text("매니저", style: TextStyle(
                                          fontWeight: FontWeight.bold),),
                                      value: 2,
                                    ),
                                    DropdownMenuItem(
                                      child: Text("일반", style: TextStyle(
                                          fontWeight: FontWeight.bold),),
                                      value: 3,
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      widget.accessValue = value;
                                    });
                                  }
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    _image == null?
                    CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.black12,
                      child: ClipRRect(
                        child:
                        widget.doc['img'] == "" || widget.doc['img'] == null  ?
                        CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 40,
                            child: Image.asset('assets/smile.png',width: 40,height: 40,fit: BoxFit.cover,color: Colors.grey,))
                        : Stack(
                          children: [
                            Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),),
                            Image.network('${widget.doc['img']}' ,width: 100, height: 100 ,fit: BoxFit.cover)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    )
                    :CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.black12,
                        child : Stack(
                          children: [
                            Center(child: CircularProgressIndicator(),),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                _image,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ],
                        )),

                    Visibility(
                      visible: widget.userData['docID'] == widget.doc.documentID,
                      child: Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: (){
                              _getImage();
                            },
                            child: CircleAvatar(
                                backgroundColor: Colors.black.withOpacity(0.5),
                                radius: 15.0,
                                child: Image.asset('assets/pencil.png',
                                    color: Colors.white,
                                    height: 15,
                                    width: 15,
                                    fit:BoxFit.cover
                                )
                            ),
                          )),
                    )
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left:25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('이름',style: TextStyle(color: Colors.black54,fontSize: 10),),
                        Theme(
                          data: new ThemeData(
                              primaryColor: Colors.blueAccent,
                              accentColor: Colors.orange,
                              hintColor: Colors.black
                          ),
                          child: new TextField(
                            enabled: widget.userData['user']['access'] == 'super' ||
                                widget.userData['user']['access'] == 'manager'
                                || widget.userData['docID'] == widget.doc.documentID,
                            controller: myControllerName,
                            decoration: new InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.only(bottom: 4,top: 7),
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

                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Text('직급/직책',style: TextStyle(color: Colors.black54,fontSize: 10),),
                              Theme(
                                data: new ThemeData(
                                    primaryColor: Colors.blueAccent,
                                    accentColor: Colors.orange,
                                    hintColor: Colors.black
                                ),
                                child: new TextField(
                                  enabled: widget.userData['user']['access'] == 'super' ||
                                      widget.userData['user']['access'] == 'manager' ||
                                      widget.userData['docID'] == widget.doc.documentID,

                                  controller: myControllerPosition,
                                  decoration: new InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(bottom: 4,top: 7),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: Colors.blueAccent
                                          )
                                      )
                                  ),
                                ),
                              ),
                            ])
                      ],
                    ),
                  ),
                ),
            ]),
            SizedBox(
              height: 20,
            ),
            Text('소속1(회사/사업부)',style: TextStyle(color: Colors.black54,fontSize: 10),),
            Theme(
              data: new ThemeData(
                  primaryColor: Colors.blueAccent,
                  accentColor: Colors.orange,
                  hintColor: Colors.black
              ),
              child: new TextField(
                enabled: widget.userData['user']['access'] == 'super' ||
                    widget.userData['user']['access'] == 'manager' ||
                    widget.userData['docID'] == widget.doc.documentID,
                controller: myControllerGroup0,
                decoration: new InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.only(bottom: 4,top: 7),
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
            Text('소속2(조직)',style: TextStyle(color: Colors.black54,fontSize: 10),),
            Theme(
              data: new ThemeData(
                  primaryColor: Colors.blueAccent,
                  accentColor: Colors.orange,
                  hintColor: Colors.black
              ),
              child: new TextField(
                enabled: widget.userData['user']['access'] == 'super' ||
                    widget.userData['user']['access'] == 'manager' ||
                    widget.userData['docID'] == widget.doc.documentID,
                controller: myControllerGroup1,
                decoration: new InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.only(bottom: 4,top: 7),
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
            Text('소속3(부서)',style: TextStyle(color: Colors.black54,fontSize: 10),),
            Theme(
              data: new ThemeData(
                  primaryColor: Colors.blueAccent,
                  accentColor: Colors.orange,
                  hintColor: Colors.black
              ),
              child: new TextField(
                enabled: widget.userData['user']['access'] == 'super' ||
                    widget.userData['user']['access'] == 'manager' ||
                    widget.userData['docID'] == widget.doc.documentID,
                controller: myControllerGroup2,
                decoration: new InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.only(bottom: 4,top: 7),
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
            Row(
              children: [
                Text('핸드폰',style: TextStyle(color: Colors.black54,fontSize: 10),),
                Spacer(),

              ],
            ),
            Theme(
              data: new ThemeData(
                  primaryColor: Colors.blueAccent,
                  accentColor: Colors.orange,
                  hintColor: Colors.black
              ),
              child: new TextField(
                enabled: false,
                keyboardType: TextInputType.number,
                // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                controller: myControllerPhoneNumber,
                decoration: new InputDecoration(
                    suffix : GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                              new ClipboardData(text: myControllerPhoneNumber.text));
                          showTopSnackBar(
                            context,
                            CustomSnackBar.info(
                              message:
                              '${myControllerPhoneNumber.text} 복사됨',
                            ),
                          );
                        },
                        child: Container(
                            color: Colors.transparent,
                            child: Icon(Icons.copy))
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.only(bottom: 4,top: 7),
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
            // SelectableText
            Row(
              children: [
                Text('유선번호',style: TextStyle(color: Colors.black54,fontSize: 10),),
                Spacer(),


              ],
            ),
            Theme(
              data: new ThemeData(
                  primaryColor: Colors.blueAccent,
                  accentColor: Colors.orange,
                  hintColor: Colors.black
              ),
              child: new TextField(
                enabled: widget.userData['user']['access'] == 'super' ||
                    widget.userData['user']['access'] == 'manager' ||
                    widget.userData['docID'] == widget.doc.documentID,
                keyboardType: TextInputType.number,
                controller: myControllerLandlineNum,
                decoration: new InputDecoration(
                    suffix:  GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                              new ClipboardData(text: myControllerLandlineNum.text));
                          showTopSnackBar(
                            context,
                            CustomSnackBar.info(
                              message:
                              '${myControllerLandlineNum.text} 복사됨',
                            ),
                          );
                        },
                        child: Container(
                        color: Colors.transparent,
                        child: Icon(Icons.copy))),
                    isDense: true,
                    contentPadding: EdgeInsets.only(bottom: 4,top: 7),
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
              height: 45,
            ),

          ],
        ),
      ),
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

  String numberWithComma(param) {
    var phoneNum;
    if (param.length != 11) {
      phoneNum = param;
    } else {
      phoneNum = param.substring(0, 3) + "-" + param.substring(3, 7) + "-" +
          param.substring(7, 11);
    }

    return phoneNum;
  }
    String numberWithLandline(param) {
    print(param.length);
      var phoneNum=param;
      if( param.length  <=8  || param.length >= 12){
        phoneNum = param;
      }
      else if (param[1] == "2") {
        if (param.length == 9) {
          //02-000-0000
          phoneNum = param.substring(0, 2) + "-" + param.substring(2, 5) + "-" +
              param.substring(5, 9);
        } else {
          //02-0000-0000
          phoneNum = param.substring(0, 2) + "-" + param.substring(2, 6) + "-" +
              param.substring(6, 10);
        }
      }
      else if(param.length== 10 ||param.length == 11) {
        if(param.length == 10){

          phoneNum = param.substring(0, 3) + "-" + param.substring(3, 6) + "-" +
              param.substring(6, 10);
        }
        else  {
          phoneNum = param.substring(0, 3) + "-" + param.substring(3, 7) + "-" +
              param.substring(7, 11);
        }
      }

      return phoneNum;
    }

    snackBar(text) {
      return
        scaffoldKey.currentState.showSnackBar(
            SnackBar(duration: const Duration(seconds: 1),
                content:
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.blueAccent,),
                      SizedBox(width: 14,),
                      Text("${text}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),),
                    ],
                  ),
                )));
    }
    String sub(num){
    var _num = num.replaceAll(RegExp(r'[^0-9]'),"").replaceAll(' ', '');
    return _num;
  }






}

