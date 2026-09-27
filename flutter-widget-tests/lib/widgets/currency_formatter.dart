import 'package:flutter/services.dart';

class NaturalCurrencyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;

    if (text.isEmpty) return newValue;

    bool negative = text.startsWith('-');
    if (negative) {
      text = text.substring(1);
    }

    text = text.replaceAll(',', '');

    if ('.'.allMatches(text).length > 1) return oldValue;

    List<String> parts = text.split('.');
    String integerPart = parts[0].replaceAll(RegExp(r'[^0-9]'), '');
    String? decimalPart = parts.length > 1 ? parts[1] : null;

    if (decimalPart != null && decimalPart.length > 2) {
      decimalPart = decimalPart.substring(0, 2);
    }

    String formattedInteger = "";

    if (integerPart.isNotEmpty) {
      final buffer = StringBuffer();
      int count = 0;
      for (int i = integerPart.length - 1; i >= 0; i--) {
        buffer.write(integerPart[i]);
        count++;
        if (count == 3 && i != 0) {
          buffer.write(',');
          count = 0;
        }
      }
      formattedInteger = buffer.toString().split('').reversed.join();
    } else {
      if (text.startsWith('.')) formattedInteger = "0";
    }

    double? value = double.tryParse(
      integerPart + (decimalPart != null ? '.$decimalPart' : ''),
    );
    if (value != null && value > 10000000.0) {
      integerPart = '10000000';
      if (decimalPart != null) {
        decimalPart = decimalPart.isEmpty
            ? '00'
            : (decimalPart.length > 2
                  ? decimalPart.substring(0, 2)
                  : decimalPart);
      }
      final buffer2 = StringBuffer();
      int count2 = 0;
      for (int i = integerPart.length - 1; i >= 0; i--) {
        buffer2.write(integerPart[i]);
        count2++;
        if (count2 == 3 && i != 0) {
          buffer2.write(',');
          count2 = 0;
        }
      }
      formattedInteger = buffer2.toString().split('').reversed.join();
    }

    String result =
        formattedInteger +
        (decimalPart != null
            ? '.$decimalPart'
            : (text.endsWith('.') ? '.' : ''));
    if (negative) result = '-$result';

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}
