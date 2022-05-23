import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marka_app/Data/Api/API_Repository.dart';
import 'package:marka_app/Data/Repositories/banner_repository.dart';
import 'package:marka_app/Data/Repositories/category_repository.dart';
import 'package:marka_app/Data/Repositories/login_repository.dart';
import 'package:marka_app/Data/Repositories/order_repository.dart';
import 'package:marka_app/Data/Repositories/product_repository.dart';
import 'package:marka_app/Views/Screens/Auth/login_page.dart';
import 'package:marka_app/Views/Screens/Home/home_screen.dart';
import 'package:marka_app/Views/Screens/IntroPages/lanch_screen.dart';
import 'package:marka_app/blocs/Banner/banner_cubit.dart';
import 'package:marka_app/blocs/Cart/cart_cubit.dart';
import 'package:marka_app/blocs/Catgory/category_cubit.dart';
import 'package:marka_app/blocs/Login/login_cubit.dart';
import 'package:marka_app/blocs/Product/product_cubit.dart';

class AppRouter {
  late BannerRepository bannerRepository;
  late BannerCubit bannerCubit;

  late CategoryRepository categoryRepository;
  late CategoryCubit categoryCubit;

  late ProductRepository productRepository;
  late ProductsCubit productsCubit;

  AppRouter() {
    bannerRepository = BannerRepository(APIRepository());
    bannerCubit = BannerCubit(bannerRepository);

    categoryRepository = CategoryRepository(APIRepository());
    categoryCubit = CategoryCubit(categoryRepository);

    productRepository = ProductRepository(APIRepository());
    productsCubit = ProductsCubit(productRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const LaunchScreen());
      case '/login':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => LoginCubit(
              LoginRepository(APIRepository()),
            ),
            child: const LoginPage(),
          ),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider<BannerCubit>(
                create: (BuildContext context) => bannerCubit,
              ),
              // BlocProvider<CategoryCubit>(
              //   create: (BuildContext context) => categoryCubit,
              // ),
              // BlocProvider<ProductsCubit>(
              //   create: (BuildContext context) => productsCubit,
              // ),
              BlocProvider<CartCubit>(
                create: (BuildContext context) =>
                    CartCubit(OrderRepository(APIRepository()))
                      ..getCartItemsCount(),
              ),
              // BlocProvider<ProductsListCubit>(
              //   create: (BuildContext context) => ProductsListCubit(
              //     ProductRepository(APIRepository()),
              //   ),
              // ),
              // BlocProvider<ProductsBestSellerCubit>(
              //   create: (BuildContext context) => ProductsBestSellerCubit(
              //     ProductRepository(APIRepository()),
              //   ),
              // ),
              // BlocProvider<ProductsLeatesCubit>(
              //   create: (BuildContext context) => ProductsLeatesCubit(
              //     ProductRepository(APIRepository()),
              //   ),
              // ),
              // BlocProvider<ProductsSimillerCubit>(
              //   create: (BuildContext context) => ProductsSimillerCubit(
              //     ProductRepository(APIRepository()),
              //   ),
              // )
            ],
            child: const HomeScreen(),
          ),
        );
      default:
        return null;
    }
  }
}
