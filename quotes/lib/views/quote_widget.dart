import 'package:flutter/material.dart';
import 'package:quotes/models/quote_model.dart';

class QuoteWidget extends StatelessWidget {
  final QuoteModel? quote;
  final VoidCallback? onLiked;

  QuoteWidget({required this.quote, this.onLiked});

  @override
  Widget build(BuildContext context) {
    if (quote == null) {
      return CircularProgressIndicator();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          quote!.content,
          style: TextStyle(fontSize: 40),
        ),
        SizedBox(height: 10),
        Text(
          '- ${quote!.author}',
          style: TextStyle(fontSize: 16),
        ),
        IconButton(
          icon: Icon(quote!.isLiked ? Icons.favorite : Icons.favorite_border),
          onPressed: onLiked,
        ),
      ],
    );
  }
}
