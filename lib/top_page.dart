import 'package:flutter/material.dart';
import 'package:test002/game_page.dart';
import 'package:test002/shared_preferences_service.dart';

// ignore: use_key_in_widget_constructors
class TopPage extends StatefulWidget {
  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  /// SharedPreferencesのインスタンス
  final SharedPreferencesService prefs = SharedPreferencesService.instance;

  Future<List<String>?> getResult() async {
    List<String>? battleRecord = await prefs.getStringList('result');
    return battleRecord;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('〇✕ゲーム'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const GamePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'ゲームをプレイする!',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const Text(
              '戦績',
              style: TextStyle(fontSize: 20),
            ),
            FutureBuilder<List<String>?>(
              future: getResult(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<String>?> snapshot) {
                /// 通信中の場合はローディングを表示
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasData) {
                  List<String>? data = snapshot.data;
                  return Column(
                    children: <Widget>[
                      for (int i = 0; i < data!.length; i++) ...{
                        Text(data[i]),
                      }
                    ],
                  );
                } else {
                  return const Text("データなし");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
