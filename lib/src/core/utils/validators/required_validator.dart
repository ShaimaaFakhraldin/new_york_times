import 'package:flutter/material.dart';
import 'package:new_york_times/src/core/translations/l10n.dart';

import 'base_validator.dart';

class RequiredValidator extends BaseValidator {
  bool? isFromVerificationPage;

  RequiredValidator({this.isFromVerificationPage});

  @override
  String getMessage(BuildContext? context) {
    if (isFromVerificationPage != null && isFromVerificationPage!) return '*';
    return S.of(context!).required_field;
  }

  @override
  bool validate(String value) {
    return value.isNotEmpty;
  }
}
