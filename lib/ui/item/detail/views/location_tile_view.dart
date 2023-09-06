import 'package:flutter/material.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/ui/common/ps_expansion_tile.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/map_pin_intent_holder.dart';
import 'package:flutteradmotors/viewobject/product.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:provider/provider.dart';

class LocationTileView extends StatefulWidget {
  const LocationTileView({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Product item;

  @override
  _LocationTileViewState createState() => _LocationTileViewState();
}

class _LocationTileViewState extends State<LocationTileView> {
  @override
  Widget build(BuildContext context) {
    final PsValueHolder psValueHolder = Provider.of<PsValueHolder>(context);
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'location_tile__title'),
        style: Theme.of(context).textTheme.titleMedium);

    final Widget _expansionTileLeadingWidget = Icon(
      Typicons.location,
      color: PsColors.mainColor,
    );
    // if (productDetail != null && productDetail.description != null) {
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
        leading: _expansionTileLeadingWidget,
        title: _expansionTileTitleWidget,
        children: <Widget>[
          Column(
            children: <Widget>[
              const Divider(
                height: PsDimens.space1,
              ),
              // const SizedBox(height: PsDimens.space16),
              if (Utils.showUI(psValueHolder.address))
              Padding(
                padding: const EdgeInsets.all(PsDimens.space16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Entypo.address,
                      size: PsDimens.space20,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    const SizedBox(width: PsDimens.space12),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(Utils.getString(context, 'item_detail__address'),
                              style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(height: PsDimens.space12),
                          Text(widget.item.address!,
                              style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                    )
                  ],
                ),
              ) else 
                  const SizedBox(height: PsDimens.space16),

              // const Divider(
              //   height: PsDimens.space1,
              // ),
              InkWell(
                child: Ink(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: PsDimens.space16),
                    child: Text(
                      Utils.getString(
                              context, 'location_tile__view_on_map_button')
                          .toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: PsColors.mainColor),
                    ),
                  ),
                ),
                onTap: () async {
                  if (psValueHolder.isUseGoogleMap!) {
                    await Navigator.pushNamed(context, RoutePaths.googleMapPin,
                        arguments: MapPinIntentHolder(
                            flag: PsConst.VIEW_MAP,
                            mapLat: widget.item.lat!,
                            mapLng: widget.item.lng!));
                  } else {
                    await Navigator.pushNamed(context, RoutePaths.mapPin,
                        arguments: MapPinIntentHolder(
                            flag: PsConst.VIEW_MAP,
                            mapLat: widget.item.lat!,
                            mapLng: widget.item.lng!));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
    // } else {
    //   return const Card();
    // }
  }
}
