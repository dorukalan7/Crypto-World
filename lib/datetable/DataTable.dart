import 'package:flutter/material.dart';

void main() {
  runApp(datatable());
}

class datatable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Titanic Passengers',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/passengerDetails': (context) => PassengerDetailsScreen(),
      },
    );
  }
}

class Passenger {
  final String name;
  final String surname;
  final String team;
  final int age;
  final String hometown;
  final String mail;

  Passenger({
    required this.name,
    required this.surname,
    required this.team,
    required this.age,
    required this.hometown,
    required this.mail,
  });
}

class HomePage extends StatelessWidget {
  final List<Passenger> passengers = [
    Passenger(
        name: "John",
        surname: "Doe",
        team: "Flutter Team",
        age: 30,
        hometown: "New York",
        mail: "john.doe@example.com"),
    Passenger(
        name: "Jane",
        surname: "Smith",
        team: "iOS Team",
        age: 25,
        hometown: "Los Angeles",
        mail: "jane.smith@example.com"),
    Passenger(
        name: "Michael",
        surname: "Johnson",
        team: "Android Team",
        age: 28,
        hometown: "Chicago",
        mail: "michael.johnson@example.com"),
    Passenger(
        name: "Emily",
        surname: "Davis",
        team: "Design Team",
        age: 22,
        hometown: "San Francisco",
        mail: "emily.davis@example.com"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Titanic Passengers'),
      ),
      body: SingleChildScrollView(
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Surname')),
            DataColumn(label: Text('Team')),
            DataColumn(label: Text('Age')),
          ],
          rows: passengers
              .map((passenger) => DataRow(
            cells: [
              DataCell(Text(passenger.name)),
              DataCell(Text(passenger.surname)),
              DataCell(Text(passenger.team)),
              DataCell(Text(passenger.age.toString())),
            ],
            onSelectChanged: (_) {
              Navigator.pushNamed(
                context,
                '/passengerDetails',
                arguments: passenger,
              );
            },
          ))
              .toList(),
        ),
      ),
    );
  }
}

class PassengerDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Passenger passenger =
    ModalRoute.of(context)!.settings.arguments as Passenger;

    return Scaffold(
      appBar: AppBar(
        title: Text('Passenger Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${passenger.name} ${passenger.surname}',
                style: TextStyle(fontSize: 20)),
            Text('Team: ${passenger.team}', style: TextStyle(fontSize: 20)),
            Text('Age: ${passenger.age}', style: TextStyle(fontSize: 20)),
            Text('Hometown: ${passenger.hometown}',
                style: TextStyle(fontSize: 20)),
            Text('Mail: ${passenger.mail}', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
