//import 'package:flutter/material.dart';
import 'dart:async'; //非同期処理用ライブラリ
import 'dart:io';  //ファイル出力用ライブラリ
import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:path/path.dart' as p;
//import 'package:flutter/services.dart';


/// ・Todoを削除/保存/読込する
class TodoListFnc {

  /// Todoリスト
  //List _list = [];

  /// ストアのインスタンス
  static final TodoListFnc _instance = TodoListFnc._internal();

  /// プライベートコンストラクタ
  TodoListFnc._internal();

  /// ファクトリーコンストラクタ
  /// (インスタンスを生成しないコンストラクタのため、自分でインスタンスを生成する)
  factory TodoListFnc() {
    return _instance;
  }

  /// Todoを削除する
  // void delete(Todo todo) {
  //   _list.remove(todo);
  //   save();
  // }

  /// Todoを保存する
  void save(List nowtodolist) async {
    List<List<dynamic>> rows = [];

    //改行置換
    nowtodolist.forEach((value){
      value[0] = value[0].replaceAll('\n', '???!n???');
    });

    //List<dynamic> associateList = nowtodolist;
    rows = nowtodolist.cast<List<dynamic>>();
    String csv = const ListToCsvConverter().convert(rows);
    
    
    File f = File(getAssetFileUrl('assets\\todolistdata.csv'));
    f.writeAsString(csv);

  }

  /// Todoを読込する
  Future<List<List>> load() async {
    final File importFile = File(getAssetFileUrl('assets\\todolistdata.csv'));
    List<List> importList = [];

    Stream fread = importFile.openRead();
    // Read lines one by one, and split each ','
    await fread.transform(utf8.decoder).transform(LineSplitter()).listen(
      (String line) {
        //改行置換
        line = line.replaceAll('???!n???', '\n');

        importList.add(line.split(','));
      },
    ).asFuture();
    
    return  importList;
  }

  //assetのパス取得
  String getAssetFileUrl(String asset) {
    final assetsDirectory = p.join(p.dirname(Platform.resolvedExecutable),
        'data', 'flutter_assets', asset);
    // print(Platform.resolvedExecutable);
    return assetsDirectory.toString();
  }

}


/////////////////////////////////////////////////////////////////////////////////////////////////
// Map<Permission, PermissionStatus> statuses = await [
//   Permission.storage,
// ].request();

// List<dynamic> associateList = [
//   {"number": 1, "lat": "14.97534313396318", "lon": "101.22998536005622"},
//   {"number": 2, "lat": "14.97534313396318", "lon": "101.22998536005622"},
//   {"number": 3, "lat": "14.97534313396318", "lon": "101.22998536005622"},
//   {"number": 4, "lat": "14.97534313396318", "lon": "101.22998536005622"}
// ];

// List<List<dynamic>> rows = [];

// List<dynamic> row = [];
// row.add("number");
// row.add("latitude");
// row.add("longitude");
// rows.add(row);
// for (int i = 0; i < associateList.length; i++) {
//   List<dynamic> row = [];
//   row.add(associateList[i]["number"] - 1);
//   row.add(associateList[i]["lat"]);
//   row.add(associateList[i]["lon"]);
//   rows.add(row);
// }

// String csv = const ListToCsvConverter().convert(rows);

// String dir = await ExtStorage.getExternalStoragePublicDirectory(
//     ExtStorage.DIRECTORY_DOWNLOADS);
// print("dir $dir");
// String file = "$dir";

// File f = File(file + "/filename.csv");

// f.writeAsString(csv);