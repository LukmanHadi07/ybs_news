import 'package:yb_news/core/errors/exceptions.dart';
import 'package:yb_news/core/network/dio_client.dart';
import 'package:yb_news/features/auth/data/models/login_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
    required String deviceId,
  });

  Future<String> verifyOtp({
    required String otp,
    required String optToken,
    required String userId,
    required String deviceId,
    required String sessionId,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _client;

  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
    required String deviceId,
  }) async {
    final response = await _client.post<LoginResponseModel>(
      '/auth/login',
      data: {'email': email, 'password': password, 'deviceId': deviceId},
      parser: (json) {
        if (json is! Map<String, dynamic>) {
          throw const ServerException(message: 'Invalid login response');
        }
        return LoginResponseModel.fromJson(json);
      },
    );
    return response.data;
  }

  @override
  Future<String> verifyOtp({
    required String otp,
    required String optToken,
    required String userId,
    required String deviceId,
    required String sessionId,
  }) async {
    final data = <String, dynamic>{
      'otp': otp,
      'userId': userId,
      'deviceId': deviceId,
    };
    if (optToken.isNotEmpty) {
      data['otpToken'] = optToken;
    }
    if (sessionId.isNotEmpty) {
      data['sessionId'] = sessionId;
    }

    final response = await _client.post<Map<String, dynamic>>(
      '/auth/verify-otp',
      data: data,
      parser: (json) {
        if (json is! Map<String, dynamic>) {
          throw const ServerException(message: 'Invalid verify otp response');
        }
        return json;
      },
    );

    String? _stringOrNull(dynamic value) {
      if (value == null) return null;
      final text = value.toString();
      if (text.isEmpty || text == 'null') return null;
      return text;
    }

    final sessionIdFromBody = _stringOrNull(
      response.data['sessionId'] ??
          response.data['session_id'] ??
          response.data['accessToken'] ??
          response.data['access_token'] ??
          response.data['token'] ??
          response.data['jwt'],
    );

    if (sessionIdFromBody == null) {
      throw const ServerException(message: 'Session ID is missing');
    }

    return sessionIdFromBody;
  }
}
