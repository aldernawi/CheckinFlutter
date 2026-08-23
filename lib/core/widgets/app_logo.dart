import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 80,
    this.borderRadius = 18,
  });

  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFDC2626),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDC2626).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CustomPaint(
        size: Size(size, size),
        painter: _LogoPainter(),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final whitePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.95)
      ..style = PaintingStyle.fill;

    final redPaint = Paint()
      ..color = const Color(0xFFDC2626)
      ..style = PaintingStyle.fill;

    final whiteStrokePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.047
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Location pin - positioned in upper portion
    final pinCenterX = size.width * 0.5;
    final pinCenterY = size.height * 0.27;
    final pinRadius = size.width * 0.156;

    // Pin body (teardrop shape)
    final pinPath = Path();
    pinPath.moveTo(pinCenterX, pinCenterY - pinRadius);
    // Top arc
    pinPath.arcToPoint(
      Offset(pinCenterX + pinRadius, pinCenterY),
      radius: Radius.circular(pinRadius),
      clockwise: true,
      largeArc: true,
    );
    // Bottom curve to tip
    pinPath.quadraticBezierTo(
      pinCenterX, pinCenterY + pinRadius * 1.5,
      pinCenterX - pinRadius, pinCenterY,
    );
    // Top arc back
    pinPath.arcToPoint(
      Offset(pinCenterX, pinCenterY - pinRadius),
      radius: Radius.circular(pinRadius),
      clockwise: true,
      largeArc: false,
    );
    pinPath.close();
    canvas.drawPath(pinPath, whitePaint);

    // Inner red circle
    canvas.drawCircle(
      Offset(pinCenterX, pinCenterY),
      size.width * 0.055,
      redPaint,
    );

    // Check mark - positioned in lower portion
    final checkPath = Path();
    final checkCenterX = size.width * 0.5;
    final checkCenterY = size.height * 0.66;
    final checkSize = size.width * 0.098;

    checkPath.moveTo(checkCenterX - checkSize, checkCenterY - checkSize * 0.2);
    checkPath.lineTo(checkCenterX - checkSize * 0.4, checkCenterY + checkSize * 0.4);
    checkPath.lineTo(checkCenterX + checkSize, checkCenterY - checkSize);

    canvas.drawPath(checkPath, whiteStrokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
