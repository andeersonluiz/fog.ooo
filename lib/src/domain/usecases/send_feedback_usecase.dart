import 'package:fogooo/src/core/resources/usecase.dart';
import 'package:fogooo/src/domain/repositories/player_repository.dart';
import 'package:tuple/tuple.dart';

class SendFeedbackUseCase
    extends UseCase<bool, Tuple4<String, String, String, String>> {
  final PlayerRepository _playerRepository;
  SendFeedbackUseCase(this._playerRepository);

  @override
  Future<bool> call(Tuple4<String, String, String, String> params) async {
    return await _playerRepository.sendFeedback(params);
  }
}
