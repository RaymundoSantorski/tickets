import 'package:flutter/material.dart';
import 'package:tickets/app/app_router.dart';
import 'package:tickets/core/theme/dark_theme.dart';
import 'package:tickets/core/theme/light_theme.dart';

class TicketsApp extends StatelessWidget {
  const TicketsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}
