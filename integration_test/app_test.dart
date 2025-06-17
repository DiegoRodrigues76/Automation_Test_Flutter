import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:automation_test_flutter/main.dart';
import 'package:automation_test_flutter/domain/repositories/payment_code_repository.dart';
import 'package:automation_test_flutter/core/di/injection.dart';
import 'package:automation_test_flutter/constants/constants.dart';

class MockPaymentCodeRepository extends Mock implements PaymentCodeRepository {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Fluxo de pagamento', () {
    late MockPaymentCodeRepository mockRepository;

    setUp(() async {
      mockRepository = MockPaymentCodeRepository();
      getIt.registerSingleton<PaymentCodeRepository>(mockRepository);
      // Stub generateCode with concrete String values
      when(mockRepository.generateCode(pix)).thenAnswer((_) async => 'PIX1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      when(mockRepository.generateCode(boleto)).thenAnswer((_) async => 'BOLETO1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ');
    });

    tearDown(() {
      getIt.reset();
    });

    testWidgets('Fluxo completo de pagamento com cartão', (WidgetTester tester) async {
      await tester.pumpWidget(const FormularioApp());

      // Navegar para FormScreen1
      await tester.tap(find.byKey(const Key('formularios_button')));
      await tester.pumpAndSettle();

      // Preencher FormScreen1
      await tester.enterText(find.byKey(const Key('name_field')), 'João Silva');
      await tester.enterText(find.byKey(const Key('email_field')), 'joao@example.com');
      await tester.enterText(find.byKey(const Key('phone_field')), '11912345678');
      await tester.tap(find.byKey(const Key('proximo_form1_button')));
      await tester.pumpAndSettle();

      // Preencher FormScreen2
      await tester.enterText(find.byKey(const Key('cep_field')), '01001000');
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.tap(find.byKey(const Key('proximo_form2_button')));
      await tester.pumpAndSettle();

      // Preencher FormScreen3
      await tester.tap(find.byKey(const Key('payment_method_dropdown')));
      await tester.tap(find.text('Cartão de Crédito/Débito'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('delivery_date_field')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirmar')); // Matches pt_BR locale
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('agree_to_terms_checkbox')));
      await tester.tap(find.byKey(const Key('proximo_form3_button')));
      await tester.pumpAndSettle();

      // Preencher FormScreen4
      await tester.enterText(find.byKey(const Key('card_number_field')), '1234567890123456');
      await tester.enterText(find.byKey(const Key('card_expiry_field')), '12/25');
      await tester.enterText(find.byKey(const Key('card_cvv_field')), '123');
      await tester.tap(find.byKey(const Key('card_type_dropdown')));
      await tester.tap(find.text('Crédito'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('proximo_form4_button')));
      await tester.pumpAndSettle();

      // Verificar FormScreen5
      expect(find.byKey(const Key('payment_summary_title')), findsOneWidget);
      await tester.tap(find.byKey(const Key('confirmar_form5_button')));
      await tester.pumpAndSettle();

      // Verificar PaymentCompletedScreen
      expect(find.byKey(const Key('payment_completed_content')), findsOneWidget);
      verifyZeroInteractions(mockRepository);
    });

    testWidgets('Fluxo completo de pagamento com Pix', (WidgetTester tester) async {
      await tester.pumpWidget(const FormularioApp());

      // Navegar para FormScreen1
      await tester.tap(find.byKey(const Key('formularios_button')));
      await tester.pumpAndSettle();

      // Preencher FormScreen1
      await tester.enterText(find.byKey(const Key('name_field')), 'Maria Oliveira');
      await tester.enterText(find.byKey(const Key('email_field')), 'maria@example.com');
      await tester.enterText(find.byKey(const Key('phone_field')), '11987654321');
      await tester.tap(find.byKey(const Key('proximo_form1_button')));
      await tester.pumpAndSettle();

      // Preencher FormScreen2
      await tester.enterText(find.byKey(const Key('cep_field')), '01001000');
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.tap(find.byKey(const Key('proximo_form2_button')));
      await tester.pumpAndSettle();

      // Preencher FormScreen3
      await tester.tap(find.byKey(const Key('payment_method_dropdown')));
      await tester.tap(find.text('Pix'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('delivery_date_field')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirmar')); // Matches pt_BR locale
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('agree_to_terms_checkbox')));
      await tester.tap(find.byKey(const Key('proximo_form3_button')));
      await tester.pumpAndSettle();

      // Preencher FormScreen4
      await tester.tap(find.byKey(const Key('gerar_codigo_form4_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('code_generated_snackbar')), findsOneWidget);
      expect(find.text('PIX1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ'), findsOneWidget);
      await tester.tap(find.byKey(const Key('proximo_form4_button')));
      await tester.pumpAndSettle();

      // Verificar FormScreen5
      expect(find.byKey(const Key('payment_summary_title')), findsOneWidget);
      await tester.tap(find.byKey(const Key('confirmar_form5_button')));
      await tester.pumpAndSettle();

      // Verificar PaymentCompletedScreen
      expect(find.byKey(const Key('payment_completed_content')), findsOneWidget);
      verify(mockRepository.generateCode(pix)).called(1);
    });
  });
}