import 'package:flutter/material.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/viewobject/manufacturer.dart';

class ManufacturerVerticalListItem extends StatelessWidget {
  const ManufacturerVerticalListItem(
      {Key? key,
      required this.manufacturer,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final Manufacturer manufacturer;

  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    animationController!.forward();
    return AnimatedBuilder(
        animation: animationController!,
        child: GestureDetector(
            onTap: onTap as void Function()?,
            child: Card(
                elevation: 0.3,
                child: Container(
                    child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: PsDimens.space200,
                              height: double.infinity,
                              child: PsNetworkImage(
                                photoKey: '',
                                defaultPhoto: manufacturer.defaultPhoto!,
                                // width: PsDimens.space200,
                                // height: double.infinity,
                                boxfit: BoxFit.cover,
                                imageAspectRation: PsConst.Aspect_Ratio_2x,
                              ),
                            ),
                            Container(
                              width: 200,
                              height: double.infinity,
                              color: PsColors.black!.withAlpha(110),
                            )
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                      child: Text(
                        manufacturer.name!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: PsColors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        child: Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        width: PsDimens.space40,
                        height: PsDimens.space40,
                        child: PsNetworkCircleIconImage(
                          photoKey: '',
                          defaultIcon: manufacturer.defaultIcon!,
                          // width: PsDimens.space40,
                          // height: PsDimens.space40,
                          boxfit: BoxFit.cover,
                          onTap: onTap,
                        ),
                      ),
                    )),
                  ],
                )))),
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: animation!,
            child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 100 * (1.0 - animation!.value), 0.0),
                child: child),
          );
        });
  }
}
