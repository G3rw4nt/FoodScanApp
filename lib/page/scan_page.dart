import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:foodscanner/database/database_helper.dart';
import 'package:foodscanner/page/add_page.dart';
import 'package:foodscanner/page/product_page.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String? scanResult;
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Make a scan')),
      body: Container(
        margin: const EdgeInsets.only(top: 100),
        child: Center(
            child: Column(
          children: [
            Text(
                scanResult == null || scanResult == '-1'
                    ? 'Scan a code!'
                    : 'Scan result: $scanResult',
                style: const TextStyle(fontSize: 18)),
            ElevatedButton(
                onPressed: ScanBarcode, child: const Text(' Start Scan'))
          ],
        )),
      ));

  Future ScanBarcode() async {
    String scanResult;

    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
          "#00FF00", "Cancel", true, ScanMode.BARCODE);
      final mongoDbService = MongoDbService();
      await mongoDbService.connect(
          "mongodb+srv://user:user@cluster.raammjg.mongodb.net/?retryWrites=true&w=majority");
      Future products =
          MongoDbService().getDocumentsByEAN("Products", scanResult);
      List productsList = await products;
      print(productsList);
      if (productsList.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(productsList: productsList),
          ),
        );
      } else {
        showYesNoAlertDialog();
      }
      await mongoDbService.closeConnection();
    } on PlatformException {
      scanResult = 'Failed to get scan';
    }
    if (!mounted) return;

    setState(() => this.scanResult = scanResult);
  }

  showYesNoAlertDialog() {
    // set up the YES button
    Widget yesButton = TextButton(
      child: Text("YES"),
      onPressed: () {
        Navigator.pop(context); // Close the dialog
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddPage()),
        );
      },
    );

    // set up the NO button
    Widget noButton = TextButton(
      child: Text("NO"),
      onPressed: () {
        Navigator.pop(context); // Close the dialog
      },
    );

    // set up the AlertDialog with YES and NO buttons
    AlertDialog alert = AlertDialog(
      title: Text("Product missing"),
      content: Text("Would you like to add new product?"),
      actions: [
        yesButton,
        noButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
