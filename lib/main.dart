import 'package:flutter/material.dart';
import 'package:weather_application/Activity/home.dart';
void main(){
  runApp(MyApp ());
}

class MyApp  extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false,
    title :"Abohawa",home: Home(),
    );
  }
  
}