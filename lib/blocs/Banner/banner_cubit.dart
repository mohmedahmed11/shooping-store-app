import 'package:bloc/bloc.dart';
import 'package:marka_app/Data/Api/API_Repository.dart';
import 'package:marka_app/Data/Models/BannerModel.dart';
import 'package:marka_app/Data/Repositories/banner_repository.dart';
import 'package:meta/meta.dart';

part 'banner_state.dart';

class BannerCubit extends Cubit<BannerState> {
  final BannerRepository bannerRepository;
  List<SliderImage> banners = [];
  BannerCubit(this.bannerRepository) : super(BannerInitial());

  List<SliderImage> getAllBannerImages() {
    emit(BannerLoaging(banners));
    bannerRepository.getBanners().then((banners) {
      if (banners.status == Status.error) {
        emit(FailToLoadBannerData(const []));
      } else if (banners.status == Status.completed) {
        print("object");
        var list =
            banners.data.map((banner) => SliderImage.fromJson(banner)).toList();
        emit(BannerLoaded(list));
      } else {
        emit(BannerLoaging(const []));
      }
    });

    return banners;
  }
}
