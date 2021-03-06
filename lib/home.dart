import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:team_call/detail_info.dart';
import 'package:team_call/invite.dart';
import 'package:flutter_incoming_call/flutter_incoming_call.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'dart:io' show Platform;
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'my_page.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:counter_animation/counter_animation.dart';
GlobalKey globalKey = GlobalKey();

class CallInfo{
  final String phoneNumber;
  final String name;

  CallInfo({this.phoneNumber,this.name});

  factory CallInfo.fromJson(Map<String, dynamic> json){
    return CallInfo(
      phoneNumber: json['phoneNumber'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "phoneNumber": this.phoneNumber,
      "name": this.name,
    };
  }
}

class Home extends StatefulWidget {
  var hintText = "";
  var bookmarkState = true;
  final FirebaseUser user;
  var userData;
  var bookmarkList = [];
  var bookmarkNum = 0;
  var bookmark = false;
  bool checkBoxState = true;
  var invitationSwitchForSuper = 3;
  var invitationSwitchForManager = 3;
  Home(this.user,this.userData);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double kDefaultPadding = 20.0;
  final FirebaseMessaging fcm = FirebaseMessaging();
  FocusNode myFocusNode;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchFilter = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  final myControllerName = TextEditingController();
  final myControllerPosition = TextEditingController();
  final myControllerGroup0= TextEditingController();
  final myControllerGroup1= TextEditingController();
  final myControllerGroup2= TextEditingController();
  final myControllerPhoneNumber= TextEditingController();
  final myControllerLandlineNum= TextEditingController();



