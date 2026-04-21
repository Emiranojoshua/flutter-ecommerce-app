import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCardDetailsPage extends StatefulWidget {
  final Map<String, Object> product;

  const ProductCardDetailsPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductCardDetailsPage> createState() =>
      _ProductCardDetailsPageState();
}

class _ProductCardDetailsPageState
    extends State<ProductCardDetailsPage> {
  int selectedSize = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Column(
        children: [
          Text(
            widget.product['title'] as String,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              widget.product['imageUrl'] as String,
              // height: 00,
            ),
          ),
          Spacer(flex: 2),
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromRGBO(245, 247, 249, 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  "\$${widget.product['prize']}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        (widget.product['sizes'] as List<int>)
                            .length,
                    itemBuilder:
                        (BuildContext context, int index) {
                          final sizes =
                              widget.product['sizes']
                                  as List<int>;
                          int size = sizes[index];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSize = size;
                                });
                              },
                              child: Chip(
                                backgroundColor:
                                    selectedSize == size
                                    ? Theme.of(
                                        context,
                                      ).primaryColor
                                    : const Color.fromARGB(
                                        255,
                                        215,
                                        230,
                                        245,
                                      ),
                                label: Text(
                                  sizes[index].toString(),
                                ),
                              ),
                            ),
                          );
                        },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.add_shopping_cart,
                      size: 25,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      if (selectedSize != 0) {
                        
                        Provider.of<CartProvider>(
                          context,
                          listen: false,
                        ).addProduct({
                          "title": widget.product['title'],
                          "prize": widget.product['prize'],
                          "sizes": selectedSize,
                          "imageUrl": widget.product['imageUrl'],
                          "company": widget.product['company'],
                          "id": widget.product['id'],
                        });
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${widget.product['title']} added successfully",
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Please Select a size",
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: selectedSize != 0
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    ),
                    label: Text(
                      selectedSize != 0
                          ? "Add to cart"
                          : "Select product size",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
