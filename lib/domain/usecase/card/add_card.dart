import 'package:lexilearnai/common/di/service_locator.dart';
import 'package:lexilearnai/core/result/result.dart';
import 'package:lexilearnai/core/usecase/usecase.dart';
import 'package:lexilearnai/domain/repository/card/card.dart';

class AddCardUseCase implements UseCase<Result, dynamic> {
  @override
  Future<Result> call({params}) {
    return serviceLocator<CardRepository>().addCard(params);
  }
}
