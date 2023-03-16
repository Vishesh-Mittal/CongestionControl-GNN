import '../errors/failures.dart';

const String SERVER_FAILURE_MESSAGE = "There seems to be some problem with the server."; // ignore: constant_identifier_names
const String SOCKET_FAILURE_MESSAGE = "Connection to the server failed."; // ignore: constant_identifier_names
const String TIMEOUT_FAILURE_MESSAGE = "Request to server timed out."; // ignore: constant_identifier_names
const String UNEXPECTED_FAILURE_MESSAGE = "An unexpected error has occurred."; // ignore: constant_identifier_names

///Allows passing different message for different [Failure] types
String mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case SocketFailure:
      return SOCKET_FAILURE_MESSAGE;
    case TimeOutFailure:
      return TIMEOUT_FAILURE_MESSAGE;
    default:
      return UNEXPECTED_FAILURE_MESSAGE;
  }
}