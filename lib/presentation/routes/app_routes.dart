import 'package:flutter/material.dart';
import 'package:automation_test_flutter/domain/usecases/create_address_usecase.dart';
import 'package:automation_test_flutter/domain/usecases/create_payment_details_usecase.dart';
import 'package:automation_test_flutter/domain/usecases/create_payment_info_usecase.dart';
import 'package:automation_test_flutter/domain/usecases/create_personal_info_usecase.dart';
import 'package:automation_test_flutter/domain/usecases/fetch_address_usecase.dart';
import 'package:automation_test_flutter/domain/repositories/payment_code_repository.dart';
import 'package:automation_test_flutter/presentation/screens/form_screen1.dart';
import 'package:automation_test_flutter/presentation/screens/form_screen2.dart';
import 'package:automation_test_flutter/presentation/screens/form_screen3.dart';
import 'package:automation_test_flutter/presentation/screens/form_screen4.dart';
import 'package:automation_test_flutter/presentation/screens/form_screen5.dart';
import 'package:automation_test_flutter/presentation/screens/menu_screen.dart';
import 'package:automation_test_flutter/presentation/screens/crypto_screen.dart';
import 'package:automation_test_flutter/presentation/screens/payment_completed_screen.dart';
import 'package:automation_test_flutter/core/di/injection.dart';
import 'package:automation_test_flutter/presentation/routes/form_data_arguments.dart';

class AppRoutes {
  static const String menu = '/menu';
  static const String form1 = '/form1';
  static const String form2 = '/form2';
  static const String form3 = '/form3';
  static const String form4 = '/form4';
  static const String form5 = '/form5';
  static const String paymentCompleted = '/payment_completed';
  static const String crypto = '/crypto';

  static Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case menu:
        return MaterialPageRoute(builder: (_) => const MenuScreen());
      case form1:
        return MaterialPageRoute(
          builder: (_) => FormScreen1(
            useCase: getIt<CreatePersonalInfoUseCase>(),
          ),
        );
      case form2:
        final args = settings.arguments as FormDataArguments?;
        return MaterialPageRoute(
          builder: (_) => FormScreen2(
            fetchAddressUseCase: getIt<FetchAddressUseCase>(),
            createAddressUseCase: getIt<CreateAddressUseCase>(),
            arguments: args,
          ),
        );
      case form3:
        final args = settings.arguments as FormDataArguments?;
        return MaterialPageRoute(
          builder: (_) => FormScreen3(
            useCase: getIt<CreatePaymentInfoUseCase>(),
            arguments: args,
          ),
        );
      case form4:
        final args = settings.arguments as FormDataArguments?;
        final paymentInfo = args?.paymentInfo;
        if (paymentInfo == null) {
          return _errorRoute();
        }
        return MaterialPageRoute(
          builder: (_) => FormScreen4(
            paymentInfo: paymentInfo,
            arguments: args,
            useCase: getIt<CreatePaymentDetailsUseCase>(),
            codeRepository: getIt<PaymentCodeRepository>(),
          ),
        );
      case form5:
        final args = settings.arguments as FormDataArguments?;
        final paymentDetails = args?.paymentDetails;
        if (paymentDetails == null) {
          return _errorRoute();
        }
        return MaterialPageRoute(
          builder: (_) => FormScreen5(
            paymentDetails: paymentDetails,
            arguments: args,
          ),
        );
      case paymentCompleted:
        return MaterialPageRoute(builder: (_) => const PaymentCompletedScreen());
      case crypto:
        return MaterialPageRoute(builder: (_) => const CryptoScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<Object> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('Rota não encontrada')),
      ),
    );
  }
}