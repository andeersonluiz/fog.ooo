import 'package:fogooo/src/core/resources/data_state.dart';
import 'package:fogooo/src/core/resources/usecase.dart';
import 'package:fogooo/src/domain/repositories/player_repository.dart';

import '../../../core/resources/no_param_usecase.dart';
import '../../entities/player_entity.dart';

class GetSortedPlayerUseCase implements NoParamUseCase<DataState<Player>> {
  final PlayerRepository _playerRepository;
  GetSortedPlayerUseCase(this._playerRepository);
  @override
  Future<DataState<Player>> call() async {
    return await _playerRepository.getSortedPlayer();
  }
}
