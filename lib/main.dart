import 'package:flutter/material.dart'; 
import 'screens/form_screen1.dart'; 

// Função principal que inicia o aplicativo
void main() {
  runApp(const MyApp());
}

// Classe principal do aplicativo
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulários com Reactive Forms', 
      theme: ThemeData(primarySwatch: Colors.blue), 
      home: const FormScreen1(), // Define a tela inicial do aplicativo
    );
  }
}
