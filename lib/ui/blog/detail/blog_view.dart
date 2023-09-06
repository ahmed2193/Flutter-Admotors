import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutteradmotors/api/common/ps_admob_banner_widget.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/ui/common/ps_back_button_with_circle_bg_widget.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/blog.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BlogView extends StatefulWidget {
  const BlogView({Key? key, required this.blog, required this.heroTagImage})
      : super(key: key);

  final Blog blog;
  final String heroTagImage;

  @override
  _BlogViewState createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  bool isReadyToShowAppBarIcons = false;

  @override
  Widget build(BuildContext context) {
    if (!isReadyToShowAppBarIcons) {
      Timer(const Duration(milliseconds: 800), () {
        setState(() {
          isReadyToShowAppBarIcons = true;
        });
      });
    }

    return Scaffold(
        body: CustomScrollView(
      shrinkWrap: true,
      slivers: <Widget>[
        SliverAppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
          ),
          expandedHeight: PsDimens.space300,
          floating: true,
          pinned: true,
          snap: false,
          elevation: 0,
          leading: PsBackButtonWithCircleBgWidget(
              isReadyToShow: isReadyToShowAppBarIcons),
          backgroundColor: PsColors.mainColor,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              height: PsDimens.space300,
              width: double.infinity,
              child: PsNetworkImage(
                photoKey: widget.heroTagImage,
                // height: PsDimens.space300,
                // width: double.infinity,
                imageAspectRation: PsConst.Aspect_Ratio_full_image,
                defaultPhoto: widget.blog.defaultPhoto!,
                boxfit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: TextWidget(
            blog: widget.blog,
          ),
        )
      ],
    ));
  }
}

class TextWidget extends StatefulWidget {
  const TextWidget({
    Key? key,
    required this.blog,
  }) : super(key: key);

  final Blog blog;

  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
  PsValueHolder? valueHolder;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && valueHolder!.isShowAdmob!) {
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context);
    if (!isConnectedToInternet && valueHolder!.isShowAdmob!) {
      print('loading ads....');
      checkConnection();
    }
    return Container(
      color: PsColors.backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(PsDimens.space12),
              child: Text(
                widget.blog.name!,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(
                    left: PsDimens.space12,
                    right: PsDimens.space12,
                    bottom: PsDimens.space12),
                child: Html(
                  data: widget.blog.description!,
                  // ignore: always_specify_types
                  style: {
                    'table': Style(
                      backgroundColor: PsColors.baseLightColor,
                      //  width: MediaQuery.of(context).size.width,
                    ),
                    'tr': Style(
                      border: const Border(
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                    'th': Style(
                      padding: HtmlPaddings.all(6),
                      backgroundColor: Colors.grey,
                    ),
                    'td': Style(
                      padding: HtmlPaddings.all(6),
                      alignment: Alignment.center,
                      width: Width(12)!,
                    ),
                  },
                  onLinkTap: (url, _, __) async {
                    if (await canLaunchUrl(Uri.parse(url!)))
                      await launchUrl(Uri.parse(url));
                    else // can't launch url, there is some error
                      throw 'Could not launch $url';
                  },
                  // ignore: always_specify_types
                  extensions: [
                    TagWrapExtension(
                        tagsToWrap: {"table"},
                        builder: (child) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: child,
                          );
                        }),
                    TagExtension.inline(
                      tagsToExtend: {"bird"},
                      child: const TextSpan(text: "🐦"),
                    ),
                    TagExtension(
                      tagsToExtend: {"flutter"},
                      builder: (context) => CssBoxWidget(
                        style: context.styledElement!.style,
                        child: FlutterLogo(
                          style: context.attributes['horizontal'] != null
                              ? FlutterLogoStyle.horizontal
                              : FlutterLogoStyle.markOnly,
                          textColor: context.styledElement!.style.color!,
                          size: context.styledElement!.style.fontSize!.value,
                        ),
                      ),
                    ),
                  ],
                
                  // ignore: always_specify_types
                  //   style: {
                  //   '#': Style(
                  //    // maxLines: 3,
                  //     fontWeight: FontWeight.normal,
                  //    // textOverflow: TextOverflow.ellipsis,
                  //   ),
                  // },
                )

                //  Text(
                //   widget.blog.description,
                //   style: Theme.of(context).textTheme.bodyText1.copyWith(height: 1.5),
                // ),
                ),
            const PsAdMobBannerWidget(
              admobSize: AdSize.banner,
            ),
          ],
        ),
      ),
    );
  }
}
