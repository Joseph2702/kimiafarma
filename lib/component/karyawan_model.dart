import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Karyawan {
  var nopekerja;
  String nama;
  String cabang;
  String alamatToko;

  Karyawan({
    required this.nopekerja,
    required this.nama,
    required this.cabang,
    required this.alamatToko,
  });

  Map<String, dynamic> toMap() {
    return {
      'nopekerja': nopekerja,
      'nama': nama,
      'cabang': cabang,
      'alamatToko': alamatToko,
    };
  }
}

class KaryawanService {
  final CollectionReference _KaryawanCollection =
      FirebaseFirestore.instance.collection('karyawan');

  Future<void> importKaryawanfromCSV(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xls', 'xlsx'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      String csvString = utf8.decode(file.bytes!);
      List<List<dynamic>> csvtable = CsvToListConverter().convert(csvString);

      for (List<dynamic> row in csvtable) {
        Karyawan karyawan = Karyawan(
          nopekerja: row[0],
          nama: row[1] as String,
          cabang: row[2] as String,
          alamatToko: row[3] as String,
        );
        await _KaryawanCollection.add(karyawan.toMap());
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data Karyawan berhasil di import'),
        ),
      );
    }
  }

  Future<void> deleteKaryawan(String documentId) async {
    await _KaryawanCollection.doc(documentId).delete();
  }
}
