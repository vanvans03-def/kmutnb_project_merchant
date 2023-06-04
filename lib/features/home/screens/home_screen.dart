import 'package:flutter/material.dart';
import 'package:kmutnb_project/features/home/widgets/address_box.dart';
import 'package:kmutnb_project/features/home/widgets/carousel_image.dart';
import 'package:kmutnb_project/features/home/widgets/deal_of_day.dart';
import 'package:kmutnb_project/features/home/widgets/top_categories.dart';
import 'package:kmutnb_project/features/search/screens/search_screen.dart';
import 'package:provider/provider.dart';

import '../../../constants/global_variables.dart';
import '../../../models/ChatModel.dart';
import '../../../providers/user_provider.dart';
import '../../chat/screens/ChatPage.dart';
import '../../chat/screens/chat_history_screen.dart';
import '../../chat/screens/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  Widget build(BuildContext context) {
    ChatModel sourceChat;
    List<ChatModel> chatmodels = [
      ChatModel(
        name: "Dev Stack",
        isGroup: false,
        currentMessage: "Hi Everyone",
        time: "4:00",
        icon: const Icon(Icons.person).toString(),
        id: 1,
        status: '',
      ),
      ChatModel(
        name: "Kishor",
        isGroup: false,
        currentMessage: "Hi Kishor",
        time: "13:00",
        icon: "person.svg",
        id: 2,
        status: '',
      ),
      ChatModel(
        name: "Collins",
        isGroup: false,
        currentMessage: "Hi Dev Stack",
        time: "8:00",
        icon: "person.svg",
        id: 3,
        status: '',
      ),
      ChatModel(
        name: "Balram Rathore",
        isGroup: false,
        currentMessage: "Hi Dev Stack",
        time: "2:00",
        icon: "person.svg",
        id: 4,
        status: '',
      ),
    ];

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String user = userProvider.user.id;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 6,
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: 'Search',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                  icon: const Icon(
                    Icons.chat,
                    color: Colors.black,
                    size: 25,
                  ),
                  onPressed: () {
                    final sourceChat = chatmodels.removeAt(0);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          chatmodels: chatmodels,
                          sourchat: sourceChat,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AddressBox(),
            const SizedBox(height: 10),
            TopCategories(),
            const SizedBox(height: 10),
            const CarouseImage(),
            const DealOfDay(),
          ],
        ),
      ),
    );
  }
}
