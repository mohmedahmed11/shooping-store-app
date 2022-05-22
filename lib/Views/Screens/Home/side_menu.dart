import 'package:flutter/material.dart';
import 'package:marka_app/constants.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        elevation: 100,
        semanticLabel: "Home Beauty",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Column(
                children: [
                  Image.asset(
                    "images/app-logo.png",
                    width: 250,
                    height: 150,
                    // fit: BoxFit.fill,
                  ),
                  Row(
                    children: const [
                      Icon(
                        Icons.person,
                        color: primaryColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("الملف الشخصي", style: TextStyle(fontSize: 14))
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: const [
                      Icon(
                        Icons.shopping_cart,
                        color: primaryColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("الطلبات السابقة", style: TextStyle(fontSize: 14))
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 200,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "الطلب الحالي",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800),
                              textDirection: TextDirection.rtl,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("طلب رقم #37463",
                                    textDirection: TextDirection.rtl),
                                Text("5 منتج",
                                    textDirection: TextDirection.rtl),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30,
                                  width: 50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  decoration: BoxDecoration(
                                    // color: primaryColor,
                                    border: Border.all(
                                        color: primaryColor, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "كاش",
                                      style: TextStyle(
                                          color: primaryColor, fontSize: 12),
                                    ),
                                  ),
                                ),
                                const Text(
                                  "400 SDG",
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800),
                                  textDirection: TextDirection.rtl,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    height: 30,
                                    width: 50,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    decoration: BoxDecoration(
                                      // color: primaryColor,
                                      border: Border.all(
                                          color: primaryColor, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "إلغاء",
                                        style: TextStyle(
                                            color: primaryColor, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  // width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    "الطلب قيد التجهيز",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
