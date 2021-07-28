import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:revive/Models/courseModel.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database _db;

  DatabaseHelper._instance();

  String coursesTable = 'course_table';
  String colId = 'id';
  String colTitle = 'title';
  String colCredit = 'credit';
  String colGpa = 'gpa';
  String colStatus = 'status';

  //  task table
  //  Id| Title | Date | Priority | Status
  //  0    ''     ''       ''         0
  //  1    ''     ''       ''         0
  //  2    ''     ''       ''         0

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'courses_list.db';
    final toDoListDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return toDoListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $coursesTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,  $colCredit INTEGER,  $colGpa REAL,  $colStatus INTEGER)',
    );
  }

  Future<List<Map<String, dynamic>>> getCourseMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(coursesTable);
    return result;
  }

  Future<List<Course>> getCourseList() async {
    final List<Map<String, dynamic>> courseMapList = (await getCourseMapList());
    final List<Course> courseList = [];
    courseMapList.forEach((courseMap) {
      courseList.add(Course.formMap(courseMap));
    });
    return courseList;
  }

  Future<int> insertCourse(Course course) async {
    Database db = await this.db;
    final int result = await db.insert(coursesTable, course.toMap());
    return result;
  }

  Future<int> updateCourse(Course course) async {
    Database db = await this.db;
    final int result = await db.update(
      coursesTable,
      course.toMap(),
      where: '$colId = ?',
      whereArgs: [course.id],
    );
    return result;
  }

  Future<int> deleteCourse(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      coursesTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }
}
