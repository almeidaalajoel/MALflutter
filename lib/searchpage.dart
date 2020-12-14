import 'package:flutter/material.dart';
import 'classes.dart';
import 'animepage.dart';
import 'networkrequests.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/SearchPage';
  final String search;
  const SearchPage(this.search);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
              return _buildSearch(snapshot);
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

  Widget _buildSearch(AsyncSnapshot<Search> s) {
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    Container(
                      height: 135,
                      width: 105,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          //alignment: FractionalOffset.topRight,
                          image: NetworkImage(s.data.mainPicture[i]),
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
                    s.data.title[i],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, i) {
        return Divider();
      },
    );
  }
}
