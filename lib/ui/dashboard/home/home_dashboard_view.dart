import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutteradmotors/api/common/ps_admob_banner_widget.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/provider/blog/blog_provider.dart';
import 'package:flutteradmotors/provider/chat/user_unread_message_provider.dart';
import 'package:flutteradmotors/provider/home_bunner/bunner_provider.dart';
import 'package:flutteradmotors/provider/item_location/item_location_provider.dart';
import 'package:flutteradmotors/provider/manufacturer/manufacturer_provider.dart';
import 'package:flutteradmotors/provider/product/discount_product_provider.dart';
import 'package:flutteradmotors/provider/product/item_list_from_followers_provider.dart';
import 'package:flutteradmotors/provider/product/nearest_product_provider.dart';
import 'package:flutteradmotors/provider/product/paid_ad_product_provider%20copy.dart';
import 'package:flutteradmotors/provider/product/popular_product_provider.dart';
import 'package:flutteradmotors/provider/product/recent_product_provider.dart';
import 'package:flutteradmotors/repository/blog_repository.dart';
import 'package:flutteradmotors/repository/bunner_repository.dart';
import 'package:flutteradmotors/repository/item_location_repository.dart';
import 'package:flutteradmotors/repository/manufacturer_repository.dart';
import 'package:flutteradmotors/repository/paid_ad_item_repository.dart';
import 'package:flutteradmotors/repository/product_repository.dart';
import 'package:flutteradmotors/repository/user_unread_message_repository.dart';
import 'package:flutteradmotors/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutteradmotors/ui/common/dialog/error_dialog.dart';
import 'package:flutteradmotors/ui/common/dialog/rating_dialog/core.dart';
import 'package:flutteradmotors/ui/common/dialog/rating_dialog/style.dart';
import 'package:flutteradmotors/ui/common/ps_frame_loading_widget.dart';
import 'package:flutteradmotors/ui/common/ps_textfield_widget_with_icon.dart';
import 'package:flutteradmotors/ui/dashboard/home/blog_product_slider.dart';
import 'package:flutteradmotors/ui/dashboard/home/home_bunner_slider.dart';
import 'package:flutteradmotors/ui/item/item/product_horizontal_list_item.dart';
import 'package:flutteradmotors/ui/manufacturer/item/manufacturer_horizontal_grid_item.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/blog.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/item_entry_intent_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutteradmotors/viewobject/holder/product_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/holder/user_unread_message_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/product.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shimmer/shimmer.dart';

class HomeDashboardViewWidget extends StatefulWidget {
  const HomeDashboardViewWidget(
    this.scrollController,
    this.animationController,
    this.animationControllerForFab,
    this.context,
    // this.onNotiClicked,
    // this.onChatNotiClicked
  );

  final ScrollController scrollController;
  final AnimationController animationController;
  final AnimationController animationControllerForFab;

  final BuildContext context;
  // final Function onNotiClicked;
  // final Function onChatNotiClicked;

  @override
  _HomeDashboardViewWidgetState createState() =>
      _HomeDashboardViewWidgetState();
}

class _HomeDashboardViewWidgetState extends State<HomeDashboardViewWidget> {
  PsValueHolder? valueHolder;
  ManufacturerRepository? repo1;
 late ProductRepository repo2;
 late BlogRepository repo3;
  BunnerRepository? bunnerRepo;
  ItemLocationRepository? repo4;

  ManufacturerProvider? _manufacturerProvider;
  BlogProvider? _blogProvider;
  ItemLocationProvider? _itemLocationProvider;
  RecentProductProvider? _recentProductProvider;
  DiscountProductProvider? _discountProductProvider;
  NearestProductProvider? _nearestProductProvider;
  PopularProductProvider? _popularProductProvider;
  PaidAdProductProvider? _paidAdItemProvider;
  UserUnreadMessageProvider? _userUnreadMessageProvider;
  UserUnreadMessageRepository? userUnreadMessageRepository;
  PaidAdItemRepository? paidAdItemRepository;
  ItemListFromFollowersProvider? _itemListFromFollowersProvider;

  final int count = 8;
  // final ManufacturerParameterHolder trendingCategory = ManufacturerParameterHolder();
  // final ManufacturerParameterHolder categoryIconList = ManufacturerParameterHolder();
  // final FirebaseMessaging _fcm = FirebaseMessaging();
  final TextEditingController userInputItemNameTextEditingController =
      TextEditingController();
  final TextEditingController useraddressTextEditingController =
      TextEditingController();
  Position? _currentPosition;
  bool androidFusedLocation = true;    

  @override
  void dispose() {
    super.dispose();
  }

