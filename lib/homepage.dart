import 'package:flutter/material.dart';
import 'searchpage.dart';
import 'animelistpage.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/search';
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 47, 82, 162),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              //mainAxisAlignment: MainAxisAlignmemt.
              children: [
                Container(
                  alignment: Alignment(0.0, -1.0),
                  child: Image(
                    image: AssetImage('assets/mal.png'),
                  ),
                ),
                Container(
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
                              builder: (context) => SearchPage('$text'),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: TextButton(
              child: Text('AnimeList'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AnimeListPage(
                            'https://api.myanimelist.net/v2/users/@me/animelist?fields=list_status&offset=0&limit=1000')));
              },
            ),
          )
        ],
      ),
    );
  }
}
