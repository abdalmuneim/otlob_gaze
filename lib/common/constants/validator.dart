// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otlob_gas/common/utils.dart';

enum ValidationType {
  phone,
  name,
  cardNumber,
  notEmpty,
  email,
  password,
  validationCode
}

class AppValidator {
  static FilteringTextInputFormatter priceValueOnly() {
    return FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'));
  }

  static String? validateFields(
    String? value,
    ValidationType fieldType,
    BuildContext context,
  ) {
    if (value == null) {
      return Utils.localization?.please_fill_this_field ?? '';
    } else if (fieldType == ValidationType.notEmpty) {
      if (value.trim().isEmpty || value.isEmpty) {
        return Utils.localization?.please_fill_this_field ?? '';
      }
    } else if (fieldType == ValidationType.name) {
      if (!RegExp(r'^[a-zA-zأ-ي\s]+$').hasMatch(value)) {
        return Utils.localization?.enter_valid_name ?? '';
      }
    } else if (fieldType == ValidationType.email) {
      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
        return Utils.localization?.enter_valid_email ?? '';
      }
    } else if (fieldType == ValidationType.phone) {
      /* if (!RegExp(r'^1[0125][0-9]{8}$').hasMatch(value)) {
        return Utils.translate(context)?.enter_valid_phone ?? '';
      }*/
      return null;
    } else if (fieldType == ValidationType.cardNumber) {
      if (value.length != 15) {
        return Utils.localization?.valid_card_number ?? '';
      }
      return null;
    } else if (fieldType == ValidationType.password) {
      if (value.length < 6) {
        return Utils.localization?.enter_valid_password ?? '';
      }
    } else if (fieldType == ValidationType.validationCode) {
      if (value.isEmpty || value.length != 5) {
        return Utils.localization?.enter_valid_verification_code ?? '';
      }
    }
    return null;
  }
}