  final RateMyApp _rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 0,
    minLaunches: 1,
    remindDays: 5,
    remindLaunches: 1,
  );

  @override
  void initState() {
    super.initState();


    if (Platform.isAndroid) {
      _rateMyApp.init().then((_) {
        if (_rateMyApp.shouldOpenDialog) {
          _rateMyApp.showStarRateDialog(
            context,
            title: Utils.getString(context, 'home__menu_drawer_rate_this_app'),
            message: Utils.getString(context, 'rating_popup_dialog_message'),
            ignoreNativeDialog: true,
            actionsBuilder: (BuildContext context, double? stars) {
              return <Widget>[
                TextButton(
                  child: Text(
                    Utils.getString(context, 'dialog__ok'),
                  ),
                  onPressed: () async {
                    if (stars != null) {
                      // _rateMyApp.save().then((void v) => Navigator.pop(context));
                      Navigator.pop(context);
                      if (stars < 1) {
                      } else if (stars >= 1 && stars <= 3) {
                        await _rateMyApp
                            .callEvent(RateMyAppEventType.laterButtonPressed);
                        await showDialog<dynamic>(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmDialogView(
                                description: Utils.getString(
                                    context, 'rating_confirm_message'),
                                leftButtonText:
                                    Utils.getString(context, 'dialog__cancel'),
                                rightButtonText: Utils.getString(
                                    context, 'home__menu_drawer_contact_us'),
                                onAgreeTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                    context,
                                    RoutePaths.contactUs,
                                  );
                                },
                              );
                            });
                      } else if (stars >= 4) {
                        await _rateMyApp
                            .callEvent(RateMyAppEventType.rateButtonPressed);
                        if (Platform.isIOS) {
                          Utils.launchAppStoreURL(
                              iOSAppId: valueHolder!.iosAppStoreId,
                              writeReview: true);
                        } else {
                          Utils.launchURL();
                        }
                      }
                    } else {
                      Navigator.pop(context);
                    }
                  },
                )
              ];
            },
            onDismissed: () =>
                _rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
            dialogStyle: const DialogStyle(
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 16.0),
            ),
            starRatingOptions: const StarRatingOptions(),
          );
        }
      });
    }

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        //if (widget.animationControllerForFab != null) {
          widget.animationControllerForFab.reverse();
       // }
      }
      if (widget.scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
       // if (widget.animationControllerForFab != null) {
          widget.animationControllerForFab.forward();
       // }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<ManufacturerRepository>(context);
    repo2 = Provider.of<ProductRepository>(context);
    repo3 = Provider.of<BlogRepository>(context);
    bunnerRepo = Provider.of<BunnerRepository>(context);
    repo4 = Provider.of<ItemLocationRepository>(context);
    paidAdItemRepository = Provider.of<PaidAdItemRepository>(context);
    userUnreadMessageRepository =
        Provider.of<UserUnreadMessageRepository>(context);

    valueHolder = Provider.of<PsValueHolder>(context, listen: false);

    return MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<NearestProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _nearestProductProvider = NearestProductProvider(
                    repo: repo2, limit: valueHolder!.recentItemLoadingLimit!);
                    final String? loginUserId = Utils.checkUserLoginId(valueHolder!);
              Geolocator.checkPermission().then((LocationPermission permission) {
                if (permission == LocationPermission.denied) {
                  Geolocator.requestPermission().then((LocationPermission permission) {
                      if (permission == LocationPermission.denied) {
                        //permission denied, do nothing
                      } else {
                      Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.medium,
                        forceAndroidLocationManager: !androidFusedLocation)
                    .then((Position position) {
                  if (mounted) {
                    setState(() {
                      _currentPosition = position;
                    });
                    _nearestProductProvider?.productNearestParameterHolder.lat =
                        _currentPosition?.latitude.toString();
                    _nearestProductProvider?.productNearestParameterHolder.lng =
                        _currentPosition?.longitude.toString();
                    _nearestProductProvider
                        ?.productNearestParameterHolder.mile = valueHolder!.mile;
                    _nearestProductProvider?.resetProductList(loginUserId!,
                      _nearestProductProvider!.productNearestParameterHolder,
                    );
                  }
                }).catchError((Object e) {
                  //
                });
                      }
                  });
                } else {
                  Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.medium,
                        forceAndroidLocationManager: !androidFusedLocation)
                    .then((Position position) {
                  if (mounted) {
                    setState(() {
                      _currentPosition = position;
                    });
                    _nearestProductProvider?.productNearestParameterHolder.lat =
                        _currentPosition?.latitude.toString();
                    _nearestProductProvider?.productNearestParameterHolder.lng =
                        _currentPosition?.longitude.toString();
                    _nearestProductProvider
                        ?.productNearestParameterHolder.mile = valueHolder!.mile;
                    _nearestProductProvider?.resetProductList(loginUserId!,
                      _nearestProductProvider!.productNearestParameterHolder,
                    );
                  }
                }).catchError((Object e) {
                  //
                });
                }
              });
                return _nearestProductProvider!;
              }),
          ChangeNotifierProvider<BunnerProvider>(
              lazy: false,
              create: (BuildContext context) {
                final BunnerProvider provider = BunnerProvider(
                    repo: bunnerRepo!,
                    limit: PsConfig.BUNNER_SLIDER_LOADING_LIMIT);
                provider.loadBunnerList();
                return provider;
              }),
          ChangeNotifierProvider<ManufacturerProvider>(
              lazy: false,
              create: (BuildContext context) {
                _manufacturerProvider ??= ManufacturerProvider(
                    repo: repo1!,
                    psValueHolder: valueHolder,
                    limit: valueHolder!.categoryLoadingLimit!);

                _manufacturerProvider!
                    .loadManufacturerList(
                        _manufacturerProvider!.manufacturerParameterHolder.toMap(),
                        Utils.checkUserLoginId(
                            _manufacturerProvider!.psValueHolder!))
                    .then((dynamic value) {
                  // Utils.psPrint("Is Has Internet " + value);
                  final bool isConnectedToIntenet = value ?? bool;
                  if (!isConnectedToIntenet) {
                    Fluttertoast.showToast(
                        msg: 'No Internet Connectiion. Please try again !',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white);
                  }
                });
                return _manufacturerProvider!;
              }),
          ChangeNotifierProvider<RecentProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _recentProductProvider = RecentProductProvider(
                    repo: repo2, limit: valueHolder!.recentItemLoadingLimit!);
                _recentProductProvider!.productRecentParameterHolder
                    .itemLocationId = valueHolder!.locationId!;
                _recentProductProvider!.productRecentParameterHolder
                    .itemLocationName = valueHolder!.locactionName!;
                _recentProductProvider!.productRecentParameterHolder
                    .mile = valueHolder!.mile;    
                if (valueHolder!.isSubLocation == PsConst.ONE) {
                  _recentProductProvider!.productRecentParameterHolder
                      .itemLocationTownshipId = valueHolder!.locationTownshipId;
                  _recentProductProvider!.productRecentParameterHolder
                          .itemLocationTownshipName =
                      valueHolder!.locationTownshipName;
                }
                final String loginUserId = Utils.checkUserLoginId(valueHolder!);

                _recentProductProvider!.loadProductList(loginUserId,
                    _recentProductProvider!.productRecentParameterHolder);
                return _recentProductProvider!;
              }),
          ChangeNotifierProvider<DiscountProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _discountProductProvider = DiscountProductProvider(
                    repo: repo2, limit: valueHolder!.populartItemLoadingLimit!);
                _discountProductProvider!.productDiscountParameterHolder
                    .itemLocationId = valueHolder!.locationId!;
                _discountProductProvider!.productDiscountParameterHolder
                    .itemLocationName = valueHolder!.locactionName!;
                _discountProductProvider!.productDiscountParameterHolder.mile = valueHolder!.mile;    
                if (valueHolder!.isSubLocation == PsConst.ONE) {
                  _recentProductProvider!.productRecentParameterHolder
                      .itemLocationTownshipId = valueHolder!.locationTownshipId;
                  _discountProductProvider!.productDiscountParameterHolder
                          .itemLocationTownshipName =
                      valueHolder!.locationTownshipName;
                }
                final String loginUserId = Utils.checkUserLoginId(valueHolder!);
                _discountProductProvider!.loadProductList(loginUserId,
                    _discountProductProvider!.productDiscountParameterHolder);
                return _discountProductProvider!;
              }),    
          ChangeNotifierProvider<PopularProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _popularProductProvider = PopularProductProvider(
                    repo: repo2, limit: valueHolder!.populartItemLoadingLimit!);
                _popularProductProvider!.productPopularParameterHolder
                    .itemLocationId = valueHolder!.locationId!;
                _popularProductProvider!.productPopularParameterHolder
                    .itemLocationName = valueHolder!.locactionName!;
                _popularProductProvider!.productPopularParameterHolder
                    .mile = valueHolder!.mile!;    
                if (valueHolder!.isSubLocation == PsConst.ONE) {
                  _recentProductProvider!.productRecentParameterHolder
                      .itemLocationTownshipId = valueHolder!.locationTownshipId;
                  _popularProductProvider!.productPopularParameterHolder
                          .itemLocationTownshipName =
                      valueHolder!.locationTownshipName;
                }
                final String loginUserId = Utils.checkUserLoginId(valueHolder!);
                _popularProductProvider!.loadProductList(loginUserId,
                    _popularProductProvider!.productPopularParameterHolder);
                return _popularProductProvider!;
              }),
          ChangeNotifierProvider<PaidAdProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _paidAdItemProvider = PaidAdProductProvider(
                    repo: repo2, limit: valueHolder!.featuredItemLoadingLimit!);
                    _paidAdItemProvider!.productPaidAdParameterHolder
                    .itemLocationId = valueHolder!.locationId!;
                _paidAdItemProvider!.productPaidAdParameterHolder
                    .itemLocationName = valueHolder!.locactionName!;
                _paidAdItemProvider!.productPaidAdParameterHolder
                    .mile = valueHolder!.mile;    
                if (valueHolder!.isSubLocation == PsConst.ONE) {
                  _recentProductProvider!.productRecentParameterHolder
                      .itemLocationTownshipId = valueHolder!.locationTownshipId;
                  _paidAdItemProvider!.productPaidAdParameterHolder
                          .itemLocationTownshipName =
                      valueHolder!.locationTownshipName;
                }
                final String loginUserId = Utils.checkUserLoginId(valueHolder!);

                _paidAdItemProvider!.loadProductList(loginUserId,
                    _paidAdItemProvider!.productPaidAdParameterHolder);
                return _paidAdItemProvider!;
              }),
          ChangeNotifierProvider<BlogProvider>(
              lazy: false,
              create: (BuildContext context) {
                _blogProvider = BlogProvider(
                    repo: repo3, limit: valueHolder!.blockSliderLoadingLimit!);
                _blogProvider!.blogParameterHolder.cityId =
                    valueHolder!.locationId!;
                final String loginUserId = Utils.checkUserLoginId(valueHolder!);
                _blogProvider!.loadBlogList(
                    loginUserId, _blogProvider!.blogParameterHolder);
                return _blogProvider!;
              }),
          ChangeNotifierProvider<UserUnreadMessageProvider>(
              lazy: false,
              create: (BuildContext context) {
                _userUnreadMessageProvider = UserUnreadMessageProvider(
                    repo: userUnreadMessageRepository!);

                if (valueHolder!.loginUserId != null &&
                    valueHolder!.loginUserId != '') {
                  final UserUnreadMessageParameterHolder
                      userUnreadMessageHolder =
                      UserUnreadMessageParameterHolder(
                          userId: valueHolder!.loginUserId!,
                          deviceToken: valueHolder!.deviceToken ?? '');
                  _userUnreadMessageProvider!
                      .userUnreadMessageCount(userUnreadMessageHolder);
                }
                return _userUnreadMessageProvider!;
              }),
          ChangeNotifierProvider<ItemLocationProvider>(
              lazy: false,
              create: (BuildContext context) {
                _itemLocationProvider = ItemLocationProvider(
                    repo: repo4!, psValueHolder: valueHolder);
                _itemLocationProvider!.loadItemLocationList(
                    _itemLocationProvider!.defaultLocationParameterHolder
                        .toMap(),
                    Utils.checkUserLoginId(
                        _itemLocationProvider!.psValueHolder!));
                return _itemLocationProvider!;
              }),
          // ChangeNotifierProvider<ItemListFromFollowersProvider>(
          //     lazy: false,
          //     create: (BuildContext context) {
          //       final ItemListFromFollowersProvider provider =
          //           ItemListFromFollowersProvider(
          //               repo: repo2,
          //               psValueHolder: valueHolder,
          //               limit: valueHolder!.followerItemLoadingLimit!);
          //       provider.loadItemListFromFollowersList(
          //           Utils.checkUserLoginId(provider.psValueHolder!));
          //       return provider;
          //     }),
                    ChangeNotifierProvider<ItemListFromFollowersProvider?>(
              lazy: false,
              create: (BuildContext context) {
                _itemListFromFollowersProvider = ItemListFromFollowersProvider(
                    repo: repo2,
                    psValueHolder: valueHolder,
                    limit: valueHolder!.followerItemLoadingLimit!);
                
                _itemListFromFollowersProvider!.followUserItemParameterHolder
                      .itemLocationId = valueHolder!.locationId;
                if (valueHolder!.isSubLocation == PsConst.ONE) {
                  _itemListFromFollowersProvider!.followUserItemParameterHolder
                      .itemLocationTownshipId = valueHolder!.locationTownshipId;
                }     

                _itemListFromFollowersProvider!.loadItemListFromFollowersList(
                  _itemListFromFollowersProvider!.followUserItemParameterHolder.toMap(),
                    Utils.checkUserLoginId(
                        _itemListFromFollowersProvider!.psValueHolder!));
                return _itemListFromFollowersProvider;
              }),
        ],
        child: Scaffold(
            primary: false,
            floatingActionButton: FadeTransition(
              opacity: widget.animationControllerForFab,
              child: ScaleTransition(
                scale: widget.animationControllerForFab,
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    print(
                        'Brightness: ${Utils.getBrightnessForAppBar(context)}');
                    if (await Utils.checkInternetConnectivity()) {
                      Utils.navigateOnUserVerificationView(
                          _manufacturerProvider, context, () async {
                        final dynamic returnData = await Navigator.pushNamed(
                            context, RoutePaths.itemEntry,
                            arguments: ItemEntryIntentHolder(
                                flag: PsConst.ADD_NEW_ITEM, item: Product()));
                        if (returnData == true) {
                          _recentProductProvider!.resetProductList(
                              valueHolder!.loginUserId!,
                              _recentProductProvider!
                                  .productRecentParameterHolder);
                        }
                      });
                    } else {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialog(
                              message: Utils.getString(
                                  context, 'error_dialog__no_internet'),
                            );
                          });
                    }
                  },
                  icon: Icon(Icons.camera_alt, color: PsColors.white),
                  backgroundColor: Utils.isLightMode(context)
                      ? PsColors.mainColor
                      : Colors.black38,
                  label: Text(Utils.getString(context, 'dashboard__submit_ad'),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: PsColors.white)),
                ),
              ),
            ),

            // floatingActionButton: AnimatedContainer(
            //   duration: const Duration(milliseconds: 300),
            //   child: FloatingActionButton.extended(
            //     onPressed: () async {
            //       if (await Utils.checkInternetConnectivity()) {
            //         Utils.navigateOnUserVerificationView(
            //             _manufacturerProvider, context, () async {
            //           Navigator.pushNamed(context, RoutePaths.itemEntry,
            //               arguments: ItemEntryIntentHolder(
            //                   flag: PsConst.ADD_NEW_ITEM, item: Product()));
            //         });
            //       } else {
            //         showDialog<dynamic>(
            //             context: context,
            //             builder: (BuildContext context) {
            //               return ErrorDialog(
            //                 message: Utils.getString(
            //                     context, 'error_dialog__no_internet'),
            //               );
            //             });
            //       }
            //     },
            //     icon: _isVisible ? const Icon(Icons.camera_alt) : null,
            //     backgroundColor: PsColors.mainColor,
            //     label: _isVisible
            //         ? Text(Utils.getString(context, 'dashboard__submit_ad'),
            //             style: Theme.of(context)
            //                 .textTheme
            //                 .caption
            //                 .copyWith(color: PsColors.white))
            //         : const Text(''),
            //   ),
            //   height: _isVisible ? PsDimens.space52 : 0.0,
            //   width: PsDimens.space200,
            // ),

            // FloatingActionButton(child: Icon(Icons.add), onPressed: () {}),
            body: Container(
              color: PsColors.coreBackgroundColor,
              child: RefreshIndicator(
                onRefresh: () {
                  final String loginUserId =
                      Utils.checkUserLoginId(valueHolder!);

                  _recentProductProvider!.resetProductList(loginUserId,
                      _recentProductProvider!.productRecentParameterHolder);

                  _nearestProductProvider!.resetProductList(loginUserId,
                       _nearestProductProvider!.productNearestParameterHolder);

                  _discountProductProvider!.resetProductList(loginUserId,
                      _discountProductProvider!.productDiscountParameterHolder);     

                  _popularProductProvider!.resetProductList(loginUserId,
                      _popularProductProvider!.productPopularParameterHolder);

                  _paidAdItemProvider!.resetProductList(loginUserId,
                      _paidAdItemProvider!.productPaidAdParameterHolder);

                  if (valueHolder!.loginUserId != null &&
                      valueHolder!.loginUserId != '') {
                    _userUnreadMessageProvider!.userUnreadMessageCount(
                        _userUnreadMessageProvider!.userUnreadMessageHolder);
                  }

                  _blogProvider!.resetBlogList(
                      loginUserId, _blogProvider!.blogParameterHolder);

                  _itemListFromFollowersProvider!
                      .resetItemListFromFollowersList( _itemListFromFollowersProvider!.followUserItemParameterHolder.toMap(),Utils.checkUserLoginId(
                          _itemListFromFollowersProvider!.psValueHolder!));

                  _manufacturerProvider!
                      .resetManufacturerList(
                          _manufacturerProvider!.manufacturerParameterHolder.toMap(),
                          Utils.checkUserLoginId(
                              _manufacturerProvider!.psValueHolder!))
                      .then((dynamic value) {
                    final bool isConnectedToIntenet = value ?? bool;

                    if (!isConnectedToIntenet) {
                      Fluttertoast.showToast(
                          msg: 'No Internet Connectiion. Please try again !',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blueGrey,
                          textColor: Colors.white);
                    }
                  });

                  return _itemLocationProvider!.resetItemLocationList(
                      _itemLocationProvider!.defaultLocationParameterHolder
                          .toMap(),
                      Utils.checkUserLoginId(
                          _itemLocationProvider!.psValueHolder!));
                },
                child: CustomScrollView(
                  scrollDirection: Axis.vertical,
                  controller: widget.scrollController,
                  slivers: <Widget>[
                    // Container(
                    //  //   visible : false,
                    //     child: SliverToBoxAdapter(
                    //         child: HomeLocationWidget(
                    //             androidFusedLocation: true,
                    //             textEditingController:
                    //                 useraddressTextEditingController,
                    //             // newShopProvider : newShopProvider,
                    //             //searchTextController: searchTextController,
                    //             valueHolder: valueHolder)),
                    //   ),
                    // FloatingActionButton(child: Icon(Icons.add), onPressed: () {}),
                    _HomeHeaderWidget(
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 1, 1.0,
                                  curve: Curves.fastOutSlowIn))),
                      psValueHolder: valueHolder!,
                      itemNameTextEditingController:
                          userInputItemNameTextEditingController,
                    ),

                    _HomeCategoryHorizontalListWidget(
                      psValueHolder: valueHolder!,
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 2, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                    _NearestProductHorizontalListWidget(
                      psValueHolder: valueHolder!,
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 3, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                    _RecentProductHorizontalListWidget(
                      psValueHolder: valueHolder!,
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 3, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                    if (Utils.showUI(valueHolder!.discountRate))
                    _DiscountProductHorizontalListWidget(
                      psValueHolder: valueHolder!,
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 4, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                    _HomePopularProductHorizontalListWidget(
                      psValueHolder: valueHolder!,
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 4, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                    _HomePaidAdProductHorizontalListWidget(
                      psValueHolder: valueHolder!,
                      animationController: widget.animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 4, 1.0,
                                  curve: Curves.fastOutSlowIn))),
                    ),
                    _HomeItemListFromFollowersHorizontalListWidget(
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 4, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),
                    _HomeBlogProductSliderListWidget(
                      animationController:
                          widget.animationController, //animationController,
                      animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: widget.animationController,
                              curve: Interval((1 / count) * 5, 1.0,
                                  curve: Curves.fastOutSlowIn))), //animation
                    ),


                  ],
                ),
              ),
            )));
  }
}

