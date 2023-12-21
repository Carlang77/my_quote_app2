import 'package:flutter/material.dart';
import 'package:quotes/controllers/quote_controller.dart';
import 'package:quotes/views/quote_widget.dart';
import 'package:quotes/models/quote_model.dart';

class QuoteScreen extends StatefulWidget {
  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final QuoteController _controller = QuoteController();
  QuoteModel? currentQuote;

  @override
  void initState() {
    super.initState();
    _reloadQuote();
  }

  Future<void> _reloadQuote() async {
    var newQuote = await _fetchQuote();
    setState(() {
      currentQuote = newQuote;
    });
  }

  Future<QuoteModel?> _fetchQuote() async {
    try {
      return await _controller.fetchQuote();
    } catch (error) {
      print('Error fetching quote: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Quote'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: QuoteWidget(quote: currentQuote),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _reloadQuote,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
