import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:may_laud/core/local_storage.dart';
import 'package:may_laud/core/performance_optimization.dart';
import 'package:may_laud/firebase_options.dart';
import 'package:may_laud/providers/app_providers.dart';
import 'package:may_laud/providers/content_providers.dart';
import 'package:may_laud/screens/intro_pages/opening_milaud.dart';
import 'package:may_laud/screens/home/nav_bar_button.dart';
import 'package:may_laud/services/push_notification_service.dart';
import 'package:may_laud/services/supabase_service.dart';
import 'theme/app_theme.dart';

/// Global navigator key so a tapped push notification can navigate even
/// when it arrives outside a widget's BuildContext (e.g. app was
/// terminated and just launched).
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await SupabaseService.init();
  } catch (e) {
    debugPrint('[SupabaseService] Failed to initialize: $e');
  }

  try {
    await LocalStorage.init();
  } catch (e) {
    debugPrint('[LocalStorage] Failed to initialize: $e');
  }

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Must be registered before runApp() so FCM can deliver background
    // messages even if the app isn't currently running.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await PushNotificationService.instance.init();
  } catch (e) {
    debugPrint('[PushNotificationService] Failed to initialize: $e');
  }

  PerformanceOptimization.configureImageCache();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});
  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Wire push callbacks once we have a WidgetRef/navigator to act on.
    PushNotificationService.instance.onMessageReceived = () {
      // Supabase stays the source of truth for the in-app list —
      // just re-pull it whenever a push comes in or is opened.
      ref.read(notificationsProvider.notifier).fetchNotifications();
    };
    PushNotificationService.instance.onNotificationTap = (data) {
      // Simple example: route everything to the notifications screen and
      // let it deep-link from there. Extend this switch as you add more
      // notification `type`s server-side (e.g. 'announcement', 'document_request').
      navigatorKey.currentState?.pushNamed('/main');
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        ref.watch(appSettingsProvider.select((s) => s.isDarkMode));

    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Maylaud - Participatory Governance',
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: '/',
          routes: {
            '/': (context) => const OpeningScreen(),
            '/main': (context) => const MainApp(),
          },
        );
      },
    );
  }
}