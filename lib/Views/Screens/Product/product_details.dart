import 'dart:convert';
import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:marka_app/Data/Api/API_Repository.dart';
import 'package:marka_app/Data/Models/Cart.dart';
import 'package:marka_app/Data/Models/InheritedInjection.dart';
import 'package:marka_app/Data/Models/ProductModel.dart';
import 'package:marka_app/Data/Repositories/product_repository.dart';
import 'package:marka_app/blocs/Cart/cart_cubit.dart';
import 'package:marka_app/blocs/Product/product_cubit.dart';

// import '../../Data/Models/models.dart';
import 'package:marka_app/constants.dart';
import 'package:http/http.dart' as http;

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    Key? key,
    required this.product,
  }) : super(key: key);
  final Product product;
  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int activePage = 1;

  int itemsCount = 1;

  late Product _product;
  @override
  void initState() {
    super.initState();
    _product = widget.product;

    // BlocProvider.of<CartCubit>(context).getCartItemsCount();
  }

  GestureDetector sliderImage(bool isActive, String image, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          activePage = index;
        });
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(5),
        height: 60,
        width: 90,
        decoration: BoxDecoration(
            color: Colors.grey[50],
            // border: BoxBorder()
            borderRadius: BorderRadius.circular(10),
            // border: const BoxBorder(),
            boxShadow: [
              BoxShadow(
                  offset: Offset.zero,
                  blurRadius: 0,
                  spreadRadius: isActive ? 2 : 0,
                  color: isActive ? primaryColor : Colors.white)
            ]),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            // border: BoxBorder()
            borderRadius: BorderRadius.circular(10),
            // border: const BoxBorder(),
          ),
          child: FadeInImage.assetNetwork(
            placeholder: "images/ICON.jpg",
            image: baseUrlImage + image,
            fit: BoxFit.fitHeight,
            width: double.infinity,
          ),
        ),
        // flex: 1,
      ),
    );
  }

  _porductProparity(ProductProparety proparety) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                proparety.name,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Expanded(
              child: Text(
                proparety.value,
                textDirection: TextDirection.rtl,
                softWrap: true,
                style: const TextStyle(fontSize: 12),
              ),
            )
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          height: 1,
          color: Colors.grey[200],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var stateProvider = InheritedInjection.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _product.name,
          style: const TextStyle(color: primaryColor),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                  icon: const Icon(Icons.shopping_cart_rounded),
                  onPressed: () {}),
              Positioned(
                top: 7,
                right: 10,
                child: Container(
                  width: 15,
                  height: 15,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(7)),
                  child: Center(
                    child: Text(
                      stateProvider.cart.products.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (kDebugMode) {
                    print(activePage);
                  }
                },
                child: SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: _product.images.isNotEmpty
                      ? ImageSlideshow(
                          /// Width of the [ImageSlideshow].
                          width: double.infinity,

                          /// Height of the [ImageSlideshow].
                          height: 200,

                          /// The page to show when first creating the [ImageSlideshow].
                          initialPage: 0,

                          /// The color to paint the indicator.
                          indicatorColor: Colors.transparent,

                          /// The color to paint behind th indicator.
                          indicatorBackgroundColor: Colors.transparent,

                          /// The widgets to display in the [ImageSlideshow].
                          /// Add the sample image file into the images folder
                          children: [
                            for (var image in _product.images)
                              GestureDetector(
                                onTap: () {
                                  print(image.productId);
                                },
                                child: Image.network(
                                  baseUrlImage + image.image,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                          ],

                          /// Called whenever the page in the center of the viewport changes.
                          onPageChanged: (value) {
                            setState(() {
                              activePage = value;
                            });

                            // print('Page changed: ');
                          },

                          /// Auto scroll interval.
                          /// Do not auto scroll with null or 0.
                          autoPlayInterval: 5000,

                          /// Loops back to first slide.
                          isLoop: true,
                        )
                      : Container(),
                ),
              ),
              Container(
                height: 100,
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      for (var i = 0; i < _product.images.length; i++)
                        sliderImage(
                            activePage == i, _product.images[i].image, i),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 2,
                  color: Colors.grey[200],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FadeInImage.assetNetwork(
                          placeholder: "images/ICON.jpg",
                          image: baseUrlImage +
                              (_product.category?.image ?? "images/ICON.jpg"),
                          fit: BoxFit.fill,
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          _product.category?.name ?? "",
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      _product.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _product.offer != null
                        ? Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: primaryColor),
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              "خصم " +
                                  _product.offer!.present.toString() +
                                  "% عند شراء " +
                                  _product.offer!.items.toString() +
                                  " قطع",
                              // "10% خصم عند شراء 3 قطع",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          )
                        : Container(),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textDirection: TextDirection.rtl,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _product.offer != null
                                ? Text(
                                    _product.price.toString() + " SDG",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: Colors.grey,
                                      decorationStyle:
                                          TextDecorationStyle.solid,
                                    ),
                                    textDirection: TextDirection.rtl,
                                  )
                                : Container(),
                            Text(
                              _product.offer != null
                                  ? (_product.price -
                                              ((_product.price *
                                                      _product.offer!.present) /
                                                  100))
                                          .toString() +
                                      " SDG"
                                  : _product.price.toString() + " SDG",
                              style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 80,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    itemsCount < 11
                                        ? itemsCount++
                                        : itemsCount = 10;
                                  });
                                },
                                child: const Icon(
                                  Icons.add_box,
                                  size: 30,
                                ),
                              ),
                              Text(
                                itemsCount.toString(),
                                style: const TextStyle(
                                    fontFamily: "System",
                                    fontSize: 14,
                                    color: primaryColor),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    itemsCount != 1
                                        ? itemsCount--
                                        : itemsCount = 1;
                                  });
                                },
                                child: const Icon(
                                  Icons.indeterminate_check_box_rounded,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (stateProvider.cart.products
                                .where((item) => item.id == _product.id)
                                .isEmpty) {
                              _product.count = itemsCount;
                              Audio.load('images/notification.mp3')
                                ..play()
                                ..dispose();
                              if (await Vibrate.canVibrate) {
                                Vibrate.vibrate();
                              }
                              stateProvider.addToCart(_product);
                            }
                          },
                          child: stateProvider.cart.products
                                  .where((item) => item.id == _product.id)
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 2,
                  color: Colors.grey[200],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "تفاصيل المنتج",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        _product.details,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 2,
                  color: Colors.grey[200],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "خصائص المنتج",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var proparity in _product.properties)
                            _porductProparity(proparity),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 100,
                                child: Text(
                                  "كود المنتج",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              Text(
                                _product.code,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 2,
                  color: Colors.grey[200],
                ),
              ),
              BlocProvider(
                  create: (context) => ProductsSimillerCubit(
                        ProductRepository(APIRepository()),
                      ),
                  child: SimilarProducts(productId: _product.id))
            ],
          ),
        ),
      ),
    );
  }
}

