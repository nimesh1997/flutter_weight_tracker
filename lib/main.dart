import 'package:flutter/material.dart';
import 'package:flutter_weight_track/screens/HomeScreen.dart';
import 'package:flutter_weight_track/screens/WeightDetailScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weight Track',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => HomeScreen(),
        '/weightDetail': (context) => WeightDetailScreen()},
      supportedLocales: [
        const Locale('en', 'US'),
      ],
    );
  }

//  void openDialog() {
//    showDialog(context: (BuildContext context){
//
//    });
//  }
}
