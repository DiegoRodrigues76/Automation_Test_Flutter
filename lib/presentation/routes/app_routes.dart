import 'package:flutter/material.dart';
import 'package:automation_test_flutter/presentation/screens/form_screen1.dart';
import 'package:automation_test_flutter/presentation/screens/form_screen2.dart';
import 'package:automation_test_flutter/presentation/screens/form_screen3.dart';
import 'package:automation_test_flutter/presentation/screens/form_screen4.dart';
import 'package:automation_test_flutter/presentation/screens/form_screen5.dart';
import 'package:automation_test_flutter/presentation/screens/payment_completed_screen.dart';

class AppRoutes {
  static const String form1 = '/';
  static const String form2 = '/form2';
  static const String form3 = '/form3';
  static const String form4 = '/form4';
  static const String form5 = '/form5';
  static const String paymentCompleted = '/paymentCompleted';

  /// ✅ Torna o método estático para poder acessar via AppRoutes.onGenerateRoute
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case form1:
        return MaterialPageRoute(builder: (_) => const FormScreen1());

      case form2:
        return MaterialPageRoute(builder: (_) => const FormScreen2());

      case form3:
        return MaterialPageRoute(builder: (_) => const FormScreen3());

      case form4:
        final args = settings.arguments as Map<String, dynamic>?;
        final paymentMethod = args?['paymentMethod'];
        return MaterialPageRoute(
          builder: (_) => FormScreen4(paymentMethod: paymentMethod),
        );

      case form5:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => FormScreen5(paymentData: args!),
        );

      case paymentCompleted:
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
