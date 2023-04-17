import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../models/movie_rating.dart';
import '../providers/user_provider.dart';
import '../utils/helper_functions.dart';
import '../utils/utils.dart';

class RatingCommentWidget extends StatefulWidget {
  final int movieId;
  final VoidCallback onComplete;

  const RatingCommentWidget({Key? key, required this.movieId, required this.onComplete})
      : super(key: key);

  @override
  State<RatingCommentWidget> createState() => _RatingCommentWidgetState();
}

class _RatingCommentWidgetState extends State<RatingCommentWidget> {
  late UserProvider userProvider;
  final txtController = TextEditingController();
  final focusNode = FocusNode();
  double rating = 1;

  @override
  void didChangeDependencies() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Rate this Movie',
            style: TextStyle(fontSize: 25),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: RatingBar.builder(
              initialRating: rating,
              minRating: 1,
              itemCount: 5,
              allowHalfRating: true,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4),
              direction: Axis.horizontal,
              itemBuilder: (context, value) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (value) {
                rating = value;
              },
            ),
          ),
          const Text(
            'Leave a comment',
            style: TextStyle(fontSize: 25),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              focusNode: focusNode,
              maxLines: 3,
              controller: txtController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          TextButton(
            onPressed: _submit,
            child: const Text('SUBMIT'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    txtController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (txtController.text.isEmpty) {
      showMsg(context, 'Please leave a comment');
      return;
    }
    final movieRating = MovieRating(
      movie_id: widget.movieId,
      user_id: userProvider.userModel.userId!,
      rating_date: getFormattedDate(DateTime.now(), dateTimePattern),
      user_reviews: txtController.text,
      rating: rating,
    );
    final didUserRate = await userProvider.didUserRate(widget.movieId);
    if(didUserRate) {
      userProvider.updateRating(movieRating)
          .then((value) {
            txtController.clear();
            focusNode.unfocus();
            widget.onComplete();
      })
          .catchError((error) {});
    }else {
      userProvider.insertRating(movieRating)
          .then((value) {
        txtController.clear();
        focusNode.unfocus();
        widget.onComplete();
      })
          .catchError((error) {});
    }
  }
}
