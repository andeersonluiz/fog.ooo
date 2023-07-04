import 'package:fogooo/src/core/resources/usecase.dart';
import 'package:fogooo/src/domain/entities/user_history_entity.dart';
import 'package:fogooo/src/domain/repositories/player_repository.dart';

class SetUserHistoryUseCase extends UseCase<bool, UserHistory> {
  final PlayerRepository _playerRepository;
  SetUserHistoryUseCase(this._playerRepository);
  @override
  Future<bool> call(UserHistory params) async {
    return await _playerRepository.setUserHistory(params);
  }
}
