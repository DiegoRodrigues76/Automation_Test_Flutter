// lib/main.dart
import 'package:flutter/material.dart';
import 'package:automation_test_flutter/core/config/app_config.dart';
import 'package:automation_test_flutter/core/di/injection.dart';
import 'package:automation_test_flutter/presentation/routes/app_routes.dart';
import 'package:automation_test_flutter/presentation/theme/app_theme.dart';
import 'package:automation_test_flutter/services/logger_service.dart';

void main() {
  LoggerService.info('Iniciando aplicativo');
  setupDependencies();
  runApp(const FormularioApp());
}

class FormularioApp extends StatelessWidget {
  const FormularioApp({super.key});

  @override
  Widget build(BuildContext context) {
    LoggerService.debug('Construindo FormularioApp');
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