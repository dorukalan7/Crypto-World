import 'package:flutter/material.dart';

void main() {
  runApp(flexible());
}

class flexible extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinSmart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FinSmart'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Welcome message and logo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Welcome to FinSmart!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.account_balance_wallet, size: 40),
              ],
            ),
            SizedBox(height: 20),

            // 2. Account summary
            Text(
              'Account Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Checking Account: \$2000.00'),
                    SizedBox(height: 10),
                    Text('Savings Account: \$5000.00'),
                    SizedBox(height: 10),
                    Text('Investment Portfolio: \$12000.00'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // 3. Flexible Row with buttons
            Row(
              children: [
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Add Expense'),
                  ),
                ),
                SizedBox(width: 1),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Transfer Funds'),
                  ),
                ),SizedBox(width: 1),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Transfer Funds'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
