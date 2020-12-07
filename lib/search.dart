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
//curl 'https://api.myanimelist.net/v2/anime/30230?fields=id,title,main_picture,alternative_titles,start_date,end_date,synopsis,
//mean,rank,popularity,num_list_users,num_scoring_users,nsfw,created_at,updated_at,media_type,status,genres,my_list_status,num_episodes,
//start_season,broadcast,source,average_episode_duration,rating,pictures,background,related_anime,related_manga,recommendations,studios,statistics' \
//-H 'Authorization: Bearer YOUR_TOKEN'

class Anime {
  final double mean;
  final int id,
      popularity,
      rank,
      numListUsers,
      numScoringUsers,
      //myScore,
      //myEpisodesWatched,
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
      //myStatus,
      //myUpdated,
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
  //final bool myRewatching;

  Anime(
      {this.id,
      this.popularity,
      this.alternativeTitles,
      this.averageEpDuration,
      this.background,
      this.endDate,
      this.genres,
      this.mainPicture,
      this.mean,
      this.mediaType,
      //this.myEpisodesWatched,
      //this.myRewatching,
      //this.myScore,
      //this.myStatus,
      //this.myUpdated,
      this.nsfw,
      this.numEpisodes,
      this.numListUsers,
      this.numScoringUsers,
      this.pictures,
      this.rank,
      this.rating,
      this.recommendations,
      this.relatedAnime,
      //this.relatedManga,
      this.season,
      this.source,
      this.startDate,
      this.status,
      this.studios,
      this.synopsis,
      this.title,
      this.enTitle,
      this.year,
      this.dims});

  factory Anime.fromJson(Map<String, dynamic> json) {
    int tempId = 0,
        tempPopularity = 0,
        tempRank = 0,
        tempNumListUsers = 0,
        tempNumScoringUsers = 0,
        //tempMyScore=0,
        //tempMyEpisodesWatched=0,
        tempNumEpisodes = 0,
        tempAverageEpDuration = 0,
        tempYear = 0;

    tempId = json['id'];
    tempPopularity = json['popularity'];
    tempRank = json['rank'];
    tempNumListUsers = json['num_list_users'];
    tempNumScoringUsers = json['num_scoring_users'];
    //tempMyScore = json['my_list_status']['score'];
    //tempMyEpisodesWatched = json['my_list_status']['num_episodes_watched'];
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
        //tempMyStatus = '',
        //tempMyUpdated = '',
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
    //tempMyStatus = json['my_list_status']['status'],
    //tempMyUpdated = json['my_list_status']['updated_at'],
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

    for (var i = 0; i < json['genres'].length; i++) {
      tempGenres.add(json['genres'][i]['name']);
    }

    for (var i = 0; i < json['pictures'].length; i++) {
      tempPictures.add(json['pictures'][i]['large']);
    }

    for (var i = 0; i < json['related_anime'].length; i++) {
      tempRelatedAnime.add(json['related_anime'][i]['node']['title']);
    }

    for (var i = 0; i < json['recommendations'].length; i++) {
      tempRecommendations.add(json['recommendations'][i]['node']['title']);
    }

    for (var i = 0; i < json['studios'].length; i++) {
      tempStudios.add(json['studios'][i]['name']);
    }

    //bool tempMyRewatching = json['my_list_status']['is_rewatching'];

    return Anime(
        id: tempId,
        popularity: tempPopularity,
        mean: tempMean,
        rank: tempRank,
        numListUsers: tempNumListUsers,
        numScoringUsers: tempNumScoringUsers,
        //myScore: tempMyScore,
        //myEpisodesWatched: tempMyEpisodesWatched,
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
        //myStatus: tempMyStatus,
        //myUpdated: tempMyUpdated,
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
        studios: tempStudios);
    //myRewatching: tempMyRewatching);
  }
}

Future<List> giveDims(String s) async {
  List list = [];
  final Image image = Image(image: NetworkImage(s));
  Completer<ui.Image> completer = new Completer<ui.Image>();
  image.image
      .resolve(new ImageConfiguration())
      .addListener(new ImageStreamListener((ImageInfo image, bool _) {
    completer.complete(image.image);
  }));
  ui.Image info = await completer.future;
  double pWidth = info.width.toDouble();
  double pHeight = info.height.toDouble();
  list.add(pWidth);
  list.add(pHeight);
  return list;
}

Future<Anime> fetchAnime(String malurl) async {
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
