import 'package:flutter/material.dart';
import 'package:marka_app/Data/Models/Cart.dart';
import 'package:marka_app/Data/Models/ProductModel.dart';

class StateWidget extends StatefulWidget {
  const StateWidget({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  State<StateWidget> createState() => _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  final Cart cart = Cart([]);

  void addToCart(Product product) {
    setState(() {
      cart.addToCart(product);
    });
  }

  @override
  Widget build(BuildContext context) => InheritedInjection(
        child: widget.child,
        cart: cart,
        stateWidget: this,
      );
}

class InheritedInjection extends InheritedWidget {
  final Cart cart;
  final Widget child;
  final _StateWidgetState stateWidget;
  const InheritedInjection(
      {Key? key,
      required this.child,
      required this.cart,
      required this.stateWidget})
      : super(key: key, child: child);

  // Cart get cart => _cart;

  static _StateWidgetState of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<InheritedInjection>()!
      .stateWidget;

  @override
  bool updateShouldNotify(InheritedInjection oldWidget) {
    return true;
  }
}
