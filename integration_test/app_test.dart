import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:automation_test_flutter/main.dart';
import 'package:automation_test_flutter/domain/repositories/payment_code_repository.dart';
import 'package:automation_test_flutter/core/di/injection.dart';
import 'package:automation_test_flutter/constants/constants.dart';
import 'package:reactive_forms/reactive_forms.dart';

class MockPaymentCodeRepository extends Mock implements PaymentCodeRepository {}

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
  await GetIt.instance.reset();
  setupDependencies();
  });

  group('Fluxo de pagamento', () {
    late MockPaymentCodeRepository mockRepository;

    setUpAll(() async {
      mockRepository = MockPaymentCodeRepository();
    });

    setUp(() {
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
      print('Navegou para FormScreen1');

      // Preencher FormScreen1
      await tester.enterText(find.byKey(const Key('name_field')), 'João Silva');
      await tester.enterText(
        find.byKey(const Key('email_field')), 'joao@example.com');
      await tester.enterText(
        find.byKey(const Key('phone_field')), '11912345678');
      await tester.tap(find.byKey(const Key('proximo_form1_button')));
      await tester.pumpAndSettle();
      print('FormScreen1 concluído');

      // Preencher FormScreen2
      await tester.enterText(find.byKey(const Key('cep_field')), '01001000');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Selecionar nacionalidade no DropdownSearch
      await tester.tap(find.byKey(const Key('country_dropdown')));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Clicar no campo de busca dentro do DropdownSearch
      final searchField = find.descendant(
        of: find.byType(Material), // Menu usa um Material no overlay
        matching: find.byType(TextField),
      ).first;

      await tester.tap(searchField);
      await tester.pumpAndSettle();

      await tester.enterText(searchField, 'Brasil'); // Simula digitação na caixa de busca
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(find.text('Brasil').last); // Seleciona "Brasil"
      await tester.pumpAndSettle();
      print('Nacionalidade selecionada: Brasil');

      // Verificar se o formulário foi atualizado
      final form = tester.widget<ReactiveForm>(find.byType(ReactiveForm)).formGroup;
      expect(form.control('country').value, 'Brasil');

      await tester.tap(find.byKey(const Key('proximo_form2_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      print('FormScreen2 concluído');

      // Preencher FormScreen3 - Selecionar cartão
      await tester.tap(find.byKey(const Key('payment_method_dropdown')));
      await tester.pumpAndSettle();
      expect(find.text('Cartão de Crédito/Débito'), findsOneWidget);
      await tester.tap(find.text('Cartão de Crédito/Débito'));
      await tester.pumpAndSettle();
      print('Método de Pagamento selecionado: Cartão de Crédito/Débito');

      // Abrir o seletor de data
      await tester.tap(find.byKey(const Key('delivery_date_field')));
      await tester.pumpAndSettle();

      // Calcular o dia de amanhã
      final DateTime today = DateTime.now();
      final DateTime tomorrow = today.add(const Duration(days: 1));
      
      // Clicar no número da data correspondente 
      await tester.tap(find.text(tomorrow.day.toString()).first);
      await tester.pumpAndSettle();

      // Confirmar a data (botão "OK" ou "Confirmar")
      final confirmButton = find.widgetWithText(TextButton, 'OK').first;
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();
      print('Data de Entrega selecionada: $tomorrow');
      
      // Aceitar os termos
      await tester.tap(find.byKey(const Key('agree_to_terms_checkbox')));
      await tester.pumpAndSettle();

      // Avançar para a próxima tela
      await tester.tap(find.byKey(const Key('proximo_form3_button')));
      await tester.pumpAndSettle();
      print('FormScreen3 concluído');

      // Preencher FormScreen4 - Dados do Cartão
      await tester.enterText(find.byKey(const Key('card_number_field')), '1234567890123456');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('card_expiry_field')));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownButton<int>).at(0)); // Mês
      await tester.pumpAndSettle();
      await tester.tap(find.text('08').last); // Seleciona Agosto
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownButton<int>).at(1)); // Ano
      await tester.pumpAndSettle();
      await tester.tap(find.text('2029').last); // Seleciona 2029
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.text('OK')); // Confirma
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.enterText(find.byKey(const Key('card_cvv_field')), '123');

      await tester.tap(find.byKey(const Key('card_type_dropdown')));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('Crédito'), findsOneWidget);
      await tester.tap(find.text('Crédito'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.byKey(const Key('proximo_form4_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      print('FormScreen4 concluído');

      // Tela resumo FormScreen5
      expect(find.byKey(const Key('payment_summary_title')), findsOneWidget);
      await tester.tap(find.byKey(const Key('confirmar_form5_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));
      print('FormScreen5 concluído');

      // Tela de confirmação final
      expect(find.byKey(const Key('payment_completed_content')), findsOneWidget);
      print('PaymentCompletedScreen alcançado');
    });

    testWidgets('Fluxo completo de pagamento com Pix',
        (WidgetTester tester) async {
      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpWidget(const FormularioApp());

      // Navegar para FormScreen1
      await tester.tap(find.byKey(const Key('formularios_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      print('Navegou para FormScreen1');

      // Preencher FormScreen1
      await tester.enterText(find.byKey(const Key('name_field')), 'Diego Rodrigues');
      await tester.enterText(find.byKey(const Key('email_field')), 'DiegoHR@example.com');
      await tester.enterText(find.byKey(const Key('phone_field')), '11965768798');
      await tester.tap(find.byKey(const Key('proximo_form1_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      print('FormScreen1 concluído');

      // Preencher FormScreen2
      await tester.enterText(find.byKey(const Key('cep_field')), '52030060');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Selecionar nacionalidade no DropdownSearch
      await tester.tap(find.byKey(const Key('country_dropdown')));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Clicar no campo de busca dentro do DropdownSearch
      final searchField = find.descendant(
        of: find.byType(Material), // Menu usa um Material no overlay
        matching: find.byType(TextField),
      ).first;

      await tester.tap(searchField);
      await tester.pumpAndSettle();

      await tester.enterText(searchField, 'Brasil'); // Simula digitação na caixa de busca
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(find.text('Brasil').last); // Seleciona "Brasil"
      await tester.pumpAndSettle();
      print('Nacionalidade selecionada: Brasil');

      // Verificar se o formulário foi atualizado
      final form = tester.widget<ReactiveForm>(find.byType(ReactiveForm)).formGroup;
      expect(form.control('country').value, 'Brasil');

      await tester.tap(find.byKey(const Key('proximo_form2_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      print('FormScreen2 concluído');

      // Preencher FormScreen3 - Selecionar PIX
      await tester.tap(find.byKey(const Key('payment_method_dropdown')));
      await tester.pumpAndSettle();
      expect(find.text('Pix'), findsOneWidget);
      await tester.tap(find.text('Pix'));
      await tester.pumpAndSettle();
      print('Método de Pagamento selecionado: PIX');

      // Abrir o seletor de data
      await tester.tap(find.byKey(const Key('delivery_date_field')));
      await tester.pumpAndSettle();

      // Calcular o dia de amanhã
      final DateTime today = DateTime.now();
      final DateTime tomorrow = today.add(const Duration(days: 1));
      
      // Clicar no número da data correspondente 
      await tester.tap(find.text(tomorrow.day.toString()).first);
      await tester.pumpAndSettle();

      // Confirmar a data (botão "OK" ou "Confirmar")
      final confirmButton = find.widgetWithText(TextButton, 'OK').first;
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();
      print('Data de Entrega selecionada: $tomorrow');
      
      // Aceitar os termos
      await tester.tap(find.byKey(const Key('agree_to_terms_checkbox')));
      await tester.pumpAndSettle();

      // Avançar para a próxima tela
      await tester.tap(find.byKey(const Key('proximo_form3_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      print('FormScreen3 concluído');

      // FormScreen4 - Gerar Código: PIX
      expect(find.byKey(const Key('gerar_codigo_form4_button')), findsOneWidget,
          reason: 'Deverá exibir o campo de Pix');
      await tester.tap(find.byKey(const Key('gerar_codigo_form4_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byKey(const Key('code_generated_snackbar')), findsOneWidget);
      print('Código Pix gerado');

      await tester.tap(find.byKey(const Key('proximo_form4_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      print('FormScreen4 concluído');

      // Tela resumo FormScreen5
      expect(find.byKey(const Key('payment_summary_title')), findsOneWidget);
      await tester.tap(find.byKey(const Key('confirmar_form5_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));
      print('FormScreen5 concluído');

      // Tela de confirmação final
      expect(find.byKey(const Key('payment_completed_content')), findsOneWidget);
      print('PaymentCompletedScreen alcançado');
    });

    testWidgets('Fluxo completo de pagamento com Boleto',
        (WidgetTester tester) async {
      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpWidget(const FormularioApp());

      // Navegar para FormScreen1
      await tester.tap(find.byKey(const Key('formularios_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      print('Navegou para FormScreen1');

      // Preencher FormScreen1
      await tester.enterText(find.byKey(const Key('name_field')), 'Pedro Álvares Cabral');
      await tester.enterText(find.byKey(const Key('email_field')), 'PedroAC@teste.com');
      await tester.enterText(find.byKey(const Key('phone_field')), '73922031500');
      await tester.tap(find.byKey(const Key('proximo_form1_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      print('FormScreen1 concluído');

      // Preencher FormScreen2
      await tester.enterText(find.byKey(const Key('cep_field')), '45848970');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Selecionar nacionalidade no DropdownSearch
      await tester.tap(find.byKey(const Key('country_dropdown')));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Clicar no campo de busca dentro do DropdownSearch
      final searchField = find.descendant(
        of: find.byType(Material), // Menu usa um Material no overlay
        matching: find.byType(TextField),
      ).first;

      await tester.tap(searchField);
      await tester.pumpAndSettle();

      await tester.enterText(searchField, 'Portugal'); // Simula digitação na caixa de busca
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(find.text('Portugal').last); // Seleciona "Brasil"
      await tester.pumpAndSettle();
      print('Nacionalidade selecionada: Portugal');

      // Verificar se o formulário foi atualizado
      final form = tester.widget<ReactiveForm>(find.byType(ReactiveForm)).formGroup;
      expect(form.control('country').value, 'Portugal');

      await tester.tap(find.byKey(const Key('proximo_form2_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      print('FormScreen2 concluído');

      // Preencher FormScreen3 - Selecionar BOLETO
      await tester.tap(find.byKey(const Key('payment_method_dropdown')));
      await tester.pumpAndSettle();
      expect(find.text('Boleto'), findsOneWidget);
      await tester.tap(find.text('Boleto'));
      await tester.pumpAndSettle();
      print('Método de Pagamento selecionado: BOLETO');

      // Abrir o seletor de data
      await tester.tap(find.byKey(const Key('delivery_date_field')));
      await tester.pumpAndSettle();

      // Calcular o dia de amanhã
      final DateTime today = DateTime.now();
      final DateTime tomorrow = today.add(const Duration(days: 1));
      
      // Clicar no número da data correspondente 
      await tester.tap(find.text(tomorrow.day.toString()).first);
      await tester.pumpAndSettle();

      // Confirmar a data (botão "OK" ou "Confirmar")
      final confirmButton = find.widgetWithText(TextButton, 'OK').first;
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();
      print('Data de Entrega selecionada: $tomorrow');
      
      // Aceitar os termos
      await tester.tap(find.byKey(const Key('agree_to_terms_checkbox')));
      await tester.pumpAndSettle();

      // Avançar para a próxima tela
      await tester.tap(find.byKey(const Key('proximo_form3_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      print('FormScreen3 concluído');

      // FormScreen4 - Gerar Código: BOLETO
      expect(find.byKey(const Key('gerar_codigo_form4_button')), findsOneWidget,
          reason: 'Deverá exibir o campo de Boleto');
      await tester.tap(find.byKey(const Key('gerar_codigo_form4_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byKey(const Key('code_generated_snackbar')), findsOneWidget);
      print('Código de Boleto gerado');

      await tester.tap(find.byKey(const Key('proximo_form4_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      print('FormScreen4 concluído');

      // Tela resumo FormScreen5
      expect(find.byKey(const Key('payment_summary_title')), findsOneWidget);
      await tester.tap(find.byKey(const Key('confirmar_form5_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));
      print('FormScreen5 concluído');

      // Tela de confirmação final
      expect(find.byKey(const Key('payment_completed_content')), findsOneWidget);
      print('PaymentCompletedScreen alcançado');
    });
  });
}