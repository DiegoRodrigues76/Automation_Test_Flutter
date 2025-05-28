// lib/core/di/injection.dart
import 'package:get_it/get_it.dart';
import 'package:automation_test_flutter/data/datasources/address_datasource.dart';
import 'package:automation_test_flutter/data/repositories/address_repository_impl.dart';
import 'package:automation_test_flutter/data/repositories/payment_code_repository_impl.dart';
import 'package:automation_test_flutter/domain/repositories/address_repository.dart';
import 'package:automation_test_flutter/domain/repositories/payment_code_repository.dart';
import 'package:automation_test_flutter/domain/usecases/create_personal_info_usecase.dart';
import 'package:automation_test_flutter/domain/usecases/create_address_usecase.dart';
import 'package:automation_test_flutter/domain/usecases/fetch_address_usecase.dart';
import 'package:automation_test_flutter/domain/usecases/create_payment_info_usecase.dart';
import 'package:automation_test_flutter/domain/usecases/create_payment_details_usecase.dart';
import 'package:automation_test_flutter/services/logger_service.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  LoggerService.info('Inicializando dependências...');

  try {
    // DataSources
    getIt.registerSingleton<AddressDataSource>(AddressDataSourceImpl());
    LoggerService.debug('AddressDataSource registrado');

    // Repositories
    getIt.registerSingleton<AddressRepository>(
      AddressRepositoryImpl(getIt<AddressDataSource>()),
    );
    getIt.registerSingleton<PaymentCodeRepository>(PaymentCodeRepositoryImpl());
    LoggerService.debug('Repositories registrados');

    // Use Cases
    getIt.registerFactory<CreatePersonalInfoUseCase>(() => CreatePersonalInfoUseCase());
    getIt.registerFactory<CreateAddressUseCase>(() => CreateAddressUseCase());
    getIt.registerFactory<FetchAddressUseCase>(
      () => FetchAddressUseCase(getIt<AddressRepository>()),
    );
    getIt.registerFactory<CreatePaymentInfoUseCase>(() => CreatePaymentInfoUseCase());
    getIt.registerFactory<CreatePaymentDetailsUseCase>(() => CreatePaymentDetailsUseCase());
    LoggerService.debug('Use Cases registrados');

    LoggerService.info('Dependências inicializadas com sucesso');
  } catch (e, stackTrace) {
    LoggerService.error('Erro ao inicializar dependências', e, stackTrace);
    rethrow;
  }
}