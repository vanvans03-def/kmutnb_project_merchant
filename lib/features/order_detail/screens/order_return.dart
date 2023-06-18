import 'package:flutter/material.dart';
import 'package:kmutnb_project_merchant/features/admin/services/admin_service.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_project_merchant/features/home/screens/store_product_screen.dart';
import 'package:kmutnb_project_merchant/features/order_detail/screens/order_succees.dart';
import 'package:provider/provider.dart';
import '../../../common/widgets/loader.dart';
import '../../../constants/global_variables.dart';
import '../../../models/orderStore.dart';
import '../../../providers/store_provider.dart';
import '../../account/widgets/single_order_product.dart';
import '../../auth/widgets/constants.dart';
import '../../chat/screens/ChatPage.dart';
import '../../order_detail/screens/order_store_details.dart';
import 'package:kmutnb_project_merchant/features/account/widgets/account_button.dart';

class OrderReturn extends StatefulWidget {
  const OrderReturn({Key? key}) : super(key: key);

  @override
  _OrderReturn createState() => _OrderReturn();
}

class _OrderReturn extends State<OrderReturn> {
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
      for (int j = 0; j < orderList[i].products.length; j++) {
        if (orderList[i].products[j].statusProductOrder >= 4) {
          orders!.add(orderList[i]);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final storeName = storeProvider.store.storeName;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          elevation: 2.0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: GlobalVariables.appBarGradientStore,
              borderRadius: const BorderRadius.only(),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // เปลี่ยนสีเงาที่นี่
                  offset: Offset(0, 5.0),

                  blurRadius: 4.0,
                )
              ],
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (storeProvider.store.storeImage == '') ...[
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    radius: 22,
                    child: Icon(
                      Icons.store,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ] else ...[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      storeProvider.store.storeImage,
                    ),
                    radius: 22,
                  ),
                ),
              ],
              Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    storeName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade200,
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 0),
                child: IconButton(
                  icon: Icon(
                    Icons.chat,
                    color: Colors.grey.shade200,
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
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
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderSucees(),
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          height: 40,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(50),
                              color: kPrimaryColor),
                          child: OutlinedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.black12.withOpacity(0.03),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  )),
                              onPressed: null,
                              child: const Text(
                                'คืนสินค้า',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              )),
                        ),
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
