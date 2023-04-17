import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/launcher_page.dart';
import 'pages/login_page.dart';
import 'pages/movie_details.dart';
import 'pages/movie_list.dart';
import 'pages/new_movie_page.dart';
import 'providers/movie_provider.dart';
import 'providers/user_provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MovieProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: MovieListPage.routeName,
      routes: {
        MovieListPage.routeName:(context)=> const MovieListPage(),
        AddNewMoviePage.routeName:(context)=> const AddNewMoviePage(),
        MovieDetailsPage.routeName:(context)=> const MovieDetailsPage(),
        LoginPage.routeName:(context)=> const LoginPage(),
        LauncherPage.routeName:(context)=> const LauncherPage(),
      },
    );
  }
}

