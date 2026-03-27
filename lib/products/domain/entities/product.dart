import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:soccer_sport/products/domain/entities/attributes.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String description;
  final String shortDescription;
  final String sku;
  final String price;
  final String regularPrice;
  final String salePrices;
  final String status;
  final String stockStatus;
  final List<Images> images;
  final List<Categories> categories;
  final List<int> relatedID;
  final List<Attributes> attributes;
  final List<int> variations;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.shortDescription,
    required this.sku,
    required this.price,
    required this.regularPrice,
    required this.salePrices,
    required this.images,
    required this.status,
    required this.stockStatus,
    required this.categories,
    required this.relatedID,
    required this.attributes,
    required this.variations,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.images, @required this.publishname, this.tags});

  @override
  List<Object?> get props => [
        id,
        name,
        sku,
        shortDescription,
        description,
        price,
        regularPrice,
        salePrices,
        stockStatus,
        images,
        categories,
        relatedID,
        attributes,
        variations,
      ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'description': description,
      'short_description': shortDescription,
      'price': price,
      'regular_price': regularPrice,
      'sale_prices': salePrices,
      'images': images.map((e) => e.toMap()).toList(),
      'stock_status': stockStatus,
      'status': status,
      'categories': categories.map((e) => e.toMap()).toList(),
      'related_ids': relatedID,
      'attributes': attributes.map((e) => e.toMap()).toList(),
      'variations': variations,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        description: map['description'] ?? '',
        shortDescription: map['shortDescription'] ?? '',
        regularPrice: map['regular_price'] ?? '',
        salePrices: map['sale_prices'] ?? '',
        price: map['price'] != null && map['price'] != '' ? map['price'] : '0',
        images: map['images'] != null
            ? (map['images'] as List<dynamic>)
                .map((v) => Images.fromMap(v))
                .toList()
            : [],
        status: map['status'] ?? '',
        stockStatus: map['stock_status'] ?? '',
        categories: map['categories'] != null
            ? (map['categories'] as List<dynamic>)
                .map((v) => Categories.fromMap(v))
                .toList()
            : [],
        sku: map['sku'] ?? '',
        attributes: map['attributes'] != null
            ? (map['attributes'] as List<dynamic>)
                .map((e) => Attributes.fromMap(e))
                .toList()
            : [],
        variations: map['variations'] != null
            ? (map['variations'] as List<dynamic>).map((e) => e as int).toList()
            : [],
        relatedID: map['related_ids'] != null
            ? (map['related_ids'] as List<dynamic>)
                .map((e) => e as int)
                .toList()
            : []);
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}

class Categories {
  final int id;
  final String name;

  Categories({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Categories.fromMap(Map<String, dynamic> map) {
    return Categories(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
    );
  }
}

class Images {
  final String src;

  Images({required this.src});

  Map<String, dynamic> toMap() {
    return {
      'src': src,
    };
  }

  factory Images.fromMap(Map<String, dynamic> map) {
    return Images(
      src: map['src'] ?? '',
    );
  }
}
