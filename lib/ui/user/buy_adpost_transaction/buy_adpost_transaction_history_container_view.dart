import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/ui/user/buy_adpost_transaction/buy_adpost_transaction_history_list.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';

class BuyAdTransactionContainerView extends StatefulWidget {
  @override
  _BuyAdTransactionContainerViewState createState() => _BuyAdTransactionContainerViewState();
}

class _BuyAdTransactionContainerViewState extends State<BuyAdTransactionContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  late PsValueHolder valueHolder;
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

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);

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
          // iconTheme: Theme.of(context)
          //     .iconTheme
          //     .copyWith(color: PsColors.backArrowColor),
          backgroundColor:
              Utils.isLightMode(context) ? PsColors.mainColor : Colors.black12,
          title: Text(Utils.getString(context, 'package__my_package_title'),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold, color: PsColors.white)
                //  .copyWith(color: Utils.isLightMode(context)? PsColors.primary500 : PsColors.primaryDarkWhite)
                  ),
          elevation: 0,
          actions: <Widget>[
            IconButton(
              padding: const EdgeInsets.only(right: PsDimens.space10),
              icon: Icon(FontAwesome5.store,
              size: 20,
              color: PsColors.white),
              onPressed: () async {
                await Navigator.pushNamed(context, RoutePaths.buyPackage,
                    arguments: <String, dynamic>{
                      'android': valueHolder.packageAndroidKeyList,
                      'ios': valueHolder.packageIOSKeyList
                    });
              },
            ),
          ],
        ),
        body: Container(
        //  color: PsColors.baseColor,
          height: double.infinity,
          child: BuyAdTransactionListView(),
        ),
      ),
    );
  }
}