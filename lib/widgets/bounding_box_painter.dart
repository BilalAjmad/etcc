import 'dart:ui';
import 'package:flutter/material.dart';

import '../models/detection_result.dart';

class BoundingBoxPainter extends CustomPainter {
  final List<DetectedObject> detections;
  final bool isNightVision;

  BoundingBoxPainter({
    required this.detections,
    this.isNightVision = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var det in detections) {
      final rect = Rect.fromLTWH(
        det.boundingBox.left * size.width,
        det.boundingBox.top * size.height,
        det.boundingBox.width * size.width,
        det.boundingBox.height * size.height,
      );

      Color boxColor;
      switch (det.alertLevel) {
        case AlertLevel.danger:
          boxColor = Colors.redAccent;
          break;
        case AlertLevel.warning:
          boxColor = Colors.amberAccent;
          break;
        case AlertLevel.info:
          boxColor = isNightVision ? Colors.greenAccent : Colors.cyanAccent;
          break;
      }

      final paint = Paint()
        ..color = boxColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

      // Draw bounding box
      canvas.drawRect(rect, paint);

      // Draw corner accents for futuristic CCTV AI HUD look
      final cornerLength = 15.0;
      final cornerPaint = Paint()
        ..color = boxColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5.0;

      // Top-Left corner
      canvas.drawLine(rect.topLeft, rect.topLeft + Offset(cornerLength, 0), cornerPaint);
      canvas.drawLine(rect.topLeft, rect.topLeft + Offset(0, cornerLength), cornerPaint);

      // Top-Right corner
      canvas.drawLine(rect.topRight, rect.topRight + Offset(-cornerLength, 0), cornerPaint);
      canvas.drawLine(rect.topRight, rect.topRight + Offset(0, cornerLength), cornerPaint);

      // Bottom-Left corner
      canvas.drawLine(rect.bottomLeft, rect.bottomLeft + Offset(cornerLength, 0), cornerPaint);
      canvas.drawLine(rect.bottomLeft, rect.bottomLeft + Offset(0, -cornerLength), cornerPaint);

      // Bottom-Right corner
      canvas.drawLine(rect.bottomRight, rect.bottomRight + Offset(-cornerLength, 0), cornerPaint);
      canvas.drawLine(rect.bottomRight, rect.bottomRight + Offset(0, -cornerLength), cornerPaint);

      // Label background
      final labelText = '${det.label} ${(det.confidence * 100).toStringAsFixed(1)}%';
      final textSpan = TextSpan(
        text: labelText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.black54,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      double textX = rect.left;
      double textY = rect.top - 20;
      if (textY < 0) textY = rect.top + 5;

      textPainter.paint(canvas, Offset(textX, textY));
    }
  }

  @override
  bool shouldRepaint(covariant BoundingBoxPainter oldDelegate) {
    return oldDelegate.detections != detections || oldDelegate.isNightVision != isNightVision;
  }
}
