import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/utils/utils.dart';

import 'favourite_product_list_view.dart';

class FavouriteProductListContainerView extends StatefulWidget {
  @override
  _FavouriteProductListContainerViewState createState() =>
      _FavouriteProductListContainerViewState();
}

class _FavouriteProductListContainerViewState
    extends State<FavouriteProductListContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController!.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    print(
        '............................Build UI Again ............................');
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
        systemOverlayStyle:  SystemUiOverlayStyle(
           statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
         ),  
          backgroundColor:
              Utils.isLightMode(context) ? PsColors.mainColor : Colors.black12,
          title: Text(
            Utils.getString(context, 'home__menu_drawer_favourite'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: PsColors.white),
          ),
          elevation: 0,
        ),
        body: FavouriteProductListView(
          scrollController: scrollController,
          animationController: animationController!,
        ),
      ),
    );
  }
}
