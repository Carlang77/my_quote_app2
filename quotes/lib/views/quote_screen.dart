import 'package:flutter/material.dart';
import 'package:quotes/controllers/quote_controller.dart';
import 'package:quotes/views/quote_widget.dart';
import 'package:quotes/models/quote_model.dart';
import 'package:quotes/liked_quotes_screen.dart';
import 'package:share/share.dart'; // Import the share package

class QuoteScreen extends StatefulWidget {
  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final QuoteController _controller = QuoteController();
  QuoteModel? currentQuote;
  final List<QuoteModel> likedQuotes = []; // List to store liked quotes

  @override
  void initState() {
    super.initState();
    _reloadQuote();
  }

  Future<void> _reloadQuote() async {
    try {
      var newQuote = await _controller.fetchQuote();
      setState(() {
        currentQuote = newQuote;
      });
    } catch (error) {
      print('Error fetching quote: $error');
      setState(() {
        currentQuote = QuoteModel(
            content:
                "Sorry. Your internet connection is buggy at the moment. And no. This is not a quote.",
            author: "Carlang :)",
            isLiked: false);
      });
    }
  }

  Future<QuoteModel?> _fetchQuote() async {
    try {
      return await _controller.fetchQuote();
    } catch (error) {
      print('Error fetching quote: $error');
      return null;
    }
  }

  void _toggleLike() {
    setState(() {
      if (currentQuote != null) {
        currentQuote!.isLiked = !currentQuote!.isLiked;
        if (currentQuote!.isLiked) {
          likedQuotes.add(currentQuote!);
        } else {
          likedQuotes
              .removeWhere((quote) => quote.content == currentQuote!.content);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Daily Quotes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40, // Adjust the font size if needed
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Image.asset(
              'assets/images/EEK_Logo.png',
              fit: BoxFit.contain,
              height: 32,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      LikedQuotesScreen(likedQuotes: likedQuotes),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              if (currentQuote != null) {
                Share.share(
                  '${currentQuote!.content} - ${currentQuote!.author}',
                  subject: 'Quote from Daily Quote App',
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 16.0),
        child: Center(
          child: FutureBuilder<QuoteModel?>(
            future: _fetchQuote(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Show loading indicator
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}"); // Show error message
              } else if (snapshot.hasData) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/quotes.png',
                      width: 80,
                      height: 80,
                    ),
                    QuoteWidget(quote: snapshot.data, onLiked: _toggleLike),
                  ],
                );
              } else {
                return Text(
                    "No quote found"); // Handle the case when no data is returned
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _reloadQuote,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
