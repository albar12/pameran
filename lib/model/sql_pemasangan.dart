import 'package:jadin_pameran/model/merchant_data.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sql.dart';

class SQLPemasangan {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE tb_pemasangan(
            idx TEXT PRIMARY KEY,
            tid TEXT,
            mid TEXT,
            merchant TEXT,
            idjo TEXT,
            area TEXT,
            foto_mesin TEXT,
            foto_struk TEXT,
            tid_merchant TEXT
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'pameran.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<void> insertPemasangan(MerchantData merchant) async {
    final db = await SQLPemasangan.db();
    await db.insert('tb_pemasangan', merchant.toJson(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  static Future<List<MerchantData>> getAllPemasangan() async {
    final db = await SQLPemasangan.db();
    final List<Map<String, dynamic>> results = await db.query('tb_pemasangan');
    return results.map((map) => MerchantData.fromJson(map)).toList();
  }
}
