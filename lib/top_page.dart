import 'package:flutter/material.dart';
import 'package:test002/game_page.dart';

// ignore: use_key_in_widget_constructors
class TopPage extends StatelessWidget {
  // List<String> battleRecord = [];
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
            ]),
      ),
    );
  }
}
