import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/movie_provider.dart';
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
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.movieList.length,
          itemBuilder: (context, index) {
            final movie = provider.movieList[index];
            return ListTile(
              leading:
              Image.file(File(movie.image),
                width: 100, height: 100, fit: BoxFit.cover,),
              title: Text(movie.name),
              subtitle: Text(movie.type),
            );
          },
        ),
      ),
    );
  }
}
