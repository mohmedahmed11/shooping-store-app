import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:marka_app/Data/Models/BannerModel.dart';
import 'package:marka_app/blocs/Banner/banner_cubit.dart';
import 'package:marka_app/constants.dart';

class Banners extends StatefulWidget {
  const Banners({Key? key}) : super(key: key);

  @override
  State<Banners> createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  List<SliderImage> sliderImages = [];
  int activePage = 0;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BannerCubit>(context).getAllBannerImages();
  }

  Widget setupBanner() {
    return BlocBuilder<BannerCubit, BannerState>(builder: (context, state) {
      if (state is BannerLoaded && (state).bannerImages.isNotEmpty) {
        sliderImages = (state).bannerImages;

        return ImageSlideshow(
          /// Width of the [ImageSlideshow].
          width: double.infinity,

          /// Height of the [ImageSlideshow].
          height: 128,

          /// The page to show when first creating the [ImageSlideshow].
          initialPage: 0,

          /// The color to paint the indicator.
          indicatorColor: primaryColor,

          /// The color to paint behind th indicator.
          indicatorBackgroundColor: Colors.grey,

          /// The widgets to display in the [ImageSlideshow].
          /// Add the sample image file into the images folder
          children: [
            for (var image in sliderImages)
              GestureDetector(
                onTap: () {
                  print(image.productId);
                },
                child: Image.network(
                  baseUrlImage + image.image,
                  fit: BoxFit.cover,
                ),
              )
          ],

          /// Called whenever the page in the center of the viewport changes.
          onPageChanged: (value) {
            activePage = value;
            // print('Page changed: ');
          },

          /// Auto scroll interval.
          /// Do not auto scroll with null or 0.
          autoPlayInterval: 5000,

          /// Loops back to first slide.
          isLoop: true,
        );
      } else if (state is FailToLoadBannerData) {
        return Center(
          child: Image.asset("images/error.png"),
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                  offset: Offset.zero,
                  blurRadius: 2,
                  spreadRadius: 0,
                  color: Colors.black12)
            ]),
        height: 128,
        width: MediaQuery.of(context).size.width,
        child: setupBanner());
  }
}
