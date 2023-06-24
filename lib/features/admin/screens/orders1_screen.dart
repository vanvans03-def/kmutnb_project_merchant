import 'package:flutter/material.dart';
import 'package:kmutnb_project_merchant/features/admin/services/admin_service.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_project_merchant/features/order_detail/screens/order_return.dart';
import '../../../common/widgets/loader.dart';
import '../../../models/orderStore.dart';
import '../../account/widgets/single_order_product.dart';
import '../../order_detail/screens/order_store_details.dart';
import 'package:kmutnb_project_merchant/features/account/widgets/account_button.dart';

import '../../order_detail/screens/order_succees.dart';

class Order1Screen extends StatefulWidget {
  const Order1Screen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<Order1Screen> {
  final AdminService adminService = AdminService();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  List<OrderStore>? orders = [];
  void fetchOrders() async {
    orders = [];
    List<OrderStore>? orderList;
    orderList = await adminService.fetchOrders(context);
    for (int i = 0; i < orderList.length; i++) {
      bool isAllProductsStatus3 = true;
      for (int j = 0; j < orderList[i].products.length; j++) {
        if (orderList[i].products[j].statusProductOrder >= 3) {
          isAllProductsStatus3 = false;
          break;
        }
      }
      if (isAllProductsStatus3) {
        orders!.add(orderList[i]);
      }
    }
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant Order1Screen oldWidget) {
    super.didUpdateWidget(oldWidget);
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Column(
              children: [
                SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      AccountButtons(
                        text: 'จัดส่งแล้ว',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderSucees(),
                            ),
                          );
                        },
                      ),
                      AccountButtons(
                        text: 'คืนสินค้า',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderReturn(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: orders == null
                      ? const Loader()
                      : GridView.builder(
                          itemCount: orders!.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                orientation == Orientation.portrait ? 2 : 4,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio:
                                orientation == Orientation.portrait ? 0.8 : 0.7,
                          ),
                          padding: const EdgeInsets.all(10),
                          itemBuilder: (context, index) {
                            final orderData = orders![index];
                            final orderDate = DateFormat().format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  orderData.orderedAt),
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
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                // ...

                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: SingleOrderProduct(
                                          image: orderData
                                              .products[0].productImage[0],
                                          date: orderDate,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // ...
                              ),
                            );
                          },
                        ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
