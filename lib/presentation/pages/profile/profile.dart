import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/presentation/pages/profile/bloc/profile_cubit.dart';
import 'package:spotify/presentation/pages/profile/bloc/fav_songs_cubit.dart';
import 'package:spotify/presentation/pages/profile/pages/profile_page_view.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProfileCubit()..getUser(),
        ),
        BlocProvider(
          create: (context) => FavoriteSongsCubit()..getFavoriteSongs(),
        ),
      ],
      child: const ProfilePageView(),
    );
  }
}
