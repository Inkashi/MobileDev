import 'package:flutter/material.dart';
import 'package:productapp/constants/constants.dart';
import 'package:productapp/models/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:productapp/database/groupdb.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late ProductModel currProduct;
  bool initModel = false;
  final favorite = Hive.box("groupsBox");
  Favorite db = Favorite();
  late final productId;
  final consts = Constants();
  bool isFavorite = false;
  @override
  void initState() {
    super.initState();
    db.loadData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchedProduct();
    });
  }

  void fetchedProduct() async {
    final productId =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    ProductModel fetchedWeather = await fetchProduct(productId['table_id']);
    setState(() {
      currProduct = fetchedWeather;
      initModel = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!initModel) {
      return const Center(child: CircularProgressIndicator());
    }
    isFavorite = db.groups.any((product) =>
        product[0]['id'] == currProduct.id &&
        product[0]['name'] == currProduct.name);

    return Scaffold(
      appBar: AppBar(
        title: Text(currProduct.name),
        flexibleSpace: consts.appbarGradien,
        actions: [
          Row(
            children: [
              Text('Избранное:', style: consts.fontfamily),
              Checkbox(
                  value: isFavorite,
                  onChanged: (bool? newValue) {
                    addFavorite(currProduct);
                  })
            ],
          )
        ],
      ),
      body: Container(
        decoration: consts.gradientBox,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withAlpha(80),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Название продукта: ${currProduct.name}',
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withAlpha(80),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Все данные предоставленны на ${currProduct.grams.floor()}грамм данного продукта',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withAlpha(80),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Данный продукт содержит ${currProduct.calories.floor()} калорий',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withAlpha(80),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text('Пищевая ценность:'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('Жиры:${currProduct.fats}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('Белки:${currProduct.proteins}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('Углеводы:${currProduct.carbohydrates}'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withAlpha(80),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        currProduct.contraindications,
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addFavorite(ProductModel card) {
    if (!isFavorite) {
      db.groups.add([
        {'id': card.id, 'name': card.name}
      ]);
    } else {
      db.groups.removeWhere((product) =>
          product[0]['id'] == card.id && product[0]['name'] == card.name);
    }
    setState(() {
      db.updateData();
    });
  }

  Future<ProductModel> fetchProduct(int id) async {
    final List<Map<String, dynamic>> product =
        await Supabase.instance.client.from('products').select().eq('id', id);
    ProductModel temp = ProductModel.fromData(product[0]);
    return temp;
  }
}
