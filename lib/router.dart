import 'package:flutter/material.dart';
import 'package:kmutnb_project/common/widgets/bottom_bar.dart';
import 'package:kmutnb_project/features/address/screens/addres_screen.dart';
import 'package:kmutnb_project/features/auth/screens/auth_screen.dart';
import 'package:kmutnb_project/features/home/screens/category_deals_screen.dart';
import 'package:kmutnb_project/features/product_details/screens/product_deatails_screen.dart';
import 'package:kmutnb_project/features/search/screens/search_screen.dart';
import 'package:kmutnb_project/models/ChatModel.dart';
import 'package:kmutnb_project/models/orderStore.dart';
import 'package:kmutnb_project/models/product.dart';

import 'features/admin/screens/add_products_screen.dart';
import 'features/admin/screens/admin_screen.dart';
import 'features/chat/screens/ChatPage.dart';
import 'features/chat/screens/chat_history_screen.dart';
import 'features/chat/screens/chat_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/order_detail/screens/order_details.dart';
import 'features/order_detail/screens/order_store_details.dart';
import 'features/store/screens/add_store_screen.dart';
import 'models/order.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );

    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );

    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );

    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddProductScreen(),
      );
    case AddStoreScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddStoreScreen(),
      );
    case AdminScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AdminScreen(),
      );
    case CategoryDealsScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CategoryDealsScreen(
          category: category,
        ),
      );
    case SearchScreen.routeName:
      var searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchScreen(
          searchQuery: searchQuery,
        ),
      );
    case ProductDetailScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductDetailScreen(
          product: product,
        ),
      );
    case AddressScreen.routeName:
      var totalAmount = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddressScreen(
          totalAmount: totalAmount,
        ),
      );
    case OrderDetailScreen.routeName:
      var order = routeSettings.arguments as Order;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderDetailScreen(
          order: order,
        ),
      );
    case OrderStoreDetailScreen.routeName:
      var order = routeSettings.arguments as OrderStore;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderStoreDetailScreen(
          order: order,
        ),
      );
    case ChatScreen.routeName:
      var chatmodel = routeSettings.arguments as ChatModel;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ChatScreen(
          chatModel: chatmodel,
          sourchat: chatmodel,
        ),
      );
    case ChatPage.routeName:
      var arguments = routeSettings.arguments;
      if (arguments is ChatModel) {
        // ignore: unnecessary_cast
        var chatmodel = arguments as ChatModel;
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => ChatPage(
            sourchat: chatmodel,
            chatmodels: [chatmodel],
          ),
        );
      } else {
        throw Exception("Invalid arguments for ChatPage");
      }

    case ChatHistoryScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ChatHistoryScreen(
          chatModel: null,
          sourchat: null,
        ),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
  }
}
