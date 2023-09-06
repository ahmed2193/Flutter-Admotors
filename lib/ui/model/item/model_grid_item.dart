import 'package:flutter/material.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/viewobject/model.dart';

// ignore: must_be_immutable
class ModelGridItem extends StatelessWidget {
  ModelGridItem(
      {Key? key,
      required this.model,
      this.onTap,
      this.animationController,
      this.animation,
      required this.subScribeNoti,
      required this.tempList
      })
      : super(key: key);

  final Model model;
  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;
  List<String?> tempList;
  bool subScribeNoti;
  @override
  Widget build(BuildContext context) {
    animationController!.forward();
    return AnimatedBuilder(
        animation: animationController!,
        child: InkWell(
            onTap: onTap as void Function()?,
            child: Stack(
              children: <Widget>[
                Card(
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
                                    defaultPhoto: model.defaultPhoto!,
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
                            model.name!,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: PsColors.white,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                        // Container(
                        //     child: Positioned(
                        //   bottom: 10,
                        //   left: 10,
                        //   child: PsNetworkCircleIconImage(
                        //     photoKey: '',
                        //     defaultIcon: model.defaultIcon,
                        //     width: PsDimens.space40,
                        //     height: PsDimens.space40,
                        //     boxfit: BoxFit.cover,
                        //     onTap: onTap,
                        //   ),
                        // )),
                      ],
                    ))),
                Visibility(
                  visible: subScribeNoti,
                  child: Positioned(
                    top: 1,
                    right: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        color: PsColors.mainColorWithBlack,
                        child: Icon(
                          Icons.circle,
                          color: tempList.contains(model.id)
                              ? PsColors.mainColorWithBlack
                              : PsColors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )),
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
