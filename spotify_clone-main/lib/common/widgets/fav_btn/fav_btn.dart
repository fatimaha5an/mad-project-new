import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/bloc/favourite_btn/fav_btn_cubit.dart';
import 'package:spotify/common/bloc/favourite_btn/fav_btn_state.dart';

import 'package:spotify/domain/entities/song/song.dart';

class FavBtn extends StatelessWidget {
  final SongEntity songEntity;
  final Function? function;
  const FavBtn({super.key, required this.songEntity, this.function});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavBtnCubit(),
      child: BlocBuilder<FavBtnCubit, FavBtnState>(
        builder: (context, state) {
          if (state is FavBtnInit) {
            print('Fav Btn Init');
            return IconButton(
              onPressed: () {
                context.read<FavBtnCubit>().favBtnUpdated(songEntity.songId);
              },
              icon: Icon(
                songEntity.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_outline_outlined,
                size: 35,
                color: Colors.red[400],
              ),
            );
          }
          if (state is FavBtnUpdated) {
            print('Fav Btn Updated');
            return IconButton(
              onPressed: () {
                context.read<FavBtnCubit>().favBtnUpdated(songEntity.songId);
              },
              icon: Icon(
                state.isFav ? Icons.favorite : Icons.favorite_outline_outlined,
                size: 35,
                color: Colors.red[400],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
