import 'package:fogooo/src/domain/entities/player_entity.dart';
import 'package:fogooo/src/domain/repositories/player_repository.dart';

import '../../core/resources/no_param_no_future.dart';

class GetSortedPlayerLocalUseCase implements NoParamNoFutureUseCase<Player?> {
  final PlayerRepository _playerRepository;
  GetSortedPlayerLocalUseCase(this._playerRepository);
  @override
  Player? call() {
    return _playerRepository.getSortedPlayerLocal();
  }
}
