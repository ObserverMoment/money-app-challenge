import 'package:get/get.dart';
import 'package:money_app/pages/home.dart';
import 'package:money_app/pages/pay.dart';
import 'package:money_app/pages/top_up.dart';

const kStandardPageTransitionDuration = Duration(milliseconds: 500);

getAppPageRoutes() => [
      GetPage(
        name: '/home',
        page: () => const HomePage(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: kStandardPageTransitionDuration,
      ),
      GetPage(
        name: '/top-up',
        page: () => const TopupPage(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: kStandardPageTransitionDuration,
      ),
      GetPage(
        name: '/pay',
        page: () => const PayPage(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: kStandardPageTransitionDuration,
      ),
    ];
