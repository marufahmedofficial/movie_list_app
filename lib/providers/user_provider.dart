import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/movie_rating.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  late UserModel userModel;
  Future<UserModel?> getUserByEmail(String email) =>
      DbHelper.getUserByEmail(email);

  Future<int> insertUser(UserModel userModel) =>
      DbHelper.insertUser(userModel);

  Future<int> insertRating(MovieRating movieRating) =>
      DbHelper.insertRating(movieRating);

  Future<int> updateRating(MovieRating movieRating) =>
      DbHelper.updateRating(movieRating);

  Future<void> getUserById(int id) async {
    userModel = await DbHelper.getUserById(id);
  }

  Future<Map<String, dynamic>> getAvgRatingByMovieId(int id) =>
      DbHelper.getAvgRatingByMovieId(id);

  Future<List<Map<String, dynamic>>> getCommentsByMovieId(int id) =>
      DbHelper.getCommentsByMovieId(id);

  Future<bool> didUserRate(int movieId) =>
      DbHelper.didUserRate(movieId, userModel.userId!);
}