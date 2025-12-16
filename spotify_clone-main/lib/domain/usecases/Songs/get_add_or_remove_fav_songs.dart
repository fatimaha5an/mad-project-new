import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/repository/songRepo/SongRepo.dart';
import 'package:spotify/service_locater.dart';

class AddOrRemoveFavSongsUseCase implements Usecase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<Songrepo>().addOrRemoveFavourites(params!);
  }
}