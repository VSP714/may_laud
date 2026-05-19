import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:may_laud/core/local_storage.dart';
import 'package:may_laud/core/performance_optimization.dart';
import 'package:may_laud/providers/app_providers.dart';
import 'package:may_laud/screens/intro_pages/opening_milaud.dart';
import 'package:may_laud/screens/home/main_app.dart';
//import 'package:may_laud/screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage
  await LocalStorage.init();

  // Configure performance optimizations
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
    final isDarkMode = ref
        .watch(appSettingsProvider.select((settings) => settings.isDarkMode));

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
          home: const OpeningScreen(),
          routes: {
            '/main': (context) => const MainApp(),
          },
        );
      },
    );
  }
}
