import 'dart:async';
import 'dart:convert';
// import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marka_app/Data/Models/InheritedInjection.dart';
import 'package:marka_app/Views/Screens/Cart/OrderSuccess.dart';
import 'package:marka_app/blocs/Cart/cart_cubit.dart';
import 'package:marka_app/constants.dart';

class OrderAddress extends StatefulWidget {
  const OrderAddress({Key? key}) : super(key: key);

  @override
  State<OrderAddress> createState() => _OrderAddressState();
}

class _OrderAddressState extends State<OrderAddress>
    with SingleTickerProviderStateMixin {
  final Completer<GoogleMapController> _controller = Completer();

  late TextEditingController addressTextcontroller = TextEditingController();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LatLng _userLocation = const LatLng(15.599549, 32.525022);
  static late CameraPosition _kGooglePlex;

  String? selectedPeriod;

  List<String> shortItems = ["الفترة الصباحية (9-12)", "الفترة المسائية (2-5)"];
  late AnimationController controller;
  late Animation colorAnimation;
  late Animation sizeAnimation;
  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _kGooglePlex = CameraPosition(
      target: _userLocation,
      zoom: 14.4746,
    );
    controller = AnimationController(
        vsync: this, duration: const Duration(microseconds: 600));
    colorAnimation =
        ColorTween(begin: Colors.yellow, end: Colors.red).animate(controller);
    sizeAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(controller);
  }

  _prepareToSendOrder() {
    if (selectedPeriod != null) {
      _sendPostData();
    } else {
      controller.addListener(() {
        setState(() {});
      });

      controller.forward();
    }
  }

  _sendPostData() {
    var _cartInfo = InheritedInjection.of(context).cart;
    List<dynamic> itemArray = [];
    for (var item in _cartInfo.products) {
      itemArray.add('{"product_id" : ${item.id}, "count" : ${item.count}}');
    }
    var orderString =
        '{"user_id": 0, "lat": 0.3443, "lng": 12.9843, "total": ${_cartInfo.total}, "delivery_cost": ${_cartInfo.delivaryCost}, "delivery_period": "dfdf", "items_count": ${itemArray.length}, "note": "note", "items": $itemArray}';

    var orderData = jsonDecode(orderString);
    print(orderData);
    BlocProvider.of<CartCubit>(context).sendOrder(orderData);
  }

  Future<void> _getUserLocation() async {
    Location location = Location();

    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final _locationData = await location.getLocation();
    final GoogleMapController controller = await _controller.future;
    if (mounted) {
      setState(() {
        _userLocation =
            LatLng(_locationData.latitude!, _locationData.longitude!);
        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: _userLocation,
          zoom: 14.4746,
        )));
        print(_userLocation);
      });
    }
  }

  _actionBtnState() {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is OrderSending) {
          return Container(
              padding: const EdgeInsets.all(12),
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
              child: const CircularProgressIndicator(
                color: Colors.white,
              ));
        } else if (state is OrderSended) {
          WidgetsBinding.instance!.addPostFrameCallback(((_) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OrderSuccess(),
              ),
            );
          }));
          //
          return Container();
        } else {
          return GestureDetector(
            onTap: () {
              _prepareToSendOrder();
            },
            child: Container(
                padding: const EdgeInsets.all(12),
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
                      "إرسال الطلب",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                )),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // _getUserLocation();
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Listener(
        onPointerDown: (PointerDownEvent event) =>
            FocusManager.instance.primaryFocus?.unfocus(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                onCameraMove: (CameraPosition position) {
                  _userLocation = position.target;
                },
              ),
            ),
            Positioned(
              top: (size.height - 114) / 2,
              child: Image.asset("images/marker.png", width: 50, height: 75),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
              offset: Offset.zero,
              spreadRadius: 0,
              blurRadius: 2,
              color: Colors.black12)
        ], color: Colors.white, borderRadius: BorderRadius.circular(8)),
        width: size.width - 30,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Container(
                // height: 50,
                width: size.width - 40,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(boxShadow: const [
                  BoxShadow(
                      offset: Offset.zero,
                      spreadRadius: 0,
                      blurRadius: 2,
                      color: Colors.black12)
                ], color: Colors.white, borderRadius: BorderRadius.circular(8)),

                child: TextFormField(
                    controller: addressTextcontroller,
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    decoration: const InputDecoration(
                      hintText: "ملاحظة علي الطلب",
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 14),
                    onSaved: (val) => {}),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                width: double.infinity,
                decoration: BoxDecoration(boxShadow: const [
                  BoxShadow(
                      offset: Offset.zero,
                      spreadRadius: 0,
                      blurRadius: 2,
                      color: Colors.black12)
                ], color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: Center(
                        child: Icon(
                          Icons.emergency_rounded,
                          size: sizeAnimation.value,
                          color: primaryColor,

                          // color: colorAnimation.value,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width - 140,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: DropdownButton(
                          // Initial Value
                          value: selectedPeriod,
                          underline: Container(),
                          // style: TextStyle(),

                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),
                          hint: const Text("مواعيد الإستلام",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14)),
                          // alignment: AlignmentDirectional.center,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontFamily: "tajawal"),
                          // Array list of items
                          items: shortItems.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          // value: ,
                          // change button value to selected value
                          onChanged: (value) {
                            String item = value as String;
                            print(item);
                            setState(() {
                              //     .where((element) => element.name == item)
                              //     .first;
                              selectedPeriod = item;

                              // longItems = val.citys;
                              // city = null;
                              // selectedCityId = 0;

                              // state = item;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _actionBtnState()),
            // const SizedBox(
            //   height: 20,
            // )
          ],
        ),
      ),
    );
  }
}
