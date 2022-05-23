import 'package:flutter/material.dart';
import 'Home/home_screen.dart';
import 'package:marka_app/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController phoneTextcontroller = TextEditingController();
  late TextInputType type;
  late String placeholder;
  late bool isPassword;
  late Function(String) onSave;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Listener(
        onPointerDown: (PointerDownEvent event) =>
            FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Image.asset(
                      "images/app-logo.png",
                      height: 150,
                    ),
                    const Text(
                      "تسجيل دخول",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                SizedBox(
                    child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      // height: 50,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.red.shade200, width: 1.5)),
                      child: Row(
                        children: [
                          const Text(
                            "+249",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          Container(
                            width: 1,
                            height: 25,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            color: Colors.black12,
                          ),
                          Expanded(
                            child: TextFormField(
                                controller: phoneTextcontroller,
                                // textAlign: TextAlign.center,
                                keyboardType: TextInputType.phone,
                                obscureText: false,
                                decoration: const InputDecoration(
                                  hintText: "رقم الهاتف",
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(fontSize: 14),
                                onSaved: (val) => {}),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: double.infinity,
                      // color: primaryColor,
                      child: Wrap(
                          // direction: Axis.vertical,
                          textDirection: TextDirection.rtl,
                          children: [
                            const Text(
                              "عند استخدامك للتطبيق فأنت تواقق على",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                            GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  "سياسة الإستخدام والخصوصية",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800),
                                ))
                          ]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 50,
                      child: const Center(
                        child: Text(
                          "تسجيل",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                )),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "/home");
                  },
                  child: const SizedBox(
                    width: 120,
                    height: 40,
                    child: Center(
                      child: Text(
                        "دخول كزائر",
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 16),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
