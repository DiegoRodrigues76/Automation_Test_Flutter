import 'package:automation_test_flutter/presentation/components/button_component.dart';
import 'package:flutter/material.dart';
import 'package:automation_test_flutter/presentation/routes/app_routes.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZemaButtonComponent(
              label: 'Formulários',
              buttonName: 'formularios_menu',
              key: const Key('formularios_button'), // Added key
              action: () {
                Navigator.pushNamed(context, AppRoutes.form1);
              },
            ),
            const SizedBox(height: 20),
            ZemaButtonComponent(
              label: 'Criptomoedas',
              buttonName: 'criptomoedas_menu',
              key: const Key('criptomoedas_button'), // Added key for consistency
              action: () {
                Navigator.pushNamed(context, AppRoutes.crypto);
              },
            ),
          ],
        ),
      ),
    );
  }
}