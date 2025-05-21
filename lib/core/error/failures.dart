import 'package:equatable/equatable.dart';

/// Base class for all failures in the application.
///
/// This abstract class serves as the foundation for different types of failures
/// that can occur in the application. It extends [Equatable] to provide value equality
/// and implements proper error message handling.
abstract class Failure extends Equatable {
  /// The error message describing the failure.
  final String message;

  /// Creates a new [Failure] instance with the specified error message.
  ///
  /// Parameters:
  ///   - message: A descriptive message explaining the failure.
  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

/// Represents failures that occur during server communication.
///
/// This includes API errors, network timeouts, and other server-related issues.
class ServerFailure extends Failure {
  /// Creates a new [ServerFailure] instance with the specified error message.
  ///
  /// Parameters:
  ///   - message: A descriptive message explaining the server failure.
  const ServerFailure({required super.message});
}

/// Represents failures that occur during cache operations.
///
/// This includes reading/writing to local storage, SharedPreferences, etc.
class CacheFailure extends Failure {
  /// Creates a new [CacheFailure] instance with the specified error message.
  ///
  /// Parameters:
  ///   - message: A descriptive message explaining the cache failure.
  const CacheFailure({required super.message});
}

/// Represents failures related to network connectivity.
///
/// This includes internet connection issues, DNS failures, etc.
class NetworkFailure extends Failure {
  /// Creates a new [NetworkFailure] instance with the specified error message.
  ///
  /// Parameters:
  ///   - message: A descriptive message explaining the network failure.
  const NetworkFailure({required super.message});
}
