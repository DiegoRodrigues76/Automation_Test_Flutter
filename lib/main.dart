import 'package:flutter/material.dart';
import 'core/config/app_config.dart';
import 'core/di/injection.dart';
import 'presentation/routes/app_routes.dart';
import 'presentation/theme/app_theme.dart';

void main() {
  setupDependencies();
  runApp(const FormularioApp());
}

class FormularioApp extends StatelessWidget {
  const FormularioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulário App',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.form1,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      locale: AppConfig.defaultLocale,
      supportedLocales: AppConfig.supportedLocales,
      localizationsDelegates: AppConfig.localizationsDelegates,
    );
  }
}