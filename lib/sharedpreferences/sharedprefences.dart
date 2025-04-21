import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(sharedpreferences());
}

class sharedpreferences extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dream Trip Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _visitCountController = TextEditingController();
  bool _hasVisited = false;
  int _visitCount = 0;
  String _placeName = '';

  @override
  void initState() {
    super.initState();
    _loadData(); // Başlangıçta veriyi yükle
  }

  // SharedPreferences'tan veriyi yükleme
  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _hasVisited = prefs.getBool('hasVisited') ?? false;
      _visitCount = prefs.getInt('visitCount') ?? 0;
      _placeName = prefs.getString('placeName') ?? '';
    });
  }

  // Veriyi SharedPreferences'a kaydetme
  _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasVisited', _hasVisited);
    prefs.setInt('visitCount', int.tryParse(_visitCountController.text) ?? 0);
    prefs.setString('placeName', _placeController.text);
    _loadData(); // Veriyi kaydettikten sonra tekrar yükle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dream Trip Planner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plan your dream trip!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _placeController,
              decoration: InputDecoration(
                labelText: 'Enter the place you want to visit',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _visitCountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'How many times have you visited this place?',
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Have you been here before?'),
                Switch(
                  value: _hasVisited,
                  onChanged: (value) {
                    setState(() {
                      _hasVisited = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _saveData,
                  child: Text('Save Information'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _loadData,
                  child: Text('Load Information'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Saved Information:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Place Name: $_placeName'),
            Text('Visited Before: ${_hasVisited ? "Yes" : "No"}'),
            Text('Visit Count: $_visitCount'),
          ],
        ),
      ),
    );
  }
}
