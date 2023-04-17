import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import 'comment_item.dart';

class AllCommentsWidget extends StatelessWidget {
  final int movieId;
  const AllCommentsWidget({Key? key, required this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context, listen: false);
    return Center(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: provider.getCommentsByMovieId(movieId),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            final commentMapList = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: commentMapList.length,
              itemBuilder: (context, index) {
                final ratingMap = commentMapList[index];
                return CommentItem(movieRating: ratingMap,);
              },
            );
          }
          if(snapshot.hasError) {
            return const Text('Failed to load comments');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