  ///?????? ??????
  Future _requestPermissions() async {
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      if (await Permission.phone.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
      }
      Map<Permission, PermissionStatus> statuses = await [
        Permission.phone,
      ].request();
      print(statuses[Permission.phone]);
    }
  }
  // if (Platform.isIOS) {
  //   var arrCallInfo = [];
  //   Firestore.instance.collection('main_data').document('${widget.userData['companyUid']}').collection('main_collection').getDocuments().then((value) {
  //     value.documents.forEach((e) {
  //       if (e.data["phoneNumber"] != null) {
  //         var _callInfo = new CallInfo(phoneNumber: "82"+e.data["phoneNumber"].substring(1) ,name: e.data["group"]+' '+e.data["department"]+' '+e.data["team"]+' '+e.data["name"]+' '+e.data['position']);
  //         arrCallInfo.add(_callInfo);
  //       }
  //
  //       if (e.data["landlineNum"] != null) {
  //         var _callInfo = new CallInfo(phoneNumber: "82"+e.data["landlineNum"].substring(1) ,name: e.data["group"]+' '+e.data["department"]+' '+e.data["team"]+' '+e.data["name"]+' '+e.data['position']);
  //         arrCallInfo.add(_callInfo);
  //       }
  //     });
  //   }).whenComplete(() {
  //     //print('==================================================');
  //     var jsonStr = jsonEncode(arrCallInfo).toString();
  //     print(jsonStr+"");
  //     FlutterIncomingCall.setCallData(jsonStr);
  //   });
  // }
  void fetch_data() {
    if (Platform.isIOS) {

      var arrCallInfo = [];
      Firestore.instance.collection('main_data').document('${widget.userData['companyUid']}').collection('main_collection').getDocuments().then((value) {
        value.documents.forEach((e) {
          if (e.data["phoneNumber"] != null) {
            var _callInfo = new CallInfo(phoneNumber: "82"+e.data["phoneNumber"].substring(1) ,name: e.data["name"]+' '+e.data["position"]+' '+e.data["group"]+' '+e.data["department"]+' '+e.data["team"]);
            arrCallInfo.add(_callInfo);
          }
          if (e.data["landlineNum"] != null && e.data["landlineNum"].length > 5) {
            var _callInfo = new CallInfo(phoneNumber: "82"+e.data["landlineNum"].substring(1) ,name: e.data["name"]+' '+e.data["position"]+' '+e.data["group"]+' '+e.data["department"]+' '+e.data["team"]);
            arrCallInfo.add(_callInfo);
          }

        });
      }).whenComplete(() {
        //print('==================================================');
        var jsonStr = jsonEncode(arrCallInfo).toString();
        print(jsonStr+"");
        FlutterIncomingCall.setCallData(jsonStr);
      });
    }
  }
  @override
  void initState() {

    // if (Platform.isIOS) {
    //   fcm.requestNotificationPermissions(
    //     IosNotificationSettings(sound: true, badge: true, alert: true) );
    //     fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
    //     print("Settings registered: $settings");
    //     });
    // }
    //
    // fcm.configure( onMessage: (Map<String, dynamic> message) async { print("onMessage: $message"); }, onResume: (Map<String, dynamic> message) async { print("onResume: $message"); }, onLaunch: (Map<String, dynamic> message) async { print("onLaunch: $message"); } );
    //


    myFocusNode = FocusNode();
    myControllerGroup0.text = widget.userData['user']['group'];
    myControllerGroup1.text = widget.userData['user']['department'];
    myControllerGroup2.text = widget.userData['user']['team'];

    print(widget.userData['companyUid']);


    super.initState();
    Fluttertoast.showToast(
      msg: "????????? ????????? ??????",
      toastLength: Toast.LENGTH_LONG,
      fontSize: 18.0,
    );
    if (Platform.isAndroid) {
      var _data ={
        'platform' : 'and',
        'docLength': widget.userData['main_collection_doc_Length']
      };
      Firestore.instance.collection("id_data")
          .document(widget.userData['id_data_docID'])
          .updateData(_data)
          .then((value) {

      });

      _requestPermissions();
      FlutterIncomingCall.startService(
        title: 'TeamCall',
        text: 'TeamCall Service',
        subText: '...',
        ticker: 'Ticker',
        companyUid: widget.userData['companyUid']
      );
    } else if (Platform.isIOS) {
      print('start BackgroundFetch ===========================');
      Timer.periodic(Duration(seconds: 60), (timer) {

        fetch_data();
      });
      BackgroundFetch.configure(BackgroundFetchConfig(
          minimumFetchInterval: 15,
          stopOnTerminate: false,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.ANY
      ), (String taskId) async {  // <-- Event callback
        print("[BackgroundFetch===========] taskId: $taskId");
        fetch_data();
        switch (taskId) {
          case 'com.teamCall.appfetcher':
          // Handle your custom task here.
            break;
          default:
          // Handle the default periodic fetch task here///
        }
        // You must call finish for each taskId.
        BackgroundFetch.finish(taskId);
      }, (String taskId) async {  // <-- Task timeout callback
        // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
        BackgroundFetch.finish(taskId);
      });

      var _data ={
        'platform' : 'ios',
        'docLength': widget.userData['main_collection_doc_Length']
      };
      Firestore.instance.collection("id_data")
          .document(widget.userData['id_data_docID'])
          .updateData(_data)
          .then((value) {

      });
    }

  }

