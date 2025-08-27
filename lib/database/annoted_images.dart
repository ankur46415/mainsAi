import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'model/anotation_model.dart';
import 'model/annotated_list_model.dart';

class AnnotationsDatabase {
  static final AnnotationsDatabase instance = AnnotationsDatabase._init();
  static Database? _database;

  AnnotationsDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('annotations.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Delete existing database to force recreation
    try {
      await deleteDatabase(path);
    } catch (e) {}

    return await openDatabase(
      path,
      version: 1, // Reset to version 1 since we're recreating
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Annotations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        questionId TEXT NOT NULL,
        imagePath TEXT NOT NULL,
        imageData BLOB NOT NULL,
        createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE annotated_lists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        questionId TEXT NOT NULL,
        annotatedImagePaths TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0
      )
    ''');

  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  }

  Future<int> insertAnnotation(Annotation annotation) async {
    final db = await database;

    try {
      // Convert List<int> to Uint8List for proper BLOB handling
      final imageData = Uint8List.fromList(annotation.imageData);

      final id = await db.insert('Annotations', {
        'questionId': annotation.questionId,
        'imagePath': annotation.imagePath,
        'imageData': imageData, // Use Uint8List for BLOB
        'createdAt': annotation.createdAt.toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      return id;
    } catch (e, stackTrace) {
    
      rethrow;
    }
  }

  Future<List<Annotation>> getAnnotationsByQuestionId(String questionId) async {
    try {
      final db = await database;

      final List<Map<String, dynamic>> maps = await db.query(
        'Annotations',
        where: 'questionId = ?',
        whereArgs: [questionId],
        orderBy: 'createdAt DESC',
      );

      return List.generate(maps.length, (i) {
        final map = maps[i];
      
        return Annotation(
          id: map['id'] as int,
          questionId: map['questionId'] as String,
          imagePath: map['imagePath'] as String,
          imageData: map['imageData'] as List<int>,
          createdAt: DateTime.parse(map['createdAt'] as String),
        );
      });
    } catch (e, stackTrace) {
   
      rethrow;
    }
  }

  Future<List<Annotation>> getAllAnnotations() async {
    try {
      final db = await database;

      // First get all unique questionIds
      final List<Map<String, dynamic>> questionIds = await db.rawQuery('''
        SELECT DISTINCT questionId 
        FROM Annotations 
        ORDER BY questionId ASC
      ''');


      // For each questionId, get its annotations
      List<Annotation> allAnnotations = [];
      for (var qId in questionIds) {
        final questionId = qId['questionId'] as String;

        final List<Map<String, dynamic>> maps = await db.query(
          'Annotations',
          where: 'questionId = ?',
          whereArgs: [questionId],
          orderBy: 'createdAt DESC',
        );


        final annotations = List.generate(maps.length, (i) {
          final map = maps[i];
        
          return Annotation(
            id: map['id'] as int,
            questionId: map['questionId'] as String,
            imagePath: map['imagePath'] as String,
            imageData: map['imageData'] as List<int>,
            createdAt: DateTime.parse(map['createdAt'] as String),
          );
        });

        allAnnotations.addAll(annotations);
      }

      return allAnnotations;
    } catch (e, stackTrace) {

      rethrow;
    }
  }

  Future<void> deleteAnnotation(int id) async {
    final db = await database;

    try {
      await db.delete('Annotations', where: 'id = ?', whereArgs: [id]);
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  Future<void> close() async {
    final db = await database;
    db.close();
    _database = null;
  }

  Future<int> insertAnnotatedList(AnnotatedList list) async {
    final db = await database;
    return await db.insert('annotated_lists', list.toMap());
  }

  Future<AnnotatedList?> getAnnotatedListByQuestionId(String questionId) async {
    final db = await database;
    final maps = await db.query(
      'annotated_lists',
      where: 'questionId = ?',
      whereArgs: [questionId],
      orderBy: 'createdAt DESC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return AnnotatedList.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updateAnnotatedList(AnnotatedList list) async {
    final db = await database;
    await db.update(
      'annotated_lists',
      list.toMap(),
      where: 'id = ?',
      whereArgs: [list.id],
    );
  }

  Future<void> markListAsCompleted(String questionId) async {
    final db = await database;
    await db.update(
      'annotated_lists',
      {'isCompleted': 1},
      where: 'questionId = ?',
      whereArgs: [questionId],
    );
  }
}
