////////////////////
library;

extension ConvertToString on String {
  String get convertToString => '"${toString()}"';
}

////////////////////
extension ToNullStringExtension on String? {
  String toNullString() {
    if (this == null ||
        this!.trim().isEmpty ||
        this!.trim().toLowerCase() == 'null') {
      return '';
    }
    return this!;
  }
}

extension ToNullIntExtension on int? {
  int toNullInt() {
    final parsedInt = int.tryParse(toString());
    if (parsedInt == null || parsedInt <= 0) {
      return 0;
    }
    return int.parse(parsedInt.toString());
  }
}

subStringText(text, [int from = 0, int max = 10]) {
  return text.toString().length > max
      ? '${text.toString().substring(from, max - 1)}...'
      : text.toString();
}
