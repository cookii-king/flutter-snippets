  downloadContent(String input_url, String filePath) async {
    if (kIsWeb) {
      final response = await http.post(
        Uri.parse(input_url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'filepath': filePath}),
      );
      if (response.statusCode == 200) {
        final mimeType =
            response.headers['content-type'] ?? 'application/octet-stream';

        // Download file in Flutter web
        final blob = html.Blob([response.bodyBytes], mimeType);
        final output_url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: output_url)
          ..setAttribute("download", filePath)
          ..click();
        html.Url.revokeObjectUrl(output_url);
        print('File downloaded: $filePath');
      } else {
        print('Failed to download file');
      }
    } else {}
  }