class SimilarProducts extends StatefulWidget {
  const SimilarProducts({
    Key? key,
    required this.productId,
  }) : super(key: key);

  final int productId;

  @override
  State<SimilarProducts> createState() => _SimilarProductsState();
}

class _SimilarProductsState extends State<SimilarProducts> {
  late int _productId;
  List<Product> _products = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _productId = widget.productId;
    BlocProvider.of<ProductsSimillerCubit>(context)
        .getSimilarProducts(_productId);
  }

  @override
  Widget build(BuildContext context) {
    var stateProvider = InheritedInjection.of(context);
    return BlocBuilder<ProductsSimillerCubit, ProductsSimillerState>(
        builder: (context, state) {
      if (state is ProductsLoadedSimimler && (state).products.isNotEmpty) {
        _products = (state).products;
        return Container(
          padding: const EdgeInsets.only(top: 10),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          height: 280,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "عروض مشابهة :",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  textDirection: TextDirection.rtl,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _products.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    var product = _products[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetails(
                                      product: product,
                                    )));
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
                                        product.category?.name ?? '',
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
                                                  .where((item) =>
                                                      item.id == product.id)
                                                  .isEmpty) {
                                                Audio.load(
                                                    'images/notification.mp3')
                                                  ..play()
                                                  ..dispose();
                                                if (await Vibrate.canVibrate) {
                                                  Vibrate.vibrate();
                                                }
                                                stateProvider
                                                    .addToCart(product);
                                              }
                                            },
                                            child: stateProvider.cart.products
                                                    .where((item) =>
                                                        item.id == product.id)
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
                ),
              )
            ],
          ),
        );
      } else {
        return const SizedBox(
          height: 34,
        );
      }
    });
  }
}
