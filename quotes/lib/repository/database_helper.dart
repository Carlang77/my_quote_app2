import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:quotes/models/quote_model.dart'; // Import your QuoteModel

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Getter for the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quotes.db'); // Initialize the database
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Open the database and specify the database version and onCreate callback
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Create the database table
  Future<void> _createDB(Database db, int version) async {
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    await db.execute('''
    CREATE TABLE quotes (
      content $textType,
      author $textType,
      isLiked $boolType
    )
    ''');
  }

  // Add a quote to the database
  Future<int> addQuote(QuoteModel quote) async {
    final db = await instance.database;
    return await db.insert('quotes', quote.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  // Retrieve all quotes from the database
  Future<List<QuoteModel>> getQuotes() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('quotes');

    return List.generate(maps.length, (i) {
      return QuoteModel.fromJson(maps[i]);
    });
  }

  // Update a quote in the database
  Future<void> updateQuote(QuoteModel quote) async {
    final db = await instance.database;
    await db.update(
      'quotes',
      quote.toMap(),
      where: 'content = ? AND author = ?',
      whereArgs: [quote.content, quote.author],
    );
  }

  // Delete a quote from the database
  Future<void> deleteQuote(QuoteModel quote) async {
    final db = await instance.database;
    await db.delete(
      'quotes',
      where: 'content = ? AND author = ?',
      whereArgs: [quote.content, quote.author],
    );
  }

  // Close the database connection
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}

// Extension on QuoteModel to convert it to a map
extension on QuoteModel {
  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'author': author,
      'isLiked': isLiked ? 1 : 0,
    };
  }
}
