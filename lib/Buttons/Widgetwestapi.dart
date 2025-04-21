import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(buttons());

class buttons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WildWestHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WildWestHome extends StatefulWidget {
  @override
  _WildWestHomeState createState() => _WildWestHomeState();
}

class _WildWestHomeState extends State<WildWestHome> with SingleTickerProviderStateMixin {
  bool showOptions = false;
  bool isBlacksmithHere = false;
  bool robberyInProgress = false;
  bool showSpecials = false;
  Color vigilanteColor = Colors.grey;
  late AnimationController _controller;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSound() async {
    await _audioPlayer.play(AssetSource('vault_shake.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Wild West Button Challenge")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Task 1: Dropdown Button with Actions
            Text("Sheriff Options"),
            ElevatedButton(
              onPressed: () => setState(() => showOptions = !showOptions),
              child: Text("Sheriff Panel"),
            ),
            if (showOptions) ...[
              ElevatedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Backup Called!"))),
                child: Text("Call for Backup"),
              ),
              ElevatedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Warning Issued!"))),
                child: Text("Issue Warning"),
              ),
            ],

            Divider(height: 32),

            // Task 2: Saloon Special Button
            Text("Saloon Specials"),
            GestureDetector(
              onTap: () => setState(() => showSpecials = !showSpecials),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.red.shade700, Colors.red.shade200], stops: [0.5, 1.0]),
                  image: DecorationImage(
                    image: AssetImage('assets/saloon_bg.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.red.withOpacity(0.6), BlendMode.dstATop),
                  ),
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(2, 4)),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Show Daily Specials",
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            if (showSpecials)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Today's Specials: Whiskey, Stew, and Poker Night!", style: TextStyle(fontSize: 16)),
              ),

            Divider(height: 32),

            // Task 3: Vigilante Button
            Text("Vigilante Alert"),
            GestureDetector(
              onTapDown: (_) => setState(() => vigilanteColor = Colors.yellow),
              onTapUp: (_) => setState(() => vigilanteColor = Colors.grey),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: vigilanteColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shield, color: Colors.purple),
                    SizedBox(width: 8),
                    Text("Vigilante Action")
                  ],
                ),
              ),
            ),

            Divider(height: 32),

            // Task 4: Blacksmith Button
            Text("Blacksmith Workshop"),
            ElevatedButton(
              onPressed: () => setState(() => isBlacksmithHere = !isBlacksmithHere),
              child: Text(isBlacksmithHere ? "Blacksmith Left" : "Blacksmith Arrived"),
            ),
            ElevatedButton(
              onPressed: isBlacksmithHere ? () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hammer Strike!"))) : null,
              child: Text("Forge Weapon"),
            ),

            Divider(height: 32),

            // Task 5: Bank Robber Button
            Text("Bank Robbery"),
            GestureDetector(
              onTap: () {
                setState(() => robberyInProgress = true);
                _controller.forward(from: 0);
                _playSound();
                Future.delayed(Duration(seconds: 1), () {
                  setState(() => robberyInProgress = false);
                });
              },
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double offset = (1 - _controller.value) * 10;
                  return Transform.translate(
                    offset: Offset(offset, 0),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.lock_open, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            robberyInProgress ? "Breaking In..." : "Rob the Bank",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}