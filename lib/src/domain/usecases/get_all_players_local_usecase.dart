import 'package:fogooo/src/core/resources/no_param_no_future.dart';
import 'package:fogooo/src/domain/entities/player_entity.dart';
import 'package:fogooo/src/domain/repositories/player_repository.dart';

class GetAllPlayerLocalUseCase implements NoParamNoFutureUseCase<List<Player>> {
  final PlayerRepository _playerRepository;
  GetAllPlayerLocalUseCase(this._playerRepository);
  @override
  List<Player> call() {
    return _playerRepository.getAllPlayersLocal();
  }
}
