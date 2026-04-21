import 'package:ecommerce_app/util/filter_list.dart';
import 'package:ecommerce_app/global_variables.dart';
import 'package:ecommerce_app/util/product_card.dart';
import 'package:ecommerce_app/screens/product_card_details_page.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey[200]!),
    borderRadius: BorderRadius.horizontal(
      left: Radius.circular(50),
      // right: Radius.circular(30),
    ),
    // borderSide: BorderSide.none,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Shoes\nCollection',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    top: 16.0,
                    bottom: 16.0,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      border: border,
                      enabledBorder: border,
                      focusedBorder: border,
                      filled: false,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
              ),
            ],
          ),
          FilterList(),
          // Placeholder(fallbackHeight: 20),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ProductCardDetailsPage(
                            product: product,
                          );
                        },
                      ),
                    );
                  },
                  child: ProductCard(
                    title: products[index]['title'] as String,
                    prize: products[index]['prize'] as double,
                    imageUrl:
                        products[index]['imageUrl'] as String,
                    company:
                        products[index]['company'] as String,
                    backgroundColor: index.isEven
                        ? Color.fromRGBO(216, 240, 253, 1)
                        : Color.fromRGBO(245, 247, 249, 1),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
