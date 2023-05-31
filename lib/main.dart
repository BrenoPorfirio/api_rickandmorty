import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataService{
  final ValueNotifier<List> tableStateNotifier = new ValueNotifier([]);
  void carregar(index){
    final funcoes = [];
    funcoes[index]();
  }

  // void (){
  //   return;
  // }

  // void (){
  //   return;
  // }

  Future<void> () async{
    var beersUri = Uri(
      scheme: 'https',
      host: '',
      path: '',
      queryParameters: {'size': '1'});
    var jsonString = await http.read(beersUri);
    var beersJson = jsonDecode(jsonString);
    tableStateNotifier.value = beersJson;
  }
}

final dataService = DataService();

void main() {
  MyApp app = MyApp();
  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green),
      debugShowCheckedModeBanner:false,
      home: Scaffold(
        appBar: AppBar( 
          title: const Text("Rick and Morty Characters"),
          ),
        body: ValueListenableBuilder(
          valueListenable: dataService.tableStateNotifier,
          builder:(_, value, __){
            return DataTableWidget(
              jsonObjects:value, 
              // propertyNames: ["name","status","species"], 
              // columnNames: ["Nome", "Status", "Espécie"]
            );
          }
        ),
        bottomNavigationBar: NewNavBar(itemSelectedCallback: dataService.carregar),
      ));
  }
}

class NewNavBar extends HookWidget {
  final _itemSelectedCallback;
  NewNavBar({itemSelectedCallback}):
    _itemSelectedCallback = itemSelectedCallback ?? (int){}
  @override
  Widget build(BuildContext context) {
    var state = useState(1);
    return BottomNavigationBar(
      onTap: (index){
        state.value = index;
        _itemSelectedCallback(index);                
      }, 
      currentIndex: state.value,
      items: const [
        BottomNavigationBarItem(
          label: "Ricks",
          icon: Icon(Icons.person),
        ),
        BottomNavigationBarItem(
            label: "Mortys", icon: Icon(Icons.location_city)),
        BottomNavigationBarItem(
          label: "Random persons", icon: Icon(Icons.shape_line))
      ]);
  }
}

class DataTableWidget extends StatelessWidget {
  final List jsonObjects;
  final List<String> columnNames;
  final List<String> propertyNames;

  DataTableWidget( {this.jsonObjects = const [], this.columnNames = const ["","",""], this.propertyNames= const ["", "", ""]});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: columnNames.map( 
                (name) => DataColumn(
                  label: Expanded(
                    child: Text(name, style: TextStyle(fontStyle: FontStyle.italic))
                  )
                )
              ).toList()       
      ,
      rows: jsonObjects.map( 
        (obj) => DataRow(
            cells: propertyNames.map(
              (propName) => DataCell(Text(obj[propName]))
            ).toList()
          )
        ).toList());
  }
}
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
