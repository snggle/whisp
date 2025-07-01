import 'package:path/path.dart' as p;

class FileUtils {
  // On Android in case the name already exists, the number is added after the extension (e.g. "generated-sound.wav (1)")
  // This method fixes the name inside the path and implements incrementation manually.
  static Future<String> fixFileNameCounter(String outputPath, List<String> existingFileNamesList) async {
    String fileName = p.basename(outputPath);
    String directoryPath = p.dirname(outputPath);
    String fixedName = _fixWrongIncrementPosition(fileName);

    while (existingFileNamesList.contains(fixedName)) {
      fixedName = _incrementFileNumber(fixedName);
    }
    String fixedPath = p.join(directoryPath, fixedName);
    return fixedPath;
  }

  static String _fixWrongIncrementPosition(String fileName) {
    String fixedName = fileName.replaceFirst(RegExp(r'\.wav', caseSensitive: false), '');
    fixedName = fixedName.trim();
    return '$fixedName.wav';
  }

  static String _incrementFileNumber(String fileName) {
    String ext = p.extension(fileName);
    String baseName = p.basenameWithoutExtension(fileName);

    RegExp regex = RegExp(r'^(.*) \((\d+)\)$');
    RegExpMatch? match = regex.firstMatch(baseName);

    if (match != null) {
      String? namePart = match.group(1);
      int number = int.parse(match.group(2)!);
      int incremented = number + 1;
      return '$namePart ($incremented)$ext';
    } else {
      return '$baseName (1)$ext';
    }
  }
}
