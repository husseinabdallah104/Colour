library colours;
import 'dart:math';

import 'package:flutter/material.dart';


class Colours extends Color {
  

  /// Construct a color from the lower 32 bits of an [int].
  ///
  /// The bits are interpreted as follows:
  ///
  /// * Bits 24-31 are the alpha value.
  /// * Bits 16-23 are the red value.
  /// * Bits 8-15 are the green value.
  /// * Bits 0-7 are the blue value.
  ///
  /// In other words, if AA is the alpha value in hex, RR the red value in hex,
  /// GG the green value in hex, and BB the blue value in hex, a color can be
  /// expressed as `const Color(0xAARRGGBB)`.
  ///
  /// For example, to get a fully opaque orange, you would use `const
  /// Color(0xFFFF9000)` (`FF` for the alpha, `FF` for the red, `90` for the
  /// green, and `00` for the blue).
  @pragma('vm:entry-point')
  Colours(int value) : super(value);

  /// Construct a color from the lower 8 bits of four integers.
  ///
  /// * `a` is the alpha value, with 0 being transparent and 255 being fully
  ///   opaque.
  /// * `r` is [red], from 0 to 255.
  /// * `g` is [green], from 0 to 255.
  /// * `b` is [blue], from 0 to 255.
  ///
  /// Out of range values are brought into range using modulo 255.
  ///
  /// See also [fromRGBO], which takes the alpha value as a floating point
  /// value.
  Colours.fromARGB(int a, int r, int g, int b) : super.fromARGB(a,r,g,b);

  /// Create a color from red, green, blue, and opacity, similar to `rgba()` in CSS.
  ///
  /// * `r` is [red], from 0 to 255.
  /// * `g` is [green], from 0 to 255.
  /// * `b` is [blue], from 0 to 255.
  /// * `opacity` is alpha channel of this color as a double, with 0.0 being
  ///   transparent and 1.0 being fully opaque.
  ///
  /// Out of range values are brought into range using modulo 255.
  ///
  /// See also [fromARGB], which takes the opacity as an integer value.
  Colours.fromRGBO(int r, int g, int b, double opacity) : super.fromRGBO(r,g,b,opacity);

  Colours.fromCIELAB(int l, int a, int b, int alpha) : super(_valfromCIE(l,a,b,alpha));
  // from CIELAB Helpers
  static int _valfromCIE(int l, int a, int b, int alpha) {
        var Y = (l + 16.0)/116.0;
        var X = a/500 + Y;
        var Z = Y - b/200;
        X = _deltaXYZ(X)*0.95047;
        Y = _deltaXYZ(Y)*1.000;
        Z = _deltaXYZ(Z)*1.08883;
        var R = X*3.2406 + (Y * -1.5372) + (Z * -0.4986);
        var G = (X * -0.9689) + Y*1.8758 + Z*0.0415;
        var B = X*0.0557 + (Y * -0.2040) + Z*1.0570;
        Color c = Color.fromARGB(alpha, _deltaRGB(R), _deltaRGB(G), _deltaRGB(B));
        return c.value;
  }

  static _deltaXYZ(double k) {
    return (pow(k, 3.0) > 0.008856) ? pow(k, 3.0) : (k - 4/29.0)/7.787;
  }

  static _deltaRGB(double k) {
      return (k > 0.0031308) ? 1.055 * (pow(k, (1/2.4))) - 0.055 : k * 12.92;
  }


  Colours.fromCMYK(double c, double m, double y, double k) : super(_valfromCMYK(c,m,y,k));
  // from CMYK Helpers

  static int _valfromCMYK(double c, double m, double y, double k) {
      var C = _cmyTransform(c, k);
      var M = _cmyTransform(m, k);
      var Y = _cmyTransform(y, k);
      Color c = Color.fromARGB(1, 1 - C, 1 - M, 1 - Y);
      return c.value;
  }

  static _cmyTransform(double x, double k) {
      return x * (1 - k) + k;
  }

  
    
    // func hue() -> CGFloat {
    //     return hsba().h
    // }
    
    // func saturation() -> CGFloat {
    //     return hsba().s
    // }
    
    // func brightness() -> CGFloat {
    //     return hsba().b
    // }
    
    // func CIE_Lightness() -> CGFloat {
    //     return CIE_LAB().l
    // }
    
    // func CIE_a() -> CGFloat {
    //     return CIE_LAB().a
    // }
    
    // func CIE_b() -> CGFloat {
    //     return CIE_LAB().b
    // }
    
    // func cyan() -> CGFloat {
    //     return cmyk().c
    // }
    
    // func magenta() -> CGFloat {
    //     return cmyk().m
    // }
    
    // func yellow() -> CGFloat {
    //     return cmyk().y
    // }
    
    // func keyBlack() -> CGFloat {
    //     return cmyk().k
    // }
  
}
