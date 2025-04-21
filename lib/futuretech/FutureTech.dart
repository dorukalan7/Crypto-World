import 'package:flutter/material.dart';

void main() {
  runApp(FutureTechApp());
}

class FutureTechApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatelessWidget {
  final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FutureTech'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Bugünün tarihi: ${now.day}/${now.month}/${now.year}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            DeviceCard(
              deviceName: 'Akıllı Işık',
              imagePath: 'https://img.icons8.com/fluency/96/light-on.png',
              status: true,
            ),
            SizedBox(height: 16),
            DeviceCard(
              deviceName: 'Klima',
              imagePath: 'https://img.icons8.com/fluency/96/air-conditioner.png',
              status: false,
            ),
          ],
        ),
      ),
    );
  }
}

class DeviceCard extends StatefulWidget {
  final String deviceName;
  final String imagePath;
  final bool status;

  const DeviceCard({
    required this.deviceName,
    required this.imagePath,
    required this.status,
  });

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  late bool deviceStatus;

  @override
  void initState() {
    super.initState();
    deviceStatus = widget.status;
  }

  void toggleStatus() {
    setState(() {
      deviceStatus = !deviceStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
      ),
      child: Row(
        children: [
          Image.network(widget.imagePath, width: 64, height: 64),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.deviceName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, )),
                Text('Durum: ${deviceStatus ? "Açık" : "Kapalı"}'),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: toggleStatus,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            child: Text(deviceStatus ? 'Kapat' : 'Aç',style: TextStyle(color: Colors.white),

          ),
          ),],
      ),
    );
  }
}
