import 'package:fogooo/src/core/resources/mapper.dart';
import 'package:fogooo/src/data/models/club_model.dart';
import 'package:fogooo/src/data/models/nationality_model.dart';
import 'package:fogooo/src/data/models/player_model.dart';
import 'package:fogooo/src/domain/entities/club_entity.dart';

import '../../domain/entities/nationality_entity.dart';
import '../../domain/entities/player_entity.dart';

class PlayerMapper implements Mapper<Player, PlayerModel> {
  @override
  entityToModel(entity) {
    return PlayerModel(
        id: entity.id,
        name: entity.name,
        age: entity.age,
        caseSearch: entity.caseSearch,
        clubHistory: entity.clubHistory
            .map<ClubModel>((e) => ClubModel(
                id: e.id,
                clubName: e.clubName,
                country: e.country,
                image: e.image))
            .toList(),
        goals: entity.goals,
        imageUrl: entity.imageUrl,
        infoUrl: entity.infoUrl,
        matches: entity.matches,
        playedTeam: entity.playedTeam,
        nationality: NationalityModel(
            id: entity.nationality.id,
            country: entity.nationality.country,
            image: entity.nationality.image),
        oficialName: entity.oficialName,
        pos: entity.pos,
        yearsPlayed: entity.yearsPlayed,
        yearsPlayedInterval: entity.yearsPlayedInterval);
  }

  @override
  modelToEntity(model) {
    return Player(
        id: model.id,
        name: model.name,
        age: model.age,
        caseSearch: model.caseSearch,
        clubHistory: model.clubHistory
            .map<Club>((m) => Club(
                id: m.id,
                clubName: m.clubName,
                country: m.country,
                image: m.image))
            .toList(),
        goals: model.goals,
        imageUrl: model.imageUrl,
        infoUrl: model.infoUrl,
        playedTeam: model.playedTeam,
        matches: model.matches,
        nationality: Nationality(
            id: model.nationality.id,
            country: model.nationality.country,
            image: model.nationality.image),
        oficialName: model.oficialName,
        pos: model.pos,
        yearsPlayed: model.yearsPlayed,
        yearsPlayedInterval: model.yearsPlayedInterval);
  }
}
