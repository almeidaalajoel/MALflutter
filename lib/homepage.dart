import 'package:flutter/material.dart';
import 'search.dart';
import 'searchpage.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/search';
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 47, 82, 162),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/mal.png'),
              alignment: Alignment(0.0, -1.0),
            ),
          ),
          child: Center(
            child: Container(
              width: 350.0,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search MAL",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onSubmitted: (text) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApiGod('$text'),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
