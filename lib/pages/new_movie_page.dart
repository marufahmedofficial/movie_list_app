import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/movie_model.dart';
import '../providers/movie_provider.dart';
import '../utils/helper_functions.dart';
import '../utils/utils.dart';

class AddNewMoviePage extends StatefulWidget {
  static const String routeName='/movie_add';

  const AddNewMoviePage({Key? key}) : super(key: key);

  @override
  State<AddNewMoviePage> createState() => _AddNewMoviePageState();
}

class _AddNewMoviePageState extends State<AddNewMoviePage> {

  late MovieProvider movieProvider;
  final _fromKey=GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final budgetController = TextEditingController();
  String? selectedType;
  DateTime? releaseDate;
  String? imagePath;
  int? id;

  @override
  void didChangeDependencies() {
    movieProvider=Provider.of(context,listen: false);
    id = ModalRoute.of(context)!.settings.arguments as int?;
    if(id != null) {
      _setData();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    budgetController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(id == null ? 'Add New Movie' : 'Update Movie'),
        actions: [
          IconButton(
              onPressed: saveMovie,
              icon: Icon(id == null ? Icons.save : Icons.update))
        ],
      ),
      body: Form(
          key: _fromKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      hintText: 'Enter Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                          const BorderSide(color: Colors.blue, width: 1))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                      hintText: 'Enter Description',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                          BorderSide(color: Colors.blue, width: 1))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: budgetController,
                  decoration: InputDecoration(
                      hintText: 'Enter budget',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                          BorderSide(color: Colors.blue, width: 1))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide:
                            BorderSide(color: Colors.blue, width: 1))),
                    hint: Text('Select Movie Type'),
                    items: movieTypes
                        .map((e) => DropdownMenuItem(value: e, child: Text(e!)))
                        .toList(),
                    value: selectedType,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a type';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: selectDate,
                      icon: const Icon(Icons.calendar_month),
                      label: const Text('Select Release Date'),
                    ),
                    Text(releaseDate == null
                        ? 'No date chosen'
                        : getFormattedDate(releaseDate!, 'dd/MM/yyyy'))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    imagePath == null
                        ? const Icon(
                      Icons.movie,
                      size: 100,
                    )
                        : Image.file(
                      File(imagePath!),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    TextButton.icon(
                      onPressed: getImage,
                      icon: const Icon(Icons.photo),
                      label: const Text('Select from Gallery'),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
  void selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        releaseDate = selectedDate;
      });
    }
  }

  void getImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        imagePath = file.path;
      });
    }
  }

  void saveMovie() {
    if (releaseDate == null) {
      showMsg(context, 'Please select a date');
      return;
    }
    if (imagePath == null) {
      showMsg(context, 'Please select an image');
      return;
    }
    if (_fromKey.currentState!.validate()) {

      final movie = MovieModel(
        name: nameController.text,
        image: imagePath!,
        description: descriptionController.text,
        budget: int.parse(budgetController.text),
        type: selectedType!,
        release_date: getFormattedDate(releaseDate!, datePattern),
      );

      if(id != null) {
        movie.id = id;
        movieProvider
            .updateMovie(movie)
            .then((value) {
          Navigator.pop(context, movie.name);
        }).catchError((error) {
          print(error.toString());
        });
      } else {
        movieProvider
            .insertMovie(movie)
            .then((value) {
          movieProvider.getAllMovies();
          Navigator.pop(context);
        }).catchError((error) {
          print(error.toString());
        });
      }
    }
  }

  void _setData() {
    final movie = movieProvider.getMovieFromList(id!);
    nameController.text = movie.name;
    descriptionController.text = movie.description;
    budgetController.text = movie.budget.toString();
    selectedType = movie.type;
    imagePath = movie.image;
    releaseDate = DateFormat(datePattern).parse(movie.release_date);

  }
}
