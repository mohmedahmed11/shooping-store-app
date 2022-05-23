import 'package:bloc/bloc.dart';
import 'package:marka_app/Data/Api/API_Repository.dart';
import 'package:marka_app/Data/Models/Cart.dart';
import 'package:marka_app/Data/Models/OrderModel.dart';
import 'package:marka_app/Data/Models/ProductModel.dart';
import 'package:marka_app/Data/Repositories/order_repository.dart';
import 'package:marka_app/blocs/Heppler.dart';
import 'package:meta/meta.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> with Disposable {
  final OrderRepository orderRepository;
  CartCubit(this.orderRepository) : super(CartInitial());
  Cart cart = Cart([]);
  Order? order;

  getCartItemsCount() {
    emit(CartLoaded());
  }

  addToCart(Product item) {
    // cart.products.add(item);
    emit(newItemAdded());
  }

  sendOrder(dynamic orderData) {
    // cart.products.add(item);

    emit(OrderSending());
    orderRepository.postOrder(orderData).then((responce) {
      if (responce.status == Status.error) {
        emit(OrderFailToSend());
      } else if (responce.status == Status.completed) {
        // print("object");
        order = Order.fromJson(responce.data);
        emit(OrderSended(order!));
      } else {
        emit(OrderSending());
      }
    });

    return order;
  }

  // @override
  // Future<void> close() {
  //   dispose();
  //   return super.close();
  // }
}
