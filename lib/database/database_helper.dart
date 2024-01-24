import 'package:mongo_dart/mongo_dart.dart';

class MongoDbService {
  static final MongoDbService _instance = MongoDbService._internal();

  factory MongoDbService() {
    return _instance;
  }

  MongoDbService._internal();

  late Db _db;

  Future<void> connect(String databaseUrl) async {
    _db = await Db.create(databaseUrl);
    await _db.open();
  }

  Future<void> closeConnection() async {
    await _db.close();
  }

  Future<void> addDocument(
      String collectionName, Map<String, dynamic> document) async {
    await _db.collection(collectionName).insert(document);
  }

  Future<List<Map<String, dynamic>>> getDocuments(String collectionName) async {
    final documents = await _db.collection(collectionName).find().toList();
    return documents.map((e) => e as Map<String, dynamic>).toList();
  }

  Future<List<Map<String, dynamic>>> getDocumentsByEAN(
      String collectionName, String eanValue) async {
    final documents = await _db
        .collection(collectionName)
        .find(where.eq('EAN', eanValue))
        .toList();
    return documents.map((e) => e as Map<String, dynamic>).toList();
  }

  Future<List<Map<String, dynamic>>> getDocumentsByIngredients(
      String collectionName, List<String> ingredients) async {
    final documents = await _db
        .collection(collectionName)
        .find(where.oneFrom('Name', ingredients))
        .toList();

    return documents.map((e) => e as Map<String, dynamic>).toList();
  }
}
