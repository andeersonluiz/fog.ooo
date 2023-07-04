import 'package:fogooo/src/data/models/user_history_model.dart';
import 'package:fogooo/src/data/models/victory_info_model.dart';
import 'package:fogooo/src/domain/entities/user_history_entity.dart';
import 'package:fogooo/src/domain/entities/victory_info_entity.dart';

import '../../core/resources/mapper.dart';

class HistoryMapper extends Mapper<UserHistory, UserHistoryModel> {
  @override
  UserHistoryModel entityToModel(UserHistory entity) {
    return UserHistoryModel(
        victorys: entity.victorys,
        streaks: entity.streaks,
        victoryList: entity.victoryList
            .map<VictoryInfoModel>(
                (e) => VictoryInfoModel(date: e.date, attempts: e.attempts))
            .toList());
  }

  @override
  UserHistory modelToEntity(UserHistoryModel model) {
    return UserHistory(
        victorys: model.victorys,
        streaks: model.streaks,
        victoryList: model.victoryList
            .map<VictoryInfo>(
                (m) => VictoryInfo(date: m.date, attempts: m.attempts))
            .toList());
  }
}
