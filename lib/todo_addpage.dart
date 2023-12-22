import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// リスト追加画面用Widget
class Todo_AddPage extends StatefulWidget {
  @override
  _TodoAddPageState createState() => _TodoAddPageState();
}

class _TodoAddPageState extends State<Todo_AddPage> {
  // 入力されたテキストをデータとして持つ
  // String _text = '';
  List tododatas = ["",""];

  //実行時の年月日・時間
  String dateStr = DateFormat('yyyy/MM/dd　kk:mm').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('リスト追加'),
      ),
      body: Container(
        padding: EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 入力されたテキストを表示
            //Text(tododatas[0], style: TextStyle(color: Colors.blue)),
            // const SizedBox(height: 8),
            // テキスト入力
            TextField(
              //改行許可
              keyboardType: TextInputType.multiline,
              maxLines: null,

              autofocus: true,

              // 入力されたテキストの値を受け取る（valueが入力されたテキスト）
              onChanged: (String value) {
                // データが変更したことを知らせる（画面を更新する）
                setState(() {
                  // データを変更
                  tododatas[0] = value;
                });
              },
            ),
            const SizedBox(height: 8),
            Container(
              // 横幅いっぱいに広げる
              width: double.infinity,
              // リスト追加ボタン
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  if(tododatas[0].contains(',')){tododatas[0] = tododatas[0].replaceAll(',', '');}
                  
                  tododatas[1] = dateStr;
                  Navigator.of(context).pop(tododatas);
                },
                child: Text('リスト追加', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              // 横幅いっぱいに広げる
              width: double.infinity,
              // キャンセルボタン
              child: TextButton(
                // ボタンをクリックした時の処理
                onPressed: () {
                  tododatas = ["",""];
                  // "pop"で前の画面に戻る
                  Navigator.of(context).pop(tododatas);
                },
                child: Text('キャンセル'),
              ),
            ),
          ],
        ),
      ),
    );
  }

}