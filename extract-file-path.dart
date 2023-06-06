String extractFilePath(String input) {
  final RegExp regExp = RegExp(r'\.\/blog_data\/[\w\d_-]+\.zip');
  final match = regExp.firstMatch(input);

  if (match != null) {
    return match.group(0)!;
  } else {
    throw Exception('Zip file path not found');
  }
}
