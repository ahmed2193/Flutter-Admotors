import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/utils/utils.dart';

import 'blocked_user_list_view.dart';

class BlockUserContainerView extends StatefulWidget {
  @override
  _BlockUserContainerViewState createState() => _BlockUserContainerViewState();
}

class _BlockUserContainerViewState extends State<BlockUserContainerView>
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

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
            Utils.getString(context, 'more__block_user_title'),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge !
                .copyWith(color: PsColors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        ),
        body: Container(
           color: PsColors.coreBackgroundColor,
          height: double.infinity,
          child: BlockedUserListView(
            animationController: animationController!,
          ),
        ),
      ),
    );
  }
}
