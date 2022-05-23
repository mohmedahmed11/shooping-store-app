import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marka_app/blocs/Login/login_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Home/home_screen.dart';
import 'package:marka_app/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController phoneTextcontroller = TextEditingController();
  late TextEditingController passwordTextcontroller = TextEditingController();
  late TextInputType type;
  late String placeholder;
  late int phone;
  late String password;
  late bool isPassword;
  late Function(String) onSave;

  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  _showTosta(IconData icon, Color color, String message) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(
            width: 12.0,
          ),
          Text(message),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
    );
  }

  _loginActionBtn(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        if (state is LoginSuccess) {
          //
          WidgetsBinding.instance!.addPostFrameCallback(((_) async {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();

            _showTosta(
                Icons.check, Colors.greenAccent, "تم تسجيل الدخول بنجاح");
            // print();
            prefs.setBool("isLoggedIn", true);
            prefs.setInt("userId", (state).user.id);
            prefs.setString("userPhone", (state).user.phone);
            Navigator.pushReplacementNamed(context, "/home");
          }));
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 30,
            width: 30,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          );
        } else if (state is LoginLoading) {
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 30,
            width: 30,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          );
        } else if (state is LoginFail) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            // Your Code Here
            BlocProvider.of<LoginCubit>(context).emit(LoginInitial());
            _showTosta(Icons.error, Colors.redAccent, (state).message);
          });

          return GestureDetector(
            onTap: () {
              _loginSubmitAction();
            },
            child: Container(
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
          );
        }

        return GestureDetector(
          onTap: () {
            _loginSubmitAction();
          },
          child: Container(
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
        );
      },
    );
  }

  _loginSubmitAction() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      var requestString = '{"phone": "$phone","password": "$password"}';

      var request = jsonDecode(requestString);
      // print(request);
      BlocProvider.of<LoginCubit>(context).login(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Listener(
        onPointerDown: (PointerDownEvent event) =>
            FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: formKey,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          "images/app-logo.png",
                          height: 150,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "مرحبا بك ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
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
                                const SizedBox(
                                  width: 30,
                                  child: Text(
                                    "+249",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 25,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  color: Colors.black12,
                                ),
                                Expanded(
                                  child: TextFormField(
                                      controller: phoneTextcontroller,
                                      // textAlign: TextAlign.center,
                                      keyboardType: TextInputType.phone,
                                      obscureText: false,
                                      validator: (val) => val!.isEmpty
                                          ? "رقم الهاتف مطلوب"
                                          : null,
                                      decoration: const InputDecoration(
                                        hintText: "رقم الهاتف (9XXXXXXXX)",
                                        border: InputBorder.none,
                                      ),
                                      style: const TextStyle(fontSize: 14),
                                      onSaved: (val) =>
                                          {phone = int.parse(val!)}),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
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
                                const SizedBox(
                                  width: 30,
                                  child: Icon(Icons.password),
                                ),
                                Container(
                                  width: 1,
                                  height: 25,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  color: Colors.black12,
                                ),
                                Expanded(
                                  child: TextFormField(
                                      controller: passwordTextcontroller,
                                      // textAlign: TextAlign.center,
                                      keyboardType: TextInputType.text,
                                      obscureText: true,
                                      validator: (val) => val!.isEmpty
                                          ? "يرجي إدخل كلمة المرور"
                                          : null,
                                      decoration: const InputDecoration(
                                        hintText: "كلمة المرور",
                                        border: InputBorder.none,
                                      ),
                                      style: const TextStyle(fontSize: 14),
                                      onSaved: (val) => {password = val!}),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
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
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
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
                          _loginActionBtn(context),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
        ),
      ),
    );
  }
}
