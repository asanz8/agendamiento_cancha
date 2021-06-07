class _Util {

  int formatDateMilliStart(DateTime dt) {
    return DateTime.parse('${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}').millisecondsSinceEpoch;
  }

  String dateFormat(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

}

final util = _Util();