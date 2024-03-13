/// Linearly interpolate between two numbers, `a` and `b`, by an extrapolation
/// factor `t`.
///
/// When `a` and `b` are equal or both NaN, `a` is returned.  Otherwise,
/// `a`, `b`, and `t` are required to be finite or null, and the result of `a +
/// (b - a) * t` is returned, where nulls are defaulted to 0.0.
double? lerpDouble(num? a, num? b, double t) {
  if (a == b || (a?.isNaN == true) && (b?.isNaN == true)) {
    return a?.toDouble();
  }
  a ??= 0.0;
  b ??= 0.0;
  assert(a.isFinite, 'Cannot interpolate between finite and non-finite values');
  assert(b.isFinite, 'Cannot interpolate between finite and non-finite values');
  assert(t.isFinite, 't must be finite when interpolating between values');
  return a * (1.0 - t) + b * t;
}

/// Linearly interpolate between two integers.
///
/// When `a` and `b` are equal or both NaN, `a` is returned.  Otherwise,
/// `a`, `b`, and `t` are required to be finite or null, and the result of `a +
/// (b - a) * t` is returned, where nulls are defaulted to 0.0.
int? lerpInt(int? a, int? b, double t) {
  if (a == b || (a?.isNaN == true) && (b?.isNaN == true)) {
    return a?.toInt();
  }
  a ??= 0;
  b ??= 0;
  assert(a.isFinite, 'Cannot interpolate between finite and non-finite values');
  assert(b.isFinite, 'Cannot interpolate between finite and non-finite values');
  assert(t.isFinite, 't must be finite when interpolating between values');
  return (a + (b - a) * t).round();
}

bool? lerpBool(bool? a, bool? b, double t) => t < 0.5 ? a : b;

T? lerpEnum<T>(T? a, T? b, double t) => t < 0.5 ? a : b;
