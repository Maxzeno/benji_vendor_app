import 'package:benji_vendor/app/orders/orders.dart';
import 'package:benji_vendor/main.dart';
import 'package:benji_vendor/src/controller/user_controller.dart';
import 'package:benji_vendor/src/model/user_model.dart';
import 'package:benji_vendor/src/providers/api_url.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

const String userBalance = "userBalance";

// API URLS AND HTTP CALL FUNCTIONS

bool rememberBalance() {
  bool remember = prefs.getBool(userBalance) ?? true;
  return remember;
}

void setRememberBalance(bool show) {
  prefs.setBool(userBalance, show);
}

Future<bool> isAuthorized() async {
  final response = await http.get(
    Uri.parse('$baseURL/auth/'),
    headers: authHeader(),
  );
  return response.statusCode == 200;
}

Map<String, String> authHeader([String? authToken, String? contentType]) {
  if (authToken == null) {
    UserModel user = UserController.instance.user.value;
    authToken = user.token;
  }

  Map<String, String> res = {
    'Authorization': 'Bearer $authToken',
  };
  // 'Content-Type': 'application/json', 'application/x-www-form-urlencoded'

  if (contentType != null) {
    res['Content-Type'] = contentType;
  }
  return res;
}

String statusTypeConverter(StatusType statusType) {
  if (statusType == StatusType.delivered) {
    return "COMP";
  }
  if (statusType == StatusType.pending) {
    return "PEND";
  }
  if (statusType == StatusType.cancelled) {
    return "CANC";
  }
  return "COMP";
}

class UppercaseTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
