import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/movie_model.dart';


class MovieProvider extends ChangeNotifier {
  List<MovieModel> movieList = [];

  Future<int> insertMovie(MovieModel movieModel) =>
      DbHelper.insertMovie(movieModel);

  Future<void> updateMovie(MovieModel movieModel) async {
    await DbHelper.updateMovie(movieModel);
    getAllMovies();
  }

  void getAllMovies() async {
    movieList = await DbHelper.getAllMovies();
    notifyListeners();
  }

  Future<MovieModel> getMovieById(int movieId) =>
      DbHelper.getMovieById(movieId);

  MovieModel getMovieFromList(int id) =>
      movieList.firstWhere((element) => element.id == id);

  void deleteMovie(int id) async {
    await DbHelper.deleteMovie(id);
    getAllMovies();
  }
}