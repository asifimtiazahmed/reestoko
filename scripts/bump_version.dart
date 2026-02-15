import 'dart:io';

void main() {
  final file = File('pubspec.yaml');
  if (!file.existsSync()) {
    print('pubspec.yaml not found');
    exit(1);
  }

  final lines = file.readAsLinesSync();
  final versionRegex = RegExp(r'^(version:\s+\d+\.\d+\.)(\d+)(\+)(\d+)$');
  
  final updatedLines = lines.map((line) {
    final match = versionRegex.firstMatch(line);
    if (match != null) {
      final prefix = match.group(1)!;
      final patch = int.parse(match.group(2)!) + 1;
      final plus = match.group(3)!;
      final build = int.parse(match.group(4)!) + 1;
      final newVersion = '$prefix$patch$plus$build';
      print('Bumping version: ${match.group(0)} -> $newVersion');
      return newVersion;
    }
    return line;
  }).toList();

  file.writeAsStringSync(updatedLines.join('\n') + '\n');
}
