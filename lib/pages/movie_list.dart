import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/movie_model.dart';
import '../providers/movie_provider.dart';
import '../providers/user_provider.dart';
import '../utils/helper_functions.dart';
import 'launcher_page.dart';
import 'movie_details.dart';
import 'new_movie_page.dart';

class MovieListPage extends StatefulWidget {
  static const String routeName = '/home';

  const MovieListPage({Key? key}) : super(key: key);

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  late MovieProvider provider;
  late UserProvider userProvider;

  @override
  void didChangeDependencies() {
    provider = Provider.of<MovieProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    provider.getAllMovies();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: userProvider.userModel.isAdmin ? FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddNewMoviePage.routeName);
        },
        child: const Icon(Icons.add),
      ) : null,
      appBar: AppBar(
        title: const Text('Movie List'),
        actions: [
          IconButton(
            onPressed: () async {
              await setLoginStatus(false);
              Navigator.pushReplacementNamed(context, LauncherPage.routeName);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.movieList.length,
          itemBuilder: (context, index) {
            final movie = provider.movieList[index];
            return MovieItem(movie: movie);
          },
        ),
      ),
    );
  }
}

class MovieItem extends StatelessWidget {
  const MovieItem({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, MovieDetailsPage.routeName,
          arguments: [movie.id, movie.name]),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.file(
                File(movie.image),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              ListTile(
                title: Text(movie.name),
                subtitle: Text(movie.type),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
