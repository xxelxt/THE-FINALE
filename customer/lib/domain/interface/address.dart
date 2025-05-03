import 'package:dingtea/domain/handlers/handlers.dart';
import 'package:dingtea/infrastructure/models/models.dart';

abstract class AddressRepositoryFacade {
  Future<ApiResult<AddressesResponse>> getUserAddresses();

  Future<ApiResult<void>> deleteAddress(int addressId);

  Future<ApiResult<SingleAddressResponse>> createAddress(
    LocalAddressData address,
  );
}
