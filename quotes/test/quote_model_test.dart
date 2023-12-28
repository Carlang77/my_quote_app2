import 'package:test/test.dart';
import 'package:quotes/models/quote_model.dart';

void main() {
  test('QuoteModel initialization', () {
    var quote = QuoteModel(content: 'Test Quote', author: 'Author');
    expect(quote.content, equals('Test Quote'));
    expect(quote.author, equals('Author'));
    expect(quote.isLiked, isFalse);
  });

  test('QuoteModel fromJson', () {
    var json = {'content': 'Test Quote', 'author': 'Author'};
    var quote = QuoteModel.fromJson(json);
    expect(quote.content, equals('Test Quote'));
    expect(quote.author, equals('Author'));
    expect(quote.isLiked, isFalse);
  });
}
