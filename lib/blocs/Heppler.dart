import 'dart:async';

mixin Disposable on Object {
  void dispose() {
    // cancel all internal subscriptions
  }

  void addSubscription(StreamSubscription subscription) {
    // add subscription to internal data structure
  }
}
