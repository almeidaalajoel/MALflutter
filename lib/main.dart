import 'package:dontevenknow/searchpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:oauth2/oauth2.dart' as oauth2;
import 'networkingstuff.dart';
import 'homepage.dart';
import 'searchpage.dart';
import 'animepage.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      ApiGod.routeName: (context) => ApiGod(''),
      HomePage.routeName: (context) => HomePage(),
      AnimePage.routeName: (context) => AnimePage(''),
    },
    home: HomePage(),
  ));
}
