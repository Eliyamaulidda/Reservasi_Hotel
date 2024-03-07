import 'package:uas/model/reservasi.dart';
import 'package:uas/model/kamar.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';

class DatabaseHelper {
  


  static Future<sql.Database> db() async {
    return sql.openDatabase(join(await sql.getDatabasesPath(), 'catatan.db'),
        version: 1, onCreate: (database, version) async {
    await database.execute("""
        CREATE TABLE reservasi (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          nama TEXT,
          telepon TEXT,
          photo TEXT

        )
      """);

      await database.execute("""
        CREATE TABLE kamar (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          nomor TEXT,
          jeniskamar TEXT,
          jumlahpesan TEXT,
          harga TEXT,
          photo TEXT

        )
      """);
    });
  }

  static Future<int> tambahReservasi(Reservasi reservasi) async {
    final db = await DatabaseHelper.db();
    final data = reservasi.toList();
    return db.insert('reservasi', data);
  }


  static Future<List<Map<String, dynamic>>> getReservasi() async {
    final db = await DatabaseHelper.db();
    return db.query("reservasi");
  }

  
  static Future<int> updateReservasi(
      Reservasi reservasi) async {
    final db = await DatabaseHelper.db();
    final data =  reservasi.toList();
    return db.update('reservasi', data, where: "id=?", whereArgs: [reservasi.id]);
  }


  static Future<int> deleteReservasi(int id) async {
    final db = await DatabaseHelper.db();
    return db.delete('reservasi', where: 'id=$id');
  }

 static Future<int> tambahKamar(Kamar kamar) async {
    final db = await DatabaseHelper.db();
    final data = kamar.toList();
    return db.insert('kamar', data);
  }


  static Future<List<Map<String, dynamic>>> getKamar() async {
    final db = await DatabaseHelper.db();
    return db.query("kamar");
  }

  
  static Future<int> updateKamar(Kamar kamar) async {
    final db = await DatabaseHelper.db();
    final data = kamar.toList();
    return db.update('kamar', data, where: "id=?", whereArgs: [kamar.id]);
  }


  static Future<int> deleteKamar(int id) async {
    final db = await DatabaseHelper.db();
    return db.delete('kamar', where: 'id=$id');
  }

}


