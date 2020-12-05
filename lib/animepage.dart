import 'package:flutter/material.dart';
import 'homepage.dart';
import 'search.dart';
import 'searchpage.dart';

class AnimePage extends StatefulWidget {
  static const routeName = '/animePage';
  final String id;
  const AnimePage(this.id);
  @override
  _AnimePageState createState() => _AnimePageState();
}

class _AnimePageState extends State<AnimePage> {
  Future<Anime> futureAnime;

  @override
  void initState() {
    super.initState();
    futureAnime = fetchAnime(
        'https://api.myanimelist.net/v2/anime/${widget.id}?fields=id,title,main_picture,alternative_titles,start_date,end_date,synopsis,mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_episodes,start_season,broadcast,source,average_episode_duration,rating,pictures,background,related_anime,related_manga,recommendations,studios,statistics');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Anime>(
      future: futureAnime,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return (Text('${snapshot.data.title}'));
        } else if (snapshot.hasError) {
          return (Text('${snapshot.error}'));
        } else {
          return (Text('idk'));
        }
      },
    );
  }
}
