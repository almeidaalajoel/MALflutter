import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'networkingstuff.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class Search {
  final List<int> id;
  final List<String> title;
  final List<String> mainPicture;

  Search({this.id, this.title, this.mainPicture});

  factory Search.fromJson(Map<String, dynamic> json) {
    List<int> tempId = [];
    List<String> tempTitle = [];
    List<String> tempPicture = [];
    for (var i = 0; i < json['data'].length; i++) {
      tempId.add(json['data'][i]['node']['id']);
      tempTitle.add(json['data'][i]['node']['title']);
      tempPicture.add(json['data'][i]['node']['main_picture']['large']);
    }
    return Search(
      id: tempId,
      title: tempTitle,
      mainPicture: tempPicture,
    );
  }
}

class AnimeList2 {
  int id;
  String title;
  String mainPicture;
  String status;
  int score;
  int numEpisodesWatched;
  bool isRewatching;
  String updatedAt;

  AnimeList2({
    this.id,
    this.isRewatching,
    this.mainPicture,
    this.numEpisodesWatched,
    this.score,
    this.status,
    this.title,
    this.updatedAt,
  });

  factory AnimeList2.fromJson(Map<String, dynamic> json) {
    int tempId = 0;
    String tempTitle = '';
    String tempPicture = '';
    String tempStatus = '';
    int tempScore = 0;
    int tempNumEpisodesWatched = 0;
    bool tempIsRewatching = false;
    String tempUpdatedAt = '';

    tempId = (json['node']['id']);
    tempTitle = (json['node']['title']);
    tempPicture = (json['node']['main_picture']['large']);
    tempStatus = (json['list_status']['status']);
    tempScore = (json['list_status']['score']);
    tempNumEpisodesWatched = (json['list_status']['num_episodes_watched']);
    tempIsRewatching = (json['list_status']['is_rewatching']);
    tempUpdatedAt = (json['list_status']['updated_at']);

    return AnimeList2(
      id: tempId,
      title: tempTitle,
      mainPicture: tempPicture,
      status: tempStatus,
      score: tempScore,
      numEpisodesWatched: tempNumEpisodesWatched,
      isRewatching: tempIsRewatching,
      updatedAt: tempUpdatedAt,
    );
  }
}

//API call used to return json for Anime object:
/*curl 'https://api.myanimelist.net/v2/anime/30230?fields=id,title,main_picture,alternative_titles,start_date,end_date,synopsis,
mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_episodes,
start_season,broadcast,source,average_episode_duration,rating,pictures,background,related_anime,related_manga,recommendations,studios,statistics' \
-H 'Authorization: Bearer YOUR_TOKEN' */

class Anime {
  final double mean;
  final int id,
      popularity,
      rank,
      numListUsers,
      numScoringUsers,
      myScore,
      myEpisodesWatched,
      numEpisodes,
      averageEpDuration,
      year;
  final String title,
      mainPicture,
      startDate,
      endDate,
      synopsis,
      nsfw,
      mediaType,
      status,
      myStatus,
      myUpdated,
      season,
      source,
      rating,
      background,
      enTitle;
  final List<String> alternativeTitles,
      genres,
      pictures,
      relatedAnime,
      //relatedManga,
      recommendations,
      studios;
  final List<int> dims;
  final bool myRewatching;

  Anime(
      {this.id = 0,
      this.popularity = 0,
      this.alternativeTitles,
      this.averageEpDuration = 0,
      this.background = '',
      this.endDate = '',
      this.genres,
      this.mainPicture = '',
      this.mean = 0.0,
      this.mediaType = '',
      this.myEpisodesWatched = 0,
      this.myRewatching = false,
      this.myScore = 0,
      this.myStatus = 'none',
      this.myUpdated = '',
      this.nsfw = '',
      this.numEpisodes = 0,
      this.numListUsers = 0,
      this.numScoringUsers = 0,
      this.pictures,
      this.rank = 0,
      this.rating = '',
      this.recommendations,
      this.relatedAnime,
      //this.relatedManga,
      this.season = '',
      this.source = '',
      this.startDate = '',
      this.status = '',
      this.studios,
      this.synopsis = '',
      this.title = '',
      this.enTitle = '',
      this.year = 0,
      this.dims});

