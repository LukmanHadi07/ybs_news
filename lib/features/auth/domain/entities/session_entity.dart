// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class SessionEntity extends Equatable {
  final String sessionId;
  final String userId;
  final String deviceId;
  const SessionEntity({
    required this.sessionId,
    required this.userId,
    required this.deviceId,
  });

  @override
  List<Object?> get props => [sessionId, userId, deviceId];
}
