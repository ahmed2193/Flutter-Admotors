import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/provider/about_us/about_us_provider.dart';
import 'package:flutteradmotors/repository/about_us_repository.dart';
import 'package:flutteradmotors/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingFAQView extends StatefulWidget {
  const SettingFAQView();
  @override
  _SettingFAQViewState createState() {
    return _SettingFAQViewState();
  }
}

class _SettingFAQViewState extends State<SettingFAQView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  late AboutUsRepository repo1;
  late PsValueHolder valueHolder;
  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<AboutUsRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    return PsWidgetWithAppBar<AboutUsProvider>(
        appBarTitle: Utils.getString(context, 'setting__faq'),
        initProvider: () {
          return AboutUsProvider(
            repo: repo1,
            psValueHolder: valueHolder,
          );
        },
        onProviderReady: (AboutUsProvider provider) {
          provider.loadAboutUsList();
          // _aboutUsProvider = provider;
        },
        builder:
            (BuildContext context, AboutUsProvider provider, Widget? child) {
          if (provider.aboutUsList.data != null &&
              provider.aboutUsList.data!.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(PsDimens.space10),
              child: SingleChildScrollView(
                child: Html(
                  data: provider.aboutUsList.data![0].faqPages!,
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
                      width: Width(120),
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
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
