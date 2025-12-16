import 'package:get_it/get_it.dart';
import 'package:spotify/data/repositoryimpl/auth/auth_repository_impl.dart';
import 'package:spotify/data/repositoryimpl/song/song_repo_impl.dart';
import 'package:spotify/data/sources/Songs/songFirebaseService.dart';
import 'package:spotify/data/sources/auth/auth_firebase_service.dart';
import 'package:spotify/domain/repository/auth/auth.dart';
import 'package:spotify/domain/repository/songRepo/SongRepo.dart';
import 'package:spotify/domain/usecases/Songs/getNewSongs.dart';
import 'package:spotify/domain/usecases/Songs/get_add_or_remove_fav_songs.dart';
import 'package:spotify/domain/usecases/Songs/get_fav_song.dart';
import 'package:spotify/domain/usecases/Songs/get_playList.dart';
import 'package:spotify/domain/usecases/Songs/is_fav_song.dart';
import 'package:spotify/domain/usecases/auth/get_user.dart';
import 'package:spotify/domain/usecases/auth/signin.dart';
import 'package:spotify/domain/usecases/auth/signup.dart';

final sl = GetIt.instance;
Future<void> initializeDependencies() async {
  sl.registerSingleton<AuthFirebaseService>(
    AuthFirebaseServiceImpl(),
  );

  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(),
  );

  sl.registerSingleton<SignupUseCase>(
    SignupUseCase(),
  );
  sl.registerSingleton<SigninUseCase>(
    SigninUseCase(),
  );
  sl.registerSingleton<Songfirebaseservice>(
    SongfirebaseserviceImpl(),
  );
  sl.registerSingleton<Songrepo>(
    SongRepoImpl(),
  );
  sl.registerSingleton<GetnewsongsUseCase>(
    GetnewsongsUseCase(),
  );
  sl.registerSingleton<GetPlaylistUseCase>(
    GetPlaylistUseCase(),
  );
  sl.registerSingleton<AddOrRemoveFavSongsUseCase>(
    AddOrRemoveFavSongsUseCase(),
  );
  sl.registerSingleton<IsFavouriteSongUseCase>(
    IsFavouriteSongUseCase(),
  );
  sl.registerSingleton<GetUserUseCase>(
    GetUserUseCase(),
  );
  sl.registerSingleton<GetFavoriteSongsUseCase>(
    GetFavoriteSongsUseCase(),
  );
}
