import 'package:birdle/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text('Birdle'),
          ),
        ),
        body: Center(child: GamePage()),
      ),
    );
  }
}

//create Tile widget
class Tile extends StatelessWidget {
  const Tile(this.letter, this.hitType, {super.key});

  final String letter;
  final HitType hitType;

  @override
  Widget build(BuildContext context) {
    //TODO: Replace Container with widgets
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      color: switch(hitType){
        HitType.hit => Colors.green,
        HitType.partial => Colors.yellow,
        HitType.miss=> Colors.grey,
        _ => Colors.white,
      },
      ),
      child: Center(
        child: Text(
          letter.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge,
        )
      )
    );
  }

}

class GamePage extends StatelessWidget{
  GamePage({super.key});

  final Game _game = Game();

  @override
  Widget build(BuildContext context){
    return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
    spacing: 5.0,
    children: [
      for (var guess in _game.guesses)
        Row(
          spacing: 5.0, 
          children: [
            for (var letter in guess)
            Tile(letter.char, letter.type)
          ]
        )
    ],
    )
    );
  }
  
}