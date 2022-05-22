import 'package:marka_app/Data/Api/API_Repository.dart';
import 'package:marka_app/constants.dart';

import '../Models/BannerModel.dart';

class BannerRepository {
  final APIRepository apiRepository;

  BannerRepository(this.apiRepository);

  Future<ApiResponse<List<dynamic>>> getBanners() async {
    final banners = await apiRepository.getAll('$baseUrlApi/banners');
    if (banners.status == Status.completed) {
      return banners;
    } else {
      return ApiResponse.error("no date");
    }

    // emit();
  }
}
