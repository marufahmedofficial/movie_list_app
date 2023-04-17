import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie_model.dart';
import '../providers/movie_provider.dart';
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

  @override
  void didChangeDependencies() {
    provider = Provider.of<MovieProvider>(context, listen: false);
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
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(
                context, AddNewMoviePage.routeName, arguments: id)
                .then((value) => setState(() {
              name = value as String;
            })),
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: _deleteMovie,
            icon: const Icon(Icons.delete),
          ),
        ],
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
                          Text('7.6'),
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
    showDialog(context: context, builder: (context) => AlertDialog(
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
}
