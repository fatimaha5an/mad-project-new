import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/usecases/auth/get_user.dart';
import 'package:spotify/presentation/pages/profile/bloc/profile_state.dart';
import 'package:spotify/service_locater.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileLoading());
  Future<void> getUser() async {
    var user = await sl<GetUserUseCase>().call();
    user.fold((l) {
      emit(ProfileFailure());
    }, (userEntity) {
      emit(ProfileLoaded(userEntity: userEntity));
    });
  }
}
