import 'package:flutter_view_model/utils/string_utils.dart';

class Subscription {
  // Properties
  final String message;
  final int subscriptionToken;

  // Messages
  Subscription(this.message, this.subscriptionToken)
      : assert(!isEmpty(message)),
        assert(subscriptionToken != null);
}
