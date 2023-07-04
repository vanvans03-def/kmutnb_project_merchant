// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_project_merchant/features/auth/widgets/constants.dart';

import '../../../common/widgets/loader.dart';
import '../../../models/orderStore.dart';
import '../../account/widgets/single_order_product.dart';

import '../../order_detail/screens/order_store_details.dart';
import '../services/admin_service.dart';

class OrderScreen extends StatelessWidget {
  OrderScreen({Key? key});
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 2,
        backgroundColor: Colors.transparent,
      ),
      body: DefaultTabController(
        length: 3, // จำนวนแท็บทั้งหมด
        child: Column(
          children: [
            SizedBox(
              height: 35,
              child: TabBar(
                isScrollable: true,
                tabs: [
                  Tab(
                    child: Text(
                      'ออเดอร์ทั้งหมด',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'สถานะออเดอร์',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'คืนสินค้าและคืนเงิน',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
                indicatorColor: kPrimaryColor,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  AllOrderWidget(),
                  OrderderStatus(),
                  ReturnAndRefund(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderderStatus extends StatefulWidget {
  const OrderderStatus({super.key});

  @override
  State<OrderderStatus> createState() => _OrderderStatusState();
}

class _OrderderStatusState extends State<OrderderStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 4, // จำนวนแท็บทั้งหมด
        child: Column(
          children: [
            SizedBox(
              height: 35,
              child: TabBar(
                isScrollable: true,
                tabs: [
                  Tab(
                    child: Text(
                      'ออเดอร์ใหม่',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'แพ็คสินค้า',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'จัดส่งสินค้า',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'ส่งสำเร็จ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
                indicatorColor: kPrimaryColor,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  OnHoldWidget(),
                  ProcessingWidget(),
                  DeliveredWidget(),
                  SucceedWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReturnAndRefund extends StatefulWidget {
  const ReturnAndRefund({super.key});

  @override
  State<ReturnAndRefund> createState() => _ReturnAndRefundState();
}

class _ReturnAndRefundState extends State<ReturnAndRefund> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2, // จำนวนแท็บทั้งหมด
        child: Column(
          children: [
            SizedBox(
              height: 35,
              child: TabBar(
                isScrollable: true,
                tabs: [
                  Tab(
                    child: Text(
                      'คำขอคืนเงินสินค้า',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'คืนเงินสินค้าเรียบร้อยแล้ว',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
                indicatorColor: kPrimaryColor,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ReturnWidget(),
                  RefundWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AllOrderWidget extends StatefulWidget {
  @override
  _AllOrderWidgetState createState() => _AllOrderWidgetState();
}

class _AllOrderWidgetState extends State<AllOrderWidget> {
  final AdminService adminService = AdminService();
  List<OrderStore>? orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    orders = [];
    orders = await adminService.fetchOrders(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: [
              Expanded(
                child: orders == null
                    ? const Loader()
                    : GridView.builder(
                        itemCount: orders!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }
}

class OnHoldWidget extends StatefulWidget {
  const OnHoldWidget({super.key});

  @override
  _OnHoldWidgetState createState() => _OnHoldWidgetState();
}

class _OnHoldWidgetState extends State<OnHoldWidget> {
  final AdminService adminService = AdminService();
  List<OrderStore>? orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    orders = [];
    List<OrderStore>? orderList;
    orderList = await adminService.fetchOrders(context);
    for (int i = 0; i < orderList.length; i++) {
      for (int j = 0; j < orderList[i].products.length; j++) {
        if (orderList[i].products[j].statusProductOrder == 0) {
          orders!.add(orderList[i]);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: [
              Expanded(
                child: orders == null
                    ? const Loader()
                    : GridView.builder(
                        itemCount: orders!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }
}

class ProcessingWidget extends StatefulWidget {
  const ProcessingWidget({super.key});

  @override
  _ProcessingWidgetState createState() => _ProcessingWidgetState();
}

class _ProcessingWidgetState extends State<ProcessingWidget> {
  final AdminService adminService = AdminService();
  List<OrderStore>? orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    orders = [];
    List<OrderStore>? orderList;
    orderList = await adminService.fetchOrders(context);
    for (int i = 0; i < orderList.length; i++) {
      for (int j = 0; j < orderList[i].products.length; j++) {
        if (orderList[i].products[j].statusProductOrder == 1) {
          orders!.add(orderList[i]);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: [
              Expanded(
                child: orders == null
                    ? const Loader()
                    : GridView.builder(
                        itemCount: orders!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }
}

class DeliveredWidget extends StatefulWidget {
  const DeliveredWidget({super.key});

  @override
  _DeliveredWidgetState createState() => _DeliveredWidgetState();
}

class _DeliveredWidgetState extends State<DeliveredWidget> {
  final AdminService adminService = AdminService();
  List<OrderStore>? orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    orders = [];
    List<OrderStore>? orderList;
    orderList = await adminService.fetchOrders(context);
    for (int i = 0; i < orderList.length; i++) {
      for (int j = 0; j < orderList[i].products.length; j++) {
        if (orderList[i].products[j].statusProductOrder == 2) {
          orders!.add(orderList[i]);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: [
              Expanded(
                child: orders == null
                    ? const Loader()
                    : GridView.builder(
                        itemCount: orders!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }
}

class SucceedWidget extends StatefulWidget {
  const SucceedWidget({super.key});

  @override
  _SucceedWidgetState createState() => _SucceedWidgetState();
}

class _SucceedWidgetState extends State<SucceedWidget> {
  final AdminService adminService = AdminService();
  List<OrderStore>? orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    orders = [];
    List<OrderStore>? orderList;
    orderList = await adminService.fetchOrders(context);
    for (int i = 0; i < orderList.length; i++) {
      for (int j = 0; j < orderList[i].products.length; j++) {
        if (orderList[i].products[j].statusProductOrder == 3) {
          orders!.add(orderList[i]);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: [
              Expanded(
                child: orders == null
                    ? const Loader()
                    : GridView.builder(
                        itemCount: orders!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }
}

class ReturnWidget extends StatefulWidget {
  const ReturnWidget({super.key});

  @override
  _ReturnWidgetState createState() => _ReturnWidgetState();
}

class _ReturnWidgetState extends State<ReturnWidget> {
  final AdminService adminService = AdminService();
  List<OrderStore>? orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    orders = [];
    List<OrderStore>? orderList;
    orderList = await adminService.fetchOrders(context);
    for (int i = 0; i < orderList.length; i++) {
      for (int j = 0; j < orderList[i].products.length; j++) {
        if (orderList[i].products[j].statusProductOrder == 4) {
          orders!.add(orderList[i]);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: [
              Expanded(
                child: orders == null
                    ? const Loader()
                    : GridView.builder(
                        itemCount: orders!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }
}

class RefundWidget extends StatefulWidget {
  const RefundWidget({super.key});

  @override
  _RefundWidgetState createState() => _RefundWidgetState();
}

class _RefundWidgetState extends State<RefundWidget> {
  final AdminService adminService = AdminService();
  List<OrderStore>? orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    orders = [];
    List<OrderStore>? orderList;
    orderList = await adminService.fetchOrders(context);
    for (int i = 0; i < orderList.length; i++) {
      for (int j = 0; j < orderList[i].products.length; j++) {
        if (orderList[i].products[j].statusProductOrder == 5) {
          orders!.add(orderList[i]);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: [
              Expanded(
                child: orders == null
                    ? const Loader()
                    : GridView.builder(
                        itemCount: orders!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }
}
