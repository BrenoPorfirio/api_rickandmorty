import 'package:flutter/material.dart';
import 'package:api_rickandmorty/main.dart';

class CharacterDetails extends StatelessWidget {
  final Character character;

  CharacterDetails({required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
      ),
      body: Center(
        child: Column(
          children: [
            Image.network(character.imageUrl),
            Text("Name: ${character.name}"),
            Text("Status: ${character.status}"),
            Text("Species: ${character.species}"),
          ],
        ),
      ),
    );
  }
}