  factory Anime.fromJson(Map<String, dynamic> json) {
    int tempId = 0,
        tempPopularity = 0,
        tempRank = 0,
        tempNumListUsers = 0,
        tempNumScoringUsers = 0,
        tempMyScore = 0,
        tempMyEpisodesWatched = 0,
        tempNumEpisodes = 0,
        tempAverageEpDuration = 0,
        tempYear = 0;

    tempId = json['id'];
    tempPopularity = json['popularity'];
    tempRank = json['rank'];
    tempNumListUsers = json['num_list_users'];
    tempNumScoringUsers = json['num_scoring_users'];
    if (json.containsKey('my_list_status')) {
      tempMyScore = json['my_list_status']['score'];
      tempMyEpisodesWatched = json['my_list_status']['num_episodes_watched'];
    }

    tempNumEpisodes = json['num_episodes'];
    tempAverageEpDuration = json['average_episode_duration'];

    if (json.containsKey('start_season')) {
      tempYear = json['start_season']['year'];
    }

    double tempMean = 0.0;
    if (json.containsKey('mean')) {
      tempMean = json['mean'].toDouble();
    }

    String tempTitle = '',
        tempMainPicture = '',
        tempStartDate = '',
        tempEndDate = '',
        tempSynopsis = '',
        tempNsfw = '',
        tempMediaType = '',
        tempStatus = '',
        tempMyStatus = '',
        tempMyUpdated = '',
        tempSeason = '',
        tempSource = '',
        tempRating = '',
        tempBackground = '',
        tempEnTitle = '';

    tempTitle = json['title'];
    tempMainPicture = json['main_picture']['large'];
    tempStartDate = json['start_date'];
    tempEndDate = json['end_date'];
    tempSynopsis = json['synopsis'];
    tempNsfw = json['nsfw'];
    tempMediaType = json['media_type'];
    tempStatus = json['status'];
    if (json.containsKey('my_list_status')) {
      tempMyStatus = json['my_list_status']['status'];
      tempMyUpdated = json['my_list_status']['updated_at'];
    }
    tempSource = json['source'];
    tempRating = json['rating'];
    tempBackground = json['background'];
    tempEnTitle = json['alternative_titles']['en'];

    if (json.containsKey('start_season')) {
      tempSeason = json['start_season']['season'];
    }

    List<String> tempAlternativeTitles = [],
        tempGenres = [],
        tempPictures = [],
        tempRelatedAnime = [],
        //tempRelatedManga = [],
        tempRecommendations = [],
        tempStudios = [];

    for (var i = 0; i < json['alternative_titles']['synonyms'].length; i++) {
      tempAlternativeTitles.add(json['alternative_titles']['synonyms'][i]);
    }
    tempAlternativeTitles.add('en: ${json['alternative_titles']['en']}');
    tempAlternativeTitles.add('ja: ${json['alternative_titles']['ja']}');

    if (json.containsKey('genres')) {
      for (var i = 0; i < json['genres'].length; i++) {
        tempGenres.add(json['genres'][i]['name']);
      }
    }

    if (json.containsKey('pictures')) {
      for (var i = 0; i < json['pictures'].length; i++) {
        tempPictures.add(json['pictures'][i]['large']);
      }
    }

    if (json.containsKey('related_anime')) {
      for (var i = 0; i < json['related_anime'].length; i++) {
        tempRelatedAnime.add(json['related_anime'][i]['node']['title']);
      }
    }

    if (json.containsKey('recommendations')) {
      for (var i = 0; i < json['recommendations'].length; i++) {
        tempRecommendations.add(json['recommendations'][i]['node']['title']);
      }
    }

    if (json.containsKey('studios')) {
      for (var i = 0; i < json['studios'].length; i++) {
        tempStudios.add(json['studios'][i]['name']);
      }
    }

    bool tempMyRewatching = false;
    if (json.containsKey('my_list_status')) {
      tempMyRewatching = json['my_list_status']['is_rewatching'];
    }

    return Anime(
      id: tempId,
      popularity: tempPopularity,
      mean: tempMean,
      rank: tempRank,
      numListUsers: tempNumListUsers,
      numScoringUsers: tempNumScoringUsers,
      myScore: tempMyScore,
      myEpisodesWatched: tempMyEpisodesWatched,
      numEpisodes: tempNumEpisodes,
      averageEpDuration: tempAverageEpDuration,
      year: tempYear,
      title: tempTitle,
      mainPicture: tempMainPicture,
      startDate: tempStartDate,
      endDate: tempEndDate,
      synopsis: tempSynopsis,
      nsfw: tempNsfw,
      mediaType: tempMediaType,
      status: tempStatus,
      myStatus: tempMyStatus,
      myUpdated: tempMyUpdated,
      season: tempSeason,
      source: tempSource,
      rating: tempRating,
      background: tempBackground,
      alternativeTitles: tempAlternativeTitles,
      genres: tempGenres,
      pictures: tempPictures,
      relatedAnime: tempRelatedAnime,
      //relatedManga: tempRelatedManga,
      recommendations: tempRecommendations,
      enTitle: tempEnTitle,
      studios: tempStudios,
      myRewatching: tempMyRewatching,
    );
  }
  bool notNull() {
    if (title.length > 0) {
      return true;
    } else {
      return false;
    }
  }
}

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
  print(myScore);

  Map<String, dynamic> body = {
    'status': status,
    'score': myScore,
  };
  final r = await http.put(
      'https://api.myanimelist.net/v2/anime/$id/my_list_status',
      body: body,
      headers: {
        'Authorization': 'Bearer $token',
      });
  print(r.body);
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
