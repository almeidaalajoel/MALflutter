import 'dart:async';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'search.dart';
import 'searchpage.dart';
import 'dart:ui' as ui;
import 'animepage.dart';
import 'main.dart';

class AnimeListPage extends StatefulWidget {
  final String mal;
  const AnimeListPage(
    this.mal,
  );
  @override
  _AnimeListPageState createState() => _AnimeListPageState();
}

class _AnimeListPageState extends State<AnimeListPage> {
  List<AnimeList2> aList = [];
  List<AnimeList2> filteredList = [];
  List<AnimeList2> completedList = [];
  List<AnimeList2> watchingList = [];
  List<AnimeList2> plannedList = [];
  List<AnimeList2> holdList = [];
  List<AnimeList2> droppedList = [];
  String sort = 'All';
  final textController = TextEditingController();

  clearTextInput() {
    textController.clear();
  }

  @override
  void initState() {
    super.initState();
    fetchList2(widget.mal).then((list) {
      setState(() {
        aList = list;
        filteredList = list;
        completedList = list.where((a) => a.status == 'completed').toList();
        watchingList = list.where((a) => a.status == 'watching').toList();
        plannedList = list.where((a) => a.status == 'plan_to_watch').toList();
        holdList = list.where((a) => a.status == 'on_hold').toList();
        droppedList = list.where((a) => a.status == 'dropped').toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 47, 82, 162),
        title: Container(
          height: 40,
          width: 200,
          child: TextField(
            controller: textController,
            onChanged: (string) {
              setState(() {
                switch (sort) {
                  case 'All':
                    filteredList = _filterList(aList, string);
                    break;
                  case "Completed":
                    filteredList = _filterList(completedList, string);
                    break;
                  case "Watching":
                    filteredList = _filterList(watchingList, string);
                    break;
                  case "Plan to Watch":
                    filteredList = _filterList(plannedList, string);
                    break;
                  case "On Hold":
                    filteredList = _filterList(holdList, string);
                    break;
                  case "Dropped":
                    filteredList = _filterList(droppedList, string);
                    break;
                }
              });
            },
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: 'Filter',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        actions: [
          DropdownButton<String>(
            value: sort,
            icon: Icon(Icons.arrow_downward),
            onChanged: (String newValue) {
              setState(() {
                FocusScope.of(context).requestFocus(new FocusNode());
                clearTextInput();
                sort = newValue;
                switch (sort) {
                  case 'All':
                    filteredList = aList;
                    break;
                  case "Completed":
                    filteredList = completedList;
                    break;
                  case "Watching":
                    filteredList = watchingList;
                    break;
                  case "Plan to Watch":
                    filteredList = plannedList;
                    break;
                  case "On Hold":
                    filteredList = holdList;
                    break;
                  case "Dropped":
                    filteredList = droppedList;
                    break;
                }
              });
            },
            items: <String>[
              'All',
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
        ],
      ),
      body: Center(
        child: aList.length > 0
            ? _buildList()
            : Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }

  Widget _buildList() {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, i) {
                return Container(
                  child: GestureDetector(
                    onTap: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      _awaitUpdate(context, i);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 135,
                                color: _returnColor(filteredList[i].status),
                              ),
                              Container(
                                height: 135,
                                width: 105,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    //alignment: FractionalOffset.topRight,
                                    image: NetworkImage(
                                        filteredList[i].mainPicture),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: 300,
                            child: Text(
                              filteredList[i].title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.only(right: 30),
                            child: filteredList[i].score != 0
                                ? Text(
                                    '${filteredList[i].score}',
                                  )
                                : Text('-'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, i) {
                return Divider(
                  height: 1,
                  thickness: 1,
                );
              },
              itemCount: filteredList.length,
            ),
          ),
        ],
      ),
    );
  }

  void _awaitUpdate(BuildContext context, int i) async {
    List<dynamic> update = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnimePage('${filteredList[i].id}'),
      ),
    );
    if (update[1] == 'Not Yet Rated') {
      update[1] = '0';
    }
    setState(() {
      filteredList[i] = new AnimeList2(
        id: filteredList[i].id,
        title: filteredList[i].title,
        mainPicture: filteredList[i].mainPicture,
        status: update[0],
        score: int.parse(update[1]),
        numEpisodesWatched: filteredList[i].numEpisodesWatched,
        isRewatching: filteredList[i].isRewatching,
        updatedAt: filteredList[i].updatedAt,
      );
    });
    //print(
    //  '${filteredList[i].id}, ${filteredList[i].title}, ${filteredList[i].score}, ${filteredList[i].status}');
  }

  List<AnimeList2> _filterList(List<AnimeList2> aList, String string) {
    List<AnimeList2> newList = aList
        .where((l) => (l.title.toLowerCase().contains(string.toLowerCase())))
        .toList();
    return newList;
  }

  Color _returnColor(String status) {
    Color color;
    switch (status) {
      case "completed":
        color = Colors.blue;
        break;
      case "Completed":
        color = Colors.blue;
        break;
      case "watching":
        color = Colors.green;
        break;
      case "Watching":
        color = Colors.green;
        break;
      case "plan_to_watch":
        color = Colors.blueGrey[300];
        break;
      case "Plan to Watch":
        color = Colors.blueGrey[300];
        break;
      case "on_hold":
        color = Colors.yellow;
        break;
      case "On Hold":
        color = Colors.yellow;
        break;
      case "dropped":
        color = Colors.red;
        break;
      case "Dropped":
        color = Colors.red;
        break;
    }
    return color;
  }
}
