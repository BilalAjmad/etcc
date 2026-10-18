import 'dart:async';
import 'package:flutter/material.dart';

import '../models/detection_result.dart';
import '../services/ai_vision_engine.dart';
import '../widgets/bounding_box_painter.dart';

class LiveCctvScreen extends StatefulWidget {
  final AiVisionEngine aiEngine;

  const LiveCctvScreen({super.key, required this.aiEngine});

  @override
  State<LiveCctvScreen> createState() => _LiveCctvScreenState();
}

class _LiveCctvScreenState extends State<LiveCctvScreen> {
  List<DetectedObject> _currentDetections = [];
  Timer? _processingTimer;
  bool _isStreaming = true;
  int _fpsCounter = 0;
  int _displayFps = 30;
  Timer? _fpsTimer;

  @override
  void initState() {
    super.initState();
    _startAiCameraLoop();
    _fpsTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _displayFps = _fpsCounter;
          _fpsCounter = 0;
        });
      }
    });
  }

  void _startAiCameraLoop() {
    _processingTimer?.cancel();
    _processingTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isStreaming && mounted) {
        final detections = widget.aiEngine.processFrame(
          imageWidth: 640,
          imageHeight: 480,
          motionIntensity: 0.25,
        );
        setState(() {
          _currentDetections = detections;
          _fpsCounter += 10;
        });
      }
    });
  }

  @override
  void dispose() {
    _processingTimer?.cancel();
    _fpsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNightVision = widget.aiEngine.enableNightVisionFilter;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.videocam_rounded, color: Colors.redAccent),
            SizedBox(width: 8),
            Text(
              'AI CCTV LIVE STREAM',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
          ],
        ),
        backgroundColor: Colors.grey[900],
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.redAccent),
            ),
            child: Row(
              children: [
                const Icon(Icons.circle, color: Colors.red, size: 10),
                const SizedBox(width: 6),
                Text(
                  '100% LOCAL • $_displayFps FPS',
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 100% Offline / Local Camera Feed Viewport
          Expanded(
            child: Stack(
              children: [
                // Pure Local Shader / Vector Background - Zero Network Requests / No API Keys
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isNightVision
                          ? [const Color(0xFF002200), const Color(0xFF001100)]
                          : [const Color(0xFF141E30), const Color(0xFF243B55)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_indoor,
                          size: 90,
                          color: isNightVision ? Colors.green.withOpacity(0.3) : Colors.white10,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'LOCAL EDGE AI SURVEILLANCE FEED',
                          style: TextStyle(
                            color: isNightVision ? Colors.greenAccent.withOpacity(0.4) : Colors.white24,
                            fontSize: 12,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bounding box AI Recognition layer
                CustomPaint(
                  size: Size.infinite,
                  painter: BoundingBoxPainter(
                    detections: _currentDetections,
                    isNightVision: isNightVision,
                  ),
                ),

                // HUD Overlay (Date, AI Status, Active detections count, Offline Badge)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DATE: 15/10/2026',
                          style: TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const Text(
                          'MODE: 100% OFFLINE EDGE AI',
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                        Text(
                          'MODEL: ${widget.aiEngine.mode.name.toUpperCase()}',
                          style: const TextStyle(
                            color: Colors.lightGreenAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                        Text(
                          'DETECTIONS: ${_currentDetections.length}',
                          style: TextStyle(
                            color: _currentDetections.isNotEmpty ? Colors.amber : Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Alarm indicator badge if high alert detected
                if (_currentDetections.any((d) => d.alertLevel == AlertLevel.danger))
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(color: Colors.red, blurRadius: 10, spreadRadius: 2),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 6),
                          Text(
                            'INTRUDER ALERT',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Control Toolbar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: Colors.grey[900],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  tooltip: _isStreaming ? 'Pause Camera' : 'Start Camera',
                  icon: Icon(
                    _isStreaming ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    color: Colors.cyanAccent,
                    size: 36,
                  ),
                  onPressed: () {
                    setState(() {
                      _isStreaming = !_isStreaming;
                    });
                  },
                ),
                IconButton(
                  tooltip: 'Night Vision Filter',
                  icon: Icon(
                    Icons.nightlight_round,
                    color: isNightVision ? Colors.greenAccent : Colors.grey,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.aiEngine.toggleNightVision(!isNightVision);
                    });
                  },
                ),
                IconButton(
                  tooltip: 'Siren Alarm Trigger',
                  icon: Icon(
                    Icons.campaign,
                    color: widget.aiEngine.enableAlarmSiren ? Colors.redAccent : Colors.grey,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.aiEngine.toggleAlarmSiren(!widget.aiEngine.enableAlarmSiren);
                    });
                  },
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[800],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Local Offline Mode Active. Zero cloud or API key dependencies.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
                  icon: const Icon(Icons.security, size: 18),
                  label: const Text('Offline Local Mode'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
