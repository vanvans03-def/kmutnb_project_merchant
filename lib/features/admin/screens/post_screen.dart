import 'package:flutter/material.dart';
import 'package:kmutnb_project_merchant/common/widgets/loader.dart';
import 'package:kmutnb_project_merchant/features/account/widgets/single_product.dart';
import 'package:kmutnb_project_merchant/features/admin/screens/add_products_screen.dart';
import 'package:kmutnb_project_merchant/features/admin/screens/edit_products_screen.dart';
import 'package:kmutnb_project_merchant/features/admin/screens/store_category_screen.dart';
import 'package:kmutnb_project_merchant/features/admin/services/admin_service.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/stars.dart';
import '../../../models/category.dart';
import '../../../models/product.dart';
import '../../../models/productprice.dart';
import '../../../providers/store_provider.dart';
import '../../auth/services/auth_service.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<Product>? products = [];
  String categoryId = '';
  List<Category> categories = [];
  String mocPrice = '';
  get store => Provider.of<StoreProvider>(context).store;

  @override
  void initState() {
    super.initState();

    _getCategories();
    fetchAllProducts();
    _getProductprices();
  }

  final AdminService adminServices = AdminService();
  List<ProductPrice> productpricesList = [];
  void _getProductprices() async {
    productpricesList = await adminServices.fetchAllProductprice(context);

    setState(() {});
  }

  void navigateToCategoryPage(BuildContext context, String categoryId) {
    Navigator.pushNamed(
      context,
      StoreCategoryScreen.routeName,
      arguments: categoryId,
    );
  }

  final AdminService adminService = AdminService();

  int selectedCategoryIndex = 0;

  void _getCategories() async {
    categories = await adminService.fetchAllCategory(context);

    setState(() {});
  }

  fetchAllProducts() async {
    products = await adminService.fetchAllProduct(context);
    setState(() {});
  }

  void navigateToAddproduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  void deleteProduct(Product product, int index) {
    adminServices.updateProduct(
      context: context,
      productName_: product.productName,
      productDescription_: product.productDescription,
      category_: product.category,
      productPrice_: product.productPrice,
      productSKU_: product.productSKU,
      productSalePrice_: product.productSalePrice,
      productShortDescription_: product.productShortDescription,
      productType_: product.productType,
      relatedProduct_: product.relatedProduct,
      stockStatus_: 'offline',
      productID: product.id.toString(),
      productImage_: [],
      imageWidget: product.productImage,
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
              body: Container(
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 70,
                      child: ListView.builder(
                        itemCount: categories.length,
                        itemExtent: 70,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => navigateToCategoryPage(
                                context, categories[index].categoryId),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      categories[index].categoryImage,
                                      fit: BoxFit.cover,
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                ),
                                Text(
                                  categories[index].categoryName,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: OrientationBuilder(
                          builder: (context, orientation) {
                            return GridView.builder(
                              itemCount: products!.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    orientation == Orientation.portrait ? 2 : 4,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio:
                                    orientation == Orientation.portrait
                                        ? 0.62
                                        : 0.56,
                              ),
                              padding: const EdgeInsets.all(10),
                              itemBuilder: (context, index) {
                                final productData = products![index];
                                String nameCategoryOfProduct = '';
                                for (int i = 0; i < categories.length; i++) {
                                  if (productData.category ==
                                      categories[i].categoryId) {
                                    nameCategoryOfProduct =
                                        categories[i].categoryName;
                                  }
                                }
                                mocPrice = '';
                                for (int i = 0;
                                    i < productpricesList.length;
                                    i++) {
                                  if (productpricesList[i].productId ==
                                      productData.productSalePrice) {
                                    mocPrice = productpricesList[i]
                                        .priceMax
                                        .toString();
                                  }
                                }
                                double totalRating = 0.0;
                                double avgRating = 0.0;
                                // ignore: unused_local_variable
                                double rateAllProduct = 0.0;

                                final productA = productData;

                                for (int j = 0;
                                    j < productA.rating!.length;
                                    j++) {
                                  totalRating += productA.rating![j].rating;
                                }
                                if (productA.rating!.isNotEmpty) {
                                  avgRating =
                                      totalRating / productA.rating!.length;
                                  rateAllProduct += avgRating;
                                }

                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProductScreen(
                                                productData: productData,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: SingleProduct(
                                              image:
                                                  productData.productImage[0],
                                              productName:
                                                  productData.productName,
                                              productPrice: productData
                                                  .productPrice
                                                  .toString(),
                                              categoryName:
                                                  nameCategoryOfProduct,
                                              mocPrice: mocPrice,
                                              avgRating: avgRating,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Delete product?'),
                                              content: const Text(
                                                  'Are you sure you want to delete this product?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('Cancel'),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                ),
                                                TextButton(
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    deleteProduct(
                                                        productData, index);
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
                      ),
                    ),
                  ],
                ),
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
