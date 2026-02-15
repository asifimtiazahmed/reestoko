import 'dart:io';

void main() {
  final file = File('pubspec.yaml');
  if (!file.existsSync()) {
    print('pubspec.yaml not found');
    exit(1);
  }

  final lines = file.readAsLinesSync();
  // Matches 'version: x.y.z+w' capturing 'version: x.y.z' and 'w'
  final versionRegex = RegExp(r'^(version:\s+\d+\.\d+\.\d+)\+(\d+)$');
  
  final updatedLines = lines.map((line) {
    final match = versionRegex.firstMatch(line);
    if (match != null) {
      final baseVersion = match.group(1)!;
      final buildNumber = int.parse(match.group(2)!) + 1;
      final newVersion = '$baseVersion+$buildNumber';
      print('Bumping build number: ${match.group(0)} -> $newVersion');
      return newVersion;
    }
    return line;
  }).toList();

  file.writeAsStringSync(updatedLines.join('\n') + '\n');
}
