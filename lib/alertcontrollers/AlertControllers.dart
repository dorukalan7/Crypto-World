import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

void main() => runApp(alertcontrol());

class alertcontrol extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pinocchio Alerts',
      home: PinocchioAlertsScreen(),
    );
  }
}

class PinocchioAlertsScreen extends StatelessWidget {
  void showAlertWithNoButtons(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Just a Title'),
        content: Text('This is a subtitle, but no buttons below.'),
      ),
    );
  }

  void showAlertWithOneButton(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Single Action'),
        content: Text('This alert has one button.'),
        actions: [
          TextButton(
            onPressed: () {
              print('Pressed: OK');
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void showAlertWithTwoButtons(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Choose an Option'),
        content: Text('Do you want to continue or cancel?'),
        actions: [
          TextButton(
            onPressed: () {
              print('Pressed: Cancel');
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              print('Pressed: Continue');
              Navigator.pop(context);
            },
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }

  void showAlertWithTextField(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Input Needed'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Type something...'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              print('Entered: ${controller.text}');
              Navigator.pop(context);
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void showActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('Choose Option 1'),
            onTap: () {
              print('Selected: Option 1');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Choose Option 2'),
            onTap: () {
              print('Selected: Option 2');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Cancel'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void showActivityController(BuildContext context) {
    Share.share('Check out Pinocchio’s app from the Flutter Academy!');
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      {'title': 'No Button Alert', 'action': () => showAlertWithNoButtons(context)},
      {'title': 'One Button Alert', 'action': () => showAlertWithOneButton(context)},
      {'title': 'Two Buttons Alert', 'action': () => showAlertWithTwoButtons(context)},
      {'title': 'Text Field Alert', 'action': () => showAlertWithTextField(context)},
      {'title': 'Action Sheet', 'action': () => showActionSheet(context)},
      {'title': 'Activity Controller', 'action': () => showActivityController(context)},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Pinocchio\'s Alert Challenge 🧚‍♂️'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: buttons.length,
          separatorBuilder: (_, __) => SizedBox(height: 12),
          itemBuilder: (context, index) => ElevatedButton(
            onPressed: buttons[index]['action'] as VoidCallback,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: EdgeInsets.symmetric(vertical: 16),
              textStyle: TextStyle(fontSize: 16),
            ),
            child: Text(buttons[index]['title'].toString()),

          ),
        ),
      ),
    );
  }
}
