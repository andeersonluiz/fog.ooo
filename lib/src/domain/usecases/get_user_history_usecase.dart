import 'package:fogooo/src/core/resources/no_param_no_future.dart';
import 'package:fogooo/src/domain/entities/user_history_entity.dart';
import 'package:fogooo/src/domain/repositories/player_repository.dart';

class GetUserHistoryUseCase extends NoParamNoFutureUseCase<UserHistory> {
  final PlayerRepository _playerRepository;
  GetUserHistoryUseCase(this._playerRepository);
  @override
  UserHistory call() {
    return _playerRepository.getUserHistory();
  }
}
