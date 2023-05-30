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