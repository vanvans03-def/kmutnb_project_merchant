import 'package:flutter/material.dart';
import 'package:image_card/image_card.dart';
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
  String mocPrice = '';
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

  fetchCategory() async {
    String categoryId = widget.category;
    Category category = await addressService.getCategory(
      context: context,
      categoryId: categoryId,
    );
    categoryName = category.categoryName;
    List<Product> products = await homeService.fetchAllProduct(context);
    storeList = await homeService.fetchAllStore(context);
    print(categoryId);
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
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
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
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(left: 15),
                              itemCount: productsInStore.length,
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
                                  child: SingleOrderProduct(
                                    image: product.productImage[0],
                                    price: product.productPrice.toString(),
                                    salePrice: product.productSalePrice,
                                    productPriceList: productpricesList,
                                    productName: product.productName,
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

class SingleOrderProduct extends StatelessWidget {
  final String image;
  final String price;
  final String? salePrice;
  final String productName;
  final List<ProductPrice> productPriceList;

  const SingleOrderProduct({
    Key? key,
    required this.image,
    required this.price,
    this.salePrice,
    required this.productPriceList,
    required this.productName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String mocPrice = '';

    // ignore: no_leading_underscores_for_local_identifiers
    void _getSalePrice() {
      if (salePrice != null && salePrice != '0') {
        for (int i = 0; i < productPriceList.length; i++) {
          if (productPriceList[i].productId == salePrice) {
            mocPrice = productPriceList[i].priceMax.toString();
          }
        }
      }
    }

    _getSalePrice();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Stack(
        children: [
          TransparentImageCard(
            width: 200,
            height: 200,
            imageProvider: NetworkImage(image),
            title: _title(color: Colors.white, productName: productName),
            description: _content(color: Colors.white, price: price),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Visibility(
              visible: mocPrice != '',
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'ราคาตลาดวันนี้ $mocPrice ฿',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }

  Widget _content({required Color color, required String price}) {
    return Text(
      "$price฿",
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
          color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  Widget _title({Color? color, required String productName}) {
    return Text(
      productName,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}
