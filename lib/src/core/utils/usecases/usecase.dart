import 'package:dartz/dartz.dart';
import 'package:new_york_times/src/core/network/error/failures.dart';

abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams {}
