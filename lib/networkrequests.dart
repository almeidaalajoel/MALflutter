import 'package:http/http.dart' as http;
import 'dart:convert';
import 'networkingstuff.dart';
import 'dart:async';
import 'classes.dart';

changeStatus(String status, String id, String myScore) async {
  switch (status) {
    case 'Completed':
      status = 'completed';
      break;
    case 'Watching':
      status = 'watching';
      break;
    case 'Plan to Watch':
      status = 'plan_to_watch';
      break;
    case 'On hold':
      status = 'on_hold';
      break;
    case 'Dropped':
      status = 'dropped';
      break;
  }
  if (myScore == 'Not Yet Rated') {
    myScore = '0';
  }

  Map<String, dynamic> body = {
    'status': status,
    'score': myScore,
  };
  await http.put('https://api.myanimelist.net/v2/anime/$id/my_list_status',
      body: body,
      headers: {
        'Authorization': 'Bearer $token',
      });
}

fetchList2(String malurl) async {
  List<AnimeList2> animeListList = [];
  AnimeList2 animeList;
  final response = await http.get(malurl, headers: {
    'Authorization': 'Bearer $token',
  });
  Map<String, dynamic> json = jsonDecode(response.body);
  dynamic response2;

  do {
    for (int i = 0; i < json['data'].length; i++) {
      animeList = AnimeList2.fromJson(json['data'][i]);
      animeListList.add(animeList);
    }
    if (json['paging'].containsKey('next')) {
      response2 = await http.get(json['paging']['next']);
      json = jsonDecode(response2.body);
    }
  } while (json['paging'].containsKey('next'));

  if (response.statusCode == 200) {
    return animeListList;
  } else {
    throw Exception('Failed to load search');
  }
}

fetchAnime(String malurl) async {
  final response = await http.get(malurl, headers: {
    'Authorization': 'Bearer $token',
  });
  Anime anime = Anime.fromJson(jsonDecode(response.body));
  if (response.statusCode == 200) {
    return anime;
  } else {
    throw Exception('Failed to load search');
  }
}

Future<Search> fetchSearch(String malurl) async {
  final response = await http.get(malurl, headers: {
    'Authorization': 'Bearer $token',
  });

  if (response.statusCode == 200) {
    return Search.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load search');
  }
}
