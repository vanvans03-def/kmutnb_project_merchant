import 'package:flutter/material.dart';
import 'package:kmutnb_project/common/widgets/loader.dart';
import 'package:kmutnb_project/features/account/widgets/single_product.dart';
import 'package:kmutnb_project/features/admin/screens/add_products_screen.dart';
import 'package:kmutnb_project/features/admin/services/admin_service.dart';
import 'package:provider/provider.dart';

import '../../../models/product.dart';
import '../../../providers/store_provider.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<Product>? products = [];
  final AdminService adminService = AdminService();
  get store => Provider.of<StoreProvider>(context).store;

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  fetchAllProducts() async {
    products = await adminService.fetchAllProduct(context);
    setState(() {});
  }

  void navigateToAddproduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
    setState(() {});
  }

  void deleteProduct(Product product, int index) {
    adminService.deleteProduct(
      context: context,
      product: product,
      onSuccess: () {
        products!.removeAt(index);
        Navigator.pop(context);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (store == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Add Store'),
        ),
        body: const Center(
          child: Text('Please add store'),
        ),
      );
    } else {
      return products == null
          ? const Loader()
          : Scaffold(
              body: OrientationBuilder(
                builder: (context, orientation) {
                  return GridView.builder(
                    itemCount: products!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          orientation == Orientation.portrait ? 2 : 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio:
                          orientation == Orientation.portrait ? 1.0 : 1.2,
                    ),
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      final productData = products![index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SingleProduct(
                                  image: productData.productImage[0],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            productData.productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Delete product?'),
                                    content: const Text(
                                        'Are you sure you want to delete this product?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                      TextButton(
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                        onPressed: () {
                                          deleteProduct(productData, index);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: navigateToAddproduct,
                tooltip: 'Add a Product',
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
    }
  }
}
