class QuoteModel {
  final String content;
  final String author;
  bool isLiked; // Added property to track if the quote is liked

  QuoteModel({
    required this.content,
    required this.author,
    this.isLiked = false,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> map) {
    return QuoteModel(
      content: map['content'],
      author: map['author'],
      isLiked: map['isLiked'] == 1, // Convert integer back to boolean
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'author': author,
      'isLiked': isLiked ? 1 : 0, // Store boolean as integer
    };
  }
}
