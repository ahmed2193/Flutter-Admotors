import 'package:flutter/material.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/provider/product/product_provider.dart';
import 'package:flutteradmotors/ui/common/ps_expansion_tile.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/ui/common/smooth_star_rating_widget.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/user_intent_holder.dart';
import 'package:flutteradmotors/viewobject/product.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SellerInfoTileView extends StatelessWidget {
  const SellerInfoTileView({
    Key? key,
    required this.itemDetail,
  }) : super(key: key);

  final ItemDetailProvider itemDetail;

  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'seller_info_tile__title'),
        style: Theme.of(context).textTheme.titleMedium);

    final Widget _expansionTileLeadingIconWidget = Icon(
      Entypo.user,
      color: PsColors.mainColor,
    );
    if (
      // itemDetail != null &&
      //   itemDetail.itemDetail != null &&
        itemDetail.itemDetail.data != null) {
      return InkWell(
        onTap: () {
          Navigator.pushNamed(context, RoutePaths.userDetail,
              // arguments: itemDetail.itemDetail.data.addedUserId
              arguments: UserIntentHolder(
                userId: itemDetail.itemDetail.data!.addedUserId!,
                userName: itemDetail.itemDetail.data!.user!.userName!,
              ));
        },
        child: Container(
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
            initiallyExpanded: false,
            leading: _expansionTileLeadingIconWidget,
            title: _expansionTileTitleWidget,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Divider(
                    height: PsDimens.space1,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          top: PsDimens.space12,
                          bottom: PsDimens.space16,
                          left: PsDimens.space16,
                          right: PsDimens.space16),
                      child: ImageAndTextWidget(
                        data: itemDetail.itemDetail.data!,
                      )),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return const Card();
    }
  }
}

class ImageAndTextWidget extends StatelessWidget {
  const ImageAndTextWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Product data;
  @override
  Widget build(BuildContext context) {
    final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context);
    final ItemDetailProvider itemDetailProvider =
        Provider.of<ItemDetailProvider>(context, listen: false);

    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space4,
    );

    final Widget _imageWidget = PsNetworkCircleImageForUser(
      photoKey: '',
      imagePath: data.user!.userProfilePhoto,
      // width: 50,
      // height: 50,
      boxfit: BoxFit.cover,
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.userDetail,
            // arguments: data.addedUserId
            arguments: UserIntentHolder(
                userId: data.addedUserId!, userName: data.user!.userName!));
      },
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(width: 50, height: 50, child: _imageWidget),
        const SizedBox(
          width: PsDimens.space12,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                      data.user!.userName! == ''
                          ? Utils.getString(context, 'default__user_name')
                          : data.user!.userName!,
                      style: Theme.of(context).textTheme.titleMedium),
                  if (data.user!.isVerifyBlueMark == PsConst.ONE)
                    Container(
                      margin: const EdgeInsets.only(left: PsDimens.space2),
                      child: Icon(
                        Icons.check_circle,
                        color: PsColors.bluemarkColor,
                        size: valueHolder.bluemarkSize,
                      ),
                    )
                ],
              ),
              if (data.user!.isVerifyBlueMark == PsConst.ONE)
                Visibility(
                  child: Container(
                    width: PsDimens.space140,
                    child: MaterialButton(
                      color: PsColors.mainColor,
                      height: PsDimens.space28,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: PsColors.mainColor!),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(18.0))),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.verified_user,
                              color: PsColors.white,
                              size: 20,
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: PsDimens.space4,
                                  right: PsDimens.space6),
                              child: Text(
                                Utils.getString(
                                    context, 'seller_info_tile__verified'),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(color: PsColors.white),
                              ),
                            ),
                          ]),
                      onPressed: () {},
                    ),
                  ),
                )
              else
                _spacingWidget,
              if (data.user!.userAboutMe != '')
              Text(
                        data.user!.userAboutMe!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge),  
              if (itemDetailProvider.itemDetail.data!.user!.isShowPhone == '1')
                Visibility(
                  visible: true,
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.phone,
                      ),
                      const SizedBox(
                        width: PsDimens.space8,
                      ),
                      InkWell(
                        child: Text(
                          data.user!.userPhone!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        onTap: () async {
                          if (data.user!.userPhone != null &&
                              data.user!.userPhone != '') {
                           if (await canLaunchUrl(
                              Uri.parse('tel://${data.user!.userPhone}')  )) {
                              await launchUrl( Uri.parse('tel://${data.user!.userPhone}'));
                            } else {
                              throw 'Could not Call Phone Number 1';
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              if (itemDetailProvider.itemDetail.data!.user!.isShowEmail == '1')
                Visibility(
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.email,
                      ),
                      const SizedBox(
                        width: PsDimens.space8,
                      ),
                      Text(
                        data.user!.userEmail!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              _spacingWidget,
              _RatingWidget(
                data: data,
              ),
              _spacingWidget,
              InkWell(
                child: Text(
                  // data.user!.addedDateTimeStamp! != null &&
                          data.user!.addedDateTimeStamp != ''
                      ? Utils.changeTimeStampToStandardDateTimeFormat(
                          data.user!.addedDateTimeStamp)
                      : Utils.getDateFormat(data.user!.addedDate!, valueHolder.dateFormat!),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                ),
                onTap: () async {},
              ),
              _spacingWidget,
              _VerifiedWidget(
                data: data,
              ),
              
            ],
          ),
        )
      ],
    );
  }
}

class _RatingWidget extends StatelessWidget {
  const _RatingWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Product data;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          data.user!.overallRating!,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          width: PsDimens.space8,
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, RoutePaths.ratingList,
                arguments: data.user!.userId);
          },
          child: SmoothStarRating(
              key: Key(data.user!.ratingDetail!.totalRatingValue!),
              rating: double.parse(data.user!.ratingDetail!.totalRatingValue!),
              allowHalfRating: false,
              isReadOnly: true,
              starCount: 5,
              size: PsDimens.space16,
              color: Colors.yellow,
              borderColor: Colors.blueGrey[200],
              onRated: (double? v) {},
              spacing: 0.0),
        ),
        const SizedBox(
          width: PsDimens.space8,
        ),
        Text(
          '( ${data.user!.ratingCount} )',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class _VerifiedWidget extends StatelessWidget {
  const _VerifiedWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Product data;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (data.user!.facebookVerify == '1' || data.user!.googleVerify == '1' || 
            data.user!.phoneVerify == '1' || data.user!.emailVerify == '1')
        Text(
          Utils.getString(context, 'seller_info_tile__verified'),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        if (data.user!.facebookVerify == '1')
          const Padding(
            padding:
                EdgeInsets.only(left: PsDimens.space4, right: PsDimens.space4),
            child: Icon(
              FontAwesome.facebook_official,
            ),
          )
        else
          Container(),
        if (data.user!.googleVerify == '1')
          const Padding(
            padding:
                EdgeInsets.only(left: PsDimens.space4, right: PsDimens.space4),
            child: Icon(
              FontAwesome.google,
            ),
          )
        else
          Container(),
        if (data.user!.phoneVerify == '1')
          const Padding(
            padding:
                EdgeInsets.only(left: PsDimens.space4, right: PsDimens.space4),
            child: Icon(
              FontAwesome.phone,
            ),
          )
        else
          Container(),
        if (data.user!.emailVerify == '1')
          const Padding(
            padding:
                EdgeInsets.only(left: PsDimens.space4, right: PsDimens.space4),
            child: Icon(
              Icons.email,
            ),
          )
        else
          Container(),
      ],
    );
  }
}