class _HomeBunnerSliderListWidget extends StatelessWidget {
  // const _HomeBunnerSliderListWidget({
  //   Key key,
  //   // @required this.animationController,
  //   // @required this.animation,
  // }) : super(key: key);

  // final AnimationController animationController;
  // final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Consumer<BunnerProvider>(builder:
        (BuildContext context, BunnerProvider? bunnerProvider, Widget? child) {
      if (
        //bunnerProvider!.bunnerList != null &&
          bunnerProvider!.bunnerList.data!.isNotEmpty)
        return Container(
          width: double.infinity,
          height: PsDimens.space380,
          child: HomeBunnerSliderView(
            bunnerList: bunnerProvider.bunnerList.data,
            // onTap: (Bunner bunner) {
            //   // Navigator.pushNamed(context, RoutePaths.blogDetail,
            //   //     arguments: blog);
            // },
          ),
        );
      else
        return Container();
    });
  }
}

class _HomePopularProductHorizontalListWidget extends StatelessWidget {
  const _HomePopularProductHorizontalListWidget(
      {Key? key,
      required this.animationController,
      required this.animation,
      required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<PopularProductProvider>(
        builder: (BuildContext context, PopularProductProvider productProvider,
            Widget? child) {
          return AnimatedBuilder(
            animation: animationController,
            child: (productProvider.productList.data != null &&
                    productProvider.productList.data!.isNotEmpty)
                ? Column(
                    children: <Widget>[
                      _MyHeaderWidget(
                        headerName: Utils.getString(
                            context, 'home__drawer_menu_popular_item'),
                        headerDescription: Utils.getString(
                            context, 'dashboard_popular_item_desc'),
                        viewAllClicked: () {
                          Navigator.pushNamed(
                              context, RoutePaths.filterProductList,
                              arguments: ProductListIntentHolder(
                                  appBarTitle: Utils.getString(context,
                                      'home__drawer_menu_popular_item'),
                                  productParameterHolder: productProvider
                                      .productPopularParameterHolder));
                        },
                      ),
                      Container(
                          height: PsDimens.space380,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  productProvider.productList.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (productProvider.productList.status ==
                                    PsStatus.BLOCK_LOADING) {
                                  return Shimmer.fromColors(
                                      baseColor: PsColors.grey!,
                                      highlightColor: PsColors.white!,
                                      child: const Row(children: <Widget>[
                                        PsFrameUIForLoading(),
                                      ]));
                                } else {
                                  final Product product =
                                      productProvider.productList.data![index];
                                           if (productProvider
                                      .productList.data![index].adType! ==
                                  PsConst.GOOGLE_AD_TYPE) {
                                return  Container();
                              } else {
                                  return ProductHorizontalListItem(
                                    coreTagKey:
                                        productProvider.hashCode.toString() +
                                            product.id!,
                                    product:
                                        productProvider.productList.data![index],
                                    onTap: () {
                                      print(productProvider.productList
                                          .data![index].defaultPhoto!.imgPath);
                                      final ProductDetailIntentHolder holder =
                                          ProductDetailIntentHolder(
                                              productId: productProvider
                                                  .productList.data![index].id!,
                                              heroTagImage: productProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id! +
                                                  PsConst.HERO_TAG__IMAGE,
                                              heroTagTitle: productProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id! +
                                                  PsConst.HERO_TAG__TITLE);
                                      Navigator.pushNamed(
                                          context, RoutePaths.productDetail,
                                          arguments: holder);
                                    },
                                  );
                                }
                                }
                              }))
                    ],
                  )
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - animation.value), 0.0),
                    child: child),
              );
            },
          );
        },
      ),
    );
  }
}

