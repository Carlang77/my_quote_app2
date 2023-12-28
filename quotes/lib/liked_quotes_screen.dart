import 'package:flutter/material.dart';
import 'package:quotes/models/quote_model.dart';
import 'package:quotes/views/quote_widget.dart';

class LikedQuotesScreen extends StatelessWidget {
  final List<QuoteModel> likedQuotes;

  LikedQuotesScreen({required this.likedQuotes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liked Quotes'),
      ),
      body: Container(
        margin:
            EdgeInsets.symmetric(horizontal: 16), // Add left and right margins
        child: ListView.builder(
          itemCount: likedQuotes.length,
          itemBuilder: (context, index) {
            final quote = likedQuotes[index];
            return QuoteWidget(quote: quote);
          },
        ),
      ),
    );
  }
}
