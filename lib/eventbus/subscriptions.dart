import '../utils/string_utils.dart';

import 'subscription.dart';
import 'subscription_handler.dart';

class Subscriptions<TMessageData> {
  // Properties
  int _subscriptionToken = 0;
  final String _message;
  final Map<int, SubscriptionHandler<TMessageData>> _subscriptions;

  // Methods
  Subscriptions(String message)
      : assert(!isEmpty(message)),
        _message = message,
        _subscriptions = Map<int, SubscriptionHandler<TMessageData>>();

  Subscription subscribe(int priority, MessageHandler<TMessageData> handler) {
    assert(handler != null);
    final subscription = Subscription(_message, ++_subscriptionToken);
    final subscriber = SubscriptionHandler<TMessageData>(priority, handler);
    _subscriptions[subscription.subscriptionToken] = subscriber;

    return subscription;
  }

  void unsubscribe(Subscription subscription) {
    assert(subscription != null);

    if (!_subscriptions.containsKey(subscription.subscriptionToken)) {
      return;
    }

    _subscriptions.remove(subscription.subscriptionToken);
  }

  Future<void> sendMessage<TMessageData>(Object sender, messageData) {
    final orderedSubscribers = _subscriptions.values.toList();
    if (orderedSubscribers.length != 0) {
      orderedSubscribers.sort((a, b) => a.priority.compareTo(b.priority));
    }

    List<Future<void>> handlerFutures = List<Future<void>>();
    for (var handler in orderedSubscribers) {
      handlerFutures.add(handler.messageHandler(sender, messageData));
    }

    return handlerFutures.length == 0
        ? Future.value(null)
        : Future.wait(handlerFutures);
  }
}
