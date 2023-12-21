import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quotes/models/quote_model.dart';
import 'package:flutter/material.dart';
import 'package:quotes/controllers/quote_controller.dart';
import 'package:quotes/views/quote_screen.dart';

class QuoteController {
  Future<QuoteModel> fetchQuote() async {
    final response =
        await http.get(Uri.parse('https://api.quotable.io/random'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> quoteData = json.decode(response.body);
      return QuoteModel(
          content: quoteData['content'], author: quoteData['author']);
    } else {
      throw Exception('Failed to load quote');
    }
  }
}
