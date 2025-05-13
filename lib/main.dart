import 'package:flutter/material.dart';
import 'screens/form_screen1.dart';
import 'screens/form_screen2.dart';
import 'screens/form_screen3.dart';
import 'screens/form_screen4.dart';
import 'screens/form_screen5.dart';

void main() {
  runApp(FormApp());
}

class FormApp extends StatelessWidget {
  const FormApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulário App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => FormScreen1());
          case '/form2':
            return MaterialPageRoute(builder: (_) => FormScreen2());
          case '/form3':
            return MaterialPageRoute(builder: (_) => FormScreen3());
          case '/form4':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => FormScreen4(paymentMethod: args['paymentMethod']),
            );
          case '/form5':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => FormScreen5(paymentData: args),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(child: Text('Rota não encontrada')),
              ),
            );
        }
      },
    );
  }
}
