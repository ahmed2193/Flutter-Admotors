import 'package:flutter/material.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/provider/product/search_product_provider.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/holder/product_parameter_holder.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:provider/provider.dart';

class BottomNavigationImageAndText extends StatefulWidget {
  const BottomNavigationImageAndText(
      {this.searchProductProvider, this.changeAppBarTitle});
  final SearchProductProvider? searchProductProvider;
  final Function? changeAppBarTitle;

  @override
  _BottomNavigationImageAndTextState createState() =>
      _BottomNavigationImageAndTextState();
}

class _BottomNavigationImageAndTextState
    extends State<BottomNavigationImageAndText> {
  bool isClickBaseLineList = false;
  bool isClickBaseLineTune = false;
  PsValueHolder? valueHolder;

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context);

    if (widget.searchProductProvider!.productParameterHolder.isFiltered()) {
      isClickBaseLineTune = true;
    }

    if (widget.searchProductProvider!.productParameterHolder
        .isCatAndSubCatFiltered()) {
      isClickBaseLineList = true;
    }

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: PsColors.mainLightShadowColor!),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: PsColors.mainShadowColor!,
                offset: const Offset(1.1, 1.1),
                blurRadius: 10.0),
          ],
          color: PsColors.backgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PsIconWithCheck(
                  icon: FontAwesome.list_bullet,
                  color: isClickBaseLineList
                      ? PsColors.mainColor!
                      : PsColors.iconColor!,
                ),
                Text(Utils.getString(context, 'search__manufacturer'),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: isClickBaseLineList
                            ? PsColors.mainColor
                            : PsColors.textPrimaryColor)),
              ],
            ),
            onTap: () async {
              final Map<String, String> dataHolder = <String, String>{};
              dataHolder[PsConst.MANUFACTURER_ID] = widget
                  .searchProductProvider!.productParameterHolder.manufacturerId!;
              dataHolder[PsConst.MODEL_ID] =
                  widget.searchProductProvider!.productParameterHolder.modelId!;
              final dynamic result = await Navigator.pushNamed(
                  context, RoutePaths.filterExpantion,
                  arguments: dataHolder);

              if (result != null && result is Map<String, String>) {
                widget.searchProductProvider!.productParameterHolder
                    .manufacturerId = result[PsConst.MANUFACTURER_ID];

                widget.searchProductProvider!.productParameterHolder.modelId =
                    result[PsConst.MODEL_ID];
                final String loginUserId = Utils.checkUserLoginId(valueHolder);
                widget.searchProductProvider!.resetLatestProductList(loginUserId,
                    widget.searchProductProvider!.productParameterHolder);

                if (result[PsConst.MANUFACTURER_ID] == '' &&
                    result[PsConst.MODEL_ID] == '') {
                  isClickBaseLineList = false;
                } else {
                  widget.changeAppBarTitle!(result[PsConst.MANUFACTURER_NAME]);
                  isClickBaseLineList = true;
                }
              }
            },
          ),
          InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PsIconWithCheck(
                  icon: Icons.filter_list,
                  color: isClickBaseLineTune
                      ? PsColors.mainColor!
                      : PsColors.textPrimaryColor!,
                ),
                Text(Utils.getString(context, 'search__filter'),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: isClickBaseLineTune
                            ? PsColors.mainColor
                            : PsColors.textPrimaryColor))
              ],
            ),
            onTap: () async {
              final dynamic result = await Navigator.pushNamed(
                  context, RoutePaths.itemSearch,
                  arguments:
                      widget.searchProductProvider!.productParameterHolder);
              if (result != null && result is ProductParameterHolder) {
                widget.searchProductProvider!.productParameterHolder = result;
                widget.searchProductProvider!.needReset = false;
                final String loginUserId = Utils.checkUserLoginId(valueHolder);
                widget.searchProductProvider!.resetLatestProductList(loginUserId,
                    widget.searchProductProvider!.productParameterHolder);    

                if (widget.searchProductProvider!.productParameterHolder
                    .isFiltered()) {
                  isClickBaseLineTune = true;
                } else {
                  isClickBaseLineTune = false;
                }
              }
            },
          ),
          InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PsIconWithCheck(
                  icon: Icons.sort,
                  color: PsColors.mainColor!,
                ),
                Text(Utils.getString(context, 'search__map'),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: isClickBaseLineTune
                            ? PsColors.mainColor
                            : PsColors.textPrimaryColor))
              ],
            ),
            onTap: () async {
              if (valueHolder!.isSubLocation == PsConst.ONE) {
                if (widget.searchProductProvider!.productParameterHolder.lat ==
                        '' &&
                    widget.searchProductProvider!.productParameterHolder.lng ==
                        '') {
                  widget.searchProductProvider!.productParameterHolder.lat =
                      widget.searchProductProvider!.psValueHolder!
                          .locationTownshipLat;
                  widget.searchProductProvider!.productParameterHolder.lng =
                      widget.searchProductProvider!.psValueHolder!
                          .locationTownshipLng;
                }
              } else {
                if (widget.searchProductProvider!.productParameterHolder.lat ==
                        '' &&
                    widget.searchProductProvider!.productParameterHolder.lng ==
                        '') {
                  widget.searchProductProvider!.productParameterHolder.lat =
                      widget.searchProductProvider!.psValueHolder!.locationLat;
                  widget.searchProductProvider!.productParameterHolder.lng =
                      widget.searchProductProvider!.psValueHolder!.locationLng;
                }
              }
              if (valueHolder!.isUseGoogleMap!) {
                final dynamic result = await Navigator.pushNamed(
                    context, RoutePaths.googleMapFilter,
                    arguments:
                        widget.searchProductProvider!.productParameterHolder);
                if (result != null && result is ProductParameterHolder) {
                  widget.searchProductProvider!.productParameterHolder = result;
                  if (widget.searchProductProvider!.productParameterHolder
                              .mile !=
                          null &&
                      widget.searchProductProvider!.productParameterHolder
                              .mile !=
                          '' &&
                      double.parse(widget.searchProductProvider!
                              .productParameterHolder.mile!) <
                          1) {
                    widget.searchProductProvider!.productParameterHolder.mile =
                        '1';
                  }
                  final String loginUserId =
                      Utils.checkUserLoginId(valueHolder);
                  //for 0.5 km, it is less than 1 miles and error
                  widget.searchProductProvider!.resetLatestProductList(
                      loginUserId,
                      widget.searchProductProvider!.productParameterHolder);
                }
              } else {
                final dynamic result = await Navigator.pushNamed(
                    context, RoutePaths.mapFilter,
                    arguments:
                        widget.searchProductProvider!.productParameterHolder);
                if (result != null && result is ProductParameterHolder) {
                  widget.searchProductProvider!.productParameterHolder = result;
                  if (widget.searchProductProvider!.productParameterHolder
                              .mile !=
                          null &&
                      widget.searchProductProvider!.productParameterHolder
                              .mile !=
                          '' &&
                      double.parse(widget.searchProductProvider!
                              .productParameterHolder.mile!) <
                          1) {
                    widget.searchProductProvider!.productParameterHolder.mile =
                        '1';
                  }
                  //for 0.5 km, it is less than 1 miles and error
                  final String loginUserId =
                      Utils.checkUserLoginId(valueHolder);
                  widget.searchProductProvider!.resetLatestProductList(
                      loginUserId,
                      widget.searchProductProvider!.productParameterHolder);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class PsIconWithCheck extends StatelessWidget {
  const PsIconWithCheck({Key? key, this.icon, this.color}) : super(key: key);
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: color ?? PsColors.grey!);
  }
}
