import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_admob_banner_widget.dart';
import 'package:flutteradmotors/api/common/ps_admob_native_widget.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/provider/product/search_product_provider.dart';
import 'package:flutteradmotors/repository/product_repository.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/ui/item/item/product_vertical_list_item.dart';
import 'package:flutteradmotors/ui/item/list_with_filter/bottom_navigation_image_and_text.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutteradmotors/viewobject/holder/product_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/product.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class ProductListWithFilterView extends StatefulWidget {
  const ProductListWithFilterView({
    Key? key,
    this.scrollController,
    required this.productParameterHolder,
    required this.animationController,
    this.changeAppBarTitle,
  }) : super(key: key);

  final ProductParameterHolder productParameterHolder;
  final AnimationController? animationController;
  final ScrollController? scrollController;
  final Function? changeAppBarTitle;

  @override
  _ProductListWithFilterViewState createState() =>
      _ProductListWithFilterViewState();
}

class _ProductListWithFilterViewState extends State<ProductListWithFilterView>
    with TickerProviderStateMixin {
 late SearchProductProvider _searchProductProvider;
  bool isVisible = true;

  @override
  void initState() {
    super.initState();

    _offset = 0;
    widget.scrollController!.addListener(() {
      if (widget.scrollController!.position.pixels ==
          widget.scrollController!.position.maxScrollExtent) {
        final String loginUserId = Utils.checkUserLoginId(valueHolder);
        _searchProductProvider.nextProductListByKey(
            loginUserId, _searchProductProvider.productParameterHolder);
      }
      if (mounted) {
        setState(() {
         // final double offset = widget.scrollController!.offset;
          //_delta += offset - _oldOffset!;
          if (_delta! > _containerMaxHeight)
            _delta = _containerMaxHeight;
          else if (_delta !< 0) {
            _delta = 0;
          }
         // _oldOffset = offset;
          _offset = -_delta!;
        });
      }
      print(' Offset $_offset');
    });
  }

  final double _containerMaxHeight = 60;
  double? _offset, _delta = 0; 
  //_oldOffset = 0;
  ProductRepository? repo1;
  dynamic data;
  PsValueHolder? valueHolder;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

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
    
    repo1 = Provider.of<ProductRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    if (!isConnectedToInternet && valueHolder!.isShowAdmob!) {
      print('loading ads....');
      checkConnection();
    }

    print(
        '............................Build UI Again ............................');
    return
        // EasyLocalizationProvider(
        //     data: data,
        //     child:
        ChangeNotifierProvider<SearchProductProvider>(
            lazy: false,
            create: (BuildContext context) {
              final SearchProductProvider provider = SearchProductProvider(
                  repo: repo1!, psValueHolder: valueHolder, limit: valueHolder!.defaultLoadingLimit!);
              if (valueHolder!.isSubLocation == PsConst.ONE) {
                widget.productParameterHolder.itemLocationTownshipId =
                    valueHolder!.locationTownshipId;
              }
              final String loginUserId = Utils.checkUserLoginId(valueHolder);
              provider.loadProductListByKey(
                  loginUserId, widget.productParameterHolder);
              _searchProductProvider = provider;
              _searchProductProvider.productParameterHolder =
                  widget.productParameterHolder;

              return _searchProductProvider;
            },
            child: Consumer<SearchProductProvider>(builder:
                (BuildContext context, SearchProductProvider provider,
                    Widget? child) {
              // print(provider.productList.data.isEmpty);
              // if (provider.productList.data.isNotEmpty) {
              return Column(
                children: <Widget>[
                  const PsAdMobBannerWidget(admobSize: AdSize.banner,),
                  Expanded(
                    child: Container(
                      color: PsColors.coreBackgroundColor,
                      child: Stack(children: <Widget>[
                        if (provider.productList.data!.isNotEmpty &&
                            provider.productList.data != null)
                          Container(
                              color: PsColors.coreBackgroundColor,
                              margin: const EdgeInsets.only(
                                  left: PsDimens.space4,
                                  right: PsDimens.space4,
                                  top: PsDimens.space4,
                                  bottom: PsDimens.space4),
                              child: RefreshIndicator(
                                child: CustomScrollView(
                                    controller: widget.scrollController,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    slivers: <Widget>[
                                      SliverGrid(
                                        gridDelegate:
                                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                                maxCrossAxisExtent: 280.0,
                                                childAspectRatio: 0.55),
                                        delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                            if (provider.productList.data !=
                                                    null ||
                                                provider.productList.data!
                                                    .isNotEmpty) {
                                              final int count = provider
                                                  .productList.data!.length;
                                              if (provider
                                                  .productList.data![index].id!
                                                  .contains(
                                                      PsConst.ADMOB_FLAG)) {
                                                     return   const PsAdMobNativeWidget();
                                                // return NativeAdmob(
                                                //   adUnitID:
                                                //       Utils.getBannerAdUnitId(),
                                                //   loading: Container(),
                                                //   error: Container(),
                                                //   options:
                                                //       const NativeAdmobOptions(
                                                //     ratingColor: Colors.red,
                                                //   ),
                                                // );
                                              } else {
                                                     if (provider
                                                     .productList.data![index].adType! ==
                                                 PsConst.GOOGLE_AD_TYPE) {
                                               return  Container();
                                             } else {
                                                return ProductVeticalListItem(
                                                  coreTagKey: provider.hashCode
                                                          .toString() +
                                                      provider.productList
                                                          .data![index].id!,
                                                  animationController: widget
                                                      .animationController,
                                                  animation: Tween<double>(
                                                          begin: 0.0, end: 1.0)
                                                      .animate(
                                                    CurvedAnimation(
                                                      parent: widget
                                                          .animationController!,
                                                      curve: Interval(
                                                          (1 / count) * index,
                                                          1.0,
                                                          curve: Curves
                                                              .fastOutSlowIn),
                                                    ),
                                                  ),
                                                  product: provider
                                                      .productList.data![index],
                                                  onTap: () {
                                                    final Product product =
                                                        provider.productList
                                                            .data!.reversed
                                                            .toList()[index];
                                                    final ProductDetailIntentHolder
                                                        holder =
                                                        ProductDetailIntentHolder(
                                                            productId: provider
                                                                .productList
                                                                .data![index]
                                                                .id!,
                                                            heroTagImage: provider
                                                                    .hashCode
                                                                    .toString() +
                                                                product.id! +
                                                                PsConst
                                                                    .HERO_TAG__IMAGE,
                                                            heroTagTitle: provider
                                                                    .hashCode
                                                                    .toString() +
                                                                product.id! +
                                                                PsConst
                                                                    .HERO_TAG__TITLE);
                                                    Navigator.pushNamed(
                                                        context,
                                                        RoutePaths
                                                            .productDetail,
                                                        arguments: holder);
                                                  },
                                                );
                                              }
                                              }
                                            } else {
                                              return null;
                                            }
                                          },
                                          childCount:
                                              provider.productList.data!.length,
                                        ),
                                      ),
                                    ]),
                                onRefresh: () {
                                  final String loginUserId =
                                      Utils.checkUserLoginId(valueHolder);
                                  return provider.resetLatestProductList(
                                      loginUserId,
                                      _searchProductProvider
                                          .productParameterHolder);
                                },
                              ))
                        else if (provider.productList.status !=
                                PsStatus.PROGRESS_LOADING &&
                            provider.productList.status !=
                                PsStatus.BLOCK_LOADING &&
                            provider.productList.status != PsStatus.NOACTION)
                          Align(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/baseline_empty_item_grey_24.png',
                                    height: 100,
                                    width: 150,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(
                                    height: PsDimens.space32,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: PsDimens.space20,
                                        right: PsDimens.space20),
                                    child: Text(
                                      Utils.getString(context,
                                          'procuct_list__no_result_data'),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: PsDimens.space20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: _offset,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: PsDimens.space12,
                                top: PsDimens.space8,
                                right: PsDimens.space12,
                                bottom: PsDimens.space16),
                            child: Container(
                                width: double.infinity,
                                height: _containerMaxHeight,
                                child: BottomNavigationImageAndText(
                                    changeAppBarTitle: widget.changeAppBarTitle!,
                                    searchProductProvider:
                                        _searchProductProvider)),
                          ),
                        ),
                        PSProgressIndicator(provider.productList.status),
                      ]),
                    ),
                  )
                ],
              );
            }));
  }
}

