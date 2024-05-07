import 'package:flutter/cupertino.dart';

class Colors {
  const Colors();
  static const Color loginGradientStart =
      const Color.fromRGBO(20, 31, 181, 100);
  static const Color loginGradientEnd = const Color.fromRGBO(52, 62, 202, 17);

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
