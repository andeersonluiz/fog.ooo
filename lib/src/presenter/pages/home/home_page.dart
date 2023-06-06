import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fogooo/src/domain/repositories/player_repository.dart';
import 'package:fogooo/src/presenter/pages/home/widgets/guess_player_widget.dart';
import 'package:fogooo/src/presenter/state_management/bloc/player/player_event.dart';
import 'package:fogooo/src/presenter/state_management/bloc/player/player_state.dart';
import 'package:provider/provider.dart';

import '../../state_management/bloc/player/player_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PlayerBloc playerBloc;
  @override
  void initState() {
    playerBloc = context.read<PlayerBloc>();
    playerBloc.add(const LoadDataEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/bg_bota.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocBuilder<PlayerBloc, PlayerState>(
            builder: (ctx, state) {
              if (state is PlayerLoadingState || state is PlayerEmptyState) {
                return CircularProgressIndicator();
              } else {
                return GuessPlayerWidget(
                  guessPlayers: state.guessList,
                  players: state.playersList,
                  sortedPlayer: state.sortedPlayer!,
                  isCompleted: state is PlayerFinishedState,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
