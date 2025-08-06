class CardEntity {
  final String id;

  final String word;
  
  List<TypeEntity> types;

  CardEntity({
    required this.id,
    required this.word,
    required this.types,
  });

  // copyWith metodu
  CardEntity copyWith({
    String? id,
    bool? success,
    String? reason,
    String? word,
    List<TypeEntity>? types,
  }) {
    return CardEntity(
      id: id ?? this.id,
      word: word ?? this.word,
      types: types ?? this.types,
    );
  }
}

class TypeEntity {
  final String type;
  final String level;
  List<String> definition;
  List<String> synonym;
  List<String> sentence;
  final String photoDescription;
  String? photo;
  
  String id;
 

  TypeEntity({
    required this.id,
    required this.type,
    required this.level,
    required this.definition,
    required this.synonym,
    required this.sentence,
    required this.photoDescription,
    this.photo,
  });
}
