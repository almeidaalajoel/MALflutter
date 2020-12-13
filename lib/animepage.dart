import 'dart:async';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'search.dart';
import 'searchpage.dart';
import 'dart:ui' as ui;
import 'dart:convert';

class AnimePage extends StatefulWidget {
  static const routeName = '/animePage';
  final String id;
  const AnimePage(this.id);
  @override
  _AnimePageState createState() => _AnimePageState();
}

class _AnimePageState extends State<AnimePage> {
  Anime anime = new Anime();
  String status = 'Add to List';
  String myScore;

  @override
  void initState() {
    super.initState();
    fetchAnime(
            'https://api.myanimelist.net/v2/anime/${widget.id}?fields=id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_episodes,start_season,broadcast,source,average_episode_duration,rating,pictures,background,related_anime,related_manga,recommendations,studios,statistics')
        .then((anim) {
      setState(() {
        anime = anim;
        if (anim.myScore == 0) {
          myScore = 'Not Yet Rated';
        } else {
          myScore = '${anim.myScore}';
        }
        switch (anim.myStatus) {
          case '':
            status = 'Add to List';
            break;
          case 'completed':
            status = 'Completed';
            break;
          case 'watching':
            status = 'Watching';
            break;
          case 'plan_to_watch':
            status = 'Plan to Watch';
            break;
          case 'on_hold':
            status = 'On Hold';
            break;
          case 'dropped':
            status = 'Dropped';
            break;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 47, 82, 162),
        title: Container(
          height: 110,
          child: Image(
            image: AssetImage('assets/mal2.png'),
          ),
        ),
      ),
      body: anime.notNull()
          ? WillPopScope(
              onWillPop: _pop,
              child: _buildPage(),
            )
          : Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }

  Future<bool> _pop() async {
    Navigator.pop(context, [status, myScore]);
    return Future.value(true);
  }

  Widget _buildPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue[50],
            ),
            child: Column(
              children: [
                Container(
                  child: Text(
                    '${anime.title}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                anime.enTitle.length > 0 //only show english title if it exists
                    ? Container(
                        child: Text(
                          '${anime.enTitle}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.4),
                            fontSize: 15,
                          ),
                        ),
                      )
                    : Container(),
                Container(
                  height: 230,
                  alignment: Alignment(0, 0),
                  child: Image(
                    image: NetworkImage(anime.mainPicture),
                  ),
                ),
                Container(
                  child: Text(
                    'Score: ${anime.mean} (${anime.numScoringUsers} ratings)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  child: Text('Studios: ${anime.studios.join(', ')}'),
                ),
                Container(
                  child: Text(
                    'Genres: ${anime.genres.join(', ')}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.4),
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  value: status,
                  icon: Icon(Icons.arrow_downward),
                  onChanged: (String newValue) {
                    setState(() {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      status = newValue;
                      changeStatus(status, '${anime.id}', myScore);
                    });
                  },
                  items: <String>[
                    'Add to List',
                    'Completed',
                    'Watching',
                    'Plan to Watch',
                    'On Hold',
                    'Dropped',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  value: myScore,
                  icon: Icon(Icons.arrow_downward),
                  onChanged: (String newValue) {
                    setState(() {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      myScore = newValue;
                      changeStatus(status, '${anime.id}', myScore);
                    });
                  },
                  items: <String>[
                    'Not Yet Rated',
                    '1',
                    '2',
                    '3',
                    '4',
                    '5',
                    '6',
                    '7',
                    '8',
                    '9',
                    '10',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.lightGreen[50],
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.fromLTRB(7.0, 5.0, 7.0, 3.0),
                    child: Text(
                      'Synopsis',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )),
                Container(
                  padding: EdgeInsets.fromLTRB(7.0, 0, 7.0, 5.0),
                  child: Text('${anime.synopsis}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
