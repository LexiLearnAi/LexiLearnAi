class Card {
  bool? success;
  String? reason;
  String? word;
  List<Types>? types;
  String? id;
  

  Card({
    this.success,
    this.reason,
    this.word,
    this.types,
    this.id,
    
  });

  Card.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    reason = json['reason'];
    word = json['word'];
    if (json['types'] != null) {
      types = <Types>[];
      json['types'].forEach((v) {
        types!.add(Types.fromJson(v));
      });
    }
    id = json['id'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['reason'] = reason;
    data['word'] = word;
    if (types != null) {
      data['types'] = types!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    return data;
  }
}

class Types {
  String? type;
  String? level;
  String? frequency;
  List<String>? definition;
  List<String>? synonym;
  List<String>? antonym;
  List<String>? collocations;
  List<String>? sentence;
  String? photoDescription;
  String? photo;
  String? id;

  Types({
    this.type,
    this.level,
    this.frequency,
    this.definition,
    this.synonym,
    this.antonym,
    this.collocations,
    this.sentence,
    this.photoDescription,
    this.id,
  });

  Types.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    level = json['level'];
    frequency = json['frequency'];
    definition = json['definition']?.cast<String>();
    synonym = json['synonym']?.cast<String>();
    antonym = json['antonym']?.cast<String>();
    collocations = json['collocations']?.cast<String>();
    sentence = json['sentence']?.cast<String>();
    photoDescription = json['photo_description'];
    photo = json['photo'];
    id = json['id'];  
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['level'] = level;
    data['frequency'] = frequency;
    data['definition'] = definition;
    data['synonym'] = synonym;
    data['antonym'] = antonym;
    data['collocations'] = collocations;
    data['sentence'] = sentence;
    data['photo_description'] = photoDescription;
    data['photo'] = photo;
    data['id'] = id;
    return data;
  }
}
