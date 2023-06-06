import 'package:flutter/material.dart';
import 'package:fogooo/src/domain/usecases/get_sorted_player_local_usecase.dart';
import 'package:fogooo/src/injection.dart';
import 'package:fogooo/src/presenter/pages/home/home_page.dart';
import 'package:fogooo/src/presenter/state_management/valueNotifier/time_notifier.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sup;
import 'src/data/datasource/remote/supabase_handler.dart';
import 'src/domain/usecases/add_player_guesses_usecase.dart';
import 'src/domain/usecases/get_all_players_local_usecase.dart';
import 'src/domain/usecases/get_player_guesses_usecase.dart';
import 'src/presenter/state_management/bloc/player/player_bloc.dart';
import 'src/presenter/theme/custom_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await sup.Supabase.initialize(
    url: 'https://ipdtvdirxguprgdqeajj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlwZHR2ZGlyeGd1cHJnZHFlYWpqIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODUzODMyMDUsImV4cCI6MjAwMDk1OTIwNX0.fto3D_Itro7GyNpikzdVmxMpgZIV1ihSlJr2mqjdoug',
  );
  var supabase = SupabaseHandler();
  //print((await supabase.getAllPlayers()).left.first);
  //print((await supabase.getSortedPlayer()).left);

  runApp(MaterialApp(
      theme: CustomTheme.theme(),
      home: Injector(
          child: MultiProvider(providers: [
        Provider<PlayerBloc>(
          create: (context) => PlayerBloc(
              addPlayerGuessesUseCase: context.read<AddPlayerGuessesUseCase>(),
              getAllPlayerGuessesUseCase:
                  context.read<GetAllPlayerGuessesUseCase>(),
              getAllPlayerLocalUseCase:
                  context.read<GetAllPlayerLocalUseCase>(),
              getSortedPlayerLocalUseCase:
                  context.read<GetSortedPlayerLocalUseCase>()),
        ),
        Provider<TimeNotifier>(
          create: (context) => TimeNotifier(),
        )
      ], child: HomePage()))));
}
