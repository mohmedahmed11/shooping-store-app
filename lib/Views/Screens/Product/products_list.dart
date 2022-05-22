import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:marka_app/Data/Api/API_Repository.dart';
import 'package:marka_app/Data/Models/CategoryModel.dart';
import 'package:marka_app/Data/Models/InheritedInjection.dart';
import 'package:marka_app/Data/Models/ProductModel.dart';
import 'package:marka_app/Data/Repositories/product_repository.dart';
// import 'package:marka_app/blocs/Cart/cart_cubit.dart';
import 'package:marka_app/blocs/Product/product_cubit.dart';
import 'product_details.dart';
import 'package:marka_app/constants.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

class ProductList extends StatefulWidget {
  ProductList({
    Key? key,
    required this.category,
  }) : super(key: key);
  final CategoryModel category;
  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late CategoryModel _category;
  List<Product> products = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _category = widget.category;

    BlocProvider.of<ProductsListCubit>(context).getProductsBy(_category.id);
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
        width: 150,
        clipBehavior: Clip.hardEdge,
        height: 350,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
                offset: Offset.zero,
                blurRadius: 2,
                spreadRadius: 0,
                color: Colors.black12)
          ],
        ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    textDirection: TextDirection.rtl,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800),
                        textDirection: TextDirection.rtl,
                      ),
                      Text(
                        product.category?.name ?? '',
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
    var stateProvider = InheritedInjection.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: TextDirection.rtl,
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(color: Colors.white,
                    // borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset.zero,
                          blurRadius: 3,
                          spreadRadius: 3,
                          color: Colors.white10)
                    ]),
                width: 25,
                height: 25,
                child: Opacity(
                  opacity: 0.8,
                  child: Image.network(
                    baseUrlImage + _category.image,
                    // fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  _category.name,
                  style: const TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w800),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
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
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ))
              ],
            ),
          ],
        ),
        body: Directionality(
            textDirection: TextDirection.rtl,
            child: BlocBuilder<ProductsListCubit, ProductsListState>(
                builder: (context, state) {
              if (state is ProductsLoadedList && (state).products.isNotEmpty) {
                products = (state).products;
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0),
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      var product = products[index];
                      return _productView(context, product);
                    });
              } else if (state is ProductsLoadedList &&
                  (state).products.isEmpty) {
                return Center(
                  child: Image.asset("images/empty.png"),
                );
              } else if (state is FailToLoadProductsDataList) {
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
            })));
  }
}