class _HomePaidAdProductHorizontalListWidget extends StatelessWidget {
  const _HomePaidAdProductHorizontalListWidget({
    Key? key,
    required this.animationController,
    required this.animation,
    required this.psValueHolder,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<PaidAdProductProvider>(
        builder: (BuildContext context,
            PaidAdProductProvider paidAdItemProvider, Widget? child) {
          return AnimatedBuilder(
            animation: animationController,
            child: (paidAdItemProvider.productList.data != null &&
                    paidAdItemProvider.productList.data!.isNotEmpty)
                ? Column(
                    children: <Widget>[
                      _MyHeaderWidget(
                        headerName: Utils.getString(
                            context, 'home__drawer_menu_feature_item'),
                        headerDescription: Utils.getString(
                            context, 'dashboard_follow_item_desc'),
                        viewAllClicked: () {
                          Navigator.pushNamed(
                              context, RoutePaths.paidAdProductList);
                        },
                      ),
                      Container(
                          height: PsDimens.space340,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  paidAdItemProvider.productList.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (paidAdItemProvider.productList.status ==
                                    PsStatus.BLOCK_LOADING) {
                                  return Shimmer.fromColors(
                                      baseColor: PsColors.grey!,
                                      highlightColor: PsColors.white!,
                                      child: const Row(children: <Widget>[
                                        PsFrameUIForLoading(),
                                      ]));
                                } else {
                                  final Product product = paidAdItemProvider
                                      .productList.data![index];
                                  return ProductHorizontalListItem(
                                    coreTagKey:
                                        paidAdItemProvider.hashCode.toString() +
                                            product.id!,
                                    product: paidAdItemProvider
                                        .productList.data![index],
                                    onTap: () {
                                      print(paidAdItemProvider.productList
                                          .data![index].defaultPhoto!.imgPath);
                                      final ProductDetailIntentHolder holder =
                                          ProductDetailIntentHolder(
                                              productId: paidAdItemProvider
                                                  .productList.data![index].id!,
                                              heroTagImage: paidAdItemProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id !+
                                                  PsConst.HERO_TAG__IMAGE,
                                              heroTagTitle: paidAdItemProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id! +
                                                  PsConst.HERO_TAG__TITLE);
                                      Navigator.pushNamed(
                                          context, RoutePaths.productDetail,
                                          arguments: holder);
                                    },
                                  );
                                }
                              }))
                    ],
                  )
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - animation.value), 0.0),
                    child: child),
              );
            },
          );
        },
      ),
    );
  }
}

