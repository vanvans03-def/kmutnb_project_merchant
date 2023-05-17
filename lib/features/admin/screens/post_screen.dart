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
              body: GridView.builder(
                itemCount: products!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  final productData = products![index];
                  return Column(
                    children: [
                      SizedBox(
                        height: 110,
                        child: SingleProduct(
                          image: productData.productImage[0],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              productData.productName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 60, // set the width of the icon
                            height: 30, // set the height of the icon
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  // ... showDialog(
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
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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