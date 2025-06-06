import 'package:flutter/material.dart';
import 'package:automation_test_flutter/core/di/injection.dart';
import 'package:automation_test_flutter/domain/usecases/fetch_crypto_data_usecase.dart';
import 'package:automation_test_flutter/services/logger_service.dart';

class CryptoScreen extends StatefulWidget {
  const CryptoScreen({super.key});

  @override
  _CryptoScreenState createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  final FetchCryptoDataUseCase _useCase = getIt<FetchCryptoDataUseCase>();
  List<dynamic> _cryptoList = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCryptoData();
  }

  Future<void> _fetchCryptoData() async {
    try {
      final cryptoList = await _useCase.execute();
      setState(() {
        _cryptoList = cryptoList;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      LoggerService.error('Erro ao buscar dados de criptomoedas', e, stackTrace);
      setState(() {
        _errorMessage = 'Erro ao carregar dados: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criptomoedas')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : RefreshIndicator(
                  onRefresh: _fetchCryptoData,
                  child: ListView.builder(
                    itemCount: _cryptoList.length,
                    itemBuilder: (context, index) {
                      final crypto = _cryptoList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: ListTile(
                          leading: Image.network(crypto.image, width: 40, errorBuilder: (_, __, ___) => const Icon(Icons.error)),
                          title: Text(crypto.name),
                          subtitle: Text(crypto.symbol.toUpperCase()),
                          trailing: Text('\$${crypto.currentPrice.toStringAsFixed(2)}'),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}