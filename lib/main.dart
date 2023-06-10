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
    } else if (index == 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          int? selectedId;
          return AlertDialog(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            title: Text('Digite o ID do personagem:'),
            content: TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                selectedId = int.tryParse(value);
              },
              decoration: InputDecoration(
                labelText: ('Entre 1 a 826'),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).elevatedButtonTheme.style?.backgroundColor?.resolve({MaterialState.disabled}), // Cor do botão
                  foregroundColor: Colors.white, // Cor do texto
                ),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  if (selectedId != null) {
                    carregarPorId(selectedId!, context);
                    Navigator.pop(context);
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).elevatedButtonTheme.style?.backgroundColor?.resolve({MaterialState.disabled}), // Cor do botão
                  foregroundColor: Colors.white, // Cor do texto
                ),
                child: Text('Buscar'),
              ),
            ],
          );
        },
      );
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

  Future<void> carregarPorId(int id, BuildContext context) async {
    var characterUri = Uri(
      scheme: 'https',
      host: 'rickandmortyapi.com',
      path: 'api/character/$id',
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
      theme: isDarkMode.value ? _buildDarkTheme() : _buildLightTheme(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "PAGINA DE LOGIN",
            style: TextStyle(fontFamily: 'Schwifty', fontSize: 30),
          ),
          actions: [
            IconButton(
              icon: Icon(
                isDarkMode.value ? Icons.wb_sunny : Icons.nightlight_round,
              ),
              onPressed: () => isDarkMode.value = !isDarkMode.value,
            ),
          ],
        ),
        body: LoginPage(),
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData.light().copyWith(
      primaryColor: Colors.green, // Defina a cor verde como a cor primária
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.green, // Cor de fundo da AppBar
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.green[900]), // verde escuro para o tema claro
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.green[900], // Defina a cor verde escuro como a cor primária
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.green[900], // Cor de fundo da AppBar
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.lightGreen), // verde claro para o tema escuro
        ),
      ),
    );
  }
}


class DataTableWidget extends StatelessWidget {
  final List<Character> jsonObjects;

  DataTableWidget({required this.jsonObjects});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color.fromARGB(110, 144, 255, 17),
            Colors.black,
          ],
        ),
        image: DecorationImage(
          image: NetworkImage(
            'https://i.imgur.com/wzTOVTZ.jpg',
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.75),
            BlendMode.dstATop,
          ),
        ),
      ),
      child: Column(
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
                      height: 150,
                      padding: EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              character.imageUrl,
                              width: 150,
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
                                    fontSize: 18,
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
      ),
    );
  }
}
