import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_project_merchant/features/admin/services/admin_service.dart';
import 'package:kmutnb_project_merchant/features/auth/widgets/constants.dart';
import 'package:kmutnb_project_merchant/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../../../common/widgets/customer_button.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utills.dart';
import '../../../models/orderStore.dart';
import '../../search/screens/search_screen.dart';

class OrderStoreDetailScreen extends StatefulWidget {
  static const String routeName = '/order-store-details';
  final OrderStore order;
  const OrderStoreDetailScreen({super.key, required this.order});

  @override
  State<OrderStoreDetailScreen> createState() => _OrderStoreDetailScreen();
}

class _OrderStoreDetailScreen extends State<OrderStoreDetailScreen> {
  int currentStep = 0;
  int indexProduct = 0;
  bool showContainer = true;
  String storeId = '';
  String productId = '';
  String orderId = '';
  int checkOrder = 0;
  AdminService adminService = AdminService();
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  void initState() {
    super.initState();
    if (widget.order.products[indexProduct].statusProductOrder > 3) {
      checkOrder = widget.order.products[indexProduct].statusProductOrder;
      showContainer = false;
    } else {
      currentStep = widget.order.products[indexProduct].statusProductOrder;
    }

    if (widget.order.products.length == 1) {
      showContainer = true;
      storeId = widget.order.products[indexProduct].storeId;
      productId = widget.order.products[indexProduct].id;
      orderId = widget.order.id;
    }
  }

  Future<void> showSlip(String image) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          'สลิปการโอนเงิน',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
        content: Container(
          height: 500.0,
          decoration: const BoxDecoration(
            color: Colors.orange,
          ),
          child: Image.network(
            image,
            fit: BoxFit.cover,
          ),
        ),
        actions: [
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'ออก',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void changeOrderstatus(
      int status, String orderId, String productId, String storeId) {
    adminService.changeOrderStatus(
        context: context,
        status: status + 1,
        orderId: orderId,
        storeId: storeId,
        productId: productId,
        onSuccess: () {});
    setState(() {
      currentStep += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<UserProvider>(context).user;
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: const Text(
            'รายละเอียดออเดอร์',
            style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'รายละเอียดออเดอร์',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: GlobalVariables.kPrimaryColor,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: GlobalVariables.kPrimaryColor,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('วันที่ของออเดอร์:      ${DateFormat().format(
                      DateTime.fromMillisecondsSinceEpoch(
                          widget.order.orderedAt),
                    )}'),
                    Text('รหัสออเดอร์:             ${widget.order.id}'),
                    Text('ยอดรวมออเดอร์:      \฿${widget.order.totalPrice}'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'รายละเอียดการซื้อ',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: GlobalVariables.kPrimaryColor,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: GlobalVariables.kPrimaryColor,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < widget.order.products.length; i++)
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (indexProduct == i && showContainer) {
                              if (widget.order.products.length != 1) {
                                showContainer = false;
                              }

                              storeId = widget.order.products[i].storeId;
                              productId = widget.order.products[i].id;
                              orderId = widget.order.id;
                              checkOrder =
                                  widget.order.products[i].statusProductOrder;
                              if (widget.order.products[i].statusProductOrder >
                                  3) {
                                currentStep = 3;
                              } else {
                                currentStep =
                                    widget.order.products[i].statusProductOrder;
                              }
                            } else {
                              showContainer = true;
                              indexProduct = i;
                              storeId = widget.order.products[i].storeId;
                              productId = widget.order.products[i].id;
                              orderId = widget.order.id;
                              checkOrder =
                                  widget.order.products[i].statusProductOrder;

                              if (widget.order.products[i].statusProductOrder >
                                  3) {
                                currentStep = 3;
                              } else {
                                currentStep =
                                    widget.order.products[i].statusProductOrder;
                              }
                            }
                          });
                        },
                        child: Row(
                          children: [
                            Image.network(
                              widget.order.products[i].productImage[0],
                              height: 120,
                              width: 120,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.order.products[i].productName,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'จำนวน: ${widget.order.products[i].productQuantity}',
                                  ),
                                  Text(
                                    'ราคาต่อชิ้น: ${widget.order.products[i].productPrice}',
                                  ),
                                  Radio(
                                    value:
                                        i, // ค่าที่แตกต่างกันสำหรับแต่ละรายการสินค้า
                                    groupValue:
                                        indexProduct, // ค่าปัจจุบันของรายการสินค้าที่ถูกเลือก
                                    onChanged: (value) {
                                      setState(() {
                                        indexProduct = value as int;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'ติดตามสินค้า',
                style: TextStyle(
                  fontSize: 22,
                  color: GlobalVariables.kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (showContainer && checkOrder < 4) ...[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: GlobalVariables.kPrimaryColor,
                    ),
                  ),
                  child: Stepper(
                    currentStep: currentStep,
                    controlsBuilder: (context, details) {
                      if (user.type == 'merchant' &&
                          currentStep != 3 &&
                          currentStep != 0) {
                        return SizedBox(
                          height: 30,
                          width: 110,
                          child: CustomButton(
                            text: 'ยืนยัน',
                            onTap: () => changeOrderstatus(details.currentStep,
                                orderId, productId, storeId),
                          ),
                        );
                      } else if (currentStep == 0) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 30,
                              width: 124,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 37, 195, 129),
                                ),
                                onPressed: () async {
                                  if (widget.order.image == "GooglePay" ||
                                      widget.order.image == "") {
                                    showSnackBar(context,
                                        'คำสั่งซื้อนี้ชำระด้วย GooglePay');
                                  } else {
                                    showSlip(widget.order.image);
                                  }

                                  setState(() {});
                                },
                                icon: const Icon(
                                    Icons.open_in_new), // ไอคอนที่แสดงในปุ่ม
                                label: const Text(
                                  'แสดงรูปภาพ',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ), // ข้อความที่แสดงในปุ่ม
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              height: 30,
                              width: 124,
                              child: CustomButton(
                                text: 'ยืนยัน',
                                onTap: () => changeOrderstatus(
                                    details.currentStep,
                                    orderId,
                                    productId,
                                    storeId),
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox();
                    },
                    steps: [
                      Step(
                        title: const Text('รอดำเนินการ'),
                        content: const Text(
                          'ได้รับออเดอร์',
                        ),
                        isActive: currentStep > 0,
                        state: currentStep > 0
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                      Step(
                        title: const Text('ร้านค้าได้รับออเดอร์แล้ว'),
                        content: const Text(
                          'เตรียมจัดส่งสืนค้า',
                        ),
                        isActive: currentStep > 1,
                        state: currentStep > 1
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                      Step(
                        title: const Text('กำลังจัดส่งสินค้า'),
                        content: const Text(
                          'ได้จัดส่งสินค้าให้กับขนส่งแล้ว',
                        ),
                        isActive: currentStep > 2,
                        state: currentStep > 2
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                      Step(
                        title: const Text('สินค้าส่งถึงแล้ว'),
                        content: const Text(
                          'สินค้าของคุณได้ถูกจัดส่งและลงนามโดยผู้ซื้อแล้ว',
                        ),
                        isActive: currentStep >= 3,
                        state: currentStep >= 3
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                    ],
                  ),
                )
              ] else if (showContainer && checkOrder == 4) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: GlobalVariables.kPrimaryColor,
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('สินค้าของคุณถูกคำขอส่งคืน'),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                            width: 140,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 37, 195, 129),
                              ),
                              onPressed: () async {
                                if (widget.order.image == "GooglePay" ||
                                    widget.order.image == "") {
                                  showSnackBar(context,
                                      'คำสั่งซื้อนี้ชำระด้วย GooglePay');
                                } else {
                                  showSlip(widget.order.image);
                                }
                                setState(() {});
                              },
                              icon: const Icon(Icons.open_in_new),
                              label: const Text(
                                'สลิปการโอนเงิน',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            height: 30,
                            width: 140,
                            child: CustomButton(
                              text: 'ยืนยันคืนเงิน',
                              onTap: () => showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('คืนเงินสินค้า ?'),
                                    content: const Text(
                                        'คุณต้องการคืนเงินสินค้าให้ลูกค้าใช้หรือไม่ ?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('ยกเลิก'),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                      TextButton(
                                        child: const Text(
                                          'ตกลง',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                        onPressed: () {
                                          changeOrderstatus(checkOrder, orderId,
                                              productId, storeId);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ] else if (showContainer && checkOrder == 5) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: GlobalVariables.kPrimaryColor,
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('คำขอถูกส่งคืนเรียบร้อยแล้ว'),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                            width: 140,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 37, 195, 129),
                              ),
                              onPressed: () async {
                                if (widget.order.image == "GooglePay" ||
                                    widget.order.image == "") {
                                  showSnackBar(context,
                                      'คำสั่งซื้อนี้ชำระด้วย GooglePay');
                                } else {
                                  showSlip(widget.order.image);
                                }
                                setState(() {});
                              },
                              icon: const Icon(Icons.open_in_new),
                              label: const Text(
                                'สลิปการโอนเงิน',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ] else
                const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
