** Background Sync & Local Notifications (Flutter) ** 

This project is a technical implementation example demonstrating how to manage background synchronization and trigger local notifications on iOS and Android without using Firebase Cloud Messaging (FCM).

** About **

In modern mobile applications, performing data synchronization and notifying users while the app is in the background is a critical requirement. This project showcases:
** Managing background tasks (one-off & periodic) using the workmanager package.
** Sending local notifications to users via flutter_local_notifications.
** Integrating native iOS BGTaskScheduler and Android WorkManager infrastructures with Flutter.

** Medium Article ** 

You can find the step-by-step technical guide and architectural details in my Medium article:
👉 [https://semihcelikol.medium.com/sending-push-notifications-without-firebase-background-sync-with-workmanager-in-flutter-0ca1e4907cc5?sk=fba30019ecc3120ba8fc3ce96d86c4b2]

** Technical Details ** 
* Platform: iOS 14.0+, Android
* Key Packages:
 workmanager: Background task management.
 flutter_local_notifications: Platform-agnostic notification system.
* Key Features:
  Initializing the Flutter engine within background isolates using WidgetsFlutterBinding.
  Managing headless isolate plugin registration on iOS via AppDelegate.
  Handling native notification permissions and configurations (Info.plist).

** Contributing ** 

This is an educational reference project. You are welcome to submit pull requests for bug fixes or feature improvements.
