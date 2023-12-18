import 'dart:math';

import 'package:flutter/material.dart';

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({super.key});

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<SwipingCardsScreen>
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;
  late final AnimationController _position = AnimationController(
    value: 0.0,
    vsync: this,
    duration: const Duration(milliseconds: 800),
    lowerBound: (size.width + 100) * -1,
    upperBound: (size.width + 100),
  );

  late final Tween<double> _rotation = Tween(
    begin: -15,
    end: 15,
  );

  late final Tween<double> _scale = Tween(
    begin: 0.8,
    end: 1.0,
  );

  late final Tween<double> _buttonscale = Tween(
    begin: 1.0,
    end: 1.2,
  );
  late final ColorTween _closeColor = ColorTween(
    begin: Colors.white,
    end: Colors.red.shade300,
  );
  late final ColorTween _checkColor = ColorTween(
    begin: Colors.white,
    end: Colors.green.shade300,
  );

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _position.value += details.delta.dx;
  }

  void _whenComplete() {
    _position.value = 0;
    setState(
      () {
        _index = _index == 5 ? 1 : _index + 1;
      },
    );
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = size.width - 170;
    final dropZone = size.width + 100;
    if (_position.value.abs() >= bound) {
      final factor = _position.value.isNegative ? -1 : 1;
      _position
          .animateTo(dropZone * factor, curve: Curves.easeOut)
          .whenComplete(_whenComplete);
    } else {
      _position.animateTo(0, curve: Curves.easeOut);
    }
  }

  void _onClick({required bool forward}) {
    final dropZone = size.width + 100;
    final factor = forward ? 1 : -1;
    _position
        .animateTo(dropZone * factor, curve: Curves.easeOut)
        .whenComplete(_whenComplete);
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  int _index = 1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Swiping Cards'),
      ),
      body: AnimatedBuilder(
        animation: _position,
        builder: (context, child) {
          final angle = _rotation.transform(
                (_position.value + size.width / 2) / size.width,
              ) *
              pi /
              180;
          final scale =
              _scale.transform(_position.value.abs() / (size.width + 100));
          final buttonScale = min(
              _buttonscale
                  .transform(_position.value.abs() / (size.width + 100)),
              1.2);
          final bound = size.width - 170;
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 100,
                child: Transform.scale(
                  scale: min(scale, 1.0),
                  child: Card(
                    index: _index == 5 ? 1 : _index + 1,
                  ),
                ),
              ),
              Positioned(
                top: 100,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Transform.translate(
                    offset: Offset(_position.value, 0),
                    child: Transform.rotate(
                      angle: angle,
                      child: Card(
                        index: _index,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 100,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _onClick(forward: false),
                      child: Transform.scale(
                        scale: _position.value.isNegative ? buttonScale : 1.0,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 5,
                            ),
                            borderRadius: BorderRadius.circular(100),
                            color: _position.value.isNegative
                                ? _closeColor.transform(
                                    _position.value.abs() / (size.width + 100))
                                : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                blurRadius: 4.0,
                                spreadRadius: 0.0,
                                offset: const Offset(0, 5.0),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: _position.value.isNegative &&
                                    _position.value.abs() > bound
                                ? Colors.white
                                : Colors.red,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () => _onClick(forward: true),
                      child: Transform.scale(
                        scale: !_position.value.isNegative ? buttonScale : 1.0,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 5,
                            ),
                            borderRadius: BorderRadius.circular(100),
                            color: !_position.value.isNegative
                                ? _checkColor.transform(
                                    _position.value.abs() / (size.width + 100))
                                : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                blurRadius: 4.0,
                                spreadRadius: 0.0,
                                offset: const Offset(0, 5.0),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            color: !_position.value.isNegative &&
                                    _position.value.abs() > bound
                                ? Colors.white
                                : Colors.green,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Card extends StatelessWidget {
  final int index;
  const Card({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.5,
        child: Image.asset(
          "assets/covers/$index.jpg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
