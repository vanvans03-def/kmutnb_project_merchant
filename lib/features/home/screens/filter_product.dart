import 'package:flutter/material.dart';

import '../../../common/widgets/stars.dart';
import '../../../models/product.dart';
import '../../product_details/screens/product_deatails_screen.dart';

class FilterProduct extends StatelessWidget {
  final List<Product> products;

  const FilterProduct({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtered Products'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          double totalRating = 0;
          for (int i = 0; i < product.rating!.length; i++) {
            totalRating += product.rating![i].rating;
          }
          double avgRating = 0;
          if (totalRating != 0) {
            avgRating = totalRating / product.rating!.length;
          }

          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ProductDetailScreen.routeName,
                    arguments: products[index],
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Image.network(
                        product.productImage[0],
                        fit: BoxFit.fitWidth,
                        height: 135,
                        width: 135,
                      ),
                      Column(
                        children: [
                          Container(
                            width: 200,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              product.productName,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              maxLines: 2,
                            ),
                          ),
                          Container(
                            width: 200,
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            child: Stars(rating: avgRating),
                          ),
                          Container(
                            width: 200,
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            child: Text(
                              '฿${product.productPrice}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                            ),
                          ),
                          Container(
                            width: 200,
                            padding: const EdgeInsets.only(left: 10),
                            child: const Text(
                              'Eligible for FREE Shipping',
                            ),
                          ),
                          Container(
                            width: 200,
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            child: const Text(
                              'In Stock',
                              style: TextStyle(
                                color: Colors.teal,
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 2,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
            ],
          );
        },
      ),
    );
  }
}
