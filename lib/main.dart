import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:may_laud/core/local_storage.dart';
import 'package:may_laud/core/performance_optimization.dart';
import 'package:may_laud/providers/app_providers.dart';
import 'package:may_laud/screens/intro_pages/opening_milaud.dart';
import 'package:may_laud/screens/home/nav_bar_button.dart';
import 'package:may_laud/services/supabase_service.dart';
import 'theme/app_theme.dart';

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

  PerformanceOptimization.configureImageCache();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode =
        ref.watch(appSettingsProvider.select((s) => s.isDarkMode));

    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Milaud - Participatory Governance',
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