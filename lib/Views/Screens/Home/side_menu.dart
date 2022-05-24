import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marka_app/Data/Api/API_Repository.dart';
import 'package:marka_app/Data/Repositories/auth_repository.dart';
import 'package:marka_app/Views/Screens/User/user_profile.dart';
import 'package:marka_app/app_router.dart';
import 'package:marka_app/blocs/User/user_cubit.dart';
import 'package:marka_app/constants.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  late SharedPreferences prefs;
  var isgLogedIN = false;
  @override
  void initState() {
    super.initState();
    _setPref();
  }

  _setPref() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("isLoggedIn") == true) {
      if (mounted) {
        setState(() {
          isgLogedIN = true;
        });
      }
    }
  }

  _logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Image.asset("images/app-logo.png"),
        content: const Text(
          "هل ترغب في تسجيل الخروج",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text("نعم"),
            onPressed: () {
              prefs.clear();
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          CupertinoDialogAction(
            child: const Text("لا"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  _userOptions(BuildContext context) {
    print(isgLogedIN);
    return isgLogedIN
        ? Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (BuildContext context) => UserCubit(
                            AuthRepository(
                              APIRepository(),
                            ),
                          ),
                          child: const UserProfile(),
                        ),
                      ));
                },
                child: Row(
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
                            Text("5 منتج", textDirection: TextDirection.rtl),
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
                                border:
                                    Border.all(color: primaryColor, width: 1),
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
                                  border:
                                      Border.all(color: primaryColor, width: 1),
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
              ),
            ],
          )
        : Container(
            child: Column(
              children: [
                const Text("شكراً لزيارتك للإطلاع علي آخر العروض"),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "/");
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
                )
              ],
            ),
          );
  }

  _logOutOption(BuildContext context) {
    return isgLogedIN
        ? GestureDetector(
            onTap: () {
              _logout(context);
            },
            child: Row(
              children: const [
                Icon(
                  Icons.logout,
                  color: primaryColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("تسجيل خروج", style: TextStyle(fontSize: 14))
              ],
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        elevation: 100,
        semanticLabel: "Home Beauty",
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Column(
              children: [
                Image.asset(
                  "images/app-logo.png",
                  width: 250,
                  height: 150,
                  // fit: BoxFit.fill,
                ),
                _userOptions(context),
                Container(
                  color: Colors.amber,
                  width: 100,
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: const [
                    Icon(
                      Icons.info_outline_rounded,
                      color: primaryColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("عن التطبيق", style: TextStyle(fontSize: 14))
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: const [
                    Icon(
                      Icons.help_outline_outlined,
                      color: primaryColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("المساعدة", style: TextStyle(fontSize: 14))
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                _logOutOption(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
