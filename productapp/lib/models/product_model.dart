import 'package:flutter/material.dart';

class ProductModel {
  int id;
  String name;
  int category;
  double calories;
  double fats;
  double proteins;
  double carbohydrates;
  String contraindications;
  double grams;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.calories,
    required this.fats,
    required this.proteins,
    required this.carbohydrates,
    required this.contraindications,
    required this.grams,
  });

  factory ProductModel.fromData(Map<String, dynamic> data) {
    return ProductModel(
      id: data['id'],
      name: data['name'],
      category: data['category'],
      calories: data['calories'].toDouble(),
      fats: data['nutritional_value']['fats'].toDouble(),
      proteins: data['nutritional_value']['proteins'].toDouble(),
      carbohydrates: data['nutritional_value']['carbohydrates'].toDouble(),
      contraindications: data['contraindications'],
      grams: data['grams'].toDouble(),
    );
  }
}
