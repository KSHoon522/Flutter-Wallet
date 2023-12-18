import 'dart:math';

import 'package:flutter/material.dart';

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({super.key});

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..forward();

  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _animationController,
    curve: Curves.bounceOut,
  );

  late Animation<double> _redprogress = Tween(
    begin: 0.005,
    end: Random().nextDouble() * 2.0,
  ).animate(_curve);
  late Animation<double> _greenprogress = Tween(
    begin: 0.005,
    end: Random().nextDouble() * 2.0,
  ).animate(_curve);
  late Animation<double> _blueprogress = Tween(
    begin: 0.005,
    end: Random().nextDouble() * 2.0,
  ).animate(_curve);

  void _animateValues() {
    setState(() {
      _redprogress = Tween(
        begin: _redprogress.value,
        end: Random().nextDouble() * 2.0,
      ).animate(_curve);
      _greenprogress = Tween(
        begin: _greenprogress.value,
        end: Random().nextDouble() * 2.0,
      ).animate(_curve);
      _blueprogress = Tween(
        begin: _blueprogress.value,
        end: Random().nextDouble() * 2.0,
      ).animate(_curve);
    });
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Apple Watch"),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return CustomPaint(
              painter: AppleWatchPainter(
                  redprogress: _redprogress.value,
                  greenprogress: _greenprogress.value,
                  blueprogress: _blueprogress.value),
              size: const Size(400, 400),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _animateValues,
        child: const Icon(
          Icons.refresh,
        ),
      ),
    );
  }
}

class AppleWatchPainter extends CustomPainter {
  final double redprogress;
  final double greenprogress;
  final double blueprogress;

  AppleWatchPainter({
    required this.redprogress,
    required this.greenprogress,
    required this.blueprogress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );
    const startAngle = -0.5 * pi;

    //draw red

    final redCirclePaint = Paint()
      ..color = Colors.red.shade300.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    final redCircleRadius = (size.width / 2) * 0.9;
    canvas.drawCircle(
      center,
      redCircleRadius,
      redCirclePaint,
    );

    //draw green
    final greenCirclePaint = Paint()
      ..color = Colors.green.shade300.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;
    canvas.drawCircle(
      center,
      (size.width / 2) * 0.76,
      greenCirclePaint,
    );
    //draw blue
    final blueCirclePaint = Paint()
      ..color = Colors.blue.shade300.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;
    canvas.drawCircle(
      center,
      (size.width / 2) * 0.62,
      blueCirclePaint,
    );

    //red arc

    final redArcRect = Rect.fromCircle(
      center: center,
      radius: (size.width / 2) * 0.9,
    );
    final redArcPaint = Paint()
      ..color = Colors.red.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;
    canvas.drawArc(
      redArcRect,
      startAngle,
      redprogress * pi,
      false,
      redArcPaint,
    );
    //green arc

    final greenArcRect = Rect.fromCircle(
      center: center,
      radius: (size.width / 2) * 0.76,
    );
    final greenArcPaint = Paint()
      ..color = Colors.green.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;
    canvas.drawArc(
      greenArcRect,
      startAngle,
      greenprogress * pi,
      false,
      greenArcPaint,
    );
    //blue arc

    final blueArcRect = Rect.fromCircle(
      center: center,
      radius: (size.width / 2) * 0.62,
    );
    final blueArcPaint = Paint()
      ..color = Colors.cyan.shade400
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 25;
    canvas.drawArc(
      blueArcRect,
      startAngle,
      blueprogress * pi,
      false,
      blueArcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant AppleWatchPainter oldDelegate) {
    return oldDelegate.redprogress != redprogress ||
        oldDelegate.greenprogress != greenprogress ||
        oldDelegate.blueprogress != blueprogress;
  }
}
