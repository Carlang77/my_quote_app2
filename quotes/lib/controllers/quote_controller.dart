import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quotes/models/quote_model.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class QuoteController {
  final http.Client httpClient;

  QuoteController({http.Client? client}) : httpClient = client ?? http.Client();

  Future<QuoteModel> fetchQuote() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // Return a special QuoteModel with custom message when offline
      return QuoteModel(
          content:
              "Sorry. Your internet connection is buggy at the moment. And no. This is not a quote",
          author: "",
          isLiked: false);
    }

    try {
      final response =
          await httpClient.get(Uri.parse('https://api.quotable.io/random'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> quoteData = json.decode(response.body);
        return QuoteModel.fromJson(quoteData);
      } else {
        throw Exception('Failed to load quote');
      }
    } catch (e) {
      // Handle other types of errors
      throw Exception('Error fetching quote');
    }
  }
}
