import 'package:dingtea/domain/handlers/handlers.dart';
import 'package:dingtea/infrastructure/models/models.dart';

abstract class CurrenciesRepositoryFacade {
  Future<ApiResult<CurrenciesResponse>> getCurrencies();
}
