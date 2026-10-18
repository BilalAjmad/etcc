import 'package:flutter_test/flutter_test.dart';
import 'package:smart_ai_cctv/main.dart';
import 'package:smart_ai_cctv/services/ai_vision_engine.dart';

void main() {
  testWidgets('Smart AI CCTV app loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartCctvApp());
    expect(find.text('AI CCTV LIVE STREAM'), findsOneWidget);
  });

  test('AiVisionEngine generates frame processing results correctly', () {
    final engine = AiVisionEngine();
    final detections = engine.processFrame(imageWidth: 640, imageHeight: 480);
    expect(detections, isA<List>());
  });
}
