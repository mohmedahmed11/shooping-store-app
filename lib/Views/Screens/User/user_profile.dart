import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marka_app/Data/Models/User.dart';
import 'package:marka_app/Views/widgets/tosts.dart';
import 'package:marka_app/blocs/Login/login_cubit.dart';
import 'package:marka_app/blocs/User/user_cubit.dart';
import 'package:marka_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late TextEditingController nameTextController = TextEditingController();
  late TextEditingController passwordTextcontroller = TextEditingController();
  late String name;
  late String password;
  final formKey = GlobalKey<FormState>();
  late TextEditingController phoneTextcontroller = TextEditingController();
  late SharedPreferences prefs;
  var userId = 0;

  late User user;

  @override
  void initState() {
    super.initState();
    user = User(id: 0, name: "", phone: "", password: "");
    _setPref();
  }

  _setPref() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("isLoggedIn") == true) {
      if (mounted) {
        setState(() {
          userId = prefs.getInt("userId")!;
        });
        BlocProvider.of<UserCubit>(context).getUser(userId);
      }
    }
  }

  _loginActionBtn(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserUpdated) {
          //
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            // Your Code Here
            BlocProvider.of<UserCubit>(context).emit(UserInitial());
            showTosta(context, Icons.error, Colors.greenAccent, "تم الحفظ");
          });
        } else if (state is UserLoging) {
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
        } else if (state is UserFailToUpdate) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            // Your Code Here
            BlocProvider.of<UserCubit>(context).emit(UserInitial());
            showTosta(context, Icons.error, Colors.redAccent, (state).message);
          });
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
                "حفظ",
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

  _loginSubmitAction() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      var requestString =
          '{"name": "$name","password": "$password", "id": $userId }';

      var request = jsonDecode(requestString);
      // print(request);
      BlocProvider.of<UserCubit>(context).updateUserInfo(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          // setState(() {
          user = (state).user;
          nameTextController.text = user.name;
          phoneTextcontroller.text = user.phone;
          passwordTextcontroller.text = user.password;
          // });
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "الملف الشخصي",
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
          body: Listener(
            onPointerDown: (PointerDownEvent event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            child: SafeArea(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 80,
                        // color: primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Image.asset(
                          "images/user.png",
                          width: 50,
                          height: 50,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
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
                                child: Icon(Icons.account_box),
                              ),
                              Container(
                                width: 1,
                                height: 25,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                color: Colors.black12,
                              ),
                              Expanded(
                                child: TextFormField(
                                    controller: nameTextController,
                                    // textAlign: TextAlign.center,
                                    keyboardType: TextInputType.text,
                                    obscureText: false,
                                    // initialValue: user.name,
                                    validator: (val) => val!.isEmpty
                                        ? "يرجي كتابة الإسم"
                                        : null,
                                    decoration: const InputDecoration(
                                      hintText: "الإسم",
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(fontSize: 14),
                                    onSaved: (val) => {name = val!}),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                color: Colors.black12,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: phoneTextcontroller,
                                  // textAlign: TextAlign.center,
                                  keyboardType: TextInputType.phone,
                                  obscureText: false,
                                  enabled: false,
                                  // initialValue: user.phone,
                                  decoration: const InputDecoration(
                                    hintText: "رقم الهاتف (9XXXXXXXX)",
                                    border: InputBorder.none,
                                  ),
                                  style: const TextStyle(fontSize: 14),
                                  // onSaved: (val) =>
                                  // {phone = int.parse(val!)}
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                color: Colors.black12,
                              ),
                              Expanded(
                                child: TextFormField(
                                    controller: passwordTextcontroller,
                                    // textAlign: TextAlign.center,
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                    // initialValue: user.password,
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: _loginActionBtn(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
