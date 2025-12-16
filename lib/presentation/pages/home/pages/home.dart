import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/presentation/pages/home/bloc/new_songs_cubit.dart';
import 'package:spotify/presentation/pages/home/bloc/play_list_cubit.dart';
import 'package:spotify/presentation/pages/home/pages/home_page_view.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NewSongsCubit()..getNewSongs(),
        ),
        BlocProvider(
          create: (context) => PlayListCubit()..getPlayList(),
        ),
      ],
      child: const HomePageView(),
    );
  }
}
