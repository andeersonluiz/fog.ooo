import 'package:fogooo/src/core/resources/no_param_usecase.dart';
import 'package:fogooo/src/domain/repositories/player_repository.dart';

class GetOrderNumberUseCase extends NoParamUseCase<int> {
  final PlayerRepository _playerRepository;
  GetOrderNumberUseCase(this._playerRepository);
  @override
  Future<int> call() async {
    return await _playerRepository.getOrderNumber();
  }
}
