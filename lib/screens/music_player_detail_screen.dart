import 'package:flutter/material.dart';

class MusicPlayerDetailScreen extends StatefulWidget {
  final int index;
  const MusicPlayerDetailScreen({
    super.key,
    required this.index,
  });

  @override
  State<MusicPlayerDetailScreen> createState() =>
      _MusicPlayerDetailScreenState();
}

class _MusicPlayerDetailScreenState extends State<MusicPlayerDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressController = AnimationController(
    vsync: this,
    duration: Duration(seconds: _defaultPlayDuration),
  )..repeat(reverse: true);

  final _defaultPlayDuration = 120;

  List<String> _timeFormmater(int progressTime) {
    final remainTimes = _defaultPlayDuration - progressTime;

    final minutes = (progressTime ~/ 60).toString().padLeft(2, "0");
    final seconds = (progressTime % 60).toString().padLeft(2, "0");

    final reaminMinutes = (remainTimes ~/ 60).toString().padLeft(2, "0");
    final remainSeconds = (remainTimes % 60).toString().padLeft(2, "0");

    return ["$minutes:$seconds", "$reaminMinutes:$remainSeconds"];
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('InterStellar'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.center,
            child: Hero(
              tag: "${widget.index}",
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/covers/${widget.index}.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return CustomPaint(
                painter: ProgressBar(
                  progressValue: _progressController.value,
                ),
                size: Size(size.width - 80, 5),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
              child: AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  final progressTime =
                      (_progressController.value * _defaultPlayDuration)
                          .round();
                  final time = _timeFormmater(progressTime);
                  return Row(
                    children: [
                      Text(
                        time[0],
                      ),
                      const Spacer(),
                      Text(
                        time[1],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "InterStellar",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            "A Film by Christopher Nolan - Original Motion Picture Stoundtrack",
            maxLines: 1,
            style: TextStyle(
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }
}

class ProgressBar extends CustomPainter {
  final double progressValue;

  ProgressBar({
    required this.progressValue,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final progress = size.width * progressValue;

    //track bar
    final trackPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;
    final trackRRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(trackRRect, trackPaint);
    //progress bar
    final progressPaint = Paint()
      ..color = Colors.grey.shade500
      ..style = PaintingStyle.fill;
    final progressRRect = RRect.fromLTRBR(
      0,
      0,
      progress,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(progressRRect, progressPaint);

    //thumb
    canvas.drawCircle(Offset(progress, size.height / 2), 7, progressPaint);
  }

  @override
  bool shouldRepaint(covariant ProgressBar oldDelegate) {
    return oldDelegate.progressValue != progressValue;
  }
}