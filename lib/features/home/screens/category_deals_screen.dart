import 'package:flutter/material.dart';
import 'package:kmutnb_project/common/widgets/loader.dart';
import 'package:kmutnb_project/features/address/services/address_services.dart';
import 'package:kmutnb_project/features/admin/services/admin_service.dart';
import 'package:kmutnb_project/features/home/services/home_service.dart';
import 'package:kmutnb_project/features/product_details/screens/product_deatails_screen.dart';

import '../../../constants/global_variables.dart';
import '../../../models/category.dart';
import '../../../models/product.dart';
import '../../../models/productprice.dart';
import '../../../models/store.dart';

class CategoryDealsScreen extends StatefulWidget {
  static const String routeName = '/category-deals';
  final String category;
  const CategoryDealsScreen({Key? key, required this.category})
      : super(key: key);

  @override
  _CategoryDealsScreenState createState() => _CategoryDealsScreenState();
}

class _CategoryDealsScreenState extends State<CategoryDealsScreen> {
  List<Product>? productList;
  List<Store>? storeList;
  String categoryName = '';
  final HomeService homeService = HomeService();
  final AddressService addressService = AddressService();
  final AdminService adminServices = AdminService();
  @override
  void initState() {
    super.initState();
    fetchCategory();
    _getProductprices();
  }

  List<ProductPrice> productpricesList = [];
  void _getProductprices() async {
    productpricesList = await adminServices.fetchAllProductprice(context);

    setState(() {});
  }

  fetchCategory() async {
    String categoryId = widget.category;
    Category category = await addressService.getCategory(
      context: context,
      categoryId: categoryId,
    );
    categoryName = category.categoryName;
    List<Product> products = await homeService.fetchAllProduct(context);
    storeList = await homeService.fetchAllStore(context);

    // Filter the products that match the desired category ID
    productList =
        products.where((product) => product.category == categoryId).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: const Text(
            'Fruit Category',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: productList == null
          ? const Loader()
          : Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Keep Shopping for $categoryName',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: storeList!.length,
                    itemBuilder: (context, storeIndex) {
                      final store = storeList![storeIndex];
                      List<Product> productsInStore = productList!
                          .where((product) => product.storeId == store.storeId)
                          .toList();
                      if (productsInStore.isEmpty) {
                        // Skip empty stores
                        return SizedBox.shrink();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Text(
                              'Store: ${store.storeName}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 200,
                            child: GridView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(left: 15),
                              itemCount: productsInStore.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: 1.5,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (context, index) {
                                final product = productsInStore[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      ProductDetailScreen.routeName,
                                      arguments: product,
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 130,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: const BorderSide(
                                              color: Colors.black12,
                                              width: 0.5,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Image.network(
                                                product.productImage[0],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          padding: const EdgeInsets.only(
                                            left: 5,
                                            top: 5,
                                            right: 5,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  product.productName,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                '${product.productPrice.toString()}฿',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          padding: const EdgeInsets.only(
                                            left: 0,
                                            top: 0,
                                            right: 0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Expanded(
                                                child: Text(
                                                  '',
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              if (product.productSalePrice !=
                                                  '0')
                                                for (int i = 0;
                                                    i <
                                                        productpricesList
                                                            .length;
                                                    i++)
                                                  if (productpricesList[i]
                                                          .productId ==
                                                      product.productSalePrice)
                                                    Card(
                                                      color: Colors.red,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'ราคากลางวันนี้ ${productpricesList[i].priceMax} ฿',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 8,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Colors.white,
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