class _RecentProductHorizontalListWidget extends StatefulWidget {
  const _RecentProductHorizontalListWidget(
      {Key? key,
      required this.animationController,
      required this.animation,
      required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  __RecentProductHorizontalListWidgetState createState() =>
      __RecentProductHorizontalListWidgetState();
}

class __RecentProductHorizontalListWidgetState
    extends State<_RecentProductHorizontalListWidget> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && widget.psValueHolder.isShowAdmob!) {
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && widget.psValueHolder.isShowAdmob!) {
      print('loading ads....');
      checkConnection();
    }

    return SliverToBoxAdapter(
        // fdfdf
        child: Consumer<RecentProductProvider>(builder: (BuildContext context,
            RecentProductProvider productProvider, Widget? child) {
      return AnimatedBuilder(
          animation: widget.animationController,
          child: (productProvider.productList.data != null &&
                  productProvider.productList.data!.isNotEmpty)
              ? Column(children: <Widget>[
                  _MyHeaderWidget(
                    headerName:
                        Utils.getString(context, 'dashboard_recent_product'),
                    headerDescription:
                        Utils.getString(context, 'dashboard_recent_item_desc'),
                    viewAllClicked: () {
                      Navigator.pushNamed(context, RoutePaths.filterProductList,
                          arguments: ProductListIntentHolder(
                              appBarTitle: Utils.getString(
                                  context, 'dashboard_recent_product'),
                              productParameterHolder: productProvider
                                  .productRecentParameterHolder));
                    },
                  ),
                  Container(
                      height: PsDimens.space340,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: productProvider.productList.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (productProvider.productList.status ==
                                PsStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: PsColors.grey!,
                                  highlightColor: PsColors.white!,
                                  child: const Row(children: <Widget>[
                                    PsFrameUIForLoading(),
                                  ]));
                            } else {
                              final Product product =
                                  productProvider.productList.data![index];
                                       if (productProvider
                                      .productList.data![index].adType! ==
                                  PsConst.GOOGLE_AD_TYPE) {
                                return  Container();
                              } else {
                              return ProductHorizontalListItem(
                                coreTagKey:
                                    productProvider.hashCode.toString() +
                                        product.id!,
                                product:
                                    productProvider.productList.data![index],
                                onTap: () {
                                  print(productProvider.productList.data![index]
                                      .defaultPhoto!.imgPath);

                                  final ProductDetailIntentHolder holder =
                                      ProductDetailIntentHolder(
                                          productId: productProvider
                                              .productList.data![index].id!,
                                          heroTagImage: productProvider.hashCode
                                                  .toString() +
                                              product.id! +
                                              PsConst.HERO_TAG__IMAGE,
                                          heroTagTitle: productProvider.hashCode
                                                  .toString() +
                                              product.id! +
                                              PsConst.HERO_TAG__TITLE);
                                  Navigator.pushNamed(
                                      context, RoutePaths.productDetail,
                                      arguments: holder);
                                },
                              );
                            }
                            }
                          })),
                  const PsAdMobBannerWidget(admobSize: AdSize.banner,),
                ])
              : Container(),
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation.value), 0.0),
                    child: child));
          });
    }));
  }
}

class _DiscountProductHorizontalListWidget extends StatefulWidget {
  const _DiscountProductHorizontalListWidget(
      {Key? key,
      required this.animationController,
      required this.animation,
      required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  __DiscountProductHorizontalListWidgetState createState() =>
      __DiscountProductHorizontalListWidgetState();
}

class __DiscountProductHorizontalListWidgetState
    extends State<_DiscountProductHorizontalListWidget> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && widget.psValueHolder.isShowAdmob!) {
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && widget.psValueHolder.isShowAdmob!) {
      print('loading ads....');
      checkConnection();
    }

