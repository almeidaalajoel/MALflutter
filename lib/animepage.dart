import 'dart:async';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'search.dart';
import 'searchpage.dart';
import 'dart:ui' as ui;

class AnimePage extends StatefulWidget {
  static const routeName = '/animePage';
  final String id;
  const AnimePage(this.id);
  @override
  _AnimePageState createState() => _AnimePageState();
}

class _AnimePageState extends State<AnimePage> {
  Anime anime = new Anime();
  //List dims = [];

  @override
  void initState() {
    super.initState();
    fetchAnime(
            'https://api.myanimelist.net/v2/anime/${widget.id}?fields=id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_episodes,start_season,broadcast,source,average_episode_duration,rating,pictures,background,related_anime,related_manga,recommendations,studios,statistics')
        .then((anim) {
      setState(() {
        anime = anim;
      });
      //fetchDims(anim.mainPicture).then((dim) {
      //dims = dim;
      //setState(() {});
      //});
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
          ? _buildPage(anime)
          : Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }

  Widget _buildPage(Anime a) {
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
                    '${a.title}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                a.enTitle.length > 0 //only show english title if it exists
                    ? Container(
                        child: Text(
                          '${a.enTitle}',
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
                    image: NetworkImage(a.mainPicture),
                  ),
                ),
                Container(
                  child: Text(
                    'Score: ${a.mean} (${a.numScoringUsers} ratings)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  child: Text('Studios: ${a.studios.join(', ')}'),
                ),
                Container(
                  child: Text(
                    'Genres: ${a.genres.join(', ')}',
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
                  child: Text('${a.synopsis}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
