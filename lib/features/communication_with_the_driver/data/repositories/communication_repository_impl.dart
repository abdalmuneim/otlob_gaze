import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/exception.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/common/network_info.dart';
import 'package:otlob_gas/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:otlob_gas/features/communication_with_the_driver/data/datasources/communicate_remote_data_source.dart';
import 'package:otlob_gas/features/communication_with_the_driver/data/models/chat_message_model.dart';
import 'package:otlob_gas/features/communication_with_the_driver/data/models/chat_model.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/repositories/communication_repository.dart';

class CommunicationRepositoryImpl implements CommunicationRepository {
  final CommunicationRemoteDataSource remoteDataSource;

  final AuthLocalDataSource localDataSource;

  final NetworkInfo networkInfo;

  CommunicationRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, ChatModel>> getChat({required String orderId}) async {
    try {
      final String? token = await localDataSource.getUserToken;
      if (token == null) {
        throw UnAuthorizedException();
      }
      final chatMessages = await remoteDataSource.getChat(
        orderId: orderId,
        token: token,
      );

      return Right(chatMessages);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatMessageModel>> sendMessage({
    required String message,
    required String type,
    required String messageId,
    required String orderId,
  }) async {
    try {
      final String? token = await localDataSource.getUserToken;
      if (token == null) {
        throw UnAuthorizedException();
      }
      final chatMessage = await remoteDataSource.sendMessage(
        message: message,
        messageId: messageId,
        type: type,
        orderId: orderId,
        token: token,
      );

      return Right(chatMessage);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> disconnectPusher() async {
    try {
      await remoteDataSource.disconnectPusher();

      return const Right(unit);
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> initPusher({required int orderId}) async {
    try {
      await remoteDataSource.initPusher(orderId: orderId);

      return const Right(unit);
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Stream<ChatMessageModel> listenToChat() {
    return remoteDataSource.listenToChat();
  }
}
