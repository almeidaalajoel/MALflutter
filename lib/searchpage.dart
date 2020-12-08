import 'package:flutter/material.dart';
import 'homepage.dart';
import 'search.dart';
import 'animepage.dart';
import 'main.dart';
import 'animelistpage.dart';

class ApiGod extends StatefulWidget {
  static const routeName = '/apiGod';
  final String search;
  const ApiGod(this.search);
  @override
  _ApiGodState createState() => _ApiGodState();
}

class _ApiGodState extends State<ApiGod> {
  Future<Search> futureSearch;

  @override
  void initState() {
    super.initState();
    futureSearch =
        fetchSearch('https://api.myanimelist.net/v2/anime?q=${widget.search}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 47, 82, 162),
        title: Container(
          alignment: Alignment(3.0, 0.0),
          width: 300.0,
          height: 40.0,
          child: TextField(
            decoration: InputDecoration(
              fillColor: Colors.lightBlue[50],
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onSubmitted: (text) {
              setState(() {
                futureSearch =
                    fetchSearch('https://api.myanimelist.net/v2/anime?q=$text');
              });
            },
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder<Search>(
          future: futureSearch,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildList(snapshot);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget _buildList(AsyncSnapshot<Search> s) {
    return ListView.separated(
      padding: const EdgeInsets.all(10.0),
      itemCount: s.data.id.length,
      itemBuilder: (context, i) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
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
                child: Text(
                  '${s.data.title[i]}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
