
import 'package:lexilearnai/core/result/result.dart';
import 'package:lexilearnai/data/model/card/photo_response.dart';
import 'package:lexilearnai/domain/entities/card/card.dart';

abstract class CardRepository  {
  Future<Result<CardEntity>> addCard(String word);
  Future<Result<PhotoResponse>> getPhoto(String id);
}
