import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/repository/songRepo/SongRepo.dart';
import 'package:spotify/service_locater.dart';

class GetPlaylistUseCase implements Usecase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<Songrepo>().getPlaylist();
  }
}