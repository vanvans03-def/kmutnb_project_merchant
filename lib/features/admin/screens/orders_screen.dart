import 'package:flutter/material.dart';
import 'package:kmutnb_project/features/account/widgets/single_product.dart';
import 'package:kmutnb_project/features/admin/services/admin_service.dart';
import 'package:kmutnb_project/features/order_detail/screens/order_details.dart';

import '../../../common/widgets/loader.dart';
import '../../../models/order.dart';
import '../../../models/orderStore.dart';
import '../../order_detail/screens/order_store_details.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<OrderStore>? orders;
  final AdminService adminService = AdminService();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await adminService.fetchOrders(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : GridView.builder(
            itemCount: orders!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              final orderData = orders![index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, OrderStoreDetailScreen.routeName,
                      arguments: orderData);
                },
                child: SizedBox(
                  height: 140,
                  child: SingleProduct(
                    image: orderData.products[0].productImage[0],
                  ),
                ),
              );
            });
  }
}
