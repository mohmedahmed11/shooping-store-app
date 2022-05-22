import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:marka_app/Data/Api/API_Repository.dart';
import 'package:marka_app/Data/Models/BannerModel.dart';
import 'package:marka_app/Data/Models/Cart.dart';
import 'package:marka_app/Data/Models/CategoryModel.dart';
import 'package:marka_app/Data/Models/InheritedInjection.dart';
import 'package:marka_app/Data/Models/ProductModel.dart';
import 'package:marka_app/Data/Repositories/product_repository.dart';
import 'package:marka_app/Views/Screens/Product/products_list.dart';
// import 'package:marka_app/Data/Models/ProductModel.dart';
import 'package:marka_app/blocs/Banner/banner_cubit.dart';
import 'package:marka_app/blocs/Cart/cart_cubit.dart';
import 'package:marka_app/blocs/Catgory/category_cubit.dart';
import 'package:marka_app/blocs/Product/product_cubit.dart';
import '../Product/product_details.dart';
import '../Cart/cart_page.dart';
// import '..//product_details.dart';
// import '..//products_list.dart';
import 'side_menu.dart';
import 'package:marka_app/constants.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:http/http.dart' as http;

// import '../../../Data/Models/models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController searchTextcontroller = TextEditingController();

  int activePage = 0;
  List<SliderImage> sliderImages = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CartCubit>(context).getCartItemsCount();
    // BlocProvider.of<BannerCubit>(context).getAllBannerImages();
    // _getBanner();
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
    // var size = MediaQuery.of(context).size;
    var _cartInfo = InheritedInjection.of(context).cart;
    print(_cartInfo.products.length);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        // backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          // leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
          actions: [
            Stack(
              children: [
                IconButton(
                    icon: const Icon(Icons.shopping_cart_rounded),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CartPage()));
                    }),
                Positioned(
                  height: 15,
                  top: 7,
                  right: 10,
                  child: BlocBuilder<CartCubit, CartState>(
                    builder: (context, state) {
                      if (_cartInfo.products.isNotEmpty) {
                        return Container(
                          width: 15,
                          height: 15,
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(7)),
                          child: Center(
                            child: Text(
                              _cartInfo.products.length.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
          centerTitle: true,
          shadowColor: Colors.black12,
          iconTheme: const IconThemeData(color: Colors.black87),
          title: Image.asset(
            "images/app-logo.png",
            height: 40,
          ),

          backgroundColor: Colors.white,
        ),

        // drawerEdgeDragWidth: 300,
        drawer: const SideMenu(),
        body: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final bool connected = connectivity != ConnectivityResult.none;

            if (connected) {
              BlocProvider.of<BannerCubit>(context).getAllBannerImages();
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
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
                        child: setupBanner()),
                    const Categories(),
                    const MostSaller(),
                    const Leatest(),
                    // const Expanded(
                    //   child: Leatest(),
                    // ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Image.asset(
                  "images/error1.png",
                  width: 150,
                  height: 150,
                ),
              );
            }
          },
          child: const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

class Categories extends StatefulWidget {
  const Categories({
    Key? key,
  }) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  late List<CategoryModel> categories = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<CategoryCubit>(context).getAllCategories();
    // BlocProvider.of<CartCubit>(context).getCartItemsCount();
    // _getCateories();
  }

  @override
  Widget build(BuildContext context) {
    // var _cartInfo = InheritedInjection.of(context)!.cart;
    return Container(
      padding: const EdgeInsets.only(top: 0),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      height: 68,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, state) {
                if (state is CategoryLoaded && (state).categories.isNotEmpty) {
                  categories = (state).categories;

                  return ListView.builder(
                    itemCount: categories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      var category = categories[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BlocProvider<ProductsListCubit>(
                                create: (BuildContext context) =>
                                    ProductsListCubit(
                                        ProductRepository(APIRepository())),
                                child: ProductList(
                                  category: category,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          // height: 110,
                          // width: 150,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset.zero,
                                    blurRadius: 3,
                                    spreadRadius: 0,
                                    color: Colors.black12)
                              ]),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            textDirection: TextDirection.rtl,
                            children: [
                              Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    // borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset.zero,
                                          blurRadius: 3,
                                          spreadRadius: 3,
                                          color: Colors.white10)
                                    ]),
                                width: 40,
                                height: 60,
                                child: Opacity(
                                  opacity: 0.8,
                                  child: Image.network(
                                      baseUrlImage + category.image,
                                      fit: BoxFit.fill),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  category.name,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is FailToLoadProductsDataBestSeller) {
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
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class MostSaller extends StatefulWidget {
  const MostSaller({
    Key? key,
  }) : super(key: key);

  @override
  State<MostSaller> createState() => _MostSallerState();
}

class _MostSallerState extends State<MostSaller> {
  late List<Product> products = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // BlocProvider.of<ProductsCubit>(context).getAllBestSellerProducts();
    print(BlocProvider.of<ProductsBestSellerCubit>(context)
        .getAllBestSellerProducts());
    // _getBestSeller();
  }

  @override
  Widget build(BuildContext context) {
    var stateProvider = InheritedInjection.of(context);
    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      height: 280,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "الأكثر مبيعاً :",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              textDirection: TextDirection.rtl,
            ),
          ),
          Expanded(
            child: Directionality(
                textDirection: TextDirection.rtl,
                child: BlocBuilder<ProductsBestSellerCubit,
                    ProductsBestSellerState>(builder: (context, state) {
                  if (state is ProductsLoadedBestSallse &&
                      (state).products.isNotEmpty) {
                    products = (state).products;

                    return ListView.builder(
                      itemCount: products.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        var product = products[index];
                        var currency = "SDG";
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BlocProvider<ProductsCubit>(
                                  create: (context) => ProductsCubit(
                                      ProductRepository(APIRepository())),
                                  child: ProductDetails(
                                    product: product,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            // color: Colors.amber,
                            width: 150,
                            clipBehavior: Clip.hardEdge,
                            // height: 50,
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              textDirection: TextDirection.rtl,
                              children: [
                                Expanded(
                                  child: Opacity(
                                    opacity: 1,
                                    child: FadeInImage.assetNetwork(
                                      placeholder: "images/ICON.jpg",
                                      image: baseUrlImage + product.image,
                                      fit: BoxFit.fitHeight,
                                      width: double.infinity,
                                    ),
                                  ),
                                  // flex: 1,
                                ),
                                // SizedBox(
                                //   height: 5,
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      height: 80,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        textDirection: TextDirection.rtl,
                                        children: [
                                          Text(
                                            product.name,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800),
                                            textDirection: TextDirection.rtl,
                                          ),
                                          Text(
                                            product.category?.name ?? "",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                            textDirection: TextDirection.rtl,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            textDirection: TextDirection.rtl,
                                            children: [
                                              Text(
                                                product.price.toString() +
                                                    " " +
                                                    currency,
                                                style: const TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w800),
                                                textDirection:
                                                    TextDirection.rtl,
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  if (stateProvider
                                                      .cart.products
                                                      .where((item) =>
                                                          item.id == product.id)
                                                      .isEmpty) {
                                                    Audio.load(
                                                        'images/notification.mp3')
                                                      ..play()
                                                      ..dispose();
                                                    if (await Vibrate
                                                        .canVibrate) {
                                                      Vibrate.vibrate();
                                                    }
                                                    stateProvider
                                                        .addToCart(product);
                                                  }
                                                },
                                                child: stateProvider
                                                        .cart.products
                                                        .where((item) =>
                                                            item.id ==
                                                            product.id)
                                                        .isNotEmpty
                                                    ? Image.asset(
                                                        "images/cart_success.png",
                                                        fit: BoxFit.cover,
                                                        width: 40,
                                                        height: 30,
                                                      )
                                                    : Image.asset(
                                                        "images/cart_add.png",
                                                        fit: BoxFit.cover,
                                                        width: 40,
                                                        height: 30,
                                                      ),
                                              )
                                            ],
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    );
                  }
                })),
          )
        ],
      ),
    );
  }
}

