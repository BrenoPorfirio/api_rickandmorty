import 'package:flutter/material.dart';
import 'package:api_rickandmorty/main.dart';

class CharacterDetails extends StatelessWidget {
  final Character character;

  CharacterDetails({required this.character});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://i.imgur.com/fkUlvdg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    character.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name: ${character.name}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Id: ${character.id}",
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Status: ${character.status}",
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Gender: ${character.gender}",
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Species: ${character.species}",
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