  FocusNode focusNode = FocusNode();
  String _searchText = "";
  _HomeState() {
    _searchFilter.addListener(() {
      setState(() {
        _searchText = _searchFilter.text;

      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        appBar:  appBarBuild(),

        body: ListView(

            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _buildSearchBar(),
              ),
              _buildGridView(),
              state(),
              SizedBox(
                height: 17,
              ),
              myInfo(),
              Visibility(
                  visible: !widget.userData['user']['state'],
                  child: userState()),
              Visibility(
                visible: widget.userData['user']['state'],
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: bookMark(),
                ),
              )
            ]
        ),
        floatingActionButton:
        Visibility(
          visible:  _searchText != "" ?false:true,
          child: RaisedButton(
            elevation: 0,
            hoverElevation: 0,
            focusElevation: 0,
            highlightElevation: 0,
            color: Colors.transparent,
            onPressed: () {
              // _postRequest() async {
              //   String url = 'https://asia-northeast3-teamcall-49b4c.cloudfunctions.net/sendSms?name=?????????&phoneNumber=01068276863&team=123123&sender=07077816868';
              //
              //
              //
              //   http.Response response = await http.post(
              //       url
              //   );
              // }
              //
              // _postRequest();


              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>
                  InvitePage(widget.user, widget.userData)));
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
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child:Icon(Icons.add,size: 40,),

            ),
          ),
        )
    );
  }
  Widget appBarBuild() {
    return
      PreferredSize(preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.only(top:15.0),
            child: Container(
              child: AppBar(
                automaticallyImplyLeading: false,
                titleSpacing: 0.0,
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: false,
                title: GestureDetector(
                    onTap: (){
                      FocusScope.of(context).unfocus();
                      _searchFilter.clear();
                      _searchText = "";
                    },
                    child: GestureDetector(
                      onDoubleTap: (){
                      //  trial version upraded
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left:12.0),
                        child: Image.asset('assets/text2.png',width: 135,),
                      ),
                    )),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right:10.0),
                    child: InkWell(
                      child: new Container(
                          child: Row(
                            children: [
                              Text('?????? ??????',style: TextStyle(fontSize: 17,color:_getColorFromHex('051841') ),),
                              Icon(Icons.arrow_forward_ios ,size: 17,color: _getColorFromHex('051841'),),
                            ],
                          )
                      ),
                      onTap:  ()
                      async {
                        //       onPressed: () async => {
                        //  await FirebaseAuth.instance.signOut();
                        //       },
                        _searchFilter.clear();
                        _searchText = "";
                        FocusScope.of(context).unfocus();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                                MyPage(widget.user, widget.userData)
                            ));
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
      );
  }
  Widget _buildSearchBar() {

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top:10.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 4, 0, 10),
              child: Row(
                children: [
                  Expanded(

                    child: TextField(
                      enabled: widget.userData['user']['state'] ,
                      cursorColor:  _getColorFromHex('051841'),
                      focusNode: focusNode,
                      style: TextStyle(
                          color:  _getColorFromHex('051841'),
                          fontSize: 15
                      ),
                      controller: _searchFilter,
                      decoration: InputDecoration(
                        hintText: '??????, ??????, ?????????, ??????????????? ??????',
                        hintStyle: TextStyle(fontSize: 12,color:  _getColorFromHex('051841')),
                        // filled: true,
                        // fillColor: Colors.redAccent,
                        prefixIcon: Icon(Icons.search, color:  _getColorFromHex('051841'), size: 20,),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color:  _getColorFromHex('051841')),
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color:  _getColorFromHex('051841')),
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color:  _getColorFromHex('051841')),
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildGridView() {
    return Visibility(
      visible: _searchText != ""  ? true : false,
      child: Container(
        height: 750,
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('main_data').document(widget.userData['companyUid']).collection('main_collection')
              .where('state',isEqualTo : true).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>( _getColorFromHex('051841'))));
            }
            return _buildGridViewElement(snapshot.data.documents);
          },
        ),
      ),
    );
  }
  Widget _buildGridViewElement(documents) {
    List<DocumentSnapshot> searchResults = [];
    for (DocumentSnapshot d in documents) {
      if (d.data.toString().contains(_searchText)) {
        searchResults.add(d);
      }
    }
    return Padding(
      padding: const EdgeInsets.only(top:10.0),
      child: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              FocusScope.of(context).unfocus();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>
                      DetailInfo(widget.user, widget.userData, searchResults[index])
                  ));
            },
            child: Container(
              child:
              Column(
                children: [
                  Row(
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(right:13.0,left:13),
                          child: Icon(Icons.add,size: 22, color:  _getColorFromHex('051841')),
                        ),


                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row (
                                children:[
                                  Container(
                                      width: MediaQuery.of(context).size.width * 0.65,

                                      child:
                                      Text('${searchResults[index]['group']+" "+searchResults[index]['department'] + " " +searchResults[index]['team']}',

                                      )),
                                ]
                            ),
                            SizedBox(height: 3,),
                            Row (
                                children:[
                                  Text('${searchResults[index]['name']}',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                                  SizedBox(width: 6,),
                                  Text('${searchResults[index]['position']}',style: TextStyle(fontSize: 15),),
                                  SizedBox(width: 6,),
                                ]
                            ),
                            SizedBox(height: 4,),
//                              Text('${numberWithComma(searchResults[index]['phoneNumber'])  }',style: TextStyle(fontSize: 15)),
                            Text('${numberWithComma(searchResults[index]['phoneNumber'] )}',style: TextStyle(fontSize: 15)),
                          ],
                        ),

                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right:18.0),
                          child: Column(
                            children: [
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: GestureDetector(
                                      onTap: (){
                                        Clipboard.setData(
                                            new ClipboardData(text: searchResults[index]['phoneNumber']));
                                        showTopSnackBar(
                                          context,
                                          CustomSnackBar.info(
                                            message:
                                            '${numberWithComma(searchResults[index]['phoneNumber'])} ?????????',
                                          ),
                                        );
                                      },
                                      child: Icon(Icons.content_copy,color:  _getColorFromHex('051841'),)),
                                ),
                              ),
                              Container(
                                child: GestureDetector(
                                    onTap: () async {

                                       _callNumber(searchResults[index]['phoneNumber']);
                                      // FlutterPhoneDirectCaller.callNumber(searchResults[index]['phoneNumber']);
                                    },
                                    child: Icon(Icons.phone,color:  _getColorFromHex('051841'),)),
                              )
                            ],
                          ),
                        ),

                      ]
                  ),
                  Opacity(
                      opacity: 0.15,
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 13.0, bottom: 13.0,right: 0,left: 0),
                          child: Container(
                            height: 1,
                            color:  _getColorFromHex('051841'),
                          )))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  Widget userState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10) ,
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
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.error,color:  _getColorFromHex('051841'), size: 20,),
                      Text(' ?????? ?????? ?????????',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w800),),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(' ???????????? ????????? ?????? ????????? ????????????????????????. ',style: TextStyle(fontSize: 13),),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
  Widget form(_widget) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10) ,
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
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Column(
                children: [
                  _widget

                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
  Widget myInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10) ,
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
        InkWell(
          onTap: (){
            FocusScope.of(context).unfocus();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>
                    DetailInfo(widget.user, widget.userData, widget.userData['user'])
                ));
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Visibility(
                      visible: !widget.userData['user']['state'],
                      child: Row(
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
                          Text("???????????? ?????? ????????? ????????? ????????????.",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:Colors.redAccent),),
                          // SizedBox(
                          //   width: 4,
                          // ),
                          // Icon(Icons.check_circle,size: 14,color: Colors.lightBlue,)
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.account_circle,color:  _getColorFromHex('051841'), size: 20,),
                        Text(' ??? ??????',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w800),),
                      ],
                    ),

                    _buildMyInFoElement()


                  ],
                ),

              ],
            ),
          ),
        ),
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
                              width: MediaQuery.of(context).size.width * 0.8,
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
                    Text('${numberWithComma (widget.userData['user']['phoneNumber'])}',style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),

            ]
        ),

      ],
    );
  }
  Widget bookMark(){

    return Padding(
      padding: const EdgeInsets.only(top:25.0),
      child: Container(
        height: 300,
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('main_data').document('${widget.userData['companyUid']}')
                .collection('main_collection').document('${widget.userData['docID']}').collection('bookmark').orderBy('date', descending:true).snapshots(),

            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)));
              }
              return
                snapshot.data.documents.length!=0
                    ? Scrollbar(
                  controller: _scrollController,
                  isAlwaysShown: true,
                  child: ListView.builder(
                    controller: _scrollController,

                    itemCount: snapshot.data.documents.length,
                    itemBuilder:(BuildContext context, int index){
                      return _buildBookMarkElement(snapshot.data.documents[index]['docID']);
                    },
                  ),
                )
                    :_buildBookMarkElementForFirstUser();

                // Center(child: Padding(
                //   padding: const EdgeInsets.only(bottom: 108.0),
                //   child: Text(""),
                // ));
            },
          ),
        ),
      ),
    );
  }
  Widget _buildBookMarkElement(doc) {

    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('main_data').document('${widget.userData['companyUid']}')
            .collection('main_collection').document('${doc}').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)));

          }
          return Padding(
              padding: const EdgeInsets.only(top:0.0),
              child: InkWell(
                onTap: (){
                  FocusScope.of(context).unfocus();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          DetailInfo(widget.user, widget.userData, snapshot.data)
                      ));
                },
                child: Container(
                  child:
                  Column(
                    children: [
                      Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right:13.0,left:13),
                              child: Icon(Icons.star,size: 22, color:  _getColorFromHex('051841')),
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row (
                                    children:[
                                      Container(
                                          width: MediaQuery.of(context).size.width * 0.65,
                                          child:
                                          Text('${snapshot.data['group'] +" "+snapshot.data['department'] + " " +snapshot.data['team']}',

                                          )),
                                    ]
                                ),
                                SizedBox(height: 8,),
                                Row (
                                    children:[
                                      Text('${snapshot.data['name']}',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                                      SizedBox(width: 6,),
                                      Text('${snapshot.data['position']}',style: TextStyle(fontSize: 15),),
                                      SizedBox(width: 6,),
                                    ]
                                ),
                                SizedBox(height: 4,),
                                Text('${numberWithComma(snapshot.data['phoneNumber'])}',style: TextStyle(fontSize: 15)),
                              ],
                            ),

                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right:18.0),
                              child: Column(
                                children: [
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 20),
                                      child: GestureDetector(
                                          onTap: (){
                                            Clipboard.setData(
                                                new ClipboardData(text: snapshot.data['phoneNumber']));
                                            showTopSnackBar(
                                              context,
                                              CustomSnackBar.info(
                                                message:
                                                '${numberWithComma(snapshot.data['phoneNumber'])} ?????????',
                                              ),
                                            );
                                          },
                                          child: Icon(Icons.content_copy,color:  _getColorFromHex('051841'),)),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){

                                      FlutterPhoneDirectCaller.callNumber(snapshot.data['phoneNumber']);
                                    },
                                    child: Container(
                                      child: Icon(Icons.phone,color:  _getColorFromHex('051841'),),
                                    ),
                                  )
                                ],
                              ),
                            ),

                          ]
                      ),
                      Opacity(
                          opacity: 0.15,
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 13.0, bottom: 13.0,right: 0,left: 0),
                              child: Container(
                                height: 1,
                                color:  _getColorFromHex('051841'),
                              )))
                    ],
                  ),
                ),
              )

          );
        }
    );

  }
  Widget _buildBookMarkElementForFirstUser() {

    return Padding(
        padding: const EdgeInsets.only(top:0.0),
        child: Container(
          child:
          Column(
            children: [
              Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right:13.0,left:13),
                      child: Icon(Icons.star,size: 22, color:  _getColorFromHex('051841')),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row (
                            children:[
                              Container(
                                  width: MediaQuery.of(context).size.width * 0.65,
                                  child:
                                  Text('${'???????????? ??????' +" "+'?????????????????????' + " " +'???????????????'}',
                                  )),
                            ]
                        ),
                        SizedBox(height: 8,),
                        Row (
                            children:[
                              Text('${'?????????'}',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                              SizedBox(width: 6,),
                              Text('${'??????'}',style: TextStyle(fontSize: 15),),
                              SizedBox(width: 6,),
                            ]
                        ),
                        SizedBox(height: 4,),
                        Text('070-8000-2059',style: TextStyle(fontSize: 15)),
                        SizedBox(height: 4,),
                        Text('???????????? ?????? ???????????? ??????????????????',style: TextStyle(color: Colors.grey),),
                      ],
                    ),

                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right:18.0),
                      child: Column(
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: GestureDetector(
                                  onTap: (){
                                    Clipboard.setData(
                                        new ClipboardData(text: '070-8065-2059'));
                                    showTopSnackBar(
                                      context,
                                      CustomSnackBar.info(
                                        message:
                                        ' 070-8000-2059 ?????????',
                                      ),
                                    );
                                  },
                                  child: Icon(Icons.content_copy,color:  _getColorFromHex('051841'),)),
                            ),
                          ),

                          GestureDetector(
                            onTap: (){

                              FlutterPhoneDirectCaller.callNumber('070-8065-2059');
                            },
                            child: Container(
                              child: Icon(Icons.phone,color:  _getColorFromHex('051841'),),
                            ),
                          )
                        ],
                      ),
                    ),

                  ]
              ),
              Opacity(
                  opacity: 0.15,
                  child: Padding(
                      padding: const EdgeInsets.only(
                          top: 13.0, bottom: 13.0,right: 0,left: 0),
                      child: Container(
                        height: 1,
                        color:  _getColorFromHex('051841'),
                      )))
            ],
          ),
        )

    );

  }

  Widget state() {
    Size size = MediaQuery
        .of(context)
        .size;
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('main_data').document('${widget.userData['companyUid']}').collection('main_collection').snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        return Visibility(
          visible: snapshot.data.documents.length == 0 || widget.userData['user']['state'] == false ? false : true,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: Offset(10, 23),
                  blurRadius: 28,
                  color: Colors.black12,
                ),
              ],
            ),
            margin: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            // color: Colors.blueAccent,
            height: 110,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                // Those are our background
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        _getColorFromHex('00cec9'),
                        Color(0xff0d4dff),
                      ],
                    ),
                  ),
                ),
                // our product image
                Positioned(
                  top: -15,
                  right: 30,
                  child: Container(
                    height: 160,
                    width: 189,
                    child: Padding(
                      padding: const EdgeInsets.only(left:120.0,bottom: 17),
                      child: Image.asset('assets/cloud.png'),
                    ),
                  ),
                ),

                // Product title and price
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: SizedBox(
                    height: 126,
                    // our image take 200 width, thats why we set out total width - 200
                    width: size.width - 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Spacer(),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20),
                          child: Row(
                            children: [
                              Text(" ????????? ????????? ??????", style: TextStyle(fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),),
                              SizedBox(
                                width: 10,
                              ),
                              CounterAnimation(
                                  begin: 0,
                                  end: snapshot.data.documents.length,
                                  duration: 3,
                                  curve: Curves.easeOut,
                                  textStyle: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 26,
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold)
                              ),
                              Text("+", style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 26,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold),),

                            ],
                          ),
                        ),
                        // it use the available space
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: kDefaultPadding * 1.5, // 30 padding
                            vertical: kDefaultPadding / 4, // 5 top and bottom
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              topRight: Radius.circular(60),
                            ),
                          ),
                          child: Text(
                            "?????? ????????? ??????",
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  _callNumber(num) async{
    bool res = await FlutterPhoneDirectCaller.callNumber('+821068276863');
    print(res);
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
  // void upload(){
  //   if(
  //   myControllerGroup0.text =="" ||
  //       myControllerGroup1.text =="" ||
  //       myControllerName.text =="" ||
  //       myControllerPosition.text =="" ||
  //       myControllerPhoneNumber.text ==""
  //   ){
  //     if(myControllerGroup0.text ==""){
  //
  //       showTopSnackBar(
  //         context,
  //         CustomSnackBar.error(
  //           message:
  //           "??????1??? ??????????????????",
  //         ),
  //       );
  //
  //     }else if(myControllerGroup1.text ==""){
  //       showTopSnackBar(
  //         context,
  //         CustomSnackBar.error(
  //           message:
  //           "??????2??? ??????????????????",
  //         ),
  //       );
  //     }else if(myControllerName.text =="" ){
  //
  //       showTopSnackBar(
  //         context,
  //         CustomSnackBar.error(
  //           message:
  //           "????????? ??????????????????",
  //         ),
  //       );
  //     }else if(myControllerPosition.text ==""){
  //
  //       showTopSnackBar(
  //         context,
  //         CustomSnackBar.error(
  //           message:
  //           "??????/????????? ??????????????????",
  //         ),
  //       );
  //
  //     }else if( myControllerPhoneNumber.text ==""){
  //
  //       showTopSnackBar(
  //         context,
  //         CustomSnackBar.error(
  //           message:
  //           "????????? ????????? ??????????????????",
  //         ),
  //       );
  //     }
  //   }else{
  //     Firestore.instance
  //         .collection("id_data")
  //         .where('phoneNumber', isEqualTo: '${myControllerPhoneNumber.text}')
  //         .getDocuments().then((querySnapshot) {
  //       if (querySnapshot.documents.length >= 1) {
  //         showTopSnackBar(
  //           context,
  //           CustomSnackBar.error(
  //             message:
  //             "?????? ????????? ?????? ????????? ??????????????????.",
  //           ),
  //         );
  //       }else{
  //         void dataUpdate(){
  //
  //           var _access;
  //
  //           if(widget.userData['user']['access'] == 'super'){
  //             if(widget.invitationSwitchForSuper==1){
  //               _access = 'super';
  //             }
  //             else if(widget.invitationSwitchForSuper==2){
  //               _access = 'manager';
  //             }
  //             else{
  //               _access = 'normal';
  //             }
  //           }
  //           else if(widget.userData['user']['access'] == 'manager'){
  //             if(widget.invitationSwitchForManager==2){
  //               _access = 'manager';
  //
  //             }
  //             else{
  //
  //               _access = 'normal';
  //             }
  //           }
  //           else{
  //             _access ='normal';
  //           }
  //
  //           var data = {
  //             'state' : true,
  //             'access' : _access,
  //             'inviteDate' : DateTime.now(),
  //
  //             'inviter' : widget.userData['user'].documentID,
  //             'name' : myControllerName.text,
  //             'position': myControllerPosition.text,
  //
  //             'group': myControllerGroup0.text,
  //             'department' : myControllerGroup1.text,
  //             'team' : myControllerGroup2.text,
  //             'phoneNumber': myControllerPhoneNumber.text,
  //             'registerDate': "",
  //             'landlineNum' : myControllerLandlineNum.text,
  //             'uid' : ""
  //           };
  //           // ?????? ??????
  //
  //
  //           Firestore.instance
  //               .collection('main_data')
  //               .document(widget.userData['companyUid'])
  //               .collection('main_collection')
  //               .add(data).then((value) {
  //             var data1={
  //               'phoneNumber': myControllerPhoneNumber.text,
  //               'uid' : "",
  //               'name' : myControllerName.text,
  //               'companyID' : widget.userData['companyUid'],
  //               'docID' : value.documentID
  //             };
  //
  //             Firestore.instance
  //                 .collection('id_data')
  //                 .add(data1).then((value) {
  //
  //
  //               setState(() {
  //                 widget.invitationSwitchForManager = 3;
  //                 widget.invitationSwitchForSuper = 3;
  //               });
  //
  //               myControllerGroup0.text = widget.userData['user']['group'];
  //               myControllerGroup1.text = widget.userData['user']['department'];
  //               myControllerGroup2.text = widget.userData['user']['team'];
  //
  //
  //               myControllerName.clear();
  //               myControllerPosition.clear();
  //               myControllerPhoneNumber.clear();
  //               myControllerLandlineNum.clear();
  //               Navigator.pop(context);
  //               showTopSnackBar(
  //                 context,
  //                 CustomSnackBar.info(
  //                   message:
  //                   "?????? ?????? ????????? ??????????????????.",
  //                 ),
  //               );
  //             });
  //           }
  //           );
  //         }
  //
  //         if(widget.userData['companyDoc']['plan'] == 'trial'){
  //           Firestore.instance
  //               .collection("main_data").document(widget.userData['companyUid']).collection('main_collection')
  //               .getDocuments().then((querySnapshot) {
  //             if(querySnapshot.documents.length >=11 ){
  //               //  ???????????? ??????????????? ?????????. ????????? ???????????? ??????????????? ???????????????
  //             }else{
  //               dataUpdate();
  //             }
  //           });
  //         }
  //         // else if( ?????? ????????? ?????? -- )
  //         else{
  //           dataUpdate();
  //         }
  //
  //       }
  //     });
  //   }
  // }
  snackBar(text){
    return
      scaffoldKey.currentState.showSnackBar(
          SnackBar(
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 1),
              content:
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle,color: Colors.blueAccent,),
                    SizedBox(width: 14,),
                    Text("${text}",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize:20),),
                  ],
                ),
              )));
  }
  snackBar2(text){
    return
      scaffoldKey.currentState.showSnackBar(
          SnackBar(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 600),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 1),
              content:
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle,color: Colors.blueAccent,),
                    SizedBox(width: 14,),
                    Text("${text}",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize:20),),
                  ],
                ),
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

}




