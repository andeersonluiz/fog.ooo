import 'package:fogooo/src/core/resources/usecase.dart';
import 'package:fogooo/src/domain/repositories/player_repository.dart';

import '../../core/resources/data_state.dart';
import '../entities/player_entity.dart';

class AddPlayerGuessesUseCase implements UseCase<DataState<bool>, Player> {
  final PlayerRepository _playerRepository;
  AddPlayerGuessesUseCase(this._playerRepository);
  @override
  Future<DataState<bool>> call(Player params) async {
    return await _playerRepository.addPlayerGuesses(params);
  }
}
