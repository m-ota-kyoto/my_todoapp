import 'package:flutter/material.dart';

import 'todo_addpage.dart';
import 'todo_editpage.dart';
import 'todo_list_fnc.dart';

//ウィンドウサイズ変更にパッケージインストール済み
//https://pub.dev/packages/bitsdojo_window
import 'package:bitsdojo_window/bitsdojo_window.dart';


void main() {
  runApp(const MyApp());

  doWhenWindowReady(() {
    final initialSize = Size(600, 700);
    final minSize = Size(600, 700);
    final maxSize = Size(1200, 850);
    appWindow.maxSize = maxSize;
    appWindow.minSize = minSize;
    appWindow.size = initialSize; //default size
    appWindow.show();
  });

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO_LIST',
      // useMaterial3: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'TODOリスト'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Todoリストのデータ
  List todoList = [];
  
  //初回起動時のみ実行
  @override
  void initState() {
    //ビルド前にCSVデータ取得
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      todoList = await TodoListFnc().load();
      setState(() { });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200], // 背景色設定
      appBar: AppBar(
        // title: Text(widget.title),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              widget.title,
              style: new TextStyle(fontSize: 28.0,)
            ), 
            Text(
              "ダブルクリックで編集",
              style: new TextStyle(fontSize: 12.0,)
            )
            ],
        ),
      ),
      body: Center(
        child: ReorderableListView.builder(
          itemCount: todoList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              key: ValueKey(index.toString()),//並び替えに必要なID
              onDoubleTap: () async {
                // print('Double Tap edit');
                final editListText = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    // 遷移先の画面としてリスト追加画面を指定
                    return Todo_EditPage(editindex: index, edittext: todoList[index][0]);
                  }),
                );
                if (editListText != null) {
                  if(editListText[0] != ""){
                    // キャンセルした場合は editListText が null となるので注意
                    setState(() {
                      // リスト置き換え
                      todoList[index] = editListText;
                    });
                  }
                }
              },
              child: Card(
                child: Row(
                  children: [
                    Container(
                      child: ReorderableDragStartListener(
                        index: index,
                        child: Icon(Icons.swap_vert, size: 40),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.fromLTRB(5, 10, 15, 10),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(todoList[index][0])
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,//両端に配置
                          children: [
                            Text(todoList[index][1]),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  todoList.removeAt(index);
                                  TodoListFnc().save(todoList);
                                });
                              },
                              child: Text("削除", style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ), 
                    )
                  ],
                )
              ),
            ); 
          }, 
          buildDefaultDragHandles: false,
          onReorder: (int oldIndex, int newIndex) {//並び替え時の処理
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            todoList.insert(newIndex,  todoList.removeAt(oldIndex));
          },
        ),
      ), 
      floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: 'adddata',
              onPressed: () async {
                final newListText = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    // 遷移先の画面としてリスト追加画面を指定
                    return Todo_AddPage();
                  }),
                );
                if (newListText != null) {
                  if(newListText[0] != ""){
                    // キャンセルした場合は newListText が null となるので注意
                    setState(() {
                      // リスト追加
                      todoList.add(newListText);
                    });
                  }
                }
              },
              child: Icon(Icons.create),
            ),
            FloatingActionButton(
              heroTag: 'savedata',
              child: Icon(
                Icons.save,
                color: Colors.white,
              ),
              onPressed: () async {
                TodoListFnc().save(todoList);
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('保存しました'),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(todoList),//todolist入れないと改行バグ出る？
                            child: Text('OK')),
                      ],
                    );
                  }
                );
              },
            ),
          ],
        ),
      
      
    );
  }
}
