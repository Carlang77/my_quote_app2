class QuoteModel {
  final String content;
  final String author;
  bool isLiked; // Added property to track if the quote is liked

  QuoteModel(
      {required this.content, required this.author, this.isLiked = false});

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      content: json['content'],
      author: json['author'],
      isLiked: false, // Initialize with false
    );
  }
}
