# Prova de Conceito (POC) - Teste Automatizado com Flutter

Este projeto tem como objetivo a realização de uma POC para um teste automatizado, implementando um fluxo de formulários utilizando **Reactive Forms**.

## 📌 Funcionalidades
- Criar **5 telas** com formulários.
- Implementar **preenchimento de formulário** em cada tela.
- Criar **navegação** para a próxima tela.
- Utilizar **Reactive Forms** para o gerenciamento dos formulários.

## 🚀 Tecnologias Utilizadas
- [Reactive Forms](https://pub.dev/packages/reactive_forms)
- Flutter

## 📖 Como Executar o Projeto
### Pré-requisitos
Antes de começar, certifique-se de ter instalado:
- [Flutter](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)
- Um editor de código (recomendado: Visual Studio Code ou Android Studio)

### Passos para executar
1. **Clone o repositório**
   ```sh
   git clone https://github.com/DiegoRodrigues76/Automation_Test_Flutter.git
   ```
2. **Acesse a pasta do projeto**
   ```sh
   cd Automation_Test_Flutter
   ```
3. **Instale as dependências**
   ```sh
   flutter pub get
   ```
4. **Execute o projeto**
   ```sh
   flutter run
   ```

## 📌 Estrutura do Projeto
```
|-- lib/
|   |-- main.dart          # Ponto de entrada do aplicativo
|   |-- screens/
|   |   |-- screen1.dart   # Primeira tela do formulário
|   |   |-- screen2.dart   # Segunda tela do formulário
|   |   |-- ...           # Demais telas
|   |-- widgets/
|   |   |-- form_widget.dart # Componente de formulário reutilizável
|-- pubspec.yaml           # Dependências do projeto
|-- README.md              # Documentação do projeto
```

## 📋 Testes
Para rodar os testes automatizados, utilize o comando:
```sh
flutter test
```

## 📌 Referências
- [Documentação oficial do Flutter](https://flutter.dev/docs)
- [Pacote Reactive Forms](https://pub.dev/packages/reactive_forms)
