import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/movie_model.dart';

class MovieProvider extends ChangeNotifier {

  List<MovieModel> movieList = [];

  Future<int> insertMovie(MovieModel movieModel) =>
      DbHelper.insertMovie(movieModel);

  void getAllMovies() async {
    movieList = await DbHelper.getAllMovies();
    notifyListeners();
  }
}