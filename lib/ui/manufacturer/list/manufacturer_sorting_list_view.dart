import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:flutteradmotors/api/common/ps_admob_banner_widget.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/provider/manufacturer/manufacturer_provider.dart';
import 'package:flutteradmotors/repository/manufacturer_repository.dart';
import 'package:flutteradmotors/ui/common/dialog/filter_dialog.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/ui/common/search_bar_view.dart';
import 'package:flutteradmotors/ui/manufacturer/item/manufacturer_vertical_list_item.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutteradmotors/viewobject/holder/product_parameter_holder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class ManufacturerSortingListView extends StatefulWidget {
  @override
  _ManufacturerSortingListViewState createState() {
    return _ManufacturerSortingListViewState();
  }
}

class _ManufacturerSortingListViewState
    extends State<ManufacturerSortingListView>
    with SingleTickerProviderStateMixin {
  _ManufacturerSortingListViewState() {
    searchBar = SearchBarView(
        inBar: true,
        controller: searchTextController,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        closeOnSubmit: false,
        onCleared: () {
          print('cleared');
        },
        onClosed: () {
          manufacturerProvider!.manufacturerParameterHolder.keyword = '';
          manufacturerProvider!.resetManufacturerList(
              manufacturerProvider!.manufacturerParameterHolder.toMap(), psValueHolder!.loginUserId!);
        });
  }

  final ScrollController _scrollController = ScrollController();

  ManufacturerProvider? manufacturerProvider;

  AnimationController? animationController;
  late SearchBarView searchBar;
  late TextEditingController searchTextController = TextEditingController();

  void onSubmitted(String value) {
    manufacturerProvider!.manufacturerParameterHolder.keyword = value;
     manufacturerProvider!.resetManufacturerList(
              manufacturerProvider!.manufacturerParameterHolder.toMap(), Utils.checkUserLoginId(manufacturerProvider!.psValueHolder!));
  }

  AppBar buildAppBar(BuildContext context) {
    if (manufacturerProvider != null) {
      manufacturerProvider!.manufacturerParameterHolder.keyword = '';
          manufacturerProvider!.resetManufacturerList(
              manufacturerProvider!.manufacturerParameterHolder.toMap(), Utils.checkUserLoginId(manufacturerProvider!.psValueHolder!));
    }
    searchTextController.clear();
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
      ),
      backgroundColor: Utils.isLightMode(context) ? PsColors.mainColor : Colors.black12,
      iconTheme: Theme.of(context).iconTheme.copyWith(
        color: PsColors.white
      ),
          // color: Utils.isLightMode(context)
          //     ? PsColors.primary500
          //     : PsColors.primaryDarkWhite),
      title: Text(Utils.getString(context, 'dashboard__manufacturer_list'),
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold)
              .copyWith(
                color: PsColors.white)
                  // color: Utils.isLightMode(context)
                  //     ? PsColors.primary500
                  //     : PsColors.primaryDarkWhite)
                      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search, color: PsColors.white),
          onPressed: () {
            searchBar.beginSearch(context);
          },
        ),
      ],
      elevation: 0,
    );
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        manufacturerProvider!.nextManufacturerList(
            manufacturerProvider!.manufacturerParameterHolder.toMap(),
            Utils.checkUserLoginId(manufacturerProvider!.psValueHolder));
      }
    });
  }

  ManufacturerRepository? repo1;
  PsValueHolder? psValueHolder;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && psValueHolder!.isShowAdmob!) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    repo1 = Provider.of<ManufacturerRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    if (!isConnectedToInternet && psValueHolder!.isShowAdmob!) {
      print('loading ads....');
      checkConnection();
    }
    Future<bool> _requestPop() {
      animationController!.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    

    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: searchBar.build(context),
        body: ChangeNotifierProvider<ManufacturerProvider?>(
            lazy: false,
            create: (BuildContext context) {
              final ManufacturerProvider provider = ManufacturerProvider(
                  repo: repo1!, psValueHolder: psValueHolder);
              manufacturerProvider = provider;
              manufacturerProvider!.loadManufacturerList(manufacturerProvider!.manufacturerParameterHolder.toMap(),
                Utils.checkUserLoginId(manufacturerProvider!.psValueHolder!));

              return manufacturerProvider;
            },
            child: Consumer<ManufacturerProvider>(builder: (BuildContext context,
                                            ManufacturerProvider provider, Widget? child) {
              return Column(
              children: <Widget>[
                const PsAdMobBannerWidget(admobSize: AdSize.banner,),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const SizedBox(
                        width: PsDimens.space1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: PsDimens.space20, top: PsDimens.space16),
                        child: InkWell(
                          onTap: () {
                          showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return FilterDialog(
                              onAscendingTap: () async {
                          manufacturerProvider!.manufacturerParameterHolder.orderBy =
                              PsConst.FILTERING_MANUFACTURE_NAME;
                          manufacturerProvider!.manufacturerParameterHolder.orderType =
                              PsConst.FILTERING__ASC;
                          manufacturerProvider!.resetManufacturerList(
                              manufacturerProvider!.manufacturerParameterHolder.toMap(),
                              Utils.checkUserLoginId(
                                  manufacturerProvider!.psValueHolder));
                        },
                        onDescendingTap: () {
                          manufacturerProvider!.manufacturerParameterHolder.orderBy =
                              PsConst.FILTERING_MANUFACTURE_NAME;
                          manufacturerProvider!.manufacturerParameterHolder.orderType =
                              PsConst.FILTERING__DESC;
                          manufacturerProvider!.resetManufacturerList(
                              manufacturerProvider!.manufacturerParameterHolder.toMap(),
                              Utils.checkUserLoginId(
                                  manufacturerProvider!.psValueHolder));
                        },
                            );
                          });
                          },
                          child: Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.sort_by_alpha_rounded,
                                //  color: PsColors.white,
                                  size: 12,
                                ),
                                const SizedBox(
                                  width: PsDimens.space4,
                                ),
                                Container(
                                    margin: const EdgeInsets.only(left: 20),
                                  child: Text(Utils.getString(context, 'Sort'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontSize: 16,
                                              // color: widget.searchProductProvider!
                                              //             .productParameterHolder.catId ==
                                              //         ''
                                              //     ? Utils.isLightMode(context)
                                              //         ? PsColors.secondary400
                                              //         : PsColors.primaryDarkWhite
                                              //     : PsColors.textColor1
                                                  )),
                                ),
                              ],
                            ),
                        ),
                      ),
                    ],
                  ),
                Expanded(
                  child: Stack(children: <Widget>[
                    Container(
                        margin: const EdgeInsets.all(PsDimens.space8),
                        child: RefreshIndicator(
                          child: CustomScrollView(
                              controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              physics: const AlwaysScrollableScrollPhysics(),
                              shrinkWrap: false,
                              slivers: <Widget>[
                                SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 300.0,
                                          childAspectRatio: 1),
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      if (provider.manufacturerList.data !=
                                              null ||
                                          provider.manufacturerList.data!
                                              .isNotEmpty) {
                                        final int count = provider
                                            .manufacturerList.data!.length;
                                        return ManufacturerVerticalListItem(
                                          animationController:
                                              animationController,
                                          animation: Tween<double>(
                                                  begin: 0.0, end: 1.0)
                                              .animate(CurvedAnimation(
                                            parent: animationController!,
                                            curve: Interval(
                                                (1 / count) * index, 1.0,
                                                curve: Curves.fastOutSlowIn),
                                          )),
                                          manufacturer: provider
                                              .manufacturerList.data![index],
                                          onTap: () {
                                            if (psValueHolder!.isShowSubcategory!) {
                                              Navigator.pushNamed(
                                                  context, RoutePaths.modelGrid,
                                                  arguments: provider
                                                      .manufacturerList
                                                      .data![index]);
                                            } else {
                                              final ProductParameterHolder
                                                  productParameterHolder =
                                                  ProductParameterHolder()
                                                      .getLatestParameterHolder();
                                              productParameterHolder
                                                      .manufacturerId =
                                                  provider.manufacturerList
                                                      .data![index].id;
                                              Navigator.pushNamed(context,
                                                  RoutePaths.filterProductList,
                                                  arguments:
                                                      ProductListIntentHolder(
                                                    appBarTitle: provider
                                                        .manufacturerList
                                                        .data![index]
                                                        .name!,
                                                    productParameterHolder:
                                                        productParameterHolder,
                                                  ));
                                            }
                                          },
                                        );
                                      } else {
                                        return null;
                                      }
                                    },
                                    childCount:
                                        provider.manufacturerList.data!.length,
                                  ),
                                ),
                              ]),
                          onRefresh: () {
                            return provider.resetManufacturerList(
                                provider.manufacturerParameterHolder.toMap(),
                                Utils.checkUserLoginId(
                                    manufacturerProvider!.psValueHolder));
                          },
                        )),
                    PSProgressIndicator(provider.manufacturerList.status)
                  ]),
                )
              ],
            );
            }),
          ),
      ),
    );
  }
}
