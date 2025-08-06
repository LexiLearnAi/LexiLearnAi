import 'package:lexilearnai/common/di/service_locator.dart';
import 'package:lexilearnai/core/result/result.dart';
import 'package:lexilearnai/core/usecase/usecase.dart';
import 'package:lexilearnai/data/model/card/photo_response.dart';
import 'package:lexilearnai/domain/repository/card/card.dart';

class GetPhotoUseCase implements UseCase<Result<PhotoResponse>, GetPhotoParams> {
  @override
  Future<Result<PhotoResponse>> call({required GetPhotoParams params}) {
    return serviceLocator<CardRepository>().getPhoto(params.id);
  }
}

class GetPhotoParams {
  final String id;  

  GetPhotoParams(this.id);
}
