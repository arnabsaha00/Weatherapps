import 'dart:convert';

import 'package:http/http.dart'as http;

class WeatherService{
  final String apiKey="4d94e89448d14ee8aa3193936243006";
final String forecastBaseUrl='http://api.weatherapi.com/v1/forecast.json';
  final String searchBaseUrl='http://api.weatherapi.com/v1/search.json';
  Future <Map<String,dynamic>>fetchCurrentWeather(String city)async{
    final url='$forecastBaseUrl?key=$apiKey&q=$city&days=1&aqi=no&alerts=no';final response=await http.get(Uri.parse(url));
    if(response.statusCode==200){
      return json.decode(response.body);
    }
    else throw Exception("Failed to load weather Data");
  }
  Future <Map<String,dynamic>>fetch7daysForecast(String city)async{
    final url='$forecastBaseUrl?key=$apiKey&q=$city&days=1&aqi=no&alerts=no';final response=await http.get(Uri.parse(url));
    if(response.statusCode==200){
      return json.decode(response.body);
    }
    else throw Exception("Failed to load weather Data");
  }
  Future <List< dynamic>?>fetchCitySuggetion(String query)async{
    final url='$searchBaseUrl?key=$apiKey&q=$query';
    final response=await http.get(Uri.parse(url));
    if(response.statusCode==200){
      return json.decode(response.body);
    }
    else return null;
  }
}

