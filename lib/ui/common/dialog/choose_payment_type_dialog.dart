import 'package:flutter/material.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/repository/user_repository.dart';
import 'package:flutteradmotors/ui/common/ps_button_widget_with_round_corner.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';

class ChoosePaymentTypeDialog extends StatefulWidget {
  const ChoosePaymentTypeDialog({Key? key, @required this.onInAppPurchaseTap,@required this.onOtherPaymentTap})
      : super(key: key);

  final Function? onInAppPurchaseTap;
  final Function? onOtherPaymentTap;

  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<ChoosePaymentTypeDialog> {
  late UserRepository repo1;
  late PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    return NewDialog(widget: widget);
  }
}

class NewDialog extends StatelessWidget {
  const NewDialog({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final ChoosePaymentTypeDialog widget;

  @override
  Widget build(BuildContext context) {
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        width: 400.0,
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(height: PsDimens.space16),
            Text(Utils.getString(context, 'pesapal_payment__title'),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: PsColors.mainColor,fontWeight: FontWeight.bold)),
            const SizedBox(height: PsDimens.space28),
            PSButtonWidgetRoundCorner(
              hasShadow: true,
              width: double.infinity,
              titleText:
                  Utils.getString(context, 'item_promote__in_app_purchase'),
              onPressed: () async {
                Navigator.pop(context);
                widget.onInAppPurchaseTap!();
          
              },
            ),
            const SizedBox(height: PsDimens.space16),
            PSButtonWidgetRoundCorner(
              hasShadow: true,
              width: double.infinity,
              titleText:
                  Utils.getString(context, 'item_promote__other'),
              onPressed: () async {
                Navigator.pop(context);
                widget.onOtherPaymentTap!();            
              },
            ),
            const SizedBox(height: PsDimens.space16),
          ],
        ),
      ),
    );
  }
}
