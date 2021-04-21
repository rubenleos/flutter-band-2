import 'package:flutter/material.dart';

import 'package:band_names/pages/homePage.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material',
      initialRoute: 'home',
      routes: {
       'home' : (_) => HomePage()
      },
    
    );
  }
}