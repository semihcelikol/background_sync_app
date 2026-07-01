import UIKit
import Flutter
import workmanager_apple

@main
@objc class AppDelegate: FlutterAppDelegate {
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // 1. Ana uygulama için pluginleri kaydet
    GeneratedPluginRegistrant.register(with: self)
      
    // 2. KRİTİK NOKTA: Arka plan isolate'i için Workmanager'a pluginleri kaydet!
    // Bu kod olmazsa bildirim paketi arka planda çalışmaz ve çöker.
    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
        GeneratedPluginRegistrant.register(with: registry)
    }

    // 3. Bildirimlerin ön planda gösterilebilmesi için delege
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Uygulama açıkken veya kapalıyken bildirim banner'ını zorla göster
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    if #available(iOS 15.0, *) {
        completionHandler([[.banner, .sound, .badge]])
    } else {
        completionHandler([[.alert, .sound, .badge]])
    }
  }
}