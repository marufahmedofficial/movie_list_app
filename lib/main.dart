import 'package:flutter/material.dart';

import 'pages/movie_details.dart';
import 'pages/movie_list.dart';
import 'pages/new_movie_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: MovieListPage.routeName,
      routes: {
        MovieListPage.routeName:(context)=>MovieListPage(),
        AddNewMoviePage.routeName:(context)=>AddNewMoviePage(),
        MovieDetailsPage.routeName:(context)=>MovieDetailsPage(),
      },
    );
  }
}


