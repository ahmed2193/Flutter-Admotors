import 'package:flutter/material.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';

class ItemSoldOutListItem extends StatelessWidget {
  const ItemSoldOutListItem(
      {Key? key,
      required this.isSoldOutName,
      required this.selectedName,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final String isSoldOutName;
  final String selectedName;
  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    animationController!.forward();
    return AnimatedBuilder(
      animation: animationController!,
      child: InkWell(
        onTap: onTap  as void Function()?,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: PsDimens.space52,
          margin: const EdgeInsets.only(bottom: PsDimens.space4),
          child: Ink(
            color: selectedName == isSoldOutName
                ? Colors.green[200]
                : PsColors.backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(PsDimens.space16),
              child: Text(
                isSoldOutName,
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
      builder: (BuildContext contenxt, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: child,
        );
      },
    );
  }
}
