abstract class Usecase<Type, Parameters> {
  Future<Type> call({Parameters params});
}
