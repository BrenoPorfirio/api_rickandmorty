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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            character.imageUrl,
            width: 200,
          ),
          SizedBox(height: 16),
          Text(
            "Name: ${character.name}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Id: ${character.id}",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            "Status: ${character.status}",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            "Species: ${character.species}",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
