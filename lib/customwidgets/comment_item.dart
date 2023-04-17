import 'package:flutter/material.dart';
import '../models/movie_rating.dart';
import '../models/user_model.dart';

class CommentItem extends StatelessWidget {
  final Map<String, dynamic> movieRating;
  const CommentItem({Key? key, required this.movieRating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: Text(movieRating[tblUserColEmail]),
          subtitle: Text(movieRating[tblRatingColDate]),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: Colors.amber,),
              Text(movieRating[tblColRating].toString())
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(movieRating[tblRatingColUserReviews]),
        ),
      ],
    );
  }
}
