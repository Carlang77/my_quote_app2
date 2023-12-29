// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:quotes/models/quote_model.dart';

// class DatabaseHelper {
//   static Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB();
//     return _database!;
//   }

//   Future<Database> _initDB() async {
//     final documentsDirectory = await getDatabasesPath();
//     final path = join(documentsDirectory, 'quotes.db');

//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (Database db, int version) async {
//         await db.execute('''
//           CREATE TABLE liked_quotes (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             content TEXT,
//             author TEXT,
//             isLiked INTEGER
//           )
//         ''');
//       },
//     );
//   }

//   Future<void> insertQuote(QuoteModel quote) async {
//     final db = await database;
//     await db.insert(
//       'liked_quotes',
//       quote.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<List<QuoteModel>> getLikedQuotes() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query('liked_quotes');

//     return List.generate(maps.length, (i) {
//       return QuoteModel.fromMap(maps[i]);
//     });
//   }

//   Future<void> deleteQuote(int id) async {
//     final db = await database;
//     await db.delete(
//       'liked_quotes',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }

//   Future<void> updateQuote(QuoteModel quote) async {
//     final db = await database;
//     await db.update(
//       'liked_quotes',
//       quote.toMap(),
//       where: 'id = ?',
//       whereArgs: [quote.id],
//     );
//   }
// }
