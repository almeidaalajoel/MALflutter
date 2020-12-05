import 'package:flutter/material.dart';
import 'homepage.dart';
import 'search.dart';
import 'animepage.dart';

class ApiGod extends StatefulWidget {
  static const routeName = '/apiGod';
  final String search;
  const ApiGod(this.search);
  @override
  _ApiGodState createState() => _ApiGodState();
}

class _ApiGodState extends State<ApiGod> {
  Future<Search> futureSearch;
  bool typing = false;

  @override
  void initState() {
    super.initState();
    futureSearch =
        fetchSearch('https://api.myanimelist.net/v2/anime?q=${widget.search}');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: typing
              ? TextField(
                  autofocus: true,
                  onSubmitted: (text) {
                    setState(() {
                      futureSearch = fetchSearch(
                          'https://api.myanimelist.net/v2/anime?q=$text');
                    });
                  },
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      typing = !typing;
                    });
                  },
                  child: Text('Search'),
                ),
          leading: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                if (!typing) {
                  typing = true;
                }
              });
            },
          ),
        ),
        body: Center(
          child: FutureBuilder<Search>(
            future: futureSearch,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (typing) {
                        typing = false;
                      }
                    });
                  },
                  child: _buildList(snapshot),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return Text('No Search Yet!');
            },
          ),
        ),
      ),
    );
  }

  Widget _buildList(AsyncSnapshot<Search> s) {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: s.data.id.length,
      itemBuilder: (context, i) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AnimePage('${s.data.id[i]}'),
              ),
            );
          },
          child: Row(children: <Widget>[
            Expanded(
              child: Container(
                height: 70,
                alignment: Alignment(-1.0, 0.0),
                child: Text('${s.data.title[i]}'),
              ),
            ),
            Expanded(
              child: Image(
                height: (70.0),
                image: NetworkImage('${s.data.mainPicture[i]}'),
              ),
            )
          ]),
        );
      },
      separatorBuilder: (context, i) {
        return Divider();
      },
    );
  }
}
