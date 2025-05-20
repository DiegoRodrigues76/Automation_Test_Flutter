import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Pacotes e módulos do app
import 'package:automation_test_flutter/modules/common/theme/theme.dart';
import 'package:automation_test_flutter/screens/form_screen1.dart';
import 'package:automation_test_flutter/screens/form_screen2.dart';
import 'package:automation_test_flutter/screens/form_screen3.dart';
import 'package:automation_test_flutter/screens/form_screen4.dart';
import 'package:automation_test_flutter/screens/form_screen5.dart';
import 'package:automation_test_flutter/screens/payment_completed_screen.dart';

void main() {
  runApp(const FormApp());
}

class FormApp extends StatelessWidget {
  const FormApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulário App',
      theme: ZemaTheme.getLightTheme(),
      themeMode: ThemeMode.light,
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      initialRoute: '/',
      onGenerateRoute: _generateRoute,
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => FormScreen1());
      case '/form2':
        return MaterialPageRoute(builder: (_) => FormScreen2());
      case '/form3':
        return MaterialPageRoute(builder: (_) => FormScreen3());
      case '/form4':
        final args = settings.arguments as Map<String, dynamic>;
        final paymentMethod = args['paymentMethod'];
        return MaterialPageRoute(
          builder: (_) => FormScreen4(paymentMethod: paymentMethod),
        );
      case '/form5':
        final paymentData = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => FormScreen5(paymentData: paymentData),
          settings: settings,
        );
      case '/paymentCompleted':
        return MaterialPageRoute(builder: (_) => const PaymentCompletedScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Rota não encontrada')),
          ),
        );
    }
  }
}
