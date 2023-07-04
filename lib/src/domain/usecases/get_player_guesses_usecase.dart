import 'package:fogooo/src/domain/entities/player_entity.dart';
import 'package:fogooo/src/domain/repositories/player_repository.dart';
import '../../core/resources/no_param_usecase.dart';

class GetAllPlayerGuessesUseCase implements NoParamUseCase<List<Player>> {
  final PlayerRepository _playerRepository;
  GetAllPlayerGuessesUseCase(this._playerRepository);
  @override
  Future<List<Player>> call() async {
    return await _playerRepository.getPlayerGuesses();
  }
}
