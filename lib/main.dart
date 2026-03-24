import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'core/app_router.dart';

void main() {
  runApp(const AeroLineApp());
}


class AeroLineApp extends StatelessWidget {
  const AeroLineApp({super.key});


  @override
  Widget build(BuildContext context) {
    // We will add providers here later as needed
    return MultiProvider(
      providers: [
        Provider.value(value: 'dummy'), // Example dummy provider
      ],
      child: MaterialApp.router(
        title: 'AeroLine Admin',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
      ),
    );
  }
}
