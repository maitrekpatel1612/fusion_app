import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../../utils/sidebar.dart'; // Sidebar import
import '../../utils/bottom_bar.dart'; // Bottom bar import
import 'PCC_Admin.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DownloadPage(),
  ));
}

class DownloadPage extends StatelessWidget {
  final List<Map<String, String>> documents = [
    {"title": "IntellectualPropertyFillingForm", "file": "assets/Annexure.pdf"},
    {"title": "NonDisclosureAgreement", "file": "assets/Annexure.pdf"},
    {"title": "PatentApplicationChecklist", "file": "assets/Annexure.pdf"},
  ];

  void downloadAndOpenPDF(String fileName) async {
    try {
      final ByteData bytes = await rootBundle.load(fileName);
      final Uint8List list = bytes.buffer.asUint8List();
      String base64String = base64Encode(list);
      String dataUrl = "data:application/pdf;base64,$base64String";

      final anchor = html.AnchorElement(href: dataUrl)
        ..setAttribute("download", fileName.split('/').last)
        ..click();
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      drawer: Drawer(
        child: Sidebar(), // Sidebar used as Drawer
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.blue),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Subtitle
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Download Forms and Documents',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Click the button to download necessary forms.',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Document List Card
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "You can review the document title and click the \"Download\" button to access the desired file.",
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 16),

                          // Table or Mobile Cards
                          if (!isMobile)
                            Table(
                              border: TableBorder.all(color: Colors.blue),
                              columnWidths: {
                                0: FlexColumnWidth(1),
                                1: FlexColumnWidth(3),
                                2: FlexColumnWidth(2),
                              },
                              children: [
                                buildTableRow(
                                    ["S.NO", "Document Title", "Download"],
                                    isHeader: true),
                                ...List.generate(documents.length, (index) {
                                  return buildTableRow([
                                    "${index + 1}",
                                    documents[index]["title"]!,
                                    "Download"
                                  ],
                                      file: documents[index]["file"]!,
                                      rowIndex: index);
                                })
                              ],
                            )
                          else
                            Column(
                              children:
                                  List.generate(documents.length, (index) {
                                final doc = documents[index];
                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("S.NO: ${index + 1}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 8),
                                        Text("Document Title: ${doc["title"]}"),
                                        SizedBox(height: 8),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton.icon(
                                            onPressed: () => downloadAndOpenPDF(
                                                doc["file"]!),
                                            style: TextButton.styleFrom(
                                              side: BorderSide(
                                                  color: Colors.blue),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                            ),
                                            icon: Icon(Icons.download,
                                                size: 18, color: Colors.blue),
                                            label: Text("Download",
                                                style: TextStyle(
                                                    color: Colors.blue)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Navigation
                  
                ],
              ),
            ),
          ),

          // Bottom Bar
          BottomBar(),
        ],
      ),
    );
  }

  TableRow buildTableRow(List<String> cells,
      {bool isHeader = false, String? file, int rowIndex = 0}) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader
            ? Colors.blue[100]
            : (rowIndex % 2 == 0 ? Colors.white : Colors.grey[50]),
      ),
      children: cells.map((cell) {
        final isDownload = cell == "Download" && !isHeader;
        return Padding(
          padding: EdgeInsets.all(8),
          child: isDownload
              ? TextButton.icon(
                  onPressed: () {
                    if (file != null) downloadAndOpenPDF(file);
                  },
                  icon: Icon(Icons.download, size: 18, color: Colors.blue),
                  label: Text("Download", style: TextStyle(color: Colors.blue)),
                  style: TextButton.styleFrom(
                    side: BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                )
              : Text(
                  cell,
                  style: TextStyle(
                    fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
        );
      }).toList(),
    );
  }

  Widget buildNavButton(BuildContext context, String title) {
    return OutlinedButton.icon(
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PatentDashboardPage()),
          (route) => false,
        );
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.blue),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: Icon(Icons.arrow_back, color: Colors.blue, size: 16),
      label: Text(title, style: TextStyle(color: Colors.blue)),
    );
  }
}
