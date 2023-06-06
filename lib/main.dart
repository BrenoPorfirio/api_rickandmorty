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

  Character(
      {required this.name,
      required this.status,
      required this.species,
      required this.imageUrl});
}

class DataService {
  final ValueNotifier<List<Character>> tableStateNotifier = ValueNotifier([]);

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
      queryParameters: {'size': '5'},
    );
    var response = await http.get(characterUri);
    var jsonData = jsonDecode(response.body);
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

final dataService = DataService();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MaterialColor customColor = MaterialColor(0xFF95C25E, {
      50: Color(0xFFF3F8E6),
      100: Color(0xFFE3F0B2),
      200: Color(0xFFCFE783),
      300: Color(0xFFBBDA55),
      400: Color(0xFFAACB31),
      500: Color(0xFF95C25E),
      600: Color(0xFF89B654),
      700: Color(0xFF7CAE4B),
      800: Color(0xFF70A642),
      900: Color(0xFF589D30),
    });

    return MaterialApp(
      theme: ThemeData(primarySwatch: customColor),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class NewNavBar extends HookWidget {
  final void Function(int) itemSelectedCallback;

  NewNavBar({required this.itemSelectedCallback});

  @override
  Widget build(BuildContext context) {
    var state = useState(1);

    return BottomNavigationBar(
      onTap: (index) {
        state.value = index;
        itemSelectedCallback(index);
      },
      currentIndex: state.value,
      items: const [
        BottomNavigationBarItem(
          label: "Ricks",
          icon: Icon(Icons.person),
        ),
        BottomNavigationBarItem(
          label: "Mortys",
          icon: Icon(Icons.location_city),
        ),
        BottomNavigationBarItem(
          label: "Random persons",
          icon: Icon(Icons.shape_line),
        ),
      ],
    );
  }
}

class DataTableWidget extends StatelessWidget {
  final List<Character> jsonObjects;

  DataTableWidget({required this.jsonObjects});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        child: DataTable(
          dataRowHeight: 150, // Mude o número para mudar o tamanho das linhas XD
          columns: const [
            DataColumn(
              label: Center(
                child: Text(
                  "Nome",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            DataColumn(
              label: Center(
                child: Text(
                  "Status",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            DataColumn(
              label: Center(
                child: Text(
                  "Espécie",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            DataColumn(
              label: Center(
                child: Text(
                  "Imagem",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
          rows: jsonObjects.map((character) {
            return DataRow(
              cells: [
                DataCell(
                  Center(
                    child: Text(
                      character.name,
                      style: TextStyle(
                        fontSize: 21,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Center(
                    child: Text(
                      character.status,
                      style: TextStyle(
                        fontSize: 21,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Center(
                    child: Text(
                      character.species,
                      style: TextStyle(
                        fontSize: 21,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Center(
                    child: Image.network(character.imageUrl),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

// essa parte do código vai para home.
// inicio da pagina de login:

//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.network(
//               'https://i0.wp.com/cloud.estacaonerd.com/wp-content/uploads/2018/05/10153353/RickAndMortyFeature.jpg?fit=1000%2C500&ssl=1', // URL da imagem desejada
//               fit: BoxFit.cover,
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Center(
//               child: LoginForm(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class LoginForm extends StatefulWidget {
//   @override
//   _LoginFormState createState() => _LoginFormState();
// }

// class _LoginFormState extends State<LoginForm> {
//   final _formKey = GlobalKey<FormState>();
//   String? _email;
//   String? _password;

//   void _submitForm() {
//     if (_formKey.currentState?.validate() == true) {
//       _formKey.currentState?.save();
//       if (_email == 'user@example.com' && _password == 'password') {
//         // Se as credenciais estiverem corretas, você pode prosseguir para a próxima tela ou executar a lógica desejada
//         // Exemplo: Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
//         print('Login bem-sucedido');
//       } else {
//         // Se as credenciais estiverem incorretas, você pode exibir uma mensagem de erro
//         print('Credenciais inválidas');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       constraints: BoxConstraints(
//           maxWidth: 400), // Definindo um tamanho máximo para o container
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(
//             10.0), // Define o formato arredondado do formulário
//       ),
//       padding: EdgeInsets.all(16.0),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           mainAxisSize:
//               MainAxisSize.min, // Reduz o espaço vertical ocupado pela coluna
//           children: [
//             TextFormField(
//               style: TextStyle(
//                   color: Colors.black), // Define a cor preta para o texto
//               decoration: InputDecoration(
//                 labelText: 'E-mail',
//                 labelStyle: TextStyle(
//                     color: Colors
//                         .black), // Define a cor preta para o texto do rótulo
//               ),
//               keyboardType: TextInputType.emailAddress,
//               validator: (value) {
//                 if (value?.isEmpty == true) {
//                   return 'Por favor, insira um e-mail válido';
//                 }
//                 return null;
//               },
//               onSaved: (value) {
//                 _email = value ?? '';
//               },
//             ),
//             TextFormField(
//               style: TextStyle(
//                   color: Colors.black), // Define a cor preta para o texto
//               decoration: InputDecoration(
//                 labelText: 'Senha',
//                 labelStyle: TextStyle(
//                     color: Colors
//                         .black), // Define a cor preta para o texto do rótulo
//               ),
//               obscureText: true,
//               validator: (value) {
//                 if (value?.isEmpty == true) {
//                   return 'Por favor, insira uma senha';
//                 }
//                 return null;
//               },
//               onSaved: (value) {
//                 _password = value;
//               },
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.green, // Define a cor para o botão "Entrar"
//               ),
//               onPressed: _submitForm,
//               child: Text(
//                 'Entrar',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
