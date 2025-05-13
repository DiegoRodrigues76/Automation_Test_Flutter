import 'package:flutter/material.dart'; // Necessário para usar Key
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:automation_test_flutter/main.dart' as app; // Ajuste se seu nome for diferente

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Fluxo completo do formulário com Pix', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // === TELA 1 ===
    final nomeField = find.byKey(Key('nomeField'));
    final emailField = find.byKey(Key('emailField'));
    final telefoneField = find.byKey(Key('telefoneField'));

    await tester.enterText(nomeField, 'João Silva');
    await tester.enterText(emailField, 'joao@email.com');
    await tester.enterText(telefoneField, '11999999999');

    await tester.pumpAndSettle();

    final botaoAvancar1 = find.text('Avançar');
    expect(botaoAvancar1, findsOneWidget);
    await tester.tap(botaoAvancar1);
    await tester.pumpAndSettle();

    // === TELA 2 ===
    final dropdownNacionalidade = find.byKey(Key('nacionalidadeDropdown'));
    await tester.tap(dropdownNacionalidade);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Brasil').last);
    await tester.pumpAndSettle();

    final cepField = find.byKey(Key('cepField'));
    await tester.enterText(cepField, '01001-000');
    await tester.pumpAndSettle();

    final botaoAvancar2 = find.text('Avançar');
    await tester.tap(botaoAvancar2);
    await tester.pumpAndSettle();

    // === TELA 3 ===
    final radioPix = find.byKey(Key('payment_pix'));
    await tester.tap(radioPix);
    await tester.pumpAndSettle();

    final botaoAvancar3 = find.text('Avançar');
    await tester.tap(botaoAvancar3);
    await tester.pumpAndSettle();

    // === TELA 4 ===
    expect(find.textContaining('Pix'), findsWidgets);
    final botaoConfirmar4 = find.text('Avançar');
    await tester.tap(botaoConfirmar4);
    await tester.pumpAndSettle();

    // === TELA 5 ===
    expect(find.textContaining('PIX'), findsWidgets);
    final botaoConfirmar5 = find.text('Confirmar Pagamento');
    await tester.tap(botaoConfirmar5);
    await tester.pumpAndSettle();

    // === PAGAMENTO CONCLUÍDO ===
    expect(find.text('Pagamento Confirmado!'), findsOneWidget);
  });
}
