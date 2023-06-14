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

downloadFirestoreDocument(String docPath, String filePath) async {
  if (kIsWeb) {
    // Fetch the document from Firestore
    final docRef = FirebaseFirestore.instance.doc(docPath);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // Convert the document data to JSON
      final docData = docSnapshot.data();
      final jsonData = jsonEncode(docData);

      // Create a Blob from the JSON data
      final blob = html.Blob([jsonData], 'application/json');

      // Create a URL for the Blob
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Create an anchor element and simulate a click to download the file
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', filePath)
        ..click();

      // Revoke the Blob URL
      html.Url.revokeObjectUrl(url);

      print('File downloaded: $filePath');
    } else {
      print('Document does not exist');
    }
  }
}

  ```ElevatedButton(
    onPressed: () async {
      try {
        final downloadedZipUrl = await generateContent();
        print(downloadedZipUrl);
        await downloadContent(
          "https://api.your-domain.com/download-content",
          downloadedZipUrl,
        );
      } catch (e) {
        print('Error: $e');
        // Handle the error as needed
      }
    },
    child: const Text("Download Content"),
  ),```