    return SliverToBoxAdapter(
        // fdfdf
        child: Consumer<DiscountProductProvider>(builder: (BuildContext context,
            DiscountProductProvider productProvider, Widget? child) {
      return AnimatedBuilder(
          animation: widget.animationController,
          child: (productProvider.productList.data != null &&
                  productProvider.productList.data!.isNotEmpty)
              ? Column(children: <Widget>[
                  _MyHeaderWidget(
                    headerName:
                        Utils.getString(context, 'dashboard__discount_product'),
                    headerDescription:
                        Utils.getString(context, 'dashboard__discount_product_description'),
                    viewAllClicked: () {
                      Navigator.pushNamed(context, RoutePaths.filterProductList,
                          arguments: ProductListIntentHolder(
                              appBarTitle: Utils.getString(
                                  context, 'dashboard__discount_product'),
                              productParameterHolder: productProvider
                                  .productDiscountParameterHolder));
                    },
                  ),
                  Container(
                      height: PsDimens.space340,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: productProvider.productList.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (productProvider.productList.status ==
                                PsStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: PsColors.grey!,
                                  highlightColor: PsColors.white!,
                                  child: const Row(children: <Widget>[
                                    PsFrameUIForLoading(),
                                  ]));
                            } else {
                              final Product product =
                                  productProvider.productList.data![index];
                                       if (productProvider
                                      .productList.data![index].adType! ==
                                  PsConst.GOOGLE_AD_TYPE) {
                                return  Container();
                              } else {
                              return ProductHorizontalListItem(
                                coreTagKey:
                                    productProvider.hashCode.toString() +
                                        product.id!,
                                product:
                                    productProvider.productList.data![index],
                                onTap: () {
                                  print(productProvider.productList.data![index]
                                      .defaultPhoto!.imgPath);

                                  final ProductDetailIntentHolder holder =
                                      ProductDetailIntentHolder(
                                          productId: productProvider
                                              .productList.data![index].id!,
                                          heroTagImage: productProvider.hashCode
                                                  .toString() +
                                              product.id! +
                                              PsConst.HERO_TAG__IMAGE,
                                          heroTagTitle: productProvider.hashCode
                                                  .toString() +
                                              product.id! +
                                              PsConst.HERO_TAG__TITLE);
                                  Navigator.pushNamed(
                                      context, RoutePaths.productDetail,
                                      arguments: holder);
                                },
                              );
                            }
                            }
                          })),
                  const PsAdMobBannerWidget(admobSize: AdSize.banner,),
                ])
              : Container(),
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation.value), 0.0),
                    child: child));
          });
    }));
  }
}

class _NearestProductHorizontalListWidget extends StatefulWidget {
  const _NearestProductHorizontalListWidget(
      {Key? key,
      required this.animationController,
      required this.animation,
      required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  __NearestProductHorizontalListWidgetState createState() =>
      __NearestProductHorizontalListWidgetState();
}

class __NearestProductHorizontalListWidgetState
    extends State<_NearestProductHorizontalListWidget> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && widget.psValueHolder.isShowAdmob!) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && widget.psValueHolder.isShowAdmob!) {
      print('loading ads....');
      // checkConnection();
    }

    return SliverToBoxAdapter(
        // fdfdf
        child: Consumer<NearestProductProvider>(builder: (BuildContext context,
            NearestProductProvider productProvider, Widget? child) {
      return RefreshIndicator(
        child: AnimatedBuilder(
            animation: widget.animationController,
            child: ((productProvider.productList.data != null &&
                    productProvider.productList.data!.isNotEmpty) && 
                    (productProvider.productNearestParameterHolder.lat != '' && productProvider.productNearestParameterHolder.lng != ''))
                ? Column(children: <Widget>[
                    _MyHeaderWidget(
                      headerName:
                          Utils.getString(context, 'dashboard_nearest_product'),
                      headerDescription:
                          Utils.getString(context, 'dashboard_nearest_item_desc'),
                      viewAllClicked: () {
                         final ProductParameterHolder holder =
                          ProductParameterHolder().getNearestParameterHolder();
                          holder.mile = widget.psValueHolder.mile;
                          holder.lat = productProvider.productNearestParameterHolder.lat;
                          holder.lng = productProvider.productNearestParameterHolder.lng;
                        Navigator.pushNamed(context, RoutePaths.nearestProductList,
                            arguments: ProductListIntentHolder(
                                appBarTitle: Utils.getString(
                                    context, 'dashboard_nearest_product'),
                                productParameterHolder: holder));
                      },
                    ),
                    Container(
                        height: PsDimens.space340,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: productProvider.productList.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (productProvider.productList.status ==
                                  PsStatus.BLOCK_LOADING) {
                                return Shimmer.fromColors(
                                    baseColor: PsColors.grey!,
                                    highlightColor: PsColors.white!,
                                    child: const Row(children: <Widget>[
                                      PsFrameUIForLoading(),
                                    ]));
                              } else {
                                final Product product =
                                    productProvider.productList.data![index];
                                         if (productProvider
                                      .productList.data![index].adType! ==
                                  PsConst.GOOGLE_AD_TYPE) {
                                return  Container();
                              } else {
                                return ProductHorizontalListItem(
                                  coreTagKey:
                                      productProvider.hashCode.toString() +
                                          product.id!,
                                  product:
                                      productProvider.productList.data![index],
                                  onTap: () {
                                    print(productProvider.productList.data![index]
                                        .defaultPhoto!.imgPath);

                                    final ProductDetailIntentHolder holder =
                                        ProductDetailIntentHolder(
                                            productId: productProvider
                                                .productList.data![index].id!,
                                            heroTagImage: productProvider.hashCode
                                                    .toString() +
                                                product.id! +
                                                PsConst.HERO_TAG__IMAGE,
                                            heroTagTitle: productProvider.hashCode
                                                    .toString() +
                                                product.id! +
                                                PsConst.HERO_TAG__TITLE);
                                    Navigator.pushNamed(
                                        context, RoutePaths.productDetail,
                                        arguments: holder);
                                  },
                                );
                              }
                              }
                            })),
                    const PsAdMobBannerWidget(
                    admobSize: AdSize.banner,
                      // admobBannerSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                    ),
                  ])
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - widget.animation.value), 0.0),
                      child: child));
            }
            ),
              onRefresh: () {
                            return productProvider.resetProductList(widget.psValueHolder.loginUserId!,productProvider.productNearestParameterHolder);
                          },
      );
    }));
  }
}

class _HomeBlogProductSliderListWidget extends StatelessWidget {
  const _HomeBlogProductSliderListWidget({
    Key? key,
    required this.animationController,
    required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    const int count = 6;
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval((1 / count) * 1, 1.0,
                curve: Curves.fastOutSlowIn)));

    return SliverToBoxAdapter(
      child: Consumer<BlogProvider>(builder:
          (BuildContext context, BlogProvider blogProvider, Widget? child) {
        return AnimatedBuilder(
            animation: animationController,
            child: (
              //blogProvider.blogList != null &&
                    blogProvider.blogList.data!.isNotEmpty)
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _MyHeaderWidget(
                        headerName:
                            Utils.getString(context, 'home__menu_drawer_blog'),
                        headerDescription: Utils.getString(context, ''),
                        viewAllClicked: () {
                          Navigator.pushNamed(
                            context,
                            RoutePaths.blogList,
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: PsColors.mainLightShadowColor!,
                                offset: const Offset(1.1, 1.1),
                                blurRadius: 20.0),
                          ],
                        ),
                        margin: const EdgeInsets.only(
                            top: PsDimens.space8, bottom: PsDimens.space20),
                        width: double.infinity,
                        child: BlogSliderView(
                          blogList: blogProvider.blogList.data,
                          onTap: (Blog blog) {
                            Navigator.pushNamed(context, RoutePaths.blogDetail,
                                arguments: blog);
                          },
                        ),
                      )
                    ],
                  )
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                  opacity: animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - animation.value), 0.0),
                      child: child));
            });
      }),
    );
  }
}

