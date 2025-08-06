

import 'package:lexilearnai/common/di/service_locator.dart';
import 'package:lexilearnai/core/result/result.dart';
import 'package:lexilearnai/data/model/card/photo_response.dart';
import 'package:lexilearnai/data/sources/card/card_supabase_service.dart';
import 'package:lexilearnai/domain/entities/card/card.dart';
import 'package:lexilearnai/domain/repository/card/card.dart';

class CardRepositoryImpl extends CardRepository {
  @override
  Future<Result<CardEntity>> addCard(String word) async {
    return await serviceLocator<CardSupabaseService>().askForCard(word);
  }

  @override
  Future<Result<PhotoResponse>> getPhoto(String id) {
    return serviceLocator<CardSupabaseService>().askForPhoto(id);
  }
}
