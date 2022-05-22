part of 'cart_cubit.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class newItemAdded extends CartState {
  //  List<Product> items;

  newItemAdded();
}

class CartLoaded extends CartState {
  //  List<Product> items;

  CartLoaded();
}

class OrderSending extends CartState {
  //  List<Product> items;

  OrderSending();
}

class OrderSended extends CartState {
  Order order;

  OrderSended(this.order);
}

class OrderFailToSend extends CartState {
  OrderFailToSend();
}
