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

    setUpAll(() async {
      mockRepository = MockPaymentCodeRepository();

      // Evitar múltiplos registros que causam erro
      if (getIt.isRegistered<PaymentCodeRepository>()) {
        await getIt.unregister<PaymentCodeRepository>();
      }
      getIt.registerSingleton<PaymentCodeRepository>(mockRepository);

      // Stubs para gerar código PIX, boleto e cartão
      when(mockRepository.generateCode(pix)).thenAnswer((_) async {
        print('generateCode chamado com: $pix');
        return 'PIX1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ';
      });

      when(mockRepository.generateCode(boleto)).thenAnswer((_) async {
        print('generateCode chamado com: $boleto');
        return 'BOLETO1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ';
      });

      when(mockRepository.generateCode(card)).thenAnswer((_) async {
        print('generateCode chamado com: $card');
        // Retorna um código vazio para cartão, já que o teste com cartão não espera um código
        return '';
      });

      // Evitar stub genérico para 'any' para prevenir chamadas inesperadas
      // Se necessário, podemos adicionar um stub padrão mais tarde
    });

    setUp(() {
      // Limpa interações, mantendo os stubs intactos
      clearInteractions(mockRepository);
    });

    tearDownAll(() async {
      await getIt.reset();
    });

    testWidgets('Fluxo completo de pagamento com cartão',
        (WidgetTester tester) async {
      await tester.pumpWidget(const FormularioApp());

      // Navegar para FormScreen1
      await tester.tap(find.byKey(const Key('formularios_button')));
      await tester.pumpAndSettle();
      print('Navigated to FormScreen1');

      // Preencher FormScreen1
      await tester.enterText(find.byKey(const Key('name_field')), 'João Silva');
      await tester.enterText(
          find.byKey(const Key('email_field')), 'joao@example.com');
      await tester.enterText(
          find.byKey(const Key('phone_field')), '11912345678');
      await tester.tap(find.byKey(const Key('proximo_form1_button')));
      await tester.pumpAndSettle();
      print('Completed FormScreen1');

      // Preencher FormScreen2
      await tester.enterText(find.byKey(const Key('cep_field')), '01001000');
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.tap(find.byKey(const Key('proximo_form2_button')));
      await tester.pumpAndSettle();
      print('Completed FormScreen2');

      // Preencher FormScreen3 - Selecionar cartão
      await tester.tap(find.byKey(const Key('payment_method_dropdown')));
      await tester.pumpAndSettle();
      expect(find.text('Cartão de Crédito/Débito'), findsOneWidget);
      await tester.tap(find.text('Cartão de Crédito/Débito'));
      await tester.pumpAndSettle();
      print('Selected payment method: Cartão de Crédito/Débito');

      await tester.tap(find.byKey(const Key('delivery_date_field')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirmar'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('agree_to_terms_checkbox')));
      await tester.tap(find.byKey(const Key('proximo_form3_button')));
      await tester.pumpAndSettle();
      print('Completed FormScreen3');

      // Preencher dados do cartão na FormScreen4
      expect(find.byKey(const Key('card_number_field')), findsOneWidget,
          reason: 'Should display card fields for card payment');
      await tester.enterText(
          find.byKey(const Key('card_number_field')), '1234567890123456');
      await tester.enterText(find.byKey(const Key('card_expiry_field')), '12/25');
      await tester.enterText(find.byKey(const Key('card_cvv_field')), '123');

      await tester.tap(find.byKey(const Key('card_type_dropdown')));
      await tester.pumpAndSettle();
      expect(find.text('Crédito'), findsOneWidget);
      await tester.tap(find.text('Crédito'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('proximo_form4_button')));
      await tester.pumpAndSettle();
      print('Completed FormScreen4');

      // Tela resumo FormScreen5
      expect(find.byKey(const Key('payment_summary_title')), findsOneWidget);
      await tester.tap(find.byKey(const Key('confirmar_form5_button')));
      await tester.pumpAndSettle();
      print('Completed FormScreen5');

      // Tela de confirmação final
      expect(find.byKey(const Key('payment_completed_content')), findsOneWidget);
      print('Reached PaymentCompletedScreen');

      // Verifica que generateCode NÃO foi chamado
      verifyNever(mockRepository.generateCode(any));
    });

    testWidgets('Fluxo completo de pagamento com Pix',
        (WidgetTester tester) async {
      await tester.pumpWidget(const FormularioApp());

      await tester.tap(find.byKey(const Key('formularios_button')));
      await tester.pumpAndSettle();
      print('Navigated to FormScreen1');

      await tester.enterText(find.byKey(const Key('name_field')), 'Maria Oliveira');
      await tester.enterText(find.byKey(const Key('email_field')), 'maria@example.com');
      await tester.enterText(find.byKey(const Key('phone_field')), '11987654321');
      await tester.tap(find.byKey(const Key('proximo_form1_button')));
      await tester.pumpAndSettle();
      print('Completed FormScreen1');

      await tester.enterText(find.byKey(const Key('cep_field')), '01001000');
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.tap(find.byKey(const Key('proximo_form2_button')));
      await tester.pumpAndSettle();
      print('Completed FormScreen2');

      await tester.tap(find.byKey(const Key('payment_method_dropdown')));
      await tester.pumpAndSettle();
      expect(find.text('Pix'), findsOneWidget);
      await tester.tap(find.text('Pix'));
      await tester.pumpAndSettle();
      print('Selected payment method: Pix');

      await tester.tap(find.byKey(const Key('delivery_date_field')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirmar'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('agree_to_terms_checkbox')));
      await tester.tap(find.byKey(const Key('proximo_form3_button')));
      await tester.pumpAndSettle();
      print('Completed FormScreen3');

      expect(find.byKey(const Key('gerar_codigo_form4_button')), findsOneWidget,
          reason: 'Should display Pix fields');
      await tester.tap(find.byKey(const Key('gerar_codigo_form4_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('code_generated_snackbar')), findsOneWidget);
      expect(find.text('PIX1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ'), findsOneWidget);
      print('Generated Pix code');

      await tester.tap(find.byKey(const Key('proximo_form4_button')));
      await tester.pumpAndSettle();
      print('Completed FormScreen4');

      expect(find.byKey(const Key('payment_summary_title')), findsOneWidget);
      await tester.tap(find.byKey(const Key('confirmar_form5_button')));
      await tester.pumpAndSettle();
      print('Completed FormScreen5');

      expect(find.byKey(const Key('payment_completed_content')), findsOneWidget);
      print('Reached PaymentCompletedScreen');

      // Verifica que generateCode foi chamado exatamente 1 vez para Pix
      verify(mockRepository.generateCode(pix)).called(1);
    });
  });
}