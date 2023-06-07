import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:api_rickandmorty/home/screens/ui/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Character {
  final String name;
  final String status;
  final String species;
  final String imageUrl;

  Character({
    required this.name,
    required this.status,
    required this.species,
    required this.imageUrl,
  });
}

class DataService {
  final ValueNotifier<List<Character>> tableStateNotifier = ValueNotifier([]);
  int currentPage = 1;
  int totalPages = 1;
  int pageSize = 5;

  void carregar(int index) {
    if (index == 1) {
      carregarDados();
    }
  }

  Future<void> carregarDados() async {
    var characterUri = Uri(
      scheme: 'https',
      host: 'rickandmortyapi.com',
      path: 'api/character',
      queryParameters: {
        'page': currentPage.toString(),
        'pageSize': pageSize.toString(),
      },
    );
    var response = await http.get(characterUri);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      totalPages = jsonData['info']['pages'];
      var characterList = <Character>[];

      for (var character in jsonData['results']) {
        var c = Character(
          name: character['name'],
          status: character['status'],
          species: character['species'],
          imageUrl: character['image'],
        );
        characterList.add(c);
      }

      tableStateNotifier.value = characterList;
    }
  }
}

final dataService = DataService();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(), // Tema inicial claro
      darkTheme: ThemeData.dark(), // Tema escuro
      debugShowCheckedModeBanner: false,
      home: DarkModeButtonWrapper(
        child: Builder(
          builder: (context) {
            // Use Builder para envolver apenas a parte que precisa ser reconstruída
            return LoginPage(); // Mostrar a tela de login inicialmente
          },
        ),
      ),
    );
  }
}


class DarkModeButtonWrapper extends HookWidget {
  final Widget child;

  DarkModeButtonWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = useState(false);

    void toggleDarkMode() {
      isDarkMode.value = !isDarkMode.value;
    }

    return MaterialApp(
      theme: isDarkMode.value ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dicas'),
          actions: [
            IconButton(
              icon: Icon(isDarkMode.value ? Icons.wb_sunny : Icons.nightlight_round),
              onPressed: toggleDarkMode,
            ),
          ],
        ),
        body: child,
      ),
    );
  }
}

class DataTableWidget extends StatelessWidget {
  final List<Character> jsonObjects;

  DataTableWidget({required this.jsonObjects});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: jsonObjects.length,
            itemBuilder: (context, index) {
              var character = jsonObjects[index];
              return ListTile(
                leading: Image.network(character.imageUrl),
                title: Text(character.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Status: ${character.status}"),
                    Text("Espécie: ${character.species}"),
                  ],
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if (dataService.currentPage > 1) {
                  dataService.currentPage--;
                  dataService.carregarDados();
                }
              },
              child: Icon(Icons.arrow_back),
            ),
            Text(
              'Página ${dataService.currentPage} de ${dataService.totalPages}',
            ),
            ElevatedButton(
              onPressed: () {
                if (dataService.currentPage < dataService.totalPages) {
                  dataService.currentPage++;
                  dataService.carregarDados();
                }
              },
              child: Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ],
    );
  }
}
