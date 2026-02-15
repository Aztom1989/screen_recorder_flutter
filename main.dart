import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const channel = MethodChannel('screen_recorder');
  String status = "Idle";

  Future<void> start() async {
    try {
      await channel.invokeMethod('start');
      setState(() => status = "Recording... (use notification Stop)");
    } catch (e) {
      setState(() => status = "Start failed: $e");
    }
  }

  Future<void> stop() async {
    try {
      final uri = await channel.invokeMethod<String>('stop');
      setState(() => status = uri == null ? "Stopped (no uri)" : "Saved: $uri");
    } catch (e) {
      setState(() => status = "Stop failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Flutter Screen Recorder")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(status),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: start, child: const Text("Start Recording")),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: stop, child: const Text("Stop Recording")),
              const SizedBox(height: 16),
              const Text("Tip: Pull down notifications and tap Stop to finish."),
            ],
          ),
        ),
      ),
    );
  }
}
