
///use this extension when you have simple string
///less than 1000 word for example
extension SimpleStringExtension on String {
  String toSimpleTitleCase() {
    return split(' ')
        .map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    })
        .join(' ');
  }
}

///use StringBuffer for big articles nad paragraphs
extension BigStringExtension on String {
  String toBigTitleCase() {
    final buffer = StringBuffer();
    bool newWord = true;

    for (final rune in runes) {
      final char = String.fromCharCode(rune);

      if (char == ' ') {
        newWord = true;
        buffer.write(char);
      } else {
        buffer.write(
          newWord ? char.toUpperCase() : char.toLowerCase(),
        );
        newWord = false;
      }
    }

    return buffer.toString();
  }
}
