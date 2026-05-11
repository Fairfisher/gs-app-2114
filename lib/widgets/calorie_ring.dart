import 'package:flutter/material.dart';
import 'dart:math' as math;

class CalorieRing extends StatelessWidget {
  final int consumed;
  final int burned;
  final int goal;

  const CalorieRing({
    super.key,
    required this.consumed,
    required this.burned,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final net = consumed - burned;
    final progress = goal > 0 ? (net / goal).clamp(0.0, 1.0) : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(200, 200),
                    painter: RingPainter(progress: progress),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        net.toString(),
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Text(
                        'of $goal kcal',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4A90E2),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text('Consumed'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$consumed kcal',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF9800),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text('Burned'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$burned kcal',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RingPainter extends CustomPainter {
  final double progress;

  const RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;
    const strokeWidth = 20.0;

    final backgroundPaint = Paint()
      ..color = const Color(0xFF242424)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = const Color(0xFF4A90E2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant RingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
