import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({Key? key}) : super(key: key);

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
 late TextEditingController textcontroller;
 late WebViewController webcontroller;
 String searchEngineUrl = "https://www.google.com/";
 bool isloading =false;

 @override
 void initState(){
   textcontroller = TextEditingController(text: searchEngineUrl);
   webcontroller = WebViewController();
   webcontroller.setJavaScriptMode(JavaScriptMode.unrestricted);
   webcontroller.setNavigationDelegate(NavigationDelegate(
     onPageStarted: (url){
       textcontroller.text = url;
       setState(() {
         isloading =true;
       });
     },
     onPageFinished: (url){
       setState(() {
         isloading = false;
       });
   }
   ));
   loadUrl(textcontroller.text);
   super.initState();
 }
 @override
 void dispose(){
   textcontroller.dispose();
   super.dispose();
 }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: WillPopScope(
      child: Scaffold(
        body: Column(
          children: [
            _buildTopWidget(),
            _buildLoadingWidget(),
             Expanded(child: _buildWebWidget()),
            _buildBottomWidget()
          ],
        ),
      ),onWillPop: onWillPop,
    ));
  }
 Future<bool>onWillPop()async{
   if(await webcontroller.canGoBack()){
     webcontroller.goBack();
     return Future.value(false);
   }
   return Future.value(true);

 }

 loadUrl(String value){
   Uri uri = Uri.parse(value);
   if(!uri.isAbsolute){
     uri = Uri.parse("${searchEngineUrl}search?q=$value");
   }
   webcontroller.loadRequest(uri);
  }

  _buildTopWidget() {
   return Padding(padding: EdgeInsets.all(10) ,child:Container(
     alignment: Alignment.center,
     decoration: BoxDecoration(
       border: Border.all(),
       borderRadius: BorderRadius.all(Radius.circular(32)),
     ),
     child: Row(
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         IconButton(onPressed: (){
           loadUrl(searchEngineUrl);
         }, icon: Icon(Icons.home,color: Colors.black,)),
         Expanded(child: TextField(
           controller: textcontroller,
           decoration: InputDecoration(
             border: InputBorder.none,
             hintText: "Search or type web address",
           ),
           onSubmitted: (value){
             loadUrl(value);
           },
         )),
         IconButton(onPressed: (){
           textcontroller.clear();
         }, icon: Icon(Icons.cancel))
       ],
     ),
   ));

  }

  _buildLoadingWidget() {
   return Container(
     height: 2,
     color: Colors.grey,
     child: isloading?LinearProgressIndicator():Container(),
   );
  }

  _buildWebWidget() {
   return WebViewWidget(controller: webcontroller);
  }

  _buildBottomWidget() {
   return BottomNavigationBar(
   onTap: (value){
      switch (value){
        case 0:
          webcontroller.goBack();
          break;
        case 1:
          webcontroller.goForward();
          break;
        case 2:
          webcontroller.reload();

      }
   },
   items: [
     BottomNavigationBarItem(icon: Icon(Icons.arrow_back),label: "Back"),
     BottomNavigationBarItem(icon: Icon(Icons.arrow_forward),label: "Forward"),
     BottomNavigationBarItem(icon: Icon(Icons.replay),label: "Reload"),
   ],
   showSelectedLabels: false,
     showUnselectedLabels: false,
     unselectedItemColor: Colors.black54,
     selectedItemColor: Colors.black54,
   );
  }
}


