import 'package:flutter/material.dart';
import 'package:foodscanner/database/database_helper.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final ean = TextEditingController();
  final name = TextEditingController();
  final ingredients = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Add  a new product')),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            FractionallySizedBox(
                widthFactor: 0.7,
                child: TextField(
                    controller: ean,
                    decoration: const InputDecoration(labelText: 'EAN Code'))),
            FractionallySizedBox(
                widthFactor: 0.7,
                child: TextField(
                    controller: name,
                    decoration: const InputDecoration(labelText: 'Name'))),
            FractionallySizedBox(
                widthFactor: 0.7,
                child: TextField(
                    controller: ingredients,
                    minLines: 3,
                    maxLines: 10,
                    decoration:
                        const InputDecoration(labelText: 'Ingredients'))),
            Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                    child: ElevatedButton(
                        child: const Text('Insert'),
                        onPressed: () async {
                          final mongoDbService = MongoDbService();
                          await mongoDbService.connect(
                              "mongodb+srv://user:user@cluster.raammjg.mongodb.net/?retryWrites=true&w=majority");
                          await MongoDbService().addDocument('Products', {
                            'EAN': ean.text,
                            'name': name.text,
                            'ingredients': ingredients.text
                          });
                          await mongoDbService.closeConnection();
                          showAlertDialog(name.text);
                          ean.clear();
                          name.clear();
                          ingredients.clear();
                        })))
          ],
        ),
      ));

  showAlertDialog(String name) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Dodano nowy produkt"),
      content: Text(name),
      actions: [
        okButton,
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
