import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:api_rickandmorty/main.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "API RICK AND MORTY",
          style: TextStyle(fontFamily: 'Schwifty', fontSize: 30),
        ),
      ),
      body: ValueListenableBuilder<List<Character>>(
        valueListenable: dataService.tableStateNotifier,
        builder: (_, value, __) {
          return DataTableWidget(jsonObjects: value);
        },
      ),
      bottomNavigationBar: NewNavBar(
        itemSelectedCallback: (index) => dataService.carregar(index, context),
      ),
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
            image: NetworkImage('https://i.redd.it/uy470gozpt2b1.jpg'),
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

                            // Verifica o formato do email usando uma expressão regular
                            final emailRegex = RegExp(
                                r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Por favor, digite um e-mail válido';
                            }

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

                            // Verifica se a senha tem no mínimo 6 caracteres
                            if (value.length < 6) {
                              return 'A senha deve ter no mínimo 6 caracteres';
                            }

                            // Adicione outras validações adicionais, se necessário

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
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      unselectedItemColor: isDarkMode ? Colors.lightGreen : Colors.green[900], // verde claro para o tema escuro, verde escuro para o tema claro
      selectedItemColor: isDarkMode ? Colors.white : Colors.white, // verde claro para o tema escuro, verde escuro para o tema claro
      onTap: (index) {
        state.value = index;
        itemSelectedCallback(index);
      },
      currentIndex: state.value,
      items: const [
        BottomNavigationBarItem(
          label: "Pesquisa",
          icon: Icon(Icons.search),
        ),
        BottomNavigationBarItem(
          label: "Personagens",
          icon: Icon(Icons.person_4),
        ),
        BottomNavigationBarItem(
          label: "Random persons",
          icon: Icon(Icons.book),
        ),
      ],
    );
  }
}
