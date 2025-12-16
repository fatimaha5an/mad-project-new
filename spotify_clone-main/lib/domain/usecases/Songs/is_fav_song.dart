import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/repository/songRepo/SongRepo.dart';
import 'package:spotify/service_locater.dart';

class IsFavouriteSongUseCase implements Usecase<bool, String> {
  @override
  Future<bool> call({String? params}) async {
    return await sl<Songrepo>().isFavouriteSong(params!);
  }
}