class _HomeCategoryHorizontalListWidget extends StatefulWidget {
  const _HomeCategoryHorizontalListWidget(
      {Key? key,
      required this.animationController,
      required this.animation,
      required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  __HomeCategoryHorizontalListWidgetState createState() =>
      __HomeCategoryHorizontalListWidgetState();
}

class __HomeCategoryHorizontalListWidgetState
    extends State<_HomeCategoryHorizontalListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Consumer<ManufacturerProvider>(
      builder: (BuildContext context, ManufacturerProvider manufacturerProvider,
          Widget? child) {
        return AnimatedBuilder(
            animation: widget.animationController,
            child: (manufacturerProvider.manufacturerList.data != null &&
                    manufacturerProvider.manufacturerList.data!.isNotEmpty)
                ? Column(children: <Widget>[
                    _MyHeaderWidget(
                      headerName:
                          Utils.getString(context, 'dashboard__manufacturer'),
                      headerDescription:
                          Utils.getString(context, 'dashboard__category_desc'),
                      viewAllClicked: () {
                        Navigator.pushNamed(
                            context, RoutePaths.manufacturerList,
                            arguments: 'Manufacturers');
                      },
                    ),
                    CustomScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        slivers: <Widget>[
                          SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                if (manufacturerProvider
                                        .manufacturerList.status ==
                                    PsStatus.BLOCK_LOADING) {
                                  return Shimmer.fromColors(
                                      baseColor: PsColors.grey!,
                                      highlightColor: PsColors.white!,
                                      child: const Row(children: <Widget>[
                                        PsFrameUIForLoading(),
                                      ]));
                                } else {
                                  return ManufacturerHorizontalGridItem(
                                      manufacturer: manufacturerProvider
                                          .manufacturerList.data![index],
                                      onTap: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        print(manufacturerProvider
                                            .manufacturerList
                                            .data![index]
                                            .defaultPhoto!
                                            .imgPath);
                                        final ProductParameterHolder
                                            productParameterHolder =
                                            ProductParameterHolder()
                                                .getLatestParameterHolder();
                                        productParameterHolder.manufacturerId =
                                            manufacturerProvider
                                                .manufacturerList
                                                .data![index]
                                                .id;

                                        if (widget.psValueHolder.isShowSubcategory!) {
                                          Navigator.pushNamed(
                                              context, RoutePaths.modelGrid,
                                              arguments: manufacturerProvider
                                                  .manufacturerList
                                                  .data![index]);
                                          productParameterHolder
                                                  .itemLocationId =
                                              widget.psValueHolder.locationId!;
                                          productParameterHolder
                                                  .itemLocationName =
                                              widget
                                                  .psValueHolder.locactionName!;
                                          if (widget.psValueHolder
                                                  .isSubLocation ==
                                              PsConst.ONE) {
                                            productParameterHolder
                                                    .itemLocationTownshipId =
                                                widget.psValueHolder
                                                    .locationTownshipId;
                                            productParameterHolder
                                                    .itemLocationTownshipName =
                                                widget.psValueHolder
                                                    .locationTownshipName;
                                          }
                                        } else {
                                          final ProductParameterHolder
                                              productParameterHolder =
                                              ProductParameterHolder()
                                                  .getLatestParameterHolder();
                                          productParameterHolder
                                                  .manufacturerId =
                                              manufacturerProvider
                                                  .manufacturerList
                                                  .data![index]
                                                  .id;
                                          Navigator.pushNamed(context,
                                              RoutePaths.filterProductList,
                                              arguments:
                                                  ProductListIntentHolder(
                                                appBarTitle:
                                                    manufacturerProvider
                                                        .manufacturerList
                                                        .data![index]
                                                        .name!,
                                                productParameterHolder:
                                                    productParameterHolder,
                                              ));
                                        }
                                      } // )
                                      );
                                }
                              },
                              childCount: manufacturerProvider
                                  .manufacturerList.data!.length,
                            ),
                          ),
                        ]),
                  ])
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - widget.animation.value), 0.0),
                      child: child));
            });
      },
    ));
  }
}

class _HomeItemListFromFollowersHorizontalListWidget extends StatelessWidget {
  const _HomeItemListFromFollowersHorizontalListWidget({
    Key? key,
    required this.animationController,
    required this.animation,
  }) : super(key: key);

  final AnimationController? animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<ItemListFromFollowersProvider>(
        builder: (BuildContext context,
            ItemListFromFollowersProvider itemListFromFollowersProvider,
            Widget? child) {
          return AnimatedBuilder(
            animation: animationController!,
            child: (itemListFromFollowersProvider.psValueHolder!.loginUserId !=
                        '' &&
                    itemListFromFollowersProvider
                            .itemListFromFollowersList.data !=
                        null &&
                    itemListFromFollowersProvider
                        .itemListFromFollowersList.data!.isNotEmpty)
                ? Column(
                    children: <Widget>[
                      _MyHeaderWidget(
                        headerName: Utils.getString(
                            context, 'dashboard__item_list_from_followers'),
                        headerDescription: '',
                        viewAllClicked: () {

                          Navigator.pushNamed(
                              context, RoutePaths.itemListFromFollower,
                                  arguments: <String, dynamic>{
                                        'userId': itemListFromFollowersProvider
                                  .psValueHolder!.loginUserId,
                                        'holder': itemListFromFollowersProvider.followUserItemParameterHolder
                                      }
                                  );
                        },
                      ),
                      Container(
                          height: PsDimens.space280,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: itemListFromFollowersProvider
                                  .itemListFromFollowersList.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (itemListFromFollowersProvider
                                        .itemListFromFollowersList.status ==
                                    PsStatus.BLOCK_LOADING) {
                                  return Shimmer.fromColors(
                                      baseColor: PsColors.grey!,
                                      highlightColor: PsColors.white!,
                                      child: const Row(children: <Widget>[
                                        PsFrameUIForLoading(),
                                      ]));
                                } else {
                                  return ProductHorizontalListItem(
                                    coreTagKey: itemListFromFollowersProvider
                                            .hashCode
                                            .toString() +
                                        itemListFromFollowersProvider
                                            .itemListFromFollowersList
                                            .data![index]
                                            .id!,
                                    product: itemListFromFollowersProvider
                                        .itemListFromFollowersList.data![index],
                                    onTap: () {
                                      print(itemListFromFollowersProvider
                                          .itemListFromFollowersList
                                          .data![index]
                                          .defaultPhoto!
                                          .imgPath);
                                      final Product product =
                                          itemListFromFollowersProvider
                                              .itemListFromFollowersList
                                              .data!
                                              .reversed
                                              .toList()[index];
                                      final ProductDetailIntentHolder holder =
                                          ProductDetailIntentHolder(
                                              productId:
                                                  itemListFromFollowersProvider
                                                      .itemListFromFollowersList
                                                      .data![index]
                                                      .id,
                                              heroTagImage:
                                                  itemListFromFollowersProvider
                                                          .hashCode
                                                          .toString() +
                                                      product.id! +
                                                      PsConst.HERO_TAG__IMAGE,
                                              heroTagTitle:
                                                  itemListFromFollowersProvider
                                                          .hashCode
                                                          .toString() +
                                                      product.id! +
                                                      PsConst.HERO_TAG__TITLE);
                                      Navigator.pushNamed(
                                          context, RoutePaths.productDetail,
                                          arguments: holder);
                                    },
                                  );
                                }
                              }))
                    ],
                  )
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - animation.value), 0.0),
                    child: child),
              );
            },
          );
        },
      ),
    );
  }
}

