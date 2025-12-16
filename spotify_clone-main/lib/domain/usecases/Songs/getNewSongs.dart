import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/repository/songRepo/SongRepo.dart';
import 'package:spotify/service_locater.dart';

class GetnewsongsUseCase implements Usecase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<Songrepo>().getNewsSongs();
  }
}
