import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:http/http.dart' as http;
class InvitePage extends StatefulWidget {
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
  bool send_message = true;
  InvitePage(this.user,this.userData);
  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {

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

  @override
  void initState() {
    if(widget.userData['companyDoc']['plan'] == 'trial'){
      setState(() {
        widget.send_message = false;
        widget.checkBoxState = false;
      });
    }


    myFocusNode = FocusNode();
    myControllerGroup0.text = widget.userData['user']['group'];
    myControllerGroup1.text = widget.userData['user']['department'];
    myControllerGroup2.text = widget.userData['user']['team'];
    print(widget.userData['companyUid']);
    super.initState();
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
  // Image.asset('assets/guide/permission/and.png',
  // fit: BoxFit.cover,
  // width: double.infinity,
  // alignment: Alignment.center,
  //
  // )
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
      appBar: appBarBuild(),
        body:
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child:
          buildBottomSheet(context),
        ),
      ));
  }

  Widget appBarBuild() {
    return
      PreferredSize(preferredSize: Size.fromHeight(30.0),
          child: Padding(
            padding: const EdgeInsets.only(top:0.0),
            child: Container(
              child: AppBar(
                automaticallyImplyLeading: false,
                titleSpacing: 0.0,
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: false,
            ),
          )
      ));
  }
  Widget buildBottomSheet(BuildContext context) {
    String getDeviceType() {
      final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
      return data.size.shortestSide < 600 ? 'phone' :'tablet';
      //return data.size.shortestSide < 600 ? 'tablet' :'tablet';
    }
    Size size = MediaQuery.of(context).size;

          return Container(
            child:
            Column(
              children: [
                Visibility(
                  visible: getDeviceType() == 'tablet' ? true:false,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Row(
                      children: [
                        RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),),
                            color:  _getColorFromHex('051841'),
                            child: Text('?????? ????????????',style: TextStyle(color:Colors.white),),
                            onPressed: (){
                              upload();
                            }),
                        Spacer(),
                        GestureDetector(child: Container(
                            color: Colors.transparent,
                            child: Icon(Icons.close,size: 20,)),
                            onTap:(){
                              setState(() {
                                widget.invitationSwitchForManager = 3;
                                widget.invitationSwitchForSuper = 3;

                              });

                              myControllerGroup0.text = widget.userData['user']['group'];
                              myControllerGroup1.text = widget.userData['user']['department'];
                              myControllerGroup2.text = widget.userData['user']['team'];


                              myControllerName.clear();
                              myControllerPosition.clear();
                              myControllerPhoneNumber.clear();
                              myControllerLandlineNum.clear();
                              Navigator.pop(context);
                            }),
                      ],
                    ),
                  ),
                ),
                Container(
                  // height: MediaQuery.of(context).size.height * 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('????????? ????????? ????????? ??????????????????.',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                              SizedBox(height: 5),

                               Visibility(
                                 visible:  widget.userData['companyDoc']['plan'] == 'trial'?false : true ,
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   children: [
                                     SizedBox(
                                       width:20,
                                       child: Checkbox(
                                         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                         activeColor: _getColorFromHex('051841'),

                                         value:  widget.send_message, //????????? false
                                         onChanged: (value){
                                           setState(() {
                                             widget.send_message = value;
                                             print( widget.send_message);
                                           });
                                         },
                                       ),
                                     ),
                                     SizedBox(width: 10,),

                                     Text('????????? ???????????? ?????? ?????? ?????? ??????',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15),),
                                   ],
                                 ),
                               ),
                              SizedBox(height: 5,),

                            ],
                          ),
                          Spacer(),
                          Visibility(
                            visible: getDeviceType() == 'tablet' ? false:true,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(child:

                              Container(
                                width: 30,
                                height: 42,
                                color: Colors.transparent,
                                  child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Icon(Icons.close,size: 25,))),
                                  onTap:(){


                                    setState(() {
                                      widget.invitationSwitchForManager = 3;
                                      widget.invitationSwitchForSuper = 3;

                                    });

                                    myControllerGroup0.text = widget.userData['user']['group'];
                                    myControllerGroup1.text = widget.userData['user']['department'];
                                    myControllerGroup2.text = widget.userData['user']['team'];


                                    myControllerName.clear();
                                    myControllerPosition.clear();
                                    myControllerPhoneNumber.clear();
                                    myControllerLandlineNum.clear();
                                    Navigator.pop(context);
                                  }),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Visibility(
                        visible: widget.userData['user']['access'] == 'super',
                        child: Row(
                          children: [
                            Text('??????'),
                            Padding(
                                padding: const EdgeInsets.only(left:18.0),
                                child:

                                Container(
                                  child: DropdownButton(

                                      value: widget.invitationSwitchForSuper,
                                      items: [
                                        DropdownMenuItem(
                                          child: Text("??????",style: TextStyle(fontWeight: FontWeight.bold),),
                                          value: 1,
                                        ),
                                        DropdownMenuItem(
                                          child: Text("?????????",style: TextStyle(fontWeight: FontWeight.bold),),
                                          value: 2,
                                        ),
                                        DropdownMenuItem(
                                          child: Text("??????",style: TextStyle(fontWeight: FontWeight.bold),),
                                          value: 3,
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          widget.invitationSwitchForSuper = value;
                                        });
                                        print(widget.invitationSwitchForSuper);
                                      }
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: widget.userData['user']['access'] == 'manager',
                        child: Row(
                          children: [
                            Text('??????'),
                            Padding(
                                padding: const EdgeInsets.only(left:18.0),
                                child:

                                Container(
                                  child: DropdownButton(
                                      value: widget.invitationSwitchForManager,
                                      items: [
                                        DropdownMenuItem(
                                          child: Text("?????????",style: TextStyle(fontWeight: FontWeight.bold),),
                                          value: 2,
                                        ),
                                        DropdownMenuItem(
                                          child: Text("??????",style: TextStyle(fontWeight: FontWeight.bold),),
                                          value: 3,
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          widget.invitationSwitchForManager = value;
                                        });
                                        print(value);
                                      }
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Text('*',style: TextStyle(color: Colors.red),),
                          Text('??????1(?????????/?????????)'),
                        ],
                      ),

                      SizedBox(height: 8),
                      Theme(
                        data: new ThemeData(
                            primaryColor: Colors.blueAccent,
                            accentColor: Colors.orange,
                            hintColor: Colors.black
                        ),
                        child: new TextField(
                          onTap: (){
                            if( myControllerGroup0.text ==widget.userData['user']['group'] ){
                              myControllerGroup0.clear();
                            }
                          },
                          controller: myControllerGroup0,
                          decoration: new InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                              isDense: true,
                              hintStyle: TextStyle(color: Colors.grey),
                              border: new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Colors.blueAccent
                                  )
                              )
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text('*',style: TextStyle(color: Colors.red),),
                          Text('??????2(??????)'),
                        ],
                      ),

                      SizedBox(height: 8),
                      Theme(
                        data: new ThemeData(
                            primaryColor: Colors.blueAccent,
                            accentColor: Colors.orange,
                            hintColor: Colors.black
                        ),
                        child: new TextField(
                          onTap: (){

                            if(myControllerGroup1.text == widget.userData['user']['department']){
                              myControllerGroup1.clear();
                            }

                          },
                          controller: myControllerGroup1,
                          decoration: new InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                              isDense: true,
                              hintStyle: TextStyle(color: Colors.grey),
                              border: new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Colors.blueAccent
                                  )
                              )
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('??????3(??????)'),
                      SizedBox(height: 8),
                      Theme(
                        data: new ThemeData(
                            primaryColor: Colors.blueAccent,
                            accentColor: Colors.orange,
                            hintColor: Colors.black
                        ),
                        child: new TextField(
                          onTap: (){
                            if( myControllerGroup2.text == widget.userData['user']['team']){
                              myControllerGroup2.clear();
                            }
                          },
                          controller: myControllerGroup2,
                          decoration: new InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                              isDense: true,
                              hintStyle: TextStyle(color: Colors.grey),
                              border: new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Colors.blueAccent
                                  )
                              )
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text('*',style: TextStyle(color: Colors.red),),
                          Text('??????'),
                        ],
                      ),
                      SizedBox(height: 8),
                      Theme(
                        data: new ThemeData(
                            primaryColor: Colors.blueAccent,
                            accentColor: Colors.orange,
                            hintColor: Colors.black
                        ),
                        child: new TextField(
                          focusNode: myFocusNode,
                          controller: myControllerName,

                          decoration: new InputDecoration(
                              hintText: widget.hintText,
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                              isDense: true,
                              hintStyle: TextStyle(color: Colors.grey),
                              border: new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Colors.blueAccent
                                  )
                              )
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: [
                          Row(
                            children: [
                              Text('*',style: TextStyle(color: Colors.red),),
                              Text('??????/??????'),
                            ],
                          ),
                          SizedBox(height: 5),
                          Theme(
                            data: new ThemeData(
                                primaryColor: Colors.blueAccent,
                                accentColor: Colors.orange,
                                hintColor: Colors.black
                            ),
                            child: new TextField(
                              controller: myControllerPosition,
                              decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical:5),
                                  isDense: true,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: new UnderlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: Colors.blueAccent
                                      )
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text('*',style: TextStyle(color: Colors.red),),
                          Text('????????? ??????'),
                        ],
                      ),
                      SizedBox(height: 8),
                      Theme(
                        data: new ThemeData(
                            primaryColor: Colors.blueAccent,
                            accentColor: Colors.orange,
                            hintColor: Colors.black
                        ),
                        child: new TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                          controller: myControllerPhoneNumber,

                          decoration: new InputDecoration(

                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                              isDense: true,
                              hintStyle: TextStyle(color: Colors.redAccent),
                              border: new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Colors.blueAccent
                                  )
                              )
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                      Text('?????? ??????'),
                      SizedBox(height: 8),
                      Theme(
                        data: new ThemeData(
                            primaryColor: Colors.blueAccent,
                            accentColor: Colors.orange,
                            hintColor: Colors.black
                        ),
                        child: new TextField(
                          controller: myControllerLandlineNum,
                          keyboardType: TextInputType.number,
                          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                          decoration: new InputDecoration(

                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                              isDense: true,
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
                        height: 25,
                      ),
                      Visibility(
                        visible: getDeviceType() == 'tablet' ? false:true,
                        child: SizedBox(
                            width: size.width * 0.9,
                            height: size.height*0.065,
                            child: RaisedButton(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),),
                              color:  _getColorFromHex('051841'),
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

                                upload();
                              },
                              child: const Text('?????? ????????????',
                                  style: TextStyle( color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                            )),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          );


  }
  _callNumber(num) async{
    bool res = await FlutterPhoneDirectCaller.callNumber('+821068276863');
    print( res);
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
  void upload(){
    if(
    myControllerGroup0.text =="" ||
        myControllerGroup1.text =="" ||
        myControllerName.text =="" ||
        myControllerPosition.text =="" ||
        myControllerPhoneNumber.text ==""
    ){
      scaffoldKey.currentState.hideCurrentSnackBar();
      if(myControllerGroup0.text ==""){

        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message:
            "??????1??? ??????????????????",
          ),
        );

      }else if(myControllerGroup1.text ==""){
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message:
            "??????2??? ??????????????????",
          ),
        );
      }else if(myControllerName.text =="" ){

        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message:
            "????????? ??????????????????",
          ),
        );
      }else if(myControllerPosition.text ==""){

        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message:
            "??????/????????? ??????????????????",
          ),
        );

      }else if( myControllerPhoneNumber.text ==""){

        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message:
            "????????? ????????? ??????????????????",
          ),
        );
      }
    }else{
      // ??????????????? ?????? ??????
      Firestore.instance
          .collection("id_data")
          .where('phoneNumber', isEqualTo: '${myControllerPhoneNumber.text}')
          .getDocuments().then((querySnapshot) {
        if (querySnapshot.documents.length >= 1) {
          scaffoldKey.currentState.hideCurrentSnackBar();
          showTopSnackBar(
            context,
            CustomSnackBar.error(
              message:
              "?????? ????????? ?????? ????????? ??????????????????.",
            ),
          );
        }

        else{
          void dataUpdate(){

            var _access;

            if(widget.userData['user']['access'] == 'super'){
              if(widget.invitationSwitchForSuper==1){
                _access = 'super';
              }
              else if(widget.invitationSwitchForSuper==2){
                _access = 'manager';
              }
              else{
                _access = 'normal';
              }
            }
            else if(widget.userData['user']['access'] == 'manager'){
              if(widget.invitationSwitchForManager==2){
                _access = 'manager';

              }
              else{

                _access = 'normal';
              }
            }
            else{
              _access ='normal';
            }

            var data = {
              'state' : true,
              'access' : _access,
              'inviteDate' : DateTime.now(),

              'inviter' : widget.userData['user'].documentID,
              'name' : myControllerName.text,
              'position': myControllerPosition.text,

              'group': myControllerGroup0.text,
              'department' : myControllerGroup1.text,
              'team' : myControllerGroup2.text,
              'phoneNumber': myControllerPhoneNumber.text,
              'registerDate': "",
              'landlineNum' : myControllerLandlineNum.text,
              'uid' : ""
            };
            // ?????? ??????


            Firestore.instance
                .collection('main_data')
                .document(widget.userData['companyUid'])
                .collection('main_collection')
                .add(data).then((value) {
              var data1={
                'phoneNumber': myControllerPhoneNumber.text,
                'uid' : "",
                'name' : myControllerName.text,
                'companyID' : widget.userData['companyUid'],
                'docID' : value.documentID
              };
              var sendNum = "07077816868";
              Firestore.instance
                  .collection('id_data')
                  .add(data1).then((value) {
                if(widget.send_message){
                  _postRequest() async {
                    String url = 'https://asia-northeast3-teamcall-49b4c.cloudfunctions.net/sendSms?name=${myControllerName.text}&phoneNumber=${myControllerPhoneNumber.text}&team=${widget.userData['companyDoc']['name']}&sender=07077816868';

                    http.Response response = await http.post(
                        url
                    );
                  }
                  _postRequest();
                }
                setState(() {
                  widget.invitationSwitchForManager = 3;
                  widget.invitationSwitchForSuper = 3;
                });

                myControllerGroup0.text = widget.userData['user']['group'];
                myControllerGroup1.text = widget.userData['user']['department'];
                myControllerGroup2.text = widget.userData['user']['team'];


                myControllerName.clear();
                myControllerPosition.clear();
                myControllerPhoneNumber.clear();
                myControllerLandlineNum.clear();
                Navigator.pop(context);
                showTopSnackBar(
                  context,
                  CustomSnackBar.info(
                    message:
                    "????????? ??????????????????.",
                  ),
                );
              });
            }
            );
          }
          //??????????????? ???????????? ??????
          if(myControllerLandlineNum.text != ""){

            if(myControllerLandlineNum.text[1] == "1" ){
              scaffoldKey.currentState.hideCurrentSnackBar();
              showTopSnackBar(
                context,
                CustomSnackBar.info(
                  message:
                  '????????? ??????????????? ????????????.',
                ),
              );
            }else{
              Firestore.instance
                  .collection('main_data')
                  .document(widget.userData['companyUid'])
                  .collection('main_collection')
                  .where('landlineNum', isEqualTo: myControllerLandlineNum.text)
                  .getDocuments().then((value) {
                var docLength = value.documents.length;
                if(docLength == 0){
                  dataUpdate();
                }
                else{
                  scaffoldKey.currentState.hideCurrentSnackBar();
                  showTopSnackBar(
                    context,
                    CustomSnackBar.info(
                      message:
                      '????????? ??????????????? ??? ???????????? ?????? ??????????????????.',
                    ),
                  );
                }
              });
            }

          }
          //??????????????? ?????? ?????? ????????????
          else{
            if(widget.userData['companyDoc']['plan'] == 'trial'){

              if(widget.userData['docLength'] >= 15){
                showTopSnackBar(
                  context,
                  CustomSnackBar.info(
                    message:
                    "???????????? ?????? ????????? ?????????????????????.\n???????????? ??????????????? ????????????.",
                  ),
                );
              }else{

                dataUpdate();
              }

            }
            else if(widget.userData['companyDoc']['plan'] == 'standard'){

              if(widget.userData['docLength'] >= 150){
                showTopSnackBar(
                  context,
                  CustomSnackBar.info(
                    message:
                    "???????????? ?????? ????????? ?????????????????????.\n???????????? ??????????????? ????????????.",
                  ),
                );
              }else{

                dataUpdate();
              }

            }
            else if(widget.userData['companyDoc']['plan'] == 'pro'){

              if(widget.userData['docLength'] >= 550){
                showTopSnackBar(
                  context,
                  CustomSnackBar.info(
                    message:
                    "???????????? ?????? ????????? ?????????????????????.\n???????????? ??????????????? ????????????.",
                  ),
                );
              }else{

                dataUpdate();
              }

            }
            else if(widget.userData['companyDoc']['plan'] == 'enterprise'){

              if(widget.userData['docLength'] >= 1000){
                showTopSnackBar(
                  context,
                  CustomSnackBar.info(
                    message:
                    "???????????? ?????? ????????? ?????????????????????.\n??????????????? ?????? ????????????.",
                  ),
                );
              }else{

                dataUpdate();
              }

            }
            else if(widget.userData['companyDoc']['plan'] == 'superTrial'){
              dataUpdate();
            }
            else{
              showTopSnackBar(
                context,
                CustomSnackBar.info(
                  message:
                  "[????????? ?????? ??????] ??????????????? ?????? ????????????.",
                ),
              );
            }

          }
          //

        }
      });
    }
  }
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
