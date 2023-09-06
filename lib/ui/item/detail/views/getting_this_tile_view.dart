import 'package:flutter/material.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/ui/common/ps_expansion_tile.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/typicons_icons.dart';

import '../../../../viewobject/deal_option.dart';

class GettingThisTileView extends StatelessWidget {
  const GettingThisTileView({
    Key? key,
    required this.detailOption,
    required this.address,
  }) : super(key: key);

  final DealOption detailOption;
  final String address;
  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'getting_this_tile__title'),
        style: Theme.of(context).textTheme.titleMedium);

    final Widget _expansionTileIconWidget = Icon(
      Elusive.lightbulb,
      color: PsColors.mainColor,
    );
    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
          bottom: PsDimens.space12),
      decoration: BoxDecoration(
        color: PsColors.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(PsDimens.space8)),
      ),
      child: PsExpansionTile(
        initiallyExpanded: true,
        leading: _expansionTileIconWidget,
        title: _expansionTileTitleWidget,
        children: <Widget>[
          Column(
            children: <Widget>[
              const Divider(
                height: PsDimens.space1,
              ),
              Padding(
                  padding: const EdgeInsets.all(PsDimens.space16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Typicons.location,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(
                        width: PsDimens.space40,
                      ),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: <Widget>[
                      //     Text(
                      //       detailOptionId == '1'
                      //           ? Utils.getString(
                      //               context, 'getting_this_tile__meet_up')
                      //           : Utils.getString(context,
                      //               'getting_this_tile__mailing_on_delivery'),
                      //       style: Theme.of(context).textTheme.bodyText1,
                      //     ),
                      //     Text(address != '' ? address : '',
                      //         style: Theme.of(context).textTheme.bodyText1)
                      //   ],
                      // ),
                      Flexible(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            Utils.getString(context, detailOption.name!),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(
                            height: PsDimens.space8,
                          ),
                          Text(
                            address != '' ? address : '',
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        ],
                      )),
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }
}
