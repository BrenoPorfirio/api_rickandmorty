import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:api_rickandmorty/main.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API RICK AND MORTY"),
      ),
      body: ValueListenableBuilder<List<Character>>(
        valueListenable: dataService.tableStateNotifier,
        builder: (_, value, __) {
          return DataTableWidget(jsonObjects: value);
        },
      ),
      bottomNavigationBar:
          NewNavBar(itemSelectedCallback: dataService.carregar),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://storage.stwonline.com.br/180graus/uploads/ckeditor/pictures/1723520/1-jrahv0lusxhrmy5tzeswiq.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Container(
                  width: 300.0, // Defina a largura desejada aqui
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, digite um e-mail válido';
                            }
                            // Adicione validações adicionais, se necessário
                            return null;
                          },
                          onSaved: (value) {
                            _email = value;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Senha',
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, digite uma senha válida';
                            }
                            // Adicione validações adicionais, se necessário
                            return null;
                          },
                          onSaved: (value) {
                            _password = value;
                          },
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              // Faça a lógica de autenticação aqui
                              // Se o login for bem-sucedido, navegue para a tela principal
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Home(),
                                ),
                              );
                            }
                          },
                          child: Text('Entrar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
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
          label: "Pesquisa",
          icon: Icon(Icons.person),
        ),
        BottomNavigationBarItem(
          label: "Personagens",
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
