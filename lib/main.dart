import 'package:flutter/material.dart';
import 'package:marka_app/Data/Models/InheritedInjection.dart';
import 'package:marka_app/app_router.dart';
import 'package:marka_app/constants.dart';

void main() {
  runApp(HasnaaStore(
    appRouter: AppRouter(),
  ));
}

class HasnaaStore extends StatelessWidget {
  final AppRouter appRouter;

  const HasnaaStore({Key? key, required this.appRouter}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StateWidget(
      child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: "tajawal",
            primaryColor: primaryColor,
            appBarTheme: const AppBarTheme(
              // backgroundColor: Colors.white,
              color: Colors.white,
              shadowColor: Colors.black12,
              iconTheme: IconThemeData(color: Colors.black87),
              centerTitle: true,
            ),
            // primarySwatch: Colors.blue,
          ),
          initialRoute: '/',
          onGenerateRoute: appRouter.generateRoute),
    );
  }
}
