import 'package:flutter/material.dart';

import '../models/detection_result.dart';
import '../services/ai_vision_engine.dart';

class EventLogScreen extends StatefulWidget {
  final AiVisionEngine aiEngine;

  const EventLogScreen({super.key, required this.aiEngine});

  @override
  State<EventLogScreen> createState() => _EventLogScreenState();
}

class _EventLogScreenState extends State<EventLogScreen> {
  @override
  Widget build(BuildContext context) {
    final history = widget.aiEngine.eventHistory;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('AI SECURITY LOGS & ALERTS'),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear Event Logs',
            onPressed: () {
              setState(() {
                widget.aiEngine.clearHistory();
              });
            },
          ),
        ],
      ),
      body: history.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_user_outlined, color: Colors.greenAccent, size: 64),
                  SizedBox(height: 12),
                  Text(
                    'No security threats or alerts detected.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'AI surveillance active on 15/10/2026',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                Color badgeColor;
                IconData iconData;

                switch (item.alertLevel) {
                  case AlertLevel.danger:
                    badgeColor = Colors.redAccent;
                    iconData = Icons.warning_amber_rounded;
                    break;
                  case AlertLevel.warning:
                    badgeColor = Colors.amberAccent;
                    iconData = Icons.visibility;
                    break;
                  case AlertLevel.info:
                    badgeColor = Colors.cyanAccent;
                    iconData = Icons.info_outline;
                    break;
                }

                return Card(
                  color: Colors.grey[850],
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: badgeColor.withOpacity(0.2),
                      child: Icon(iconData, color: badgeColor),
                    ),
                    title: Text(
                      item.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Confidence: ${(item.confidence * 100).toStringAsFixed(1)}% • ${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}:${item.timestamp.second.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: badgeColor, width: 0.8),
                      ),
                      child: Text(
                        item.alertLevel.name.toUpperCase(),
                        style: TextStyle(
                          color: badgeColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
