import 'package:flutter/material.dart';

import '../services/ai_vision_engine.dart';

class SettingsScreen extends StatefulWidget {
  final AiVisionEngine aiEngine;

  const SettingsScreen({super.key, required this.aiEngine});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late double _sensitivity;
  late DetectionMode _selectedMode;
  late bool _motionTracking;
  late bool _alarmSiren;

  @override
  void initState() {
    super.initState();
    _sensitivity = widget.aiEngine.sensitivityThreshold;
    _selectedMode = widget.aiEngine.mode;
    _motionTracking = widget.aiEngine.enableMotionTracking;
    _alarmSiren = widget.aiEngine.enableAlarmSiren;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('AI & SURVEILLANCE SETTINGS'),
        backgroundColor: Colors.grey[900],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'AI Recognition Model Selection (Current: 15/10/2026)',
            style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Card(
            color: Colors.grey[850],
            child: Column(
              children: [
                RadioListTile<DetectionMode>(
                  title: const Text('Ultra CCTV Security Pro', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Full Person, Intruder, Face & Motion Detection', style: TextStyle(color: Colors.grey)),
                  value: DetectionMode.ultraCctvPro,
                  groupValue: _selectedMode,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedMode = val;
                        widget.aiEngine.setMode(val);
                      });
                    }
                  },
                ),
                RadioListTile<DetectionMode>(
                  title: const Text('Hyper YOLOv8 Nano Vision', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Ultra-high accuracy multi-object detection', style: TextStyle(color: Colors.grey)),
                  value: DetectionMode.hyperYoloV8,
                  groupValue: _selectedMode,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedMode = val;
                        widget.aiEngine.setMode(val);
                      });
                    }
                  },
                ),
                RadioListTile<DetectionMode>(
                  title: const Text('Edge Lightweight MobileNetV4', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Minimal CPU usage for very old mobile devices', style: TextStyle(color: Colors.grey)),
                  value: DetectionMode.edgeLightweight,
                  groupValue: _selectedMode,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedMode = val;
                        widget.aiEngine.setMode(val);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'AI Sensitivity & Threshold',
            style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Card(
            color: Colors.grey[850],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Detection Confidence Threshold:', style: TextStyle(color: Colors.white)),
                      Text(
                        '${(_sensitivity * 100).toInt()}%',
                        style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Slider(
                    value: _sensitivity,
                    min: 0.20,
                    max: 0.90,
                    divisions: 14,
                    activeColor: Colors.amberAccent,
                    onChanged: (val) {
                      setState(() {
                        _sensitivity = val;
                        widget.aiEngine.setSensitivity(val);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Security Features',
            style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Card(
            color: Colors.grey[850],
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Motion Vector Tracking', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Detect background motion & moving objects', style: TextStyle(color: Colors.grey)),
                  value: _motionTracking,
                  activeColor: Colors.cyanAccent,
                  onChanged: (val) {
                    setState(() {
                      _motionTracking = val;
                      widget.aiEngine.enableMotionTracking = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Auto Siren Alarm Trigger', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Sound loud alert sound when intruder is detected', style: TextStyle(color: Colors.grey)),
                  value: _alarmSiren,
                  activeColor: Colors.redAccent,
                  onChanged: (val) {
                    setState(() {
                      _alarmSiren = val;
                      widget.aiEngine.toggleAlarmSiren(val);
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                const Text(
                  'Smart Old Mobile AI CCTV Camera System v2.5.0',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  'System Date: 15/10/2026 • Edge AI Enabled',
                  style: TextStyle(color: Colors.cyanAccent.withOpacity(0.6), fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
