
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class DataInfo extends StatefulWidget {


  @override
  _DataInfoState createState() => _DataInfoState();
}

class _DataInfoState extends State<DataInfo> {
  WebViewController webViewController;
  String htmlFilePath = 'assets/data.html';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBuild(),
      body:  WebView(
        initialUrl: '',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController tmp) {
          webViewController = tmp;
          loadLocalHTML();
        },
      ),
    );
  }
  Widget appBarBuild() {
    return
      PreferredSize(preferredSize: Size.fromHeight(60.0),
          child: Container(
            color: Colors.white,
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
                          child: Icon(Icons.arrow_back ,color: Colors.black),
                        ))),
                title: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Text('개인정보 처리 약관')),

              ),
            ),
          )
      );
  }
  loadLocalHTML() async{

    String fileHtmlContents = await rootBundle.loadString(htmlFilePath);
    webViewController.loadUrl(Uri.dataFromString(fileHtmlContents,
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }



}

