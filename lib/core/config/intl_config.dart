import 'package:intl/date_symbol_data_local.dart';

class IntlConfig {
  static Future<void> initialize() {
    return initializeDateFormatting('pt_BR', null);
  }
}