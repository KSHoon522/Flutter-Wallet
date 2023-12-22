import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class SharedAxisScreen extends StatefulWidget {
  const SharedAxisScreen({super.key});

  @override
  State<SharedAxisScreen> createState() => _SharedAxisScreenState();
}

class _SharedAxisScreenState extends State<SharedAxisScreen> {
  int _currentImage = 1;

  void _goToImage(int newIamge) {
    setState(() {
      _currentImage = newIamge;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Shared Axis",
        ),
      ),
      body: Column(
        children: [
          PageTransitionSwitcher(
            duration: const Duration(seconds: 2),
            transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
                SharedAxisTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            ),
            child: Padding(
              key: ValueKey(_currentImage),
              padding: const EdgeInsets.all(8.0),
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset("assets/covers/$_currentImage.jpg"),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var btn in [1, 2, 3, 4, 5])
                ElevatedButton(
                  onPressed: () => _goToImage(btn),
                  child: Text("$btn"),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
