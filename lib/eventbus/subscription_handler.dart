typedef MessageHandler<TMessage> = Future<void> Function(
    Object sender, TMessage message);

class SubscriptionHandler<TMessageData> {
  // Properties
  final int priority;
  final MessageHandler<TMessageData> messageHandler;

  // Methods
  SubscriptionHandler(this.priority, this.messageHandler);
}
