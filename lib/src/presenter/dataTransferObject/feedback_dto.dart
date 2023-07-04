// ignore: file_names
import 'package:fogooo/src/domain/usecases/send_feedback_usecase.dart';
import 'package:tuple/tuple.dart';

class FeedbackDTO {
  final SendFeedbackUseCase sendFeedbackUseCase;

  FeedbackDTO(this.sendFeedbackUseCase);
  Future<bool> sendFeedback(Tuple4<String, String, String, String> data) async {
    return await sendFeedbackUseCase(data);
  }
}
