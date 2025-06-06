// import 'package:intl/intl.dart';

// class PaymentDetails {
//   final String paymentMethod;
//   final String? cardType;
//   final String? cardNumber;
//   final DateTime? cardExpiry;
//   final String? cardCVV;
//   final String? pixCode;
//   final String? boletoCode;

//   PaymentDetails({
//     required this.paymentMethod,
//     this.cardType,
//     this.cardNumber,
//     this.cardExpiry,
//     this.cardCVV,
//     this.pixCode,
//     this.boletoCode,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'paymentMethod': paymentMethod,
//       'cardType': cardType,
//       'cardNumber': cardNumber,
//       'cardExpiry': cardExpiry != null ? DateFormat('MM/yy').format(cardExpiry!) : null,
//       'cardCVV': cardCVV,
//       'pixCode': pixCode,
//       'boletoCode': boletoCode,
//     };
//   }
// }

class PaymentDetails {
  final String paymentMethod;
  final String? cardType;
  final String? cardNumber;
  final DateTime? cardExpiry;
  final String? cardCVV;
  final String? pixCode;
  final String? boletoCode;

  PaymentDetails({
    required this.paymentMethod,
    this.cardType,
    this.cardNumber,
    this.cardExpiry,
    this.cardCVV,
    this.pixCode,
    this.boletoCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'paymentMethod': paymentMethod,
      'cardType': cardType,
      'cardNumber': cardNumber,
      'cardExpiry': cardExpiry?.toIso8601String(),
      'cardCVV': cardCVV,
      'pixCode': pixCode,
      'boletoCode': boletoCode,
    };
  }
}