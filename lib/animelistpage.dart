import 'dart:async';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'search.dart';
import 'searchpage.dart';
import 'dart:ui' as ui;

class AnimeListPage extends StatefulWidget {
  final String mal;
  const AnimeListPage(this.mal);
  @override
  _AnimeListPageState createState() => _AnimeListPageState();
}

class _AnimeListPageState extends State<AnimeListPage> {
  Future<AnimeList> futureAList;

  @override
  void initState() {
    super.initState();
    futureAList = fetchList(widget.mal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<AnimeList>(
        future: futureAList,
        builder: (context, snapshot) {
          //return Column(
          //children: [
          return ListView.separated(
            itemBuilder: (context, i) {
              return Container(
                child: Text(snapshot.data.title[i]),
              );
            },
            separatorBuilder: (context, i) {
              return Divider();
            },
            itemCount: snapshot.data.id.length,
          );
          //Text(snapshot.data.paging),
          //],
          //);
        },
      ),
    );
  }
}
