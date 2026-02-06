import 'package:fpdart/fpdart.dart';

import '../errors/failures.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef JsonMap = Map<String, dynamic>;
