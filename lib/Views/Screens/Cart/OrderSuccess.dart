import 'package:flutter/material.dart';
import 'package:marka_app/constants.dart';

class OrderSuccess extends StatelessWidget {
  const OrderSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset("images/successful.png"),
              const Text(
                "تهانينا",
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w800),
              ),
              const Text(
                "تم انشاء طلبك ينجاح , سيتم التواصل معك لتأكيد الطلب والتوصيل",
                textAlign: TextAlign.center,
                style: TextStyle(
                    // color: primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/home");
                },
                child: Container(
                    // height: 44,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "العودة للقائمة الرئيسية",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//https://github.com/mohmedahmed11/shooping-store-app.git