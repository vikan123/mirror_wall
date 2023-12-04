import 'package:flutter/material.dart';
import 'package:mirror_wall/provider.dart';
import 'package:mirror_wall/screen/browser.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(

        providers: [

        ChangeNotifierProvider(create: (context)=>BrowserProvider()),

    ],child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BrowserPage(),
    ));

  }
}
