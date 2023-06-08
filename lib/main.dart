import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:api_rickandmorty/home/screens/ui/home.dart';
import 'package:api_rickandmorty/home/screens/ui/character_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class Character {
  final String name;
  final int id;
  final String status;
  final String gender;
  final String species;
  final String imageUrl;

  Character({
    required this.name,
    required this.id,
    required this.status,
    required this.gender,
    required this.species,
    required this.imageUrl,
  });
}

class DataService {
  final ValueNotifier<List<Character>> tableStateNotifier = ValueNotifier([]);
  int currentPage = 1;
  int totalPages = 1;
  int pageSize = 5;

  void carregar(int index, BuildContext context) {
    if (index == 1) {
      carregarDados();
    } else if (index == 2) {
      carregarPersonagemAleatorio(context);
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
          id: character['id'],
          status: character['status'],
          gender: character['gender'],
          species: character['species'],
          imageUrl: character['image'],
        );
        characterList.add(c);
      }

      tableStateNotifier.value = characterList;
    }
  }

  Future<void> carregarPersonagemAleatorio(BuildContext context) async {
    Random random = new Random();
    int randomId = random.nextInt(826) + 1;
    var characterUri = Uri(
      scheme: 'https',
      host: 'rickandmortyapi.com',
      path: 'api/character/$randomId',
    );
    var response = await http.get(characterUri);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var character = Character(
        name: jsonData['name'],
        id: jsonData['id'],
        status: jsonData['status'],
        gender: jsonData['gender'],
        species: jsonData['species'],
        imageUrl: jsonData['image'],
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CharacterDetails(character: character),
        ),
      );
    }
  }
}

final dataService = DataService();

void main() {
  runApp(MyApp());
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = useState(false);
    return MaterialApp(
      theme: isDarkMode.value ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("PÁGiNA DE LOGIN"),
          actions: [
            IconButton(
              icon: Icon(
                  isDarkMode.value ? Icons.wb_sunny : Icons.nightlight_round),
              onPressed: () => isDarkMode.value = !isDarkMode.value,
            ),
          ],
        ),
        body: LoginPage(),
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
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CharacterDetails(character: character),
                      ),
                    );
                  },
                  child: Container(
                    height: 100, // Defina a altura da linha aqui
                    padding: EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            character.imageUrl,
                            width: 100, // Defina a largura da imagem aqui
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                character.name,
                                style: TextStyle(
                                  fontSize:
                                      18, // Ajuste o tamanho do texto conforme necessário
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Id: ${character.id}",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
