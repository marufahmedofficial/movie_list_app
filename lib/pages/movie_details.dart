import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../customwidgets/all_comments_widget.dart';
import '../customwidgets/rating_comment_widget.dart';
import '../models/movie_favorite.dart';
import '../models/movie_model.dart';
import '../providers/movie_provider.dart';
import '../providers/user_provider.dart';
import '../utils/utils.dart';
import 'new_movie_page.dart';

class MovieDetailsPage extends StatefulWidget {
  static const String routeName = '/movie_details';

  const MovieDetailsPage({Key? key}) : super(key: key);

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  int? id;
  late String name;
  late MovieProvider provider;
  late UserProvider userProvider;

  @override
  void didChangeDependencies() {
    provider = Provider.of<MovieProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    id = argList[0];
    name = argList[1];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: userProvider.userModel.isAdmin
            ? [
          IconButton(
            onPressed: () => Navigator.pushNamed(
                context, AddNewMoviePage.routeName,
                arguments: id)
                .then((value) => setState(() {
              name = value as String;
            })),
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: _deleteMovie,
            icon: const Icon(Icons.delete),
          ),
        ]
            : null,
      ),
      body: Center(
        child: FutureBuilder<MovieModel>(
          future: provider.getMovieById(id!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final movie = snapshot.data!;
              return ListView(
                children: [
                  Image.file(
                    File(movie.image),
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  FutureBuilder<bool>(
                    future: userProvider.didUserFavorite(id!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final isFavorite = snapshot.data!;
                        return TextButton.icon(
                          onPressed: () {
                            _favoriteMovie(isFavorite);
                          },
                          icon: Icon(isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border),
                          label: Text(isFavorite
                              ? 'Remove from Favorite'
                              : 'Add to Favorite'),
                        );
                      }
                      if (snapshot.hasError) {
                        print(snapshot.error.toString());
                        return const Text('Failed to load favorite');
                      }
                      return const Text('Loading');
                    },
                  ),
                  ListTile(
                      title: Text(movie.name),
                      subtitle: Text(movie.type),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          FutureBuilder<Map<String, dynamic>>(
                            future: userProvider.getAvgRatingByMovieId(id!),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final map = snapshot.data!;
                                return Text('${map[avgRating] ?? 0.0}');
                              }
                              if (snapshot.hasError) {
                                return const Text('Error loading');
                              }
                              return const Text('Loading');
                            },
                          ),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Budget: \$${movie.budget}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(movie.description),
                  ),
                  if (!userProvider.userModel.isAdmin)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: RatingCommentWidget(
                        movieId: id!,
                        onComplete: () {
                          setState(() {});
                        },
                      ),
                    ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'All Comments',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  AllCommentsWidget(
                    movieId: id!,
                  )
                ],
              );
            }
            if (snapshot.hasError) {
              return const Text('Failed to load data');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  void _deleteMovie() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Delete $name?'),
          content: Text('Are you sure to delete $name?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('NO'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                provider.deleteMovie(id!);
                Navigator.pop(context);
              },
              child: const Text('YES'),
            )
          ],
        ));
  }

  void _favoriteMovie(bool isFavorite) async {
    final movieFavorite = MovieFavorite(
      movieId: id!,
      userId: userProvider.userModel.userId!,
    );
    if(isFavorite) {
      await userProvider.deleteFavorite(id!);
    } else {
      await userProvider.insertFavorite(movieFavorite);
    }
    setState(() {

    });
  }
}
