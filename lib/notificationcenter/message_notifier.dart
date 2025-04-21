import 'package:flutter/foundation.dart';

class MessageNotifier extends ChangeNotifier {
  String? _message;

  String? get message => _message;

  void setMessage(String msg) {
    _message = msg;
    notifyListeners();
  }

  void clear() {
    _message = null;
    notifyListeners();
  }
}
