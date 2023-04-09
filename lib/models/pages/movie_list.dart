import 'package:flutter/material.dart';

import 'new_movie_page.dart';

class MovieListPage extends StatefulWidget {
  static const String routeName='/';
  const MovieListPage({Key? key}) : super(key: key);

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, AddNewMoviePage.routeName);
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(title: Text('Movie List'),),
    );
  }
}
