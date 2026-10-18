import 'dart:ui';

enum AlertLevel { info, warning, danger }

class DetectedObject {
  final String id;
  final String label;
  final double confidence; // 0.0 to 1.0
  final Rect boundingBox; // Normalized coordinates 0.0 to 1.0
  final DateTime timestamp;
  final AlertLevel alertLevel;

  DetectedObject({
    required this.id,
    required this.label,
    required this.confidence,
    required this.boundingBox,
    required this.timestamp,
    required this.alertLevel,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'confidence': confidence,
        'rect': [boundingBox.left, boundingBox.top, boundingBox.width, boundingBox.height],
        'timestamp': timestamp.toIso8601String(),
        'alertLevel': alertLevel.name,
      };
}
