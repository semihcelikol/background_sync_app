import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import 'service/notification_service.dart';

// 1. Define a unique task identifier
const String syncTask = "backgroundSyncTask";

// 2. Define the top-level callback dispatcher
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // 1. Critical: Ensure Flutter bindings are initialized in the background isolate
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize the notification service inside the background isolate
      await NotificationService.initialize();

      // SIMULATE BACKGROUND WORK (e.g., API call, database sync)
      await Future.delayed(const Duration(seconds: 2));

      // Show the local notification
      await NotificationService.showNotification(
        title: "Sync Completed",
        body: "Your data was updated in the background without Firebase!",
      );

      return Future.value(true);
    } catch (err) {
      debugPrint("Arka plan hatası: $err");
      return Future.value(false); 
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  // Initialize notification service for the main app UI
  await NotificationService.initialize();

  // BURAYI EKLİYORUZ: Kullanıcıdan bildirim izni iste
  await NotificationService.requestPermission();

  // Initialize Workmanager
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Background Sync Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Push Notification')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. One-Off Task Button
            ElevatedButton(
              onPressed: () {
                Workmanager().registerOneOffTask(
                  "unique_sync_id_1",
                  syncTask,
                  initialDelay: const Duration(seconds: 10),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('One-off task registered! Wait 10 seconds.'),
                  ),
                );
              },
              child: const Text('Trigger One-Off Sync'),
            ),

            const SizedBox(height: 20),

            // 2. Start Periodic Task Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                // Register a periodic task
                Workmanager().registerPeriodicTask(
                  "periodic_sync_id", // A unique name for the periodic task
                  syncTask,
                  frequency: const Duration(
                    minutes: 15,
                  ), // Minimum is 15 minutes!
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Periodic sync started (Every 15 mins).'),
                  ),
                );
              },
              child: const Text(
                'Start Periodic Sync',
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),

            // 3. Stop Periodic Task Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                // Cancel the periodic task using its unique name
                Workmanager().cancelByUniqueName("periodic_sync_id");

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Periodic sync stopped.')),
                );
              },
              child: const Text(
                'Stop Periodic Sync',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}