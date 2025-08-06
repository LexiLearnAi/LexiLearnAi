import 'package:lexilearnai/data/model/card/card.dart' as model;
import 'package:lexilearnai/domain/entities/card/card.dart';

class CardMapper {
  static CardEntity toEntity(model.Card card) {
    return CardEntity(
      id: card.id ?? '',
      word: card.word ?? '',
      types: card.types?.map((type) => _toTypeEntity(type)).toList() ?? [],
    );
  }

  static model.Card toModel(CardEntity entity) {
    return model.Card(
      id: entity.id,
      word: entity.word,
      types: entity.types.map((type) => _toTypeModel(type)).toList(),
    );
  }

  static TypeEntity _toTypeEntity(model.Types type) {
    return TypeEntity(
      id: "",
      type: type.type ?? '',
      level: type.level ?? '',
      definition: type.definition ?? [],
      synonym: type.synonym ?? [],
      sentence: type.sentence ?? [],
      photoDescription: type.photoDescription ?? '',
      photo: type.photo ?? '',
    );
  }

  static model.Types _toTypeModel(TypeEntity entity) {
    return model.Types(
      id: entity.id,
      type: entity.type,
      level: entity.level,
      definition: entity.definition,
      synonym: entity.synonym,
      sentence: entity.sentence,
      photoDescription: entity.photoDescription,
      
    );
  }
}