class Leatest extends StatefulWidget {
  const Leatest({
    Key? key,
  }) : super(key: key);

  @override
  State<Leatest> createState() => _LeatestState();
}

class _LeatestState extends State<Leatest> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductsLeatesCubit>(context).getLeatesProducts();
  }

  _productView(BuildContext context, Product product) {
    var stateProvider = InheritedInjection.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider<ProductsCubit>(
              create: (context) =>
                  ProductsCubit(ProductRepository(APIRepository())),
              child: ProductDetails(
                product: product,
              ),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        // color: Colors.amber,
        // width: 150,
        clipBehavior: Clip.hardEdge,
        height: 128,
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.rtl,
          children: [
            Opacity(
              opacity: 1,
              child: FadeInImage.assetNetwork(
                placeholder: "images/ICON.jpg",
                image: baseUrlImage + product.image,
                fit: BoxFit.fitHeight,
                width: 128,
              ),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    textDirection: TextDirection.rtl,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800),
                        textDirection: TextDirection.rtl,
                      ),
                      Text(
                        product.category?.name ?? "",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                        textDirection: TextDirection.rtl,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(
                            product.price.toString() + " SDG",
                            style: const TextStyle(
                                color: primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w800),
                            textDirection: TextDirection.rtl,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (stateProvider.cart.products
                                  .where((item) => item.id == product.id)
                                  .isEmpty) {
                                Audio.load('images/notification.mp3')
                                  ..play()
                                  ..dispose();
                                if (await Vibrate.canVibrate) {
                                  Vibrate.vibrate();
                                }
                                stateProvider.addToCart(product);
                              }
                            },
                            child: stateProvider.cart.products
                                    .where((item) => item.id == product.id)
                                    .isNotEmpty
                                ? Image.asset(
                                    "images/cart_success.png",
                                    fit: BoxFit.cover,
                                    width: 40,
                                    height: 30,
                                  )
                                : Image.asset(
                                    "images/cart_add.png",
                                    fit: BoxFit.cover,
                                    width: 40,
                                    height: 30,
                                  ),
                          )
                        ],
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 0),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        // height: double.infinity,
        width: double.infinity,
        child: BlocBuilder<ProductsLeatesCubit, ProductsLeatesState>(
            builder: (context, state) {
          if (state is ProductsLoadedLeates && (state).products.isNotEmpty) {
            products = (state).products;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    " أحدث العروض :",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                    textDirection: TextDirection.rtl,
                  ),
                ),

                for (var product in products) _productView(context, product),

                // for (var product in leatesProducts) _productView(context, product)
              ],
            );
          } else if (state is FailToLoadProductsDataLeates) {
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
        }));
  }
}
