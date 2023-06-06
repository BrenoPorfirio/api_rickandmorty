import 'package:flutter/material.dart';
import 'package:api_rickandmorty/main.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rick And Morty API"),
      ),
      body: SingleChildScrollView(
        child: ValueListenableBuilder<List<Character>>(
          valueListenable: dataService.tableStateNotifier,
          builder: (_, value, __) {
            return DataTableWidget(jsonObjects: value);
          },
        ),
      ),
      bottomNavigationBar:
          NewNavBar(itemSelectedCallback: dataService.carregar),
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
