import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/provider/about_us/about_us_provider.dart';
import 'package:flutteradmotors/ui/common/ps_expansion_tile.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/safety_tips_intent_holder.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:provider/provider.dart';

class SafetyTipsTileView extends StatelessWidget {
  const SafetyTipsTileView({
    Key? key,
    required this.animationController,
  }) : super(key: key);

  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'safety_tips_tile__title'),
        style: Theme.of(context).textTheme.titleMedium);

    final Widget _expansionTileLeadingIconWidget = Icon(
      FontAwesome.shield,
      color: PsColors.mainColor,
    );

    return Consumer<AboutUsProvider>(builder:
        (BuildContext context, AboutUsProvider aboutUsProvider, Widget? gchild) {
      if (
          // aboutUsProvider.aboutUsList != null &&
          aboutUsProvider.aboutUsList.data!.isNotEmpty) {
        return Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space12,
              right: PsDimens.space12,
              bottom: PsDimens.space12),
          decoration: BoxDecoration(
            color: PsColors.backgroundColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(PsDimens.space8)),
          ),
          child: PsExpansionTile(
            initiallyExpanded: true,
            leading: _expansionTileLeadingIconWidget,
            title: _expansionTileTitleWidget,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Divider(
                    height: PsDimens.space1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(PsDimens.space12),
                    child:  Html(
                     data: aboutUsProvider.aboutUsList.data![0].safetyTips!,
                     // ignore: always_specify_types
                     style: {
                       '#': Style(
                         margin:  Margins.only(top: -7.0),
                         maxLines: 2,
                         height:Height(40) ,
                         fontWeight: FontWeight.normal,
                         textOverflow: TextOverflow.ellipsis,
                        // color: PsColors.textColor2
                       ),
                     },
                     ),
                    // child: Text(
                    //   aboutUsProvider.aboutUsList.data![0].safetyTips!,
                    //     maxLines: 3,
                    //     style: Theme.of(context).textTheme.bodyText1),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(PsDimens.space12),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RoutePaths.safetyTips,
                            arguments: SafetyTipsIntentHolder(
                                animationController: animationController,
                                safetyTips: aboutUsProvider
                                    .aboutUsList.data![0].safetyTips!));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            Utils.getString(
                                context, 'safety_tips_tile__read_more_button'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: PsColors.mainColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
