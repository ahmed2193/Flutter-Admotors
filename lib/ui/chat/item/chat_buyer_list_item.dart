import 'package:flutter/material.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/chat_history.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/user_intent_holder.dart';
import 'package:provider/provider.dart';

class ChatBuyerListItem extends StatelessWidget {
  const ChatBuyerListItem({
    Key? key,
    required this.chatHistory,
    this.animationController,
    this.animation,
    this.onTap,
  }) : super(key: key);

  final ChatHistory? chatHistory;
  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController!,
        child: chatHistory != null
            ? InkWell(
                onTap: onTap as void Function()?,
                child: Container(
                  margin: const EdgeInsets.only(bottom: PsDimens.space8),
                  child: Ink(
                    color: PsColors.backgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(PsDimens.space16),
                      child: _ImageAndTextWidget(
                        chatHistory: chatHistory,
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
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

class _ImageAndTextWidget extends StatelessWidget {
  const _ImageAndTextWidget({
    Key? key,
    required this.chatHistory,
  }) : super(key: key);

  final ChatHistory? chatHistory;

  @override
  Widget build(BuildContext context) {
    final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context);
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space8,
    );

    if (chatHistory != null && chatHistory!.item != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: PsDimens.space40,
            height: PsDimens.space40,
            child: PsNetworkCircleImageForUser(
              photoKey: '',
              imagePath: chatHistory!.buyer!.userProfilePhoto!,
              // width: PsDimens.space40,
              // height: PsDimens.space40,
              boxfit: BoxFit.cover,
              onTap: () {
                Navigator.pushNamed(context, RoutePaths.userDetail,
                    arguments: UserIntentHolder(
                      userId: chatHistory!.buyer!.userId!,
                      userName: chatHistory!.buyer!.userName!,
                    ));
              },
            ),
          ),
          const SizedBox(
            width: PsDimens.space8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          chatHistory!.buyer!.userName! == ''
                              ? Utils.getString(context, 'default__user_name')
                              : chatHistory!.buyer!.userName!,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.grey),
                        ),
                        if (chatHistory!.buyer!.isVerifyBlueMark == PsConst.ONE)
                          Container(
                            margin:
                                const EdgeInsets.only(left: PsDimens.space2),
                            child: Icon(
                              Icons.check_circle,
                              color: PsColors.bluemarkColor,
                              size: valueHolder.bluemarkSize,
                            ),
                          )
                      ],
                    ),
                    if (
                    //chatHistory!.sellerUnreadCount != null &&
                    chatHistory!.sellerUnreadCount != '' &&
                        chatHistory!.sellerUnreadCount == '0')
                      Container()
                    else
                      Container(
                        padding: const EdgeInsets.all(PsDimens.space4),
                        decoration: BoxDecoration(
                          color: PsColors.mainColor,
                          borderRadius: BorderRadius.circular(PsDimens.space8),
                          border: Border.all(
                              color: Utils.isLightMode(context)
                                  ? Colors.grey[200]!
                                  : Colors.black87),
                        ),
                        child: Text(
                          chatHistory!.sellerUnreadCount!,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: PsColors.whiteColorWithBlack),
                        ),
                      )
                  ],
                ),
                _spacingWidget,
                const Divider(
                  height: 2,
                ),
                _spacingWidget,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        chatHistory!.item!.title!,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    if (chatHistory!.item!.isSoldOut == '1')
                      Container(
                        padding: const EdgeInsets.all(PsDimens.space4),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(PsDimens.space8),
                          border: Border.all(
                              color: Utils.isLightMode(context)
                                  ? Colors.grey[200]!
                                  : Colors.black87),
                        ),
                        child: Text(
                          Utils.getString(
                              context, 'chat_history_list_item__sold'),
                          //'Sold',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.white),
                        ),
                      )
                    else
                      Container()
                  ],
                ),
                _spacingWidget,
                Row(
                  children: <Widget>[
                    Text(
                      //chatHistory!.item != null &&
                      chatHistory!.item!.price != '0' &&
                              chatHistory!.item!.price != ''
                          ? '${chatHistory!.item!.itemCurrency!.currencySymbol}  ${Utils.getPriceFormat(chatHistory!.item!.price!, valueHolder.priceFormat!)}'
                          : Utils.getString(context, 'item_price_free'),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: PsColors.mainColor),
                    ),
                    const SizedBox(
                      width: PsDimens.space8,
                    ),
                    Text(
                      '( ${chatHistory!.item!.conditionOfItem!.name} )',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.blue),
                    ),
                  ],
                ),
                _spacingWidget,
                Text(
                  chatHistory!.addedDateStr!,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: PsDimens.space8,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(PsDimens.space4),
            child: Container(
              height: PsDimens.space60,
              width: PsDimens.space60,
              child: PsNetworkImage(
                // height: PsDimens.space60,
                // width: PsDimens.space60,
                imageAspectRation: PsConst.Aspect_Ratio_1x,
                photoKey: '',
                defaultPhoto: chatHistory!.item!.defaultPhoto!,
                boxfit: BoxFit.cover,
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
