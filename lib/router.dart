import 'package:get/get.dart';
import 'package:money_app/modules/top_up/top_up_controller.dart';
import 'package:money_app/modules/transactions/transactions_controller.dart';
import 'package:money_app/modules/transactions/transactions_page.dart';
import 'package:money_app/modules/pay.dart';
import 'package:money_app/modules/top_up/top_up_page.dart';

class PageRoutes {
  static const String transactions = '/transactions';
  static const String topup = '/top-up';
  static const String pay = '/pay';
}

getAppPageRoutes() => [
      GetPage(
        name: PageRoutes.transactions,
        page: () => const TransactionsPage(),
        binding: TransactionsBinding(),
      ),
      GetPage(
        name: PageRoutes.topup,
        page: () => const TopupPage(),
        binding: TopupBinding(),
      ),
      GetPage(
        name: PageRoutes.pay,
        page: () => const PayPage(),
      ),
    ];
