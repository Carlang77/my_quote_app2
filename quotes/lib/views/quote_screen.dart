import 'package:flutter/material.dart';
import 'package:quotes/controllers/quote_controller.dart';
import 'package:quotes/views/quote_widget.dart';
import 'package:quotes/repository/database_helper.dart';
import 'package:quotes/models/quote_model.dart';
import 'package:quotes/liked_quotes_screen.dart';
import 'package:share/share.dart'; // Import the share package

class QuoteScreen extends StatefulWidget {
  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final QuoteController _controller = QuoteController();
  QuoteModel? currentQuote; // The currently displayed quote
  final List<QuoteModel> likedQuotes = []; // List of liked quotes

  @override
  void initState() {
    super.initState();
    _loadLikedQuotes(); // Load liked quotes from the database
    _reloadQuote(); // Load a new quote when the screen initializes
  }

  Future<void> _reloadQuote() async {
    try {
      var newQuote = await _controller.fetchQuote(); // Fetch a new quote
      setState(() {
        currentQuote = newQuote; // Update the displayed quote
      });
    } catch (error) {
      print('Error fetching quote: $error');
      setState(() {
        // Display a default quote if there's an error fetching a new one
        currentQuote = QuoteModel(
          content:
              "Sorry. Your internet connection is buggy at the moment. And no. This is not a quote.",
          author: "Carlang :)",
          isLiked: false,
        );
      });
    }
  }

  Future<void> _loadLikedQuotes() async {
    final liked = await DatabaseHelper.instance
        .getQuotes(); // Load liked quotes from the database
    setState(() {
      likedQuotes.clear(); // Clear existing liked quotes
      likedQuotes.addAll(liked); // Add loaded liked quotes to the list
    });
  }

  Future<void> _toggleLike() async {
    try {
      setState(() {
        if (currentQuote != null) {
          currentQuote!.isLiked =
              !currentQuote!.isLiked; // Toggle like status of the current quote
          if (currentQuote!.isLiked) {
            likedQuotes.add(currentQuote!); // Add the liked quote to the list
            DatabaseHelper.instance
                .addQuote(currentQuote!); // Add the liked quote to the database
          } else {
            likedQuotes.removeWhere((quote) =>
                quote.content ==
                currentQuote!
                    .content); // Remove the unliked quote from the list
            DatabaseHelper.instance.deleteQuote(
                currentQuote!); // Delete the unliked quote from the database
          }
        }
      });
    } catch (error) {
      print('Error saving liked quote: $error');
    }
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
                  fontSize: 40,
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
                  builder: (context) => LikedQuotesScreen(
                      likedQuotes:
                          likedQuotes), // Navigate to the LikedQuotesScreen
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
                ); // Share the current quote
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 16.0),
        child: Center(
          child: currentQuote != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/quotes.png',
                      width: 80,
                      height: 80,
                    ),
                    QuoteWidget(
                        quote: currentQuote,
                        onLiked: _toggleLike), // Display the current quote
                  ],
                )
              : CircularProgressIndicator(), // Show a loading indicator if there's no current quote
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            _reloadQuote, // Reload a new quote when the button is pressed
        child: Icon(Icons.refresh),
      ),
    );
  }
}
