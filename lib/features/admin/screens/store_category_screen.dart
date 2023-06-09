import 'package:flutter/material.dart';
import 'package:kmutnb_project_merchant/common/widgets/loader.dart';
import 'package:kmutnb_project_merchant/features/account/widgets/single_product.dart';
import 'package:kmutnb_project_merchant/features/admin/screens/add_products_screen.dart';
import 'package:kmutnb_project_merchant/features/admin/screens/edit_products_screen.dart';
import 'package:kmutnb_project_merchant/models/category.dart';
import 'package:kmutnb_project_merchant/models/product.dart';
import '../../../models/productprice.dart';
import '../../address/services/address_services.dart';
import '../../home/services/home_service.dart';
import '../services/admin_service.dart';

class StoreCategoryScreen extends StatefulWidget {
  static const String routeName = '/store-category';
  final String category;

  const StoreCategoryScreen({Key? key, required this.category})
      : super(key: key);

  @override
  _StoreCategoryScreenState createState() => _StoreCategoryScreenState();
}

class _StoreCategoryScreenState extends State<StoreCategoryScreen> {
  List<Product>? productList;
  List<Category> categories = [];
  String categoryName = '';
  final HomeService homeService = HomeService();
  final AddressService addressService = AddressService();

  @override
  void initState() {
    super.initState();
    fetchCategory();
    _getProductprices();
  }

  final AdminService adminServices = AdminService();
  List<ProductPrice> productpricesList = [];
  void _getProductprices() async {
    productpricesList = await adminServices.fetchAllProductprice(context);

    setState(() {});
  }

  void navigateToAddproduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  fetchCategory() async {
    String categoryId = widget.category;
    Category category = await addressService.getCategory(
      context: context,
      categoryId: categoryId,
    );
    categoryName = category.categoryName;
    List<Product> products = await homeService.fetchAllProduct(context);

    // Filter the products that match the desired category ID
    productList =
        products.where((product) => product.category == categoryId).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'สินค้าในหมวดหมู่ $categoryName',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: productList == null
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
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Center(
                          child: OrientationBuilder(
                            builder: (context, orientation) {
                              return GridView.builder(
                                itemCount: productList!.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      orientation == Orientation.portrait
                                          ? 2
                                          : 4,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio:
                                      orientation == Orientation.portrait
                                          ? 0.62
                                          : 0.56,
                                ),
                                padding: const EdgeInsets.all(10),
                                itemBuilder: (context, index) {
                                  final productData = productList![index];
                                  String mocPrice = '';
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
                                                categoryName: categoryName,
                                                mocPrice: mocPrice,
                                                avgRating: avgRating,
                                                productType:
                                                    productData.productType,
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
                                                title: const Text(
                                                    'Delete product?'),
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
              ));
  }

  void deleteProduct(Product product, int index) {
    // Replace this with your own implementation
    // Example:
    // adminService.deleteProduct(
    //   context: context,
    //   product: product,
    //   onSuccess: () {
    //     productList!.removeAt(index);
    //     Navigator.pop(context);
    //     setState(() {});
    //   },
    // );
  }
}
