library colours;
import 'dart:math';

import 'package:flutter/material.dart';

enum ColorScheme {
  analagous, monochromatic, triad, complementary
}
    
enum ColorFormulation {
  rgba, hsba, lab, cmyk
}

enum ColorDistance {
  cie76, cie94, cie2000
}

enum ColorComparison {
  darkness, lightness, desaturated, saturated, red, green, blue
}

class LMColor extends Color {
  
  
  LMColor(int value) : super(value);

  LMColor.fromARGB(int a, int r, int g, int b) : super.fromARGB(a,r,g,b);

  LMColor.fromRGBO(int r, int g, int b, double opacity) : super.fromRGBO(r,g,b,opacity);

  LMColor.fromCIELAB(int l, int a, int b, int alpha) : super(_valfromCIE(l,a,b,alpha));

  LMColor.fromCMYK(double c, double m, double y, double k) : super(_valfromCMYK(c,m,y,k));


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


  // from CMYK Helpers

  static int _valfromCMYK(double c, double m, double y, double k) {
      var C = _cmyTransform(c, k);
      var M = _cmyTransform(m, k);
      var Y = _cmyTransform(y, k);
      Color color = Color.fromARGB(1, 1 - C, 1 - M, 1 - Y);
      return color.value;
  }

  static _cmyTransform(double x, double k) {
      return x * (1 - k) + k;
  }

  cieLAB() {
        double r = red / 255.0;
        double g = green / 255.0;
        double b = blue / 255.0;

        // Create deltaRGB
        r = (r > 0.04045) ? pow((r + 0.055) / 1.055, 2.40) : (r / 12.92);
        g = (g > 0.04045) ? pow((g + 0.055) / 1.055, 2.40) : (g / 12.92);
        b = (b > 0.04045) ? pow((b + 0.055) / 1.055, 2.40) : (b / 12.92);

        // Create XYZ
        double X = r * 41.24 + g * 35.76 + b * 18.05;
        double Y = r * 21.26 + g * 71.52 + b * 7.22;
        double Z = r * 1.93 + g * 11.92 + b * 95.05;

        // Convert XYZ to L*a*b*
        X = X / 95.047;
        Y = Y / 100.000;
        Z = Z / 108.883;
        X = (X > pow((6.0 / 29.0), 3.0)) ? pow(X, 1.0 / 3.0) : (1 / 3) * pow((29.0 / 6.0), 2.0) * X + 4 / 29.0;
        Y = (Y > pow((6.0 / 29.0), 3.0)) ? pow(Y, 1.0 / 3.0) : (1 / 3) * pow((29.0 / 6.0), 2.0) * Y + 4 / 29.0;
        Z = (Z > pow((6.0 / 29.0), 3.0)) ? pow(Z, 1.0 / 3.0) : (1 / 3) * pow((29.0 / 6.0), 2.0) * Z + 4 / 29.0;
        double cieL = 116 * Y - 16;
        double cieA = 500 * (X - Y);
        double cieB = 200 * (Y - Z);
        List<double> cieLAB = [cieL, cieA, cieB];
        return cieLAB;
    }

    cmyk() {
        // TODO: check rgb value correctness
        double c = 1 - red / 255;
        double m = 1 - green / 255;
        double y = 1 - blue / 255;
        double k = min(1, min(c, min(m, y)));
        if (k == 1) {
            c = 0;
            m = 0;
            y = 0;
        } else {
            c = (c - k) / (1 - k);
            m = (m - k) / (1 - k);
            y = (y - k) / (1 - k);
        }
        List<double> cmyk = [c, m, y, k];
        return cmyk;
    }
  
  // double get hue => hsba()[0];

  // double get saturation => hsba()[1];

  // double get brightness => hsba()[2];

  double get cieLightness => cieLAB()[0];

  double get cieA => cieLAB()[1];

  double get cieB => cieLAB()[2];
    
  
  double get cyan => cmyk()[0];

  double get magenta => cmyk()[1];

  double get yellow => cmyk()[2];

  double get keyBlack => cmyk()[3];

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
