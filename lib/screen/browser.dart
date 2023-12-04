import 'package:flutter/material.dart';
import 'package:mirror_wall/provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({Key? key}) : super(key: key);

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  bool outline = false;

 @override
 void initState(){

   final auth = Provider.of<BrowserProvider>(context, listen: false);
   auth.browserTheme();
   super.initState();
 }

  @override
  Widget build(BuildContext context) {
    return Consumer<BrowserProvider>(builder:(context,provider,child){
      return SafeArea(child: WillPopScope(
        onWillPop:provider.onPop(),
        child: Scaffold(
          body: Column(
            children: [
              buildTopWidget(),
              buildLoadingWidget(),
              Expanded(child: buildWebWidget()),
              buildBottomWidget()
            ],
          ),
        ),
      ));
    });
  }


  buildTopWidget() {
   return Consumer<BrowserProvider>(builder: (context,provider,child){
     return Padding(padding: const EdgeInsets.all(10) ,child:Container(
       alignment: Alignment.center,
       decoration: BoxDecoration(
         border: Border.all(),
         borderRadius: const BorderRadius.all(Radius.circular(32)),
       ),
       child: Row(
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           IconButton(onPressed: (){
             provider.searchEngineUrl;
           }, icon: const Icon(Icons.home,color: Colors.black,)),
           Expanded(child: TextField(
             controller: provider.textcontroller,
             decoration: const InputDecoration(
               border: InputBorder.none,
               hintText: "Search or type web address",
             ),
             onSubmitted: (value){
              provider.value;
             },
           )),
           IconButton(icon: Icon(outline ? Icons.bookmark_outline : Icons.bookmark),
               onPressed:(){
                 setState((){
                   outline = !outline;
                 });
               }
           ),
           IconButton(onPressed: (){
             provider.textcontroller!.clear();
           }, icon: const Icon(Icons.cancel))
         ],
       ),
     ));
   });

  }

  buildLoadingWidget() {
   return Consumer<BrowserProvider>(builder: (context,provider,child){
     return Container(
       height: 2,
       color: Colors.grey,
       child: provider.isloading?const LinearProgressIndicator():Container(),
     );
   });
  }

  buildWebWidget() {
   return Consumer<BrowserProvider>(builder: (context,provider,child){
     return WebViewWidget(controller:provider.webcontroller!);
   });
  }

  buildBottomWidget() {
   return Consumer<BrowserProvider>(builder: (context,provider,child){
     return BottomNavigationBar(
       onTap: (value){
         switch (value){
           case 0:
             provider.webcontroller!.goBack();
             break;
           case 1:
             provider.webcontroller!.goForward();
             break;
           case 2:
             provider.webcontroller!.reload();

         }
       },
       items: const [
         BottomNavigationBarItem(icon: Icon(Icons.arrow_back),label: "Back"),
         BottomNavigationBarItem(icon: Icon(Icons.arrow_forward),label: "Forward"),
         BottomNavigationBarItem(icon: Icon(Icons.replay),label: "Reload"),
       ],
       showSelectedLabels: false,
       showUnselectedLabels: false,
       unselectedItemColor: Colors.black54,
       selectedItemColor: Colors.black54,
     );
   });
  }
}


