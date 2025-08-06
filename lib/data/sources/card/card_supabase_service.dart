import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:lexilearnai/core/model/failure/error_response.dart';
import 'package:lexilearnai/core/network/model/base_response.dart';
import 'package:lexilearnai/core/result/result.dart';
import 'package:lexilearnai/data/mapper/card_mapper.dart';
import 'package:lexilearnai/data/model/card/card.dart';
import 'package:lexilearnai/data/model/card/photo_response.dart';
import 'package:lexilearnai/domain/entities/card/card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CardSupabaseService {
  Future<Result<CardEntity>> askForCard(String word);
  Future<Result<PhotoResponse>> askForPhoto(String wordTypeId);
  Future<Result<void>> addCard(CardEntity card);
}

class CardSupabaseServiceImpl extends CardSupabaseService {
  final supabase = Supabase.instance.client;
  @override
  Future<Result<CardEntity>> askForCard(String word) async {
    try {
      final res = await supabase.functions.invoke(
        'create-card',
        body: {'word': word},
      );

      log(res.data.toString());
      if (res.status == 200) {
        final succesResponse = BaseResponse.fromJson(res.data);
        final card = Card.fromJson(succesResponse.data);
        final cardEntity = CardMapper.toEntity(card);

        return Result.success(cardEntity);
      } else {
        final errorResponse = ErrorResponse.fromJson(res.data);
        return Result.failure(errorResponse.message);
      }
    } catch (e) {
      if (e is DioException) {
        return Result.failure(e.response?.data ?? e.message);
      }

      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<PhotoResponse>> askForPhoto(String wordTypeId) async {
    try {
      final res = await supabase.functions.invoke(
        'create-image',
        body: {'type_id': "4cee9e7e-47e0-4726-86fb-054dc4204b3c"},
      );
      if (res.status == 200) {
        final succesResponse = BaseResponse.fromJson(res.data);
        final photoUrls = PhotoResponse.fromJson(succesResponse.data);
        log(photoUrls.originalUrl.toString());
        return Result.success(photoUrls);
      } else {
        final errorResponse = ErrorResponse.fromJson(res.data);
        return Result.failure(errorResponse.message);
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
  
  @override
  Future<Result<void>> addCard(CardEntity card) {
    return throw UnimplementedError();
  }
}
