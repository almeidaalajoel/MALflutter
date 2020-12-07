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
  Future<Anime> futureAnime;
  Future<List> futureDims;
  String url;
  List<double> dimsList;

  @override
  void initState() {
    super.initState();
    futureAnime = fetchAnime(
        'https://api.myanimelist.net/v2/anime/${widget.id}?fields=id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_episodes,start_season,broadcast,source,average_episode_duration,rating,pictures,background,related_anime,related_manga,recommendations,studios,statistics');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<Anime>(
        future: futureAnime,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildPage(snapshot);
          } else if (snapshot.hasError) {
            return (Text('${snapshot.error}'));
          } else {
            return Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildPage(AsyncSnapshot<Anime> s) {
    //double wid = dimsList[0];
    //double hei = dimsList[1];
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 150,
                alignment: Alignment(-1.0, -1.0),
                child: Image(
                  image: NetworkImage(s.data.mainPicture),
                ),
              ),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 10,
                      fit: FlexFit.loose,
                      child: Container(
                        color: Colors.green,
                        alignment: Alignment(-1.0, -1.0),
                        child: Text(
                          '${s.data.title}',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 1,
                      child: Container(
                        color: Colors.red,
                        alignment: Alignment(-1.0, -1.0),
                        child: Text(
                          '${s.data.enTitle}',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 1,
                      child: Container(
                        color: Colors.blue,
                        alignment: Alignment(-1.0, -1.0),
                        child: Text(
                          'Genres: ${s.data.genres.join(', ')}',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          Container(
            child: Text('${s.data.synopsis}'),
          ),
        ],
      ),
    );
  }
}
