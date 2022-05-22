import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marka_app/Data/Api/API_Repository.dart';
import 'package:marka_app/Data/Models/InheritedInjection.dart';
import 'package:marka_app/Data/Models/ProductModel.dart';
import 'package:marka_app/Data/Repositories/order_repository.dart';
import 'package:marka_app/blocs/Cart/cart_cubit.dart';
import 'order_address.dart';
import 'package:marka_app/constants.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int itemsCount = 1;

  Widget _setupProperities(ProductProparety properity) {
    if (properity.type == "size" ||
        properity.type == "count" ||
        properity.type == "bakdg") {
      return Text(
        properity.name + " : " + properity.value,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        textDirection: TextDirection.rtl,
      );
    } else {
      return const Text("data");
    }
  }

  _productView(BuildContext context, Product product) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
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
          // flex: 1,
          // ),
          // SizedBox(
          //   height: 5,
          // ),
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
                    Wrap(
                      children: [
                        for (var properity in product.properties)
                          _setupProperities(properity),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          (product.price * product.count).toString() + " SDG",
                          style: const TextStyle(
                              color: primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w800),
                          textDirection: TextDirection.rtl,
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
                                    product.count < 11
                                        ? product.count++
                                        : product.count = 10;
                                  });
                                },
                                child: const Icon(
                                  Icons.add_box,
                                  size: 25,
                                ),
                              ),
                              Text(
                                product.count.toString(),
                                style: const TextStyle(
                                    fontFamily: "System",
                                    fontSize: 14,
                                    color: primaryColor),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    product.count != 1
                                        ? product.count--
                                        : product.count = 1;
                                  });
                                },
                                child: const Icon(
                                  Icons.indeterminate_check_box_rounded,
                                  size: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: () {},
                        //   child: const Icon(
                        //     Icons.add_shopping_cart_rounded,
                        //     size: 20,
                        //   ),
                        // )
                      ],
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var stateProvider = InheritedInjection.of(context);
    return BlocProvider(
      create: (context) => CartCubit(OrderRepository(APIRepository())),
      child: Scaffold(
        appBar: AppBar(
            title: const Text(
          "سلة الطلبات",
          style: TextStyle(color: primaryColor),
        )),
        body: SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: stateProvider.cart.products.isNotEmpty
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Column(children: [
                          for (var product in stateProvider.cart.products)
                            _productView(context, product),
                        ]),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
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
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text("إجمالي السعر",
                                      style: TextStyle(fontSize: 16)),
                                  Text(
                                      stateProvider.cart.total.toString() +
                                          " SDG",
                                      style: const TextStyle(fontSize: 16))
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text("تكلفة التوصيل",
                                      style: TextStyle(fontSize: 16)),
                                  Text(
                                      stateProvider.cart.delivaryCost
                                              .toString() +
                                          " SDG",
                                      style: const TextStyle(fontSize: 16))
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text("إجمالي المبلغ",
                                      style: TextStyle(fontSize: 16)),
                                  Text(
                                      stateProvider.cart.finalTotal.toString() +
                                          " SDG",
                                      style: const TextStyle(fontSize: 16))
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                          create: (context) => CartCubit(
                                              OrderRepository(APIRepository())),
                                          child: const OrderAddress(),
                                        )));
                          },
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [
                                    BoxShadow(
                                        offset: Offset.zero,
                                        blurRadius: 1,
                                        spreadRadius: 1,
                                        color: Colors.black12)
                                  ]),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "إكمال الطلب",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              )),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "تكلفة التوصيل ثابتة لجميع الطلبات داخل ولاية الخرطوم",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                  : Center(
                      child: Image.asset("images/no-item.jpg",
                          width: 250, height: 250)),
            ),
          ),
        ),
      ),
    );
  }
}
