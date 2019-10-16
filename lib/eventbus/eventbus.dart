import 'dart:async';

import 'package:flutter_view_model/eventbus/subscription.dart';
import 'package:flutter_view_model/eventbus/subscription_handler.dart';
import 'package:flutter_view_model/eventbus/subscriptions.dart';

class EventBus {
  // Properties
  static final EventBus _singleton = new EventBus._internal();

  final Map<String, Subscriptions> _messageSubscriptions;

  // Methods
  factory EventBus() => _singleton;

  EventBus._internal() : _messageSubscriptions = Map<String, Subscriptions>();

  Subscription subscribe<TMessage>(
      String message, MessageHandler<TMessage> handler) {
    return subscribeWithPriority(message, 9999, handler);
  }

  Subscription subscribeWithPriority<TMessage>(
      String message, int priority, MessageHandler<TMessage> handler) {
    Subscriptions<TMessage> subscriptions;
    if (!_messageSubscriptions.containsKey(message)) {
      subscriptions = Subscriptions<TMessage>(message);
      _messageSubscriptions[message] = subscriptions;
    } else {
      subscriptions = _messageSubscriptions[message];
    }
    return subscriptions.subscribe(priority, handler);
  }

  void unsubscribe(Subscription subscription) {
    if (!_messageSubscriptions.containsKey(subscription.message)) {
      return;
    }
    _messageSubscriptions[subscription.message].unsubscribe(subscription);
  }

  void unsubscribeAll(List<Subscription> subscriptions) {
    assert(subscriptions != null);

    for (var subscription in subscriptions) {
      if (subscription == null) {
        continue;
      }
      if (!_messageSubscriptions.containsKey(subscription.message)) {
        continue;
      }

      _messageSubscriptions[subscription.message].unsubscribe(subscription);
    }
    subscriptions.clear();
  }

  Future<void> sendMessage<TMessageData>(
      Object sender, String message, TMessageData messageData) {
    if (!_messageSubscriptions.containsKey(message)) {
      return Future.value(null);
    }

    return _messageSubscriptions[message]
        .sendMessage<TMessageData>(sender, messageData);
  }
}
