part of 'banner_cubit.dart';

@immutable
abstract class BannerState {}

class BannerInitial extends BannerState {}

class BannerLoaded extends BannerState {
  final List<SliderImage> bannerImages;

  BannerLoaded(this.bannerImages);
}

class BannerLoaging extends BannerState {
  final List<SliderImage> bannerImages;

  BannerLoaging(this.bannerImages);
}

class FailToLoadBannerData extends BannerState {
  final List<SliderImage> bannerImages;

  FailToLoadBannerData(this.bannerImages);
}
