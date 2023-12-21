import 'package:flutter/material.dart';
import 'package:quotes/models/quote_model.dart';

class QuoteWidget extends StatelessWidget {
  final QuoteModel? quote;

  QuoteWidget({required this.quote});

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
      ],
    );
  }
}
