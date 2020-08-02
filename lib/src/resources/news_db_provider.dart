import 'package:hacker_news/src/models/item_model.dart';
import 'package:hacker_news/src/resources/repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class NewsDbProvider implements Source, Cache {
  /// class for handling sqlite connections
  Database db;

  NewsDbProvider() {
    init();
  }

  init() async {
    ////initialize the db else connect to existing one
    Directory dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'items.db');
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
           CREATE TABLE items (

              id  INTEGER PRIMARY KEY, 
              deleted INTEGER , 
              type TEXT , 
              by TEXT , 
              time  INTEGER, 
              text  TEXT, 
              dead  INTEGER, 
              parent  INTEGER, 
              kids BLOB,
              url  TEXT, 
              score  INTEGER, 
              title  TEXT, 
              descendants INTEGER 

           )
          """);
      },
    );
  }

  @override
  Future<ItemModel> fetchItem(int id) async {
    /// sqlite query to fetch an item
    final maps = await db.query('items', where: 'id=?', whereArgs: [id]);
    if (maps.length > 0) {
      return ItemModel.fromDB(maps[0]);
    }
    return null;
  }

  @override
  Future<int> clearCache() {
    return db.delete('items');
  }

  @override
  Future<int> addItem(ItemModel item) async {
    return db.insert('items', item.mapForDB(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<List<int>> fetchTopIds() {
    // TODO: implement fetchTopIds
    throw UnimplementedError();
  }
}

/// intance to be shared to repository both
/// to Source and Cache lists
final newsDBProvider = NewsDbProvider();
