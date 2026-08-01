/// Base failure class for clean error handling across domain & data layers.
abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.statusCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network connection failure']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache retrieval failure']);
}
