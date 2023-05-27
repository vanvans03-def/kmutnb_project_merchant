import 'package:flutter/material.dart';
import 'package:kmutnb_project/features/account/widgets/single_product.dart';
import 'package:kmutnb_project/features/admin/services/admin_service.dart';
import 'package:kmutnb_project/features/order_detail/screens/order_details.dart';
import 'package:intl/intl.dart';
import '../../../common/widgets/loader.dart';
import '../../../models/order.dart';
import '../../../models/orderStore.dart';
import '../../order_detail/screens/order_store_details.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
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
  void didUpdateWidget(covariant OrderScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orders == null
              ? const Loader()
              : GridView.builder(
                  itemCount: orders!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio:
                        orientation == Orientation.portrait ? 1.2 : 1.6,
                  ),
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    final orderData = orders![index];
                    final orderDate = DateFormat().format(
                      DateTime.fromMillisecondsSinceEpoch(orderData.orderedAt),
                    );
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          OrderStoreDetailScreen.routeName,
                          arguments: orderData,
                        ).then((value) {
                          fetchOrders();
                        });
                      },
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
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SingleProduct(
                                  image: orderData.products[0].productImage[0],
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'orderAt: $orderDate',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
