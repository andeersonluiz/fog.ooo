import 'package:fogooo/src/core/resources/no_param_usecase.dart';
import 'package:fogooo/src/core/resources/usecase.dart';
import 'package:fogooo/src/domain/repositories/player_repository.dart';

import '../../../core/resources/data_state.dart';
import '../../entities/player_entity.dart';

class GetAllPlayersUseCase implements NoParamUseCase<DataState<List<Player>>> {
  final PlayerRepository _playerRepository;
  GetAllPlayersUseCase(this._playerRepository);
  @override
  Future<DataState<List<Player>>> call() async {
    return await _playerRepository.getAllPlayers();
  }
}