class _MyHeaderWidget extends StatefulWidget {
  const _MyHeaderWidget({
    Key? key,
    required this.headerName,
    this.headerDescription,
    required this.viewAllClicked,
  }) : super(key: key);

  final String? headerName;
  final String? headerDescription;
  final Function? viewAllClicked;

  @override
  __MyHeaderWidgetState createState() => __MyHeaderWidgetState();
}

class __MyHeaderWidgetState extends State<_MyHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.viewAllClicked as void Function()?,
      child: Padding(
        padding: const EdgeInsets.only(
            top: PsDimens.space20,
            left: PsDimens.space16,
            right: PsDimens.space16,
            bottom: PsDimens.space10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  //   fit: FlexFit.loose,
                  child: Text(widget.headerName!,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: PsColors.textPrimaryDarkColor)),
                ),
                Text(
                  Utils.getString(context, 'dashboard__view_all'),
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: PsColors.mainColor),
                ),
              ],
            ),
            if (widget.headerDescription == '')
              Container()
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: PsDimens.space10),
                      child: Text(
                        widget.headerDescription!,
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: PsColors.textPrimaryLightColor),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeaderWidget extends StatefulWidget {
  const _HomeHeaderWidget(
      {Key? key,
      required this.animationController,
      required this.animation,
      required this.psValueHolder,
      required this.itemNameTextEditingController})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;
  final TextEditingController itemNameTextEditingController;

  @override
  __HomeHeaderWidgetState createState() => __HomeHeaderWidgetState();
}

final ProductParameterHolder productParameterHolder =
    ProductParameterHolder().getLatestParameterHolder();

class __HomeHeaderWidgetState extends State<_HomeHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Consumer<ItemLocationProvider>(
      builder: (BuildContext context, ItemLocationProvider itemLocationProvider,
          Widget? child) {
        return AnimatedBuilder(
            animation: widget.animationController,
            child: Stack(
              children: <Widget>[
                _HomeBunnerSliderListWidget(),
                _MyHomeHeaderWidget(
                  userInputItemNameTextEditingController:
                      widget.itemNameTextEditingController,
                  selectedLocation: () {
                    Navigator.pushNamed(context, RoutePaths.itemLocationList);
                  },
                  locationName: widget.psValueHolder.isSubLocation ==
                          PsConst.ONE
                      ? (widget.psValueHolder.locationTownshipName.isEmpty ||
                              widget.psValueHolder.locationTownshipName ==
                                  Utils.getString(
                                      context, 'product_list__category_all'))
                          ? widget.psValueHolder.locactionName!
                          : widget.psValueHolder.locationTownshipName
                      : widget.psValueHolder.locactionName!,
                  psValueHolder: widget.psValueHolder,
                )
              ],
            ),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - widget.animation.value), 0.0),
                      child: child));
            });
      },
    ));
  }
}

class _MyHomeHeaderWidget extends StatefulWidget {
  const _MyHomeHeaderWidget(
      {Key? key,
      required this.userInputItemNameTextEditingController,
      required this.selectedLocation,
      required this.locationName,
      required this.psValueHolder})
      : super(key: key);

  final Function selectedLocation;
  final String locationName;
  final TextEditingController userInputItemNameTextEditingController;
  final PsValueHolder psValueHolder;
  @override
  __MyHomeHeaderWidgetState createState() => __MyHomeHeaderWidgetState();
}

class __MyHomeHeaderWidgetState extends State<_MyHomeHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space8,
    );
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(
          left: PsDimens.space32,
          right: PsDimens.space32,
          top: PsDimens.space120),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(PsDimens.space12),
        // color:  Colors.white54
        color: Utils.isLightMode(context) ? Colors.white54 : Colors.black54,
      ),
      child: Column(
        children: <Widget>[
          _spacingWidget,
          _spacingWidget,
          Text(
            Utils.getString(context, 'dashboard__your_location'),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          _spacingWidget,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                onTap: widget.selectedLocation as void Function()?,
                child: Text(
                  widget.locationName,
                  textAlign: TextAlign.right,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: PsColors.mainColor),
                ),
              ),
              MySeparator(color: PsColors.grey!),
            ],
          ),
          _spacingWidget,
          PsTextFieldWidgetWithIcon(
              hintText: Utils.getString(context, 'home__bottom_app_bar_search'),
              textEditingController:
                  widget.userInputItemNameTextEditingController,
              psValueHolder: widget.psValueHolder,
              clickSearchButton: () {
                productParameterHolder.itemLocationId =
                    widget.psValueHolder.locationId;
                productParameterHolder.itemLocationName =
                    widget.psValueHolder.locactionName;
                if (widget.psValueHolder.isSubLocation == PsConst.ONE) {
                  productParameterHolder.itemLocationTownshipId =
                      widget.psValueHolder.locationTownshipId;
                  productParameterHolder.itemLocationTownshipName =
                      widget.psValueHolder.locationTownshipName;
                }
                productParameterHolder.searchTerm =
                    widget.userInputItemNameTextEditingController.text;
                Navigator.pushNamed(context, RoutePaths.filterProductList,
                    arguments: ProductListIntentHolder(
                        appBarTitle: Utils.getString(
                            context, 'home_search__app_bar_title'),
                        productParameterHolder: productParameterHolder));
              },
              clickEnterFunction: () {
                productParameterHolder.itemLocationId =
                    widget.psValueHolder.locationId;
                productParameterHolder.itemLocationName =
                    widget.psValueHolder.locactionName;
                if (widget.psValueHolder.isSubLocation == PsConst.ONE) {
                  productParameterHolder.itemLocationTownshipId =
                      widget.psValueHolder.locationTownshipId;
                  productParameterHolder.itemLocationTownshipName =
                      widget.psValueHolder.locationTownshipName;
                }
                productParameterHolder.searchTerm =
                    widget.userInputItemNameTextEditingController.text;
                Navigator.pushNamed(context, RoutePaths.filterProductList,
                    arguments: ProductListIntentHolder(
                        appBarTitle: Utils.getString(
                            context, 'home_search__app_bar_title'),
                        productParameterHolder: productParameterHolder));
              }),
          _spacingWidget
        ],
      ),
    );
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({this.height = 1, this.color});
  final double height;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // final double boxWidth = constraints.constrainWidth();
        const double dashWidth = 10.0;
        final double dashHeight = height;
        const int dashCount = 10; //(boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List<Widget>.generate(dashCount, (_) {
            return Padding(
              padding: const EdgeInsets.only(right: PsDimens.space2),
              child: SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.center,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
