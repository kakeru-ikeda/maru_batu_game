import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test002/game_page.dart';

// ignore: use_key_in_widget_constructors
class TopPage extends StatefulWidget {
  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  List<String> battleRecord = [];

  void getResult() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    battleRecord = prefs.getStringList('result') ?? [];
  }

  @override
  void initState() {
    super.initState();
    getResult();
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GamePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.blue,
                ),
                child: const Text('ゲームをプレイする!'),
              ),
              const Text('戦績'),
              for (int i = 0; i < battleRecord.length; i++) ...{
                Text(battleRecord[i]),
              }
            ]),
      ),
    );
  }
}
