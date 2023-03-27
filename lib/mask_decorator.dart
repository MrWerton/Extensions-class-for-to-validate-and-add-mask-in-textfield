//class for add mask in text field

import 'package:flutter/material.dart';

class MaskDecorator extends TextEditingController {
  final String mask;
  final RegExp _maskRegExp;

  MaskDecorator({required this.mask, String? text})
      : _maskRegExp = RegExp(mask.replaceAll('#', r'\d')),
        super(text: text) {
    addListener(_onChanged);
  }

  void _onChanged() {
    final nonMaskedValue = text!.replaceAll(RegExp('[^0-9]'), '');
    String maskedText = '';
    var maskIndex = 0;
    for (var i = 0; i < nonMaskedValue.length; i++) {
      if (maskIndex >= mask.length) {
        break;
      }
      if (mask[maskIndex] == '#') {
        maskedText += nonMaskedValue[i];
        maskIndex++;
      } else {
        maskedText += mask[maskIndex];
        maskIndex++;
        i--;
      }
    }
    value = TextEditingValue(
      text: maskedText,
      selection: TextSelection.fromPosition(
        TextPosition(offset: maskedText.length),
      ),
    );
  }

  bool isValid() {
    return _maskRegExp.hasMatch(text!);
  }
}
