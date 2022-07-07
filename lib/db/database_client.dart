import 'dart:async';
import 'dart:io';
import 'package:My_Wallet/models/operation.dart';
import 'package:My_Wallet/my_diary/report.dart';
import 'package:My_Wallet/my_diary/transaction_graph.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableName = "operations";
  final String columnId = "id";
  final String columnDateAdded = "dateAdded";
  final String columnDateOperation = "dateOperation";
  final String columnAmount = "amount";
  final String columnWalletType = "wallet";
  final String columnDescription = "description";
  final String columnPostingKey = "postingKey";

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "wallet.db");
    var walletDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    //sTable();
    return walletDb;
  }

  void sTable() async {
    Database? ddb = await DatabaseHelper._instance.db;
    List<Map> result = await ddb!.query(DatabaseHelper().tableName);
    result.forEach((row) => print(row));
    return null /*result.forEach((row) => print(row))*/;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY, $columnDateAdded INTEGER, $columnDateOperation TEXT, $columnAmount REAL, $columnWalletType TEXT, $columnDescription TEXT, $columnPostingKey TEXT)");
  }

  Future<int> saveItem(Operation operation) async {
    var dbClient = await db;
    int result = await dbClient!.insert("$tableName", operation.toMap());
    return result;
  }

  Future<int> deleteOperation(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(tableName, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> updateOperation(int id, String date, double amount, String desc) async {
    var dbClient = await db;
    return await dbClient!.rawUpdate("UPDATE $tableName SET $columnDateOperation =  '"+date+"', $columnAmount = $amount, "
        "$columnDescription = '"+desc+"' WHERE $columnId = $id");
  }

  Future<double> getSTotal() async {
    var dbClient = await db;
    double num = 0;
    final result = await dbClient!.rawQuery("SELECT SUM($columnAmount) as total FROM $tableName WHERE $columnPostingKey = 'Expense'");
    if (result[0]['total'] == null) {
      num = 0;
    } else {
      num = result[0]['total'];
    }
    return num;
  }

  Future<double> getRTotal() async {
    var dbClient = await db;
    double num = 0;
    final result = await dbClient!.rawQuery("SELECT SUM($columnAmount) as total FROM $tableName WHERE $columnPostingKey = 'Profit'");
    if (result[0]['total'] == null) {
      num = 0;
    } else {
      num = result[0]['total'];
    }
    return num;
  }

  Future<int> getTypeTotal() async {
    var dbClient = await db;
    final result = await dbClient!.rawQuery("SELECT COUNT($columnWalletType) as total FROM (SELECT $columnWalletType FROM $tableName GROUP BY $columnWalletType)");
    return result[0]["total"];
  }

  Future<List> getType() async {
    var dbClient = await db;
    return await dbClient!.rawQuery("SELECT $columnWalletType ,$columnPostingKey FROM $tableName GROUP BY $columnWalletType");
  }

  Future<List> getDate(String type, String typeName) async {
    var dbClient = await db;
    return await dbClient!.rawQuery("SELECT strftime('"+type+"', $columnDateOperation) as '"+typeName+"' FROM $tableName GROUP BY '"+typeName+"'");
  }

  Future<List> getDay() async {
    var dbClient = await db;
    return await dbClient!.rawQuery("SELECT strftime('%d', $columnDateOperation) as Day FROM $tableName GROUP BY Day");
  }

  Future<List> getWeek() async {
    var dbClient = await db;
    return await dbClient!.rawQuery("SELECT strftime('%w', $columnDateOperation) as Week FROM $tableName GROUP BY Week");
  }

  Future<List> getMonth() async {
    var dbClient = await db;
    return await dbClient!.rawQuery("SELECT strftime('%m', $columnDateOperation) as Month FROM $tableName GROUP BY Month");
  }

  Future<List> getYear() async {
    var dbClient = await db;
    return await dbClient!.rawQuery("SELECT strftime('%Y', $columnDateOperation) as Year FROM $tableName GROUP BY Year");
  }

  Future<List> getDetailsWithDate(String type, String date) async {
    var dbClient = await db;
    return await dbClient!.rawQuery("SELECT $columnId, $columnDateOperation, $columnAmount, $columnDescription, $columnWalletType, $columnPostingKey FROM $tableName WHERE strftime('" + type + "', $columnDateOperation) = '" + date + "'");
  }

  Future<List> typeDetailsDate(String type, String date) async {
    var dbClient = await db;
    return await dbClient!.rawQuery("SELECT * FROM $tableName WHERE $columnWalletType = '" + type + "' AND $columnDateOperation = '" + date + "' ");
  }

  Future<double> getTypeAmount(String type) async {
    var dbClient = await db;
    double num = 0;
    final result = await dbClient!.rawQuery("SELECT SUM($columnAmount) as total FROM $tableName WHERE $columnWalletType = '" + type + "' AND $columnPostingKey = 'Profit'");
    if (result[0]['total'] == null) {num = 0;} else {num = result[0]['total'];}
    return num;
  }

  Future<String> getTypeDate(String type) async {
    var dbClient = await db;
    String date;
    final count = await dbClient!.rawQuery("SELECT COUNT($columnDateOperation) as total FROM $tableName WHERE $columnWalletType = '" + type + "' AND $columnPostingKey = 'Profit'");
    if (count[0]["total"] > 1) {
      final result = await dbClient!.rawQuery("SELECT $columnDateOperation FROM $tableName WHERE $columnDateOperation IN (SELECT max($columnDateOperation) FROM $tableName WHERE $columnWalletType = '" + type + "' AND $columnPostingKey = 'Profit')");
      date = await result[0]["dateOperation"];
    } else if (count[0]["total"] == 0) {date = 'No Record';
    } else {
      final result = await dbClient!.rawQuery("SELECT $columnDateOperation FROM $tableName WHERE $columnWalletType = '" + type + "' AND $columnPostingKey = 'Profit'");
      date = await result[0]["dateOperation"];
    }
    return date;
  }

  Future<List<SalesData>> getTotalEachDay(String type) async {
    var dbClient = await db;
    List<Map> maps = await dbClient!.rawQuery("SELECT $columnDateOperation, SUM($columnAmount) AS Total FROM $tableName WHERE $columnPostingKey = '" + type + "' GROUP BY $columnDateOperation");
    List<SalesData> result = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        result.add(SalesData.fromMap(maps[i] as Map<String, dynamic>));
      }
    }
    return result;
  }

  Future<List<ChartData>> getLastMonthTotalWithPostingKey(String type) async {
    var dbClient = await db;
    //List<Map> maps = await dbClient!.rawQuery("SELECT $columnWalletType, $columnDateOperation, SUM($columnAmount) AS Total FROM $tableName WHERE $columnPostingKey = '" + type + "' AND $columnDateOperation BETWEEN datetime('now', 'start of month') AND datetime('now', 'localtime') GROUP BY $columnWalletType");
    List<Map> maps = await dbClient!.rawQuery("SELECT $columnWalletType, $columnDateOperation, SUM($columnAmount) AS Total FROM $tableName WHERE $columnPostingKey = '" + type + "'GROUP BY $columnWalletType");
    List<ChartData> result = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        result.add(ChartData.fromMap(maps[i] as Map<String, dynamic>));
      }
    }
    return result;
  }

  Future<List<BarData>> getTotalExpense(String type) async {
    var dbClient = await db;
    List<Map> maps = await dbClient!.rawQuery("SELECT $columnWalletType, $columnDateOperation, strftime('%m', $columnDateOperation) as Month, SUM($columnAmount) AS Total FROM $tableName WHERE $columnPostingKey = '" + type + "' GROUP BY Month");
    List<BarData> result = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        result.add(BarData.fromMap(maps[i] as Map<String, dynamic>));
      }
    }
    return result;
  }

  Future close() async {
    var dbClient = await db;
    return dbClient!.close();
  }
}
