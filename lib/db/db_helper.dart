import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;



class DbHelper {
  static const String createTableMovie = '''create table $tableMovie(
  $tblMovieColId integer primary key autoincrement,
  $tblMovieColName text,
  $tblMovieColDes text,
  $tblMovieColType text,
  $tblMovieColImage text,
  $tblMovieColRelease text,
  $tblMovieColBudget integer)''';

  static const String createTableUser = '''create table $tableUser(
  $tblUserColId integer primary key autoincrement,
  $tblUserColEmail text,
  $tblUserColPassword text)''';

  static const String createTableRating = '''create table $tableRating(
  $tblRatingColMovieId integer,
  $tblRatingColUserId integer,
  $tblRatingColDate text,
  $tblRatingColUserReviews text,
  $tblColRating real)''';

  static const String createTableFavorite = '''create table $tableFavorite(
  $tblFavColMovieId integer,
  $tblFavColUserId integer,
  $tblFavColFavorite integer)''';


  static Future<Database> open() async {

    final rootPath = await getDatabasesPath();
    final dbPath = Path.join(rootPath, 'movie_db');

    return openDatabase(dbPath, version: 1, onCreate: (db, version) async {
      await db.execute(createTableMovie);
      await db.execute(createTableUser);
      await db.execute(createTableRating);
      await db.execute(createTableFavorite);
    });
  }

  static Future<int> insertMovie(MovieModel movieModel) async {
    final db = await open();
    return db.insert(tableMovie, movieModel.toMap());
  }

  static Future<List<MovieModel>> getAllMovies() async {

    final db = await open();
    final mapList = await db.query(tableMovie);
    return List.generate(mapList.length, (index) =>
        MovieModel.fromMap(mapList[index]));
  }
}