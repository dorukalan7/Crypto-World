import 'package:flutter/material.dart';

class MazePage extends StatefulWidget {
  const MazePage({Key? key}) : super(key: key);

  @override
  State<MazePage> createState() => _MazePageState();
}

class _MazePageState extends State<MazePage> with TickerProviderStateMixin {
  final List<String> correctPath = ['up', 'right', 'right', 'down', 'left', 'up', 'left'];
  final List<String> userPath = [];

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<Offset> _zoomSlideAnimation;
  late Animation<Offset> _pushAnimation;
  late Animation<double> _coverAnimation;

  late Animation<Offset> _currentAnimation;

  @override
  void initState() {
    super.initState();
    // AnimationController ve animasyonlar
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1), // Slide upwards for 'up'
    ).animate(_animationController);

    _zoomSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1, 0), // Slide right for 'right'
    ).animate(_animationController);

    _pushAnimation = Tween<Offset>(
      begin: Offset(1, 0), // Slide left for 'left'
      end: Offset.zero,
    ).animate(_animationController);

    _coverAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _currentAnimation = _slideAnimation; // Default animation is for 'up'
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void handleMove(String direction) {
    setState(() {
      userPath.add(direction);

      bool isCorrect = true;
      for (int i = 0; i < userPath.length; i++) {
        if (i >= correctPath.length || userPath[i] != correctPath[i]) {
          isCorrect = false;
          break;
        }
      }

      if (!isCorrect) {
        Navigator.pushReplacementNamed(context, '/trapped');
      } else if (userPath.length == correctPath.length) {
        Navigator.pushReplacementNamed(context, '/success');
      }
    });

    // Apply animations based on direction
    if (direction == 'up') {
      _currentAnimation = _slideAnimation; // Slide upwards
    } else if (direction == 'right') {
      _currentAnimation = _zoomSlideAnimation; // Zoom slide right
    } else if (direction == 'left') {
      _currentAnimation = _pushAnimation; // Push left
    } else if (direction == 'down') {
      _currentAnimation = _coverAnimation as Animation<Offset>; // Cover transition (use different widget if needed)
    }

    // Start the animation
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("The Maze")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Use the arrows to navigate the maze"),
          const SizedBox(height: 30),
          Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return SlideTransition(
                  position: _currentAnimation, // Use the current animation based on the direction
                  child: child,
                );
              },
              child: Image.asset(
                "assets/images/hero.png",
                width: 250,
                height: 250,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  handleMove('up');
                },
                child: const Icon(Icons.arrow_upward),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  handleMove('left');
                },
                child: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  handleMove('down');
                },
                child: const Icon(Icons.arrow_downward),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  handleMove('right');
                },
                child: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
