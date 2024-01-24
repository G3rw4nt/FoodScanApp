import 'package:flutter/material.dart';
import 'package:foodscanner/database/database_helper.dart';

class ProductPage extends StatelessWidget {
  final List productsList;
  final MongoDbService mongoDbService = MongoDbService();

  ProductPage({Key? key, required this.productsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Wystąpił błąd: ${snapshot.error}'),
            ),
          );
        } else {
          return _buildPage(snapshot.data as Map<String, dynamic>);
        }
      },
    );
  }

  Future<Map<String, dynamic>> _loadData() async {
    await mongoDbService.connect(
        "mongodb+srv://user:user@cluster.raammjg.mongodb.net/?retryWrites=true&w=majority");

    if (productsList.isNotEmpty) {
      final product = productsList.first;
      List<String> ingredientsList = product['ingredients'].split(', ');

      final harmfulIngredients = await mongoDbService.getDocumentsByIngredients(
          'HarmfulIngredients', ingredientsList);

      await mongoDbService.closeConnection();

      return {
        'product': product,
        'harmfulIngredients': harmfulIngredients,
      };
    } else {
      await mongoDbService.closeConnection();
      return {
        'product': null,
        'harmfulIngredients': [],
      };
    }
  }

  Widget _buildPage(Map<String, dynamic> data) {
    final product = data['product'];
    final harmfulIngredients = data['harmfulIngredients'];

    if (product != null) {
      List<String> ingredientsList = product['ingredients'].split(', ');

      return Scaffold(
        appBar: AppBar(
          title: Text('Product Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'EAN: ${product['EAN']}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Name: ${product['name']}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Ingredients:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                ingredientsList.join(', '),
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              Text(
                'Harmful Ingredients:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: harmfulIngredients.isEmpty
                    ? [
                        Text(
                          'Brak szkodliwych składników!',
                          style: TextStyle(fontSize: 18),
                        )
                      ]
                    : harmfulIngredients
                        .map<Widget>(
                          (ingredient) => Text(
                            '${ingredient['Name']}: ${ingredient['Description']}',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Product Page'),
        ),
        body: Center(
          child: Text(
            'Brak danych produktu',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }
  }
}
