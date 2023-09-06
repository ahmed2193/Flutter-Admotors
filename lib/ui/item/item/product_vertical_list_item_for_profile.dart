import 'package:flutter/material.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/ui/common/ps_hero.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/product.dart';
import 'package:provider/provider.dart';

class ProductVeticalListItemForProfile extends StatelessWidget {
  const ProductVeticalListItemForProfile(
      {Key? key,
      required this.product,
      this.onTap,
      this.animationController,
      this.animation,
      this.coreTagKey})
      : super(key: key);

  final Product product;
  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final String? coreTagKey;

  @override
  Widget build(BuildContext context) {
    //print("${PsConfig.ps_app_image_thumbs_url}${subCategory.defaultPhoto.imgPath}");
    final PsValueHolder valueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    animationController!.forward();
    return AnimatedBuilder(
        animation: animationController!,
        child: InkWell(
          onTap: onTap as void Function()?,
          child: GridTile(
            header: Container(
              padding: const EdgeInsets.all(PsDimens.space8),
              child: Ink(
                color: PsColors.backgroundColor,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: PsDimens.space8, vertical: PsDimens.space8),
              decoration: BoxDecoration(
                color: PsColors.backgroundColor,
                borderRadius:
                    const BorderRadius.all(Radius.circular(PsDimens.space8)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (valueHolder.isShowOwnerInfo!)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: PsDimens.space4,
                      top: PsDimens.space4,
                      right: PsDimens.space12,
                      bottom: PsDimens.space4,
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: PsDimens.space40,
                          height: PsDimens.space40,
                          child: PsNetworkCircleImageForUser(
                            photoKey: '',
                            imagePath: product.user!.userProfilePhoto,
                            // width: PsDimens.space40,
                            // height: PsDimens.space40,
                            boxfit: BoxFit.cover,
                            onTap: () {
                              Utils.psPrint(
                                  product.defaultPhoto!.imgParentId!);
                              onTap!();
                            },
                          ),
                        ),
                        const SizedBox(width: PsDimens.space8),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: PsDimens.space8,
                                top: PsDimens.space8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                          product.user!.userName == ''
                                              ? Utils.getString(
                                                  context, 'default__user_name')
                                              : '${product.user!.userName}',
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge),
                                    ),
                                    if (product.user!.isVerifyBlueMark ==
                                        PsConst.ONE)
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: PsDimens.space2),
                                        child: Icon(
                                          Icons.check_circle,
                                          color: PsColors.bluemarkColor,
                                          size: valueHolder.bluemarkSize,
                                        ),
                                      )
                                  ],
                                ),
                                Text('${product.addedDateStr}',
                                    textAlign: TextAlign.start,
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // Stack(
                  //   children: <Widget>[
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(PsDimens.space2),
                          width: PsDimens.space180,
                          height: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(PsDimens.space6),
                            child: PsNetworkImage(
                              photoKey: '$coreTagKey${PsConst.HERO_TAG__IMAGE}',
                              defaultPhoto: product.defaultPhoto!,
                              imageAspectRation: PsConst.Aspect_Ratio_2x,
                              // width: PsDimens.space180,
                              // height: double.infinity,
                              boxfit: BoxFit.cover,
                              onTap: () {
                                Utils.psPrint(
                                    product.defaultPhoto!.imgParentId!);
                                onTap!();
                              },
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            child: product.isSoldOut == '1'
                                ? Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: PsDimens.space18,right: 12),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            Utils.getString(context,
                                                'dashboard__sold_out'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: PsColors.white)),
                                      ),
                                    ),
                                    height: 30,
                                    width: PsDimens.space180,
                                    decoration: BoxDecoration(
                                        color: PsColors.soldOutUIColor),
                                  )
                                : Container()
                            //   )
                            // ],
                            ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space8,
                        top: PsDimens.space12,
                        right: PsDimens.space8,
                        bottom: PsDimens.space4),
                    child: PsHero(
                      tag: '$coreTagKey$PsConst.HERO_TAG__TITLE',
                      child: Text(
                        product.title!,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space8,
                      //  top: PsDimens.space4,
                        right: PsDimens.space8),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            PsHero(
                              tag: '$coreTagKey$PsConst.HERO_TAG__UNIT_PRICE',
                              flightShuttleBuilder: Utils.flightShuttleBuilder,
                              child: Material(
                                type: MaterialType.transparency,
                                child: Text(
                                    // product != null &&
                                    Utils.showUI(valueHolder.discountRate) ?
                                        product.discountRate == '0' ?
                                              product.price != '0' && product.price != ''
                                              ? '${product.itemCurrency!.currencySymbol}${Utils.getPriceFormat(product.price!, valueHolder.priceFormat!)}'
                                              : Utils.getString(context, 'item_price_free') :
                                        '${product.itemCurrency!.currencySymbol}${Utils.getPriceFormat(product.discountedPrice ?? '0.0', valueHolder.priceFormat!)}' 
                                        : product.price != '0' && product.price != ''
                                              ? '${product.itemCurrency!.currencySymbol}${Utils.getPriceFormat(product.price!, valueHolder.priceFormat!)}'
                                              : Utils.getString(context, 'item_price_free'),
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(color: PsColors.mainColor, 
                                                      fontSize: 16)),
                              ),
                            ),
                            if (Utils.showUI(valueHolder.condition)  && product.conditionOfItem!.name != null && product.conditionOfItem!.name != '')
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: PsDimens.space8,
                                    right: PsDimens.space8),
                                child: Text(
                                  '(${product.conditionOfItem!.name})',
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: PsColors.mainColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: Utils.showUI(valueHolder.discountRate) && product.discountRate != '0',
                            child: Row(
                              children: <Widget>[
                                Text(
                                      '  ${product.itemCurrency!.currencySymbol}${Utils.getPriceFormat(product.price!, valueHolder.priceFormat!)}  ',                                      
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: PsColors.textPrimaryLightColorForLight, 
                                            decoration: TextDecoration.lineThrough,
                                            fontSize: 10),
                                ),
                                const SizedBox(
                                  width: PsDimens.space6
                                ),
                                Text(
                                      '-${product.discountRate}%',                                      
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: PsColors.textPrimaryLightColorForLight,
                                            fontSize: 10),
                                ),
                              ],
                            )
                          )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space8,
                        top: PsDimens.space12,
                        right: PsDimens.space8,
                        bottom: PsDimens.space4),
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/images/baseline_pin_black_24.png',
                          width: PsDimens.space10,
                          height: PsDimens.space10,
                          fit: BoxFit.contain,

                          // ),
                        ),
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  left: PsDimens.space8,
                                  right: PsDimens.space8),
                              child: Text(
                                  valueHolder.isSubLocation == PsConst.ONE && product.itemLocationTownship!.townshipName != ''
                                      ? '${product.itemLocationTownship!.townshipName}'
                                      : '${product.itemLocation!.name}',
                                  textAlign: TextAlign.start,
                                  style:
                                      Theme.of(context).textTheme.bodySmall)),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space8,
                        right: PsDimens.space8,
                        bottom: PsDimens.space16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        if (Utils.showUI(valueHolder.itemType) && product.itemType!.name != '')
                        Row(
                          children: <Widget>[
                            Container(
                              width: PsDimens.space8,
                              height: PsDimens.space8,
                              decoration: BoxDecoration(
                                  color: PsColors.itemTypeColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(PsDimens.space4))),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: PsDimens.space8,
                                    right: PsDimens.space4),
                                child: Text('${product.itemType!.name}',
                                    textAlign: TextAlign.start,
                                    style:
                                        Theme.of(context).textTheme.bodySmall))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/baseline_favourite_grey_24.png',
                              width: PsDimens.space10,
                              height: PsDimens.space10,
                              fit: BoxFit.contain,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: PsDimens.space4,
                              ),
                              child: Text('${product.favouriteCount}',
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.bodySmall),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
              opacity: animation!,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation!.value), 0.0),
                  child: child));
        });
  }
}
