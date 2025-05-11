import 'package:flutter/material.dart';
import 'newattform.dart';
import 'attrprofile.dart';
import 'shared_data.dart';
import '../../utils/sidebar.dart'; // Import the sidebar
import '../../utils/bottom_bar.dart'; // Import the bottom bar

class RemoveAttorneyPage extends StatefulWidget {
  @override
  _RemoveAttorneyPageState createState() => _RemoveAttorneyPageState();
}

class _RemoveAttorneyPageState extends State<RemoveAttorneyPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {}); // Refresh if attorneys changed
  }

  TableRow buildTableRow(List<dynamic> cells,
      {bool isHeader = false, int? rowIndex}) {
    return TableRow(
      decoration:
          BoxDecoration(color: isHeader ? Colors.blue[100] : Colors.white),
      children: cells.map((cell) {
        if (isHeader) {
          return Padding(
            padding: EdgeInsets.all(8),
            child: Text(cell.toString(),
                style: TextStyle(fontWeight: FontWeight.bold)),
          );
        } else if (cell == 'Select' && rowIndex != null) {
          return Padding(
            padding: EdgeInsets.all(8),
            child: Checkbox(
              value: sharedAttorneys[rowIndex]['selected'] ?? false,
              onChanged: (val) {
                setState(() {
                  sharedAttorneys[rowIndex]['selected'] = val!;
                });
              },
            ),
          );
        } else if (cell == 'View Details' && rowIndex != null) {
          return Padding(
            padding: EdgeInsets.all(8),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AttorneyProfilePage()),
                );
              },
              style: TextButton.styleFrom(
                side: BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              child: Text("View Details", style: TextStyle(color: Colors.blue)),
            ),
          );
        } else {
          return Padding(
            padding: EdgeInsets.all(8),
            child: Text(cell.toString()),
          );
        }
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      drawer: const Sidebar(), // Sidebar added
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the drawer when the menu icon is tapped
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header same as other pages…
            

            SizedBox(height: 16),
            Center(
                child: Text('Manage Attorney Assignments',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue))),
            SizedBox(height: 16),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select attorneys below to remove them.",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 16),
                    // Table or Card layout:
                    isMobile ? buildCardLayout() : buildTableLayout(),
                    SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          sharedAttorneys
                              .removeWhere((att) => att['selected'] == true);
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red),
                      ),
                      child: Text("Remove selected",
                          style: TextStyle(color: Colors.red)),
                    ),
                    SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey),
                      ),
                      child:
                          Text("CANCEL", style: TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(), // Bottom bar added
    );
  }

  Widget buildTableLayout() {
    List<TableRow> rows = [
      buildTableRow(
          ["Select", "S.NO", "Attorney Name", "Attorney ID", "Action"],
          isHeader: true)
    ];
    for (int i = 0; i < sharedAttorneys.length; i++) {
      final a = sharedAttorneys[i];
      rows.add(buildTableRow(
          ["Select", "${i + 1}", a['name'], a['id'], "View Details"],
          rowIndex: i));
    }
    return Table(
      border: TableBorder.all(color: Colors.blue),
      columnWidths: {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(1.5),
        4: FlexColumnWidth(2),
      },
      children: rows,
    );
  }

  Widget buildCardLayout() {
    return Column(
      children: sharedAttorneys.asMap().entries.map((entry) {
        final i = entry.key;
        final data = entry.value;
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Attorney Name: ${data['name']}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Attorney ID: ${data['id']}"),
                Row(
                  children: [
                    Text("Select: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Checkbox(
                      value: data['selected'] ?? false,
                      onChanged: (val) {
                        setState(() {
                          data['selected'] = val!;
                        });
                      },
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AttorneyProfilePage()),
                        );
                      },
                      style: TextButton.styleFrom(
                        side: BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                      ),
                      child: Text("View Details",
                          style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}