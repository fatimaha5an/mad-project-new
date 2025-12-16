abstract class FavBtnState {}

class FavBtnInit extends FavBtnState {}

class FavBtnUpdated extends FavBtnState {
  final bool isFav;
  FavBtnUpdated({required this.isFav});
}
