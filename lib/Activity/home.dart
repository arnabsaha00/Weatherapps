import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_application/Activity/loading.dart';
import 'package:weather_application/services/weather_service.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final WeatherService weatherService=WeatherService();
  String city="Kolkata";
  Map<String,dynamic>? CurrentWeather;
  void initState(){
    super.initState();_fetchWeather();
  }
  Future<void>_fetchWeather()async{
    try{
      final weatherData=await weatherService.fetchCurrentWeather(city);
      setState(() {
        CurrentWeather=weatherData;
      });
    }
    catch(e){
      print(e);
    }
  }
  void showcityselection(){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Enter City Name"),content: TypeAheadField(
        suggestionsCallback: (pattern)async{
          return await weatherService.fetchCitySuggetion(pattern);

        },
        builder: (context,controller,focusNode){
          return TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(

              ),
              labelText:"city",
            ),
          );
        },
        itemBuilder:  (context,suggestion){
          return ListTile(title: Text(suggestion['name']));
      },onSelected: (City){
          setState(() {
            city=City['name'];
          });
      },
      ),
        actions: [
          TextButton(onPressed: (){Navigator.pop(context);}, child: Text("cancel")),
          TextButton(onPressed: (){Navigator.pop(context);_fetchWeather();}, child: Text("Submit")),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
   body: CurrentWeather==null?Container(decoration:
   BoxDecoration(

       gradient:
       LinearGradient(
         begin: Alignment.topCenter,
         end: Alignment.bottomCenter,colors: [
         Color(0xFF1A2344),Color.fromARGB(255, 125, 40, 160),Colors.purple,Color.fromARGB(255, 170, 60, 180),
       ],)
   ),child: Center(
     child: CircularProgressIndicator(color: Colors.white,),
   ),):Container(padding:EdgeInsets.all(20),decoration: BoxDecoration(
       gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,colors: [
         Color(0xFF1A2344),Color.fromARGB(255, 125, 40, 160),Colors.purple,Color.fromARGB(255, 170, 60, 180),
       ],)
   ),child:

   ListView(children: [
     SizedBox(height: 10,),
     InkWell(onTap:showcityselection ,
     child:  Text(city,
       style: GoogleFonts.lato
         (fontSize: 36,color: Colors.white,fontWeight: FontWeight.bold),),),

     SizedBox(height: 10,),
     Center(child: Column(
       children: [Image.network('http:${CurrentWeather!['current']['condition']['icon']}',
       height: 100,width: 100,
       fit: BoxFit.cover,
       ),
       Text('${CurrentWeather!['current']['temp_c'].round()}C',
         style: GoogleFonts.lato(
             fontSize: 42,color: Colors.white,fontWeight: FontWeight.bold
         ),),
         Text('${CurrentWeather!['current']['condition']['text']}',
           style: GoogleFonts.lato(
               fontSize: 42,color: Colors.white,fontWeight: FontWeight.bold
           ),),
     SizedBox(height: 30,),
     Row(
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
       children: [
         Text('Max: ${CurrentWeather!['forecast']['forecastday'][0]['day']['maxtemp_c'].round()}C',
         style: GoogleFonts.lato(
         fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold
         ),),
         Text('Min: ${CurrentWeather!['forecast']['forecastday'][0]['day']['mintemp_c'].round()}C',
           style: GoogleFonts.lato(
               fontSize: 20,color: Colors.white60,fontWeight: FontWeight.bold
           ),),
       ],
     )
       ],
     ),
     ),
     SizedBox(height: 50,),
     Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [buildWeatherDetail('Sunrise', Icons.wb_sunny,
           CurrentWeather!['forecast']['forecastday'][0]['astro']['sunrise']
       ),
         buildWeatherDetail('Sunset', Icons.brightness_3,
             CurrentWeather!['forecast']['forecastday'][0]['astro']['sunset']
         ),
       ],

     ),
     SizedBox(height: 40,),
     Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [buildWeatherDetail('Humidity', Icons.opacity,
           CurrentWeather!['current']['humidity']
       ),
         buildWeatherDetail('wind(KPH)', Icons.wind_power,
             CurrentWeather!['current']['wind_kph']
         ),
       ],

     ),
     SizedBox(height: 30,),
     Center(child: ElevatedButton(
       onPressed: (){
         Navigator.push(context, MaterialPageRoute(builder: (context)=>forecast(city:city,)));
       },
       style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1A2344)),
       child: Text('Next 7 Days Forecast',style: TextStyle(color: Colors.white),),
     ),)
   ],),
   ),
    );
  }
  Widget buildWeatherDetail(String Label,IconData icon,dynamic value){
return Padding(
  padding: const EdgeInsets.symmetric(horizontal: 10),
  child: ClipRRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX:3,sigmaY: 3)
      ,child: Container(
      padding: EdgeInsets.all(5),
      height: 110,width: 110,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
      gradient: LinearGradient(
        begin: AlignmentDirectional.topStart,
        end:AlignmentDirectional.bottomEnd,
        colors: [
          Color(0xFF1A2344).withOpacity(0.5),Color(0xFF1A2344).withOpacity(0.2),
        ]
      )),
      child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
        Icon(icon,color: Colors.white,),SizedBox(height: 8,),
        Text(Label, style: GoogleFonts.lato(
            fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold
        ),),
        SizedBox(height: 8,),
        Text(value is String ? value:value.toString(), style: GoogleFonts.lato(
            fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold
        ),),
      ],),
    ),
    ),
  ),
);
  }
}
