import 'package:birdle/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          //child: Tile('A', HitType.hit)
          //child: Tile('A', HitType.miss)
          child: Tile('A', HitType.partial)
        ),
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