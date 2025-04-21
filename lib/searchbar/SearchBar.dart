import 'package:flutter/material.dart';

void main() {
  runApp(searchbar());
}

class searchbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Searchable DataTable',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class Person {
  final String name;
  final String surname;
  final String team;
  final int age;

  Person({required this.name, required this.surname, required this.team, required this.age});
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchCriteria = 'name';
  TextEditingController searchController = TextEditingController();

  List<Person> people = [
    Person(name: 'Mini', surname: 'Mouse', team: 'Flutter', age: 25),
    Person(name: 'Mickey', surname: 'Mouse', team: 'Flutter', age: 30),
    Person(name: 'Donald', surname: 'Duck', team: 'Android', age: 35),
    Person(name: 'Daisy', surname: 'Duck', team: 'iOS', age: 28),
  ];

  List<Person> filteredPeople = [];

  @override
  void initState() {
    super.initState();
    filteredPeople = people;
  }

  void filterPeople(String query) {
    List<Person> results = [];
    if (query.isEmpty) {
      results = people;
    } else {
      results = people.where((person) {
        if (searchCriteria == 'name') {
          return person.name.toLowerCase().contains(query.toLowerCase());
        } else {
          return person.surname.toLowerCase().contains(query.toLowerCase());
        }
      }).toList();
    }
    setState(() {
      filteredPeople = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Searchable DataTable'),
        actions: [
          DropdownButton<String>(
            value: searchCriteria,
            onChanged: (value) {
              setState(() {
                searchCriteria = value!;
              });
              filterPeople(searchController.text);
            },
            items: [
              DropdownMenuItem(value: 'name', child: Text('Search by Name')),
              DropdownMenuItem(value: 'surname', child: Text('Search by Surname')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: filterPeople,
              decoration: InputDecoration(
                labelText: 'Search',
                labelStyle: TextStyle(fontSize: 20),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Horizontal scrolling
                child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 50.0,
                  columns: const <DataColumn>[
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Surname')),
                    DataColumn(label: Text('Team')),
                    DataColumn(label: Text('Age')),
                  ],
                  rows: filteredPeople.map((person) {
                    return DataRow(
                      cells: [
                        DataCell(Text(person.name, style: TextStyle(fontSize: 18))),
                        DataCell(Text(person.surname, style: TextStyle(fontSize: 18))),
                        DataCell(Text(person.team, style: TextStyle(fontSize: 18))),
                        DataCell(Text(person.age.toString(), style: TextStyle(fontSize: 18))),
                      ],
                    );
                  }).toList(),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
