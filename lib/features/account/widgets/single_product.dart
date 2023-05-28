import 'package:flutter/material.dart';
import 'package:image_card/image_card.dart';
import 'package:kmutnb_project/features/address/services/address_services.dart';
import '../../../models/category.dart';

class SingleProduct extends StatelessWidget {
  String image;
  String productName;
  String category;
  String productPrice;

  SingleProduct({
    Key? key,
    required this.image,
    required this.productName,
    required this.category,
    required this.productPrice,
  }) : super(key: key);

  final AddressService addressService = AddressService();

  Future<Category> _getCategoryData(BuildContext context) async {
    // Call the service to get category data
    return await addressService.getCategory(
      context: context,
      categoryId: category,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: TransparentImageCard(
            height: 300,
            width: 300,
            imageProvider: NetworkImage(image),
            tags: [
              FutureBuilder<Category>(
                future: _getCategoryData(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasData) {
                    final categoryData = snapshot.data!;
                    return _tag(
                      categoryData.categoryName,
                      () {
                        // Handle onTap event
                      },
                      categoryData,
                    );
                  }
                  return Container();
                },
              ),
            ],
            title: _title(color: Colors.white, productName: productName),
            description:
                _content(color: Colors.white, productPrice: productPrice),
          ),
        ),
      ),
    );
  }

  Widget _tag(String label, VoidCallback onPressed, Category categoryData) {
    Color tagColor;

    if (categoryData.categoryName.toString() == "Fruit") {
      tagColor = Colors.blue;
    } else if (categoryData.categoryName.toString() == "Dry Friut") {
      tagColor = Colors.red;
    } else if (categoryData.categoryName.toString() == "Vegetable") {
      tagColor = Colors.green;
    } else {
      tagColor = Colors.blue; // ค่าเริ่มต้นสำหรับกรณีอื่นๆ
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: tagColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _title({required Color color, required String productName}) {
    return Text(
      productName,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  Widget _content({required Color color, required String productPrice}) {
    return Text(
      '$productPrice ฿',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
    );
  }
}
