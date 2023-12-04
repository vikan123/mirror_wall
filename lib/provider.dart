import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserProvider with ChangeNotifier{
   TextEditingController? textcontroller;
   WebViewController? webcontroller;
  String searchEngineUrl = "https://www.google.com/";
  bool isloading =false;

  get value => null;
  loadUrl(String value){
    Uri uri = Uri.parse(value);
    if(!uri.isAbsolute){
      uri = Uri.parse("${searchEngineUrl}search?q=$value");
    }
    webcontroller!.loadRequest(uri);
    notifyListeners();
  }

  browserTheme(){
    textcontroller = TextEditingController(text: searchEngineUrl);
    webcontroller = WebViewController();
    webcontroller!.setJavaScriptMode(JavaScriptMode.unrestricted);
    webcontroller!.setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url){
          textcontroller!.text = url;

            isloading =true;

        },
        onPageFinished: (url){

            isloading = false;

        }
    ));
    loadUrl(textcontroller!.text);
    notifyListeners();
  }


      onPop() {
        Future<bool> onWillPop() async {
          if (await webcontroller!.canGoBack()) {
            webcontroller!.goBack();
            return Future.value(false);
          }
          return Future.value(true);
        }
        notifyListeners();
      }


}