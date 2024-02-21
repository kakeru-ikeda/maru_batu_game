import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test002/game_page.dart';

// ignore: use_key_in_widget_constructors
class TopPage extends StatefulWidget {
  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  late List<String>? battleRecord;

  Future<List<String>?> getResult() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    battleRecord = prefs.getStringList('result');
    return battleRecord;
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
              FutureBuilder<List<String>?>(
                future: getResult(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>?> snapshot) {
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
            ]),
      ),
    );
  }
}
