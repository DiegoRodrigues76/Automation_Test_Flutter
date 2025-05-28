// lib/presentation/routes/app_routes.dart
import 'package:automation_test_flutter/core/di/injection.dart';
import 'package:automation_test_flutter/domain/repositories/payment_code_repository.dart';
import 'package:automation_test_flutter/domain/usecases/create_address_usecase.dart';
import 'package:automation_test_flutter/domain/usecases/create_payment_details_usecase.dart';
import 'package:automation_test_flutter/domain/usecases/create_payment_info_usecase.dart';
import 'package:automation_test_flutter/domain/usecases/create_personal_info_usecase.dart';
import 'package:automation_test_flutter/domain/usecases/fetch_address_usecase.dart';
import 'package:automation_test_flutter/domain/entities/personal_info.dart';
import 'package:automation_test_flutter/domain/entities/address.dart';
import 'package:automation_test_flutter/domain/entities/payment_info.dart';
import 'package:automation_test_flutter/domain/entities/payment_details.dart';
import 'package:automation_test_flutter/presentation/screens/form_screen1.dart';
import 'package:automation_test_flutter/presentation/screens/form_screen2.dart';
import 'package:automation_test_flutter/presentation/screens/form_screen3.dart';
import 'package:automation_test_flutter/presentation/screens/form_screen4.dart';
import 'package:automation_test_flutter/presentation/screens/form_screen5.dart';
import 'package:automation_test_flutter/presentation/screens/payment_completed_screen.dart';
import 'package:automation_test_flutter/services/logger_service.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String form1 = '/form1';
  static const String form2 = '/form2';
  static const String form3 = '/form3';
  static const String form4 = '/form4';
  static const String form5 = '/form5';
  static const String paymentCompleted = '/paymentCompleted';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    LoggerService.info('Navegando para a rota: ${settings.name}');
    switch (settings.name) {
      case form1:
        return MaterialPageRoute(
          builder: (_) => FormScreen1(
            useCase: getIt<CreatePersonalInfoUseCase>(),
          ),
        );
      case form2:
        return MaterialPageRoute(
          builder: (_) => FormScreen2(
            fetchAddressUseCase: getIt<FetchAddressUseCase>(),
            createAddressUseCase: getIt<CreateAddressUseCase>(),
          ),
          settings: RouteSettings(arguments: settings.arguments as PersonalInfo?),
        );
      case form3:
        return MaterialPageRoute(
          builder: (_) => FormScreen3(
            useCase: getIt<CreatePaymentInfoUseCase>(),
          ),
          settings: RouteSettings(arguments: settings.arguments as Address?),
        );
      case form4:
        final paymentInfo = settings.arguments as PaymentInfo?;
        return MaterialPageRoute(
          builder: (_) => FormScreen4(
            paymentInfo: paymentInfo ??
                PaymentInfo(
                  paymentMethod: '',
                  deliveryDate: DateTime.now(),
                  receiveEmails: false,
                  agreeToTerms: false,
                ),
            useCase: getIt<CreatePaymentDetailsUseCase>(),
            codeRepository: getIt<PaymentCodeRepository>(),
          ),
        );
      case form5:
        final paymentDetails = settings.arguments as PaymentDetails?;
        return MaterialPageRoute(
          builder: (_) => FormScreen5(
            paymentDetails: paymentDetails ?? PaymentDetails(paymentMethod: ''),
          ),
        );
      case paymentCompleted:
        return MaterialPageRoute(builder: (_) => const PaymentCompletedScreen());
      default:
        LoggerService.warning('Rota desconhecida: ${settings.name}');
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Rota não encontrada')),
          ),
        );
    }
  }
}