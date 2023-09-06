import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/provider/gallery/gallery_provider.dart';
import 'package:flutteradmotors/provider/package_bought/package_bought_transaction_provider.dart';
import 'package:flutteradmotors/provider/product/added_item_provider.dart';
import 'package:flutteradmotors/provider/product/disabled_product_provider.dart';
import 'package:flutteradmotors/provider/product/paid_id_item_provider.dart';
import 'package:flutteradmotors/provider/product/pending_product_provider.dart';
import 'package:flutteradmotors/provider/product/rejected_product_provider.dart';
import 'package:flutteradmotors/provider/product/sold_out_item_provider.dart';
import 'package:flutteradmotors/provider/user/user_provider.dart';
import 'package:flutteradmotors/repository/gallery_repository.dart';
import 'package:flutteradmotors/repository/package_bought_transaction_history_repository.dart';
import 'package:flutteradmotors/repository/paid_ad_item_repository.dart';
import 'package:flutteradmotors/repository/product_repository.dart';
import 'package:flutteradmotors/repository/sold_out_item_repository.dart';
import 'package:flutteradmotors/repository/user_repository.dart';
import 'package:flutteradmotors/ui/common/dialog/apply_blue_mark.dart';
import 'package:flutteradmotors/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutteradmotors/ui/common/dialog/error_dialog.dart';
import 'package:flutteradmotors/ui/common/ps_frame_loading_widget.dart';
import 'package:flutteradmotors/ui/common/ps_header_widget.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/ui/common/smooth_star_rating_widget.dart';
import 'package:flutteradmotors/ui/item/item/product_horizontal_list_item_for_profile.dart';
import 'package:flutteradmotors/ui/item/paid_ad/paid_ad_item_horizontal_list_item.dart';
import 'package:flutteradmotors/ui/user/buy_adpost_transaction/buy_adpost_transaction_history_horizontal_item.dart';
import 'package:flutteradmotors/utils/ps_progress_dialog.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/api_status.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/holder/delete_user_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/item_entry_intent_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/item_list_intent_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutteradmotors/viewobject/holder/package_transaction_holder.dart';
import 'package:flutteradmotors/viewobject/holder/product_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/product.dart';
import 'package:flutteradmotors/viewobject/user.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shimmer/shimmer.dart';

class ProfileView extends StatefulWidget {
  const ProfileView(
      {Key? key,
      this.animationController,
      required this.flag,
      this.userId,
      required this.scaffoldKey,
      required this.callLogoutCallBack})
      : super(key: key);
  final AnimationController? animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int? flag;
  final String? userId;
  final Function callLogoutCallBack;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

ScrollController scrollController = ScrollController();
AnimationController? animationControllerForFab;

class _ProfilePageState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  UserRepository? userRepository;
  PsValueHolder? psValueHolder;
  UserProvider? provider;
  AddedItemProvider? productProvider;
  PendingProductProvider? pendingProductProvider;
  ProductRepository? productRepository;
  PaidAdItemProvider? paidAdItemProvider;
  DisabledProductProvider? disabledProductProvider;
  RejectedProductProvider? rejectedProductProvider;
  PaidAdItemRepository? paidAdItemRepository;
  GalleryRepository? galleryRepo;
  GalleryProvider? galleryProvider;
  PackageTranscationHistoryRepository? packageTranscationHistoryRepository;
  PackageTranscationHistoryProvider? packageTranscationHistoryProvider;
  SoldOutProductProvider? soldOutProductProvider;
  SoldOutItemRepository? soldOutItemRepository;

  @override
  void initState() {
    animationControllerForFab = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this, value: 1);

    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (animationControllerForFab != null) {
          animationControllerForFab!.reverse();
        }
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (animationControllerForFab != null) {
          animationControllerForFab!.forward();
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.animationController!.forward();
     soldOutItemRepository = Provider.of<SoldOutItemRepository>(context);
    paidAdItemRepository = Provider.of<PaidAdItemRepository>(context);
    userRepository = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    provider = UserProvider(repo: userRepository!, psValueHolder: psValueHolder);
    productRepository = Provider.of<ProductRepository>(context);
    galleryRepo = Provider.of<GalleryRepository>(context);
    galleryProvider = GalleryProvider(repo: galleryRepo!);
    packageTranscationHistoryRepository =
        Provider.of<PackageTranscationHistoryRepository>(context);

    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<PaidAdItemProvider>(
            lazy: false,
            create: (BuildContext context) {
              paidAdItemProvider = PaidAdItemProvider(
                  repo: paidAdItemRepository!, psValueHolder: psValueHolder!);
              if (paidAdItemProvider!.psValueHolder.loginUserId == null ||
                  paidAdItemProvider!.psValueHolder.loginUserId == '') {
                paidAdItemProvider!.loadPaidAdItemList(widget.userId!);
              } else {
                paidAdItemProvider!.loadPaidAdItemList(
                    paidAdItemProvider!.psValueHolder.loginUserId!);
              }

              return paidAdItemProvider!;
            }),
        ChangeNotifierProvider<AddedItemProvider>(
            lazy: false,
            create: (BuildContext context) {
              productProvider = AddedItemProvider(
                  repo: productRepository!, psValueHolder: psValueHolder);
              productProvider!.addedUserParameterHolder.mile = 
                  psValueHolder!.mile;
              if (productProvider!.psValueHolder!.loginUserId == null ||
                  productProvider!.psValueHolder!.loginUserId == '') {
                productProvider!.addedUserParameterHolder.addedUserId =
                    widget.userId;
                productProvider!.addedUserParameterHolder.status = '1';
                productProvider!.loadItemList(
                    widget.userId!, productProvider!.addedUserParameterHolder);
              } else {
                productProvider!.addedUserParameterHolder.addedUserId =
                    productProvider!.psValueHolder!.loginUserId;
                productProvider!.addedUserParameterHolder.status = '1';
                productProvider!.loadItemList(
                    productProvider!.psValueHolder!.loginUserId!,
                    productProvider!.addedUserParameterHolder);
              }

              return productProvider!;
            }),
        ChangeNotifierProvider<PendingProductProvider>(
            lazy: false,
            create: (BuildContext context) {
              pendingProductProvider = PendingProductProvider(
                  repo: productRepository!, psValueHolder: psValueHolder);
              if (pendingProductProvider!.psValueHolder!.loginUserId == null ||
                  pendingProductProvider!.psValueHolder!.loginUserId == '') {
                pendingProductProvider!.addedUserParameterHolder.addedUserId =
                    widget.userId;
                pendingProductProvider!.addedUserParameterHolder.status = '0';
                pendingProductProvider!.loadProductList(widget.userId!,
                    pendingProductProvider!.addedUserParameterHolder);
              } else {
                pendingProductProvider!.addedUserParameterHolder.addedUserId =
                    pendingProductProvider!.psValueHolder!.loginUserId;
                pendingProductProvider!.addedUserParameterHolder.status = '0';
                pendingProductProvider!.loadProductList(
                    provider!.psValueHolder!.loginUserId!,
                    pendingProductProvider!.addedUserParameterHolder);
              }

              return pendingProductProvider!;
            }),
        ChangeNotifierProvider<DisabledProductProvider>(
            lazy: false,
            create: (BuildContext context) {
              disabledProductProvider = DisabledProductProvider(
                  repo: productRepository!, psValueHolder: psValueHolder);
              disabledProductProvider!.addedUserParameterHolder.mile = psValueHolder!.mile;    
              if (disabledProductProvider!.psValueHolder!.loginUserId == null ||
                  disabledProductProvider!.psValueHolder!.loginUserId == '') {
                disabledProductProvider!.addedUserParameterHolder.addedUserId =
                    widget.userId;
                disabledProductProvider!.addedUserParameterHolder.status = '2';
                disabledProductProvider!.loadProductList(widget.userId!,
                    disabledProductProvider!.addedUserParameterHolder);
              } else {
                disabledProductProvider!.addedUserParameterHolder.addedUserId =
                    disabledProductProvider!.psValueHolder!.loginUserId;
                disabledProductProvider!.addedUserParameterHolder.status = '2';
                disabledProductProvider!.loadProductList(
                    disabledProductProvider!.psValueHolder!.loginUserId!,
                    disabledProductProvider!.addedUserParameterHolder);
              }

              return disabledProductProvider!;
            }),
        ChangeNotifierProvider<RejectedProductProvider>(
            lazy: false,
            create: (BuildContext context) {
              rejectedProductProvider = RejectedProductProvider(
                  repo: productRepository!, psValueHolder: psValueHolder);
              rejectedProductProvider!.addedUserParameterHolder.mile = psValueHolder!.mile;    
              if (rejectedProductProvider!.psValueHolder!.loginUserId == null ||
                  rejectedProductProvider!.psValueHolder!.loginUserId == '') {
                rejectedProductProvider!.addedUserParameterHolder.addedUserId =
                    widget.userId;
                rejectedProductProvider!.addedUserParameterHolder.status = '3';
                rejectedProductProvider!.loadProductList(widget.userId!,
                    rejectedProductProvider!.addedUserParameterHolder);
              } else {
                rejectedProductProvider!.addedUserParameterHolder.addedUserId =
                    rejectedProductProvider!.psValueHolder!.loginUserId;
                rejectedProductProvider!.addedUserParameterHolder.status = '3';
                rejectedProductProvider!.loadProductList(
                    rejectedProductProvider!.psValueHolder!.loginUserId!,
                    rejectedProductProvider!.addedUserParameterHolder);
              }

              return rejectedProductProvider!;
            }),
            ChangeNotifierProvider<SoldOutProductProvider?>(
              lazy: false,
              create: (BuildContext context) {
                soldOutProductProvider = SoldOutProductProvider(
                    repo: soldOutItemRepository, psValueHolder: psValueHolder, limit: psValueHolder!.defaultLoadingLimit!); 
                     if (productProvider!.psValueHolder!.loginUserId == null ||
                    soldOutProductProvider!.psValueHolder!.loginUserId == '') {
                  soldOutProductProvider!.addedUserParameterHolder.addedUserId =
                      widget.userId;
                  soldOutProductProvider!.addedUserParameterHolder.isSoldOut = '1';
                  soldOutProductProvider!.loadSoldOutProductList(
                      widget.userId, productProvider!.addedUserParameterHolder);
                } else {
                  soldOutProductProvider!.addedUserParameterHolder.addedUserId =
                      productProvider!.psValueHolder!.loginUserId;
                  soldOutProductProvider!.addedUserParameterHolder.isSoldOut = '1';
                  soldOutProductProvider!.loadSoldOutProductList(
                      soldOutProductProvider!.psValueHolder!.loginUserId,
                      soldOutProductProvider!.addedUserParameterHolder);
                }
                return soldOutProductProvider;
              }),
            ChangeNotifierProvider<PackageTranscationHistoryProvider?>(
              lazy: false,
              create: (BuildContext context) {
                packageTranscationHistoryProvider =
                    PackageTranscationHistoryProvider(
                        repo: packageTranscationHistoryRepository,
                        psValueHolder: psValueHolder);
                final PackgageBoughtTransactionParameterHolder
                    packgageBoughtParameterHolder =
                    PackgageBoughtTransactionParameterHolder(
                        userId: psValueHolder!.loginUserId);
                if (packageTranscationHistoryProvider!
                            .psValueHolder!.loginUserId ==
                        null ||
                    packageTranscationHistoryProvider!
                            .psValueHolder!.loginUserId ==
                        '') {
                  packageTranscationHistoryProvider!
                      .loadBuyAdTransactionList(packgageBoughtParameterHolder);
                } else {
                  packageTranscationHistoryProvider!
                      .loadBuyAdTransactionList(packgageBoughtParameterHolder);
                }

                return packageTranscationHistoryProvider!;
              }),
      ],
      child: Scaffold(
        floatingActionButton: FadeTransition(
          opacity: animationControllerForFab!,
          child: ScaleTransition(
            scale: animationControllerForFab!,
            child: FloatingActionButton.extended(
              onPressed: () async {
                if (await Utils.checkInternetConnectivity()) {
                  Utils.navigateOnUserVerificationView(provider, context,
                      () async {
                    final dynamic returnData = await Navigator.pushNamed(
                        context, RoutePaths.itemEntry,
                        arguments: ItemEntryIntentHolder(
                            flag: PsConst.ADD_NEW_ITEM, item: Product()));

                    if (returnData == true) {
                      productProvider!.addedUserParameterHolder.addedUserId =
                          productProvider!.psValueHolder!.loginUserId;

                      productProvider!.resetItemList(
                          productProvider!.psValueHolder!.loginUserId!,
                          productProvider!.addedUserParameterHolder);

                      pendingProductProvider!.resetProductList(
                          productProvider!.psValueHolder!.loginUserId!,
                          pendingProductProvider!.addedUserParameterHolder);

                      rejectedProductProvider!.resetProductList(
                          rejectedProductProvider!.psValueHolder!.loginUserId!,
                          rejectedProductProvider!.addedUserParameterHolder);

                      disabledProductProvider!.resetProductList(
                          disabledProductProvider!.psValueHolder!.loginUserId!,
                          disabledProductProvider!.addedUserParameterHolder);
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
                      : Colors.black87,
              label: Text(Utils.getString(context, 'dashboard__submit_ad'),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: PsColors.white)),
            ),
          ),
        ),
        body:
            // SingleChildScrollView(
            //   child: Container(
            //     color: PsColors.coreBackgroundColor,
            //     height: widget.flag ==
            //           PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT
            //       ? MediaQuery.of(context).size.height - 100
            //       : MediaQuery.of(context).size.height - 40,
            //   child:
            CustomScrollView(
                controller: scrollController,
                scrollDirection: Axis.vertical,
                slivers: <Widget>[
              _ProfileDetailWidget(
                  animationController: widget.animationController!,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: widget.animationController!,
                      curve: const Interval((1 / 4) * 2, 1.0,
                          curve: Curves.fastOutSlowIn),
                    ),
                  ),
                  userId: widget.userId,
                  provider: provider!,
                  callLogoutCallBack: widget.callLogoutCallBack,
                  galleryProvider: galleryProvider!),
              if (psValueHolder!.isPaidApp == PsConst.ONE)    
              _BuyAdTransactionWidget(
                  animationController: widget.animationController,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: widget.animationController!,
                      curve: const Interval((1 / 4) * 2, 1.0,
                          curve: Curves.fastOutSlowIn),
                    ),
                  ),
                  userId: widget.userId,
                  userProvider: provider!,
                ),    
              _PaidAdWidget(
                animationController: widget.animationController!,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: widget.animationController!,
                    curve: const Interval((1 / 4) * 2, 1.0,
                        curve: Curves.fastOutSlowIn),
                  ),
                ),
                userId: widget.userId, //animationController,
              ),
              
              _ListingDataWidget(
                animationController: widget.animationController!,
                userId: widget.userId,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: widget.animationController!,
                    curve: const Interval((1 / 4) * 2, 1.0,
                        curve: Curves.fastOutSlowIn),
                  ),
                ),
                headerTitle: Utils.getString(context, 'profile__listing'),
                status: '1', //animationController,
              ),
              _PendingListingDataWidget(
                animationController: widget.animationController!,
                userId: widget.userId,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: widget.animationController!,
                    curve: const Interval((1 / 4) * 2, 1.0,
                        curve: Curves.fastOutSlowIn),
                  ),
                ),
                headerTitle:
                    Utils.getString(context, 'profile__pending_listing'),
                status: '0', //animationController,
              ),
             _SoldOutListingDataWidget(
                  animationController: widget.animationController,
                  userId: widget.userId,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: widget.animationController!,
                      curve: const Interval((1 / 4) * 2, 1.0,
                          curve: Curves.fastOutSlowIn),
                    ),
                  ),
                  headerTitle:
                      Utils.getString(context, 'item_entry__sold_out'),
                      isSoldOut: '1'
                //  status: '0', //animationController,
                ),
              _RejectedListingDataWidget(
                animationController: widget.animationController!,
                userId: widget.userId,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: widget.animationController!,
                    curve: const Interval((1 / 4) * 2, 1.0,
                        curve: Curves.fastOutSlowIn),
                  ),
                ),
                headerTitle:
                    Utils.getString(context, 'profile__rejected_listing'),
                status: '3', //animationController,
              ),
              _DisabledListingDataWidget(
                animationController: widget.animationController!,
                userId: widget.userId,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: widget.animationController!,
                    curve: const Interval((1 / 4) * 2, 1.0,
                        curve: Curves.fastOutSlowIn),
                  ),
                ),
                headerTitle:
                    Utils.getString(context, 'profile__disable_listing'),
                status: '2', //animationController,
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: PsDimens.space20,
                ),
              )
            ]),
        // )),
      ),
    );
  }
}

class _PaidAdWidget extends StatefulWidget {
  const _PaidAdWidget(
      {Key? key,
      required this.animationController,
      this.userId,
      this.animation})
      : super(key: key);

  final AnimationController? animationController;
  final String? userId;
  final Animation<double> ?animation;

  @override
  __PaidAdWidgetState createState() => __PaidAdWidgetState();
}

class __PaidAdWidgetState extends State<_PaidAdWidget> {
  PaidAdItemRepository? paidAdItemRepository;
  PsValueHolder? psValueHolder;
  ProductParameterHolder? parameterHolder;

  @override
  Widget build(BuildContext context) {
    paidAdItemRepository = Provider.of<PaidAdItemRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(child: Consumer<PaidAdItemProvider>(builder:
        (BuildContext context, PaidAdItemProvider productProvider,
            Widget? child) {
      return AnimatedBuilder(
          animation: widget.animationController!,
          child: (productProvider.paidAdItemList.data != null &&
                  productProvider.paidAdItemList.data!.isNotEmpty)
              ? Column(children: <Widget>[
                  PsHeaderWidget(
                    headerName: Utils.getString(context, 'profile__paid_ad'),
                    viewAllClicked: () {
                      Navigator.pushNamed(
                        context,
                        RoutePaths.paidAdItemList,
                      );
                    },
                  ),
                  Container(
                      height: 400,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: productProvider.paidAdItemList.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (productProvider.paidAdItemList.status ==
                                PsStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.white,
                                  child: const Row(children: <Widget>[
                                    PsFrameUIForLoading(),
                                  ]));
                            } else {
                              return PaidAdItemHorizontalListItem(
                                paidAdItem:
                                    productProvider.paidAdItemList.data![index],
                                onTap: () {
                                  // final Product product = provider.historyList.data.reversed.toList()[index];
                                  final ProductDetailIntentHolder holder =
                                      ProductDetailIntentHolder(
                                          productId: productProvider
                                              .paidAdItemList
                                              .data![index]
                                              .item!
                                              .id!,
                                          heroTagImage: productProvider.hashCode
                                                  .toString() +
                                              productProvider.paidAdItemList
                                                  .data![index].item!.id! +
                                              PsConst.HERO_TAG__IMAGE,
                                          heroTagTitle: productProvider.hashCode
                                                  .toString() +
                                              productProvider.paidAdItemList
                                                  .data![index].item!.id! +
                                              PsConst.HERO_TAG__TITLE);
                                  Navigator.pushNamed(
                                      context, RoutePaths.productDetail,
                                      arguments: holder
                                      // productProvider
                                      //     .paidAdItemList.data[index].item
                                      );
                                },
                              );
                            }
                          }))
                ])
              : Container(),
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
                opacity: widget.animation!,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation!.value), 0.0),
                    child: child));
          });
    }));
  }
}


class _BuyAdTransactionWidget extends StatefulWidget {
  const _BuyAdTransactionWidget(
      {Key? key,
      required this.animationController,
      required this.userProvider,
      this.userId,
      this.animation})
      : super(key: key);

  final AnimationController? animationController;
  final UserProvider userProvider;
  final String? userId;
  final Animation<double>? animation;

  @override
  __BuyAdTransactionWidgetState createState() =>
      __BuyAdTransactionWidgetState();
}

class __BuyAdTransactionWidgetState extends State<_BuyAdTransactionWidget> {
  PsValueHolder? psValueHolder;
  ProductParameterHolder? parameterHolder;

  @override
  Widget build(BuildContext context) {
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(child:
        Consumer<PackageTranscationHistoryProvider>(builder:
            (BuildContext context,
                PackageTranscationHistoryProvider productProvider,
                Widget? child) {
      return AnimatedBuilder(
          animation: widget.animationController!,
          child: (productProvider.transactionList.data != null &&
                  productProvider.transactionList.data!.isNotEmpty)
              ? Column(children: <Widget>[
                  PsHeaderWidget(
                    headerName: Utils.getString(
                        context, 'package__purchased'),
                    viewAllClicked: () async {
                      await Navigator.pushNamed(
                        context,
                        RoutePaths.packageTransactionHistoryList,
                      );

                      widget.userProvider.getUser(Utils.checkUserLoginId(psValueHolder!));

                      productProvider.resetPackageTransactionDetailList(
                            PackgageBoughtTransactionParameterHolder(userId: 
                              Utils.checkUserLoginId(psValueHolder!)
                            )
                          );
                    },
                  ),
                  Container(
                      height: 118,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              productProvider.transactionList.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (productProvider.transactionList.status ==
                                PsStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.white,
                                  child: const Row(children: <Widget>[
                                    PsFrameUIForLoading(),
                                  ]));
                            } else {
                              return BuyAdTransactionHorizontalListItem(
                                transaction: productProvider
                                    .transactionList.data![index],
                                onTap: () {
                                    // Navigator.pushNamed(
                                    //             context, RoutePaths.packageTransactionHistoryDetail,
                                    //             arguments: productProvider.transactionList.data![index]);
                                },
                              );
                            }
                          }))
                ])
              : Container(),
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
                opacity: widget.animation!,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation!.value), 0.0),
                    child: child));
          });
    }));
  }
}

class _ListingDataWidget extends StatefulWidget {
  const _ListingDataWidget(
      {Key ?key,
      required this.animationController,
      this.userId,
      required this.headerTitle,
      required this.status,
      this.animation})
      : super(key: key);

  final AnimationController animationController;
  final String? userId;
  final String headerTitle;
  final String status;
  final Animation<double>? animation;

  @override
  __ListingDataWidgetState createState() => __ListingDataWidgetState();
}

class __ListingDataWidgetState extends State<_ListingDataWidget> {
  ProductRepository? productRepository;

  PsValueHolder? psValueHolder;

  @override
  Widget build(BuildContext context) {
    productRepository = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(child: Consumer<AddedItemProvider>(builder:
        (BuildContext context, AddedItemProvider productProvider,
            Widget? child) {
      return Container(
        color: PsColors.coreBackgroundColor,
        child: AnimatedBuilder(
            animation: widget.animationController,
            child: (productProvider.itemList.data != null &&
                    productProvider.itemList.data!.isNotEmpty)
                ? Column(children: <Widget>[
                    PsHeaderWidget(
                      headerName: widget.headerTitle,
                      viewAllClicked: () {
                        Navigator.pushNamed(
                            context, RoutePaths.userItemListForProfile,
                            arguments: ItemListIntentHolder(
                                userId: productProvider.psValueHolder!.loginUserId!,
                                status: widget.status,
                                title: widget.headerTitle));
                      },
                    ),
                    Container(
                      
                        height: PsDimens.space340,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: productProvider.itemList.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (productProvider.itemList.status ==
                                  PsStatus.BLOCK_LOADING) {
                                return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.white,
                                    child: const Row(children: <Widget>[
                                      PsFrameUIForLoading(),
                                    ]));
                              } else {
                                     if (productProvider
                                      .itemList.data![index].adType! ==
                                  PsConst.GOOGLE_AD_TYPE) {
                                return  Container();
                              } else {
                                return ProductHorizontalListItemForProfile(
                                  product: productProvider.itemList.data![index],
                                  coreTagKey:
                                      productProvider.hashCode.toString() +
                                          productProvider.itemList.data![index].id!,
                                  onTap: () {
                                    print(productProvider.itemList.data![index]
                                        .defaultPhoto!.imgPath);
                                    final Product product = productProvider
                                        .itemList.data!.reversed
                                        .toList()[index];
                                    final ProductDetailIntentHolder holder =
                                        ProductDetailIntentHolder(
                                            productId: productProvider
                                                .itemList.data![index].id!,
                                            heroTagImage: productProvider.hashCode
                                                    .toString() +
                                                product.id! +
                                                PsConst.HERO_TAG__IMAGE,
                                            heroTagTitle: productProvider.hashCode
                                                    .toString() +
                                                product.id !+
                                                PsConst.HERO_TAG__TITLE);
                                    Navigator.pushNamed(
                                        context, RoutePaths.productDetail,
                                        arguments: holder);
                                  },
                                );
                              }
                              }
                            }))
                  ])
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                  opacity: widget.animation!,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - widget.animation!.value), 0.0),
                      child: child));
            }),
      );
    }));
  }
}

class _PendingListingDataWidget extends StatefulWidget {
  const _PendingListingDataWidget(
      {Key? key,
      required this.animationController,
      this.userId,
      required this.headerTitle,
      required this.status,
      this.animation})
      : super(key: key);

  final AnimationController animationController;
  final String? userId;
  final String headerTitle;
  final String status;
  final Animation<double> ?animation;

  @override
  ___PendingListingDataWidgetState createState() =>
      ___PendingListingDataWidgetState();
}

class ___PendingListingDataWidgetState
    extends State<_PendingListingDataWidget> {
  ProductRepository? itemRepository;

  PsValueHolder? psValueHolder;

  @override
  Widget build(BuildContext context) {
    itemRepository = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(child: Consumer<PendingProductProvider>(builder:
        (BuildContext context, PendingProductProvider itemProvider,
            Widget? child) {
      return AnimatedBuilder(
          animation: widget.animationController,
          child: (itemProvider.itemList.data != null &&
                  itemProvider.itemList.data!.isNotEmpty)
              ? Column(children: <Widget>[
                  PsHeaderWidget(
                    headerName: widget.headerTitle,
                    viewAllClicked: () {
                      Navigator.pushNamed(
                          context, RoutePaths.userItemListForProfile,
                          arguments: ItemListIntentHolder(
                              userId: itemProvider.psValueHolder!.loginUserId!,
                              status: widget.status,
                              title: widget.headerTitle));
                    },
                  ),
                  Container(
                      height: PsDimens.space320,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: itemProvider.itemList.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (itemProvider.itemList.status ==
                                PsStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.white,
                                  child: const Row(children: <Widget>[
                                    PsFrameUIForLoading(),
                                  ]));
                            } else {
                              return ProductHorizontalListItemForProfile(
                                product: itemProvider.itemList.data![index],
                                coreTagKey: itemProvider.hashCode.toString() +
                                    itemProvider.itemList.data![index].id!,
                                onTap: () {
                                  print(itemProvider.itemList.data![index]
                                      .defaultPhoto!.imgPath);
                                  final Product product = itemProvider
                                      .itemList.data!.reversed
                                      .toList()[index];
                                  final ProductDetailIntentHolder holder =
                                      ProductDetailIntentHolder(
                                          productId: itemProvider
                                              .itemList.data![index].id!,
                                          heroTagImage:
                                              itemProvider.hashCode.toString() +
                                                  product.id! +
                                                  PsConst.HERO_TAG__IMAGE,
                                          heroTagTitle:
                                              itemProvider.hashCode.toString() +
                                                  product.id! +
                                                  PsConst.HERO_TAG__TITLE);
                                  Navigator.pushNamed(
                                      context, RoutePaths.productDetail,
                                      arguments: holder);
                                },
                              );
                            }
                          }))
                ])
              : Container(),
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
                opacity: widget.animation!,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation!.value), 0.0),
                    child: child));
          });
    }));
  }
}

class _DisabledListingDataWidget extends StatefulWidget {
  const _DisabledListingDataWidget(
      {Key? key,
      required this.animationController,
      this.userId,
      required this.headerTitle,
      required this.status,
      this.animation})
      : super(key: key);

  final AnimationController animationController;
  final String? userId;
  final String headerTitle;
  final String status;
  final Animation<double>? animation;

  @override
  __DisabledListingDataWidgetState createState() =>
      __DisabledListingDataWidgetState();
}

class __DisabledListingDataWidgetState
    extends State<_DisabledListingDataWidget> {
  ProductRepository? itemRepository;

  PsValueHolder? psValueHolder;

  @override
  Widget build(BuildContext context) {
    itemRepository = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(child: Consumer<DisabledProductProvider>(builder:
        (BuildContext context, DisabledProductProvider itemProvider,
            Widget? child) {
      return AnimatedBuilder(
          animation: widget.animationController,
          child: (itemProvider.itemList.data != null &&
                  itemProvider.itemList.data!.isNotEmpty)
              ? Column(children: <Widget>[
                  PsHeaderWidget(
                    headerName: widget.headerTitle,
                    viewAllClicked: () {
                      Navigator.pushNamed(
                          context, RoutePaths.userItemListForProfile,
                          arguments: ItemListIntentHolder(
                              userId: itemProvider.psValueHolder!.loginUserId!,
                              status: widget.status,
                              title: widget.headerTitle));
                    },
                  ),
                  Container(
                      height: PsDimens.space320,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: itemProvider.itemList.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (itemProvider.itemList.status ==
                                PsStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.white,
                                  child: const Row(children: <Widget>[
                                    PsFrameUIForLoading(),
                                  ]));
                            } else {
                              return ProductHorizontalListItemForProfile(
                                product: itemProvider.itemList.data![index],
                                coreTagKey: itemProvider.hashCode.toString() +
                                    itemProvider.itemList.data![index].id!,
                                onTap: () {
                                  print(itemProvider.itemList.data![index]
                                      .defaultPhoto!.imgPath);
                                  final Product product = itemProvider
                                      .itemList.data!.reversed
                                      .toList()[index];
                                  final ProductDetailIntentHolder holder =
                                      ProductDetailIntentHolder(
                                          productId: itemProvider
                                              .itemList.data![index].id!,
                                          heroTagImage:
                                              itemProvider.hashCode.toString() +
                                                  product.id! +
                                                  PsConst.HERO_TAG__IMAGE,
                                          heroTagTitle:
                                              itemProvider.hashCode.toString() +
                                                  product.id! +
                                                  PsConst.HERO_TAG__TITLE);
                                  Navigator.pushNamed(
                                      context, RoutePaths.productDetail,
                                      arguments: holder);
                                },
                              );
                            }
                          }))
                ])
              : Container(),
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
                opacity: widget.animation!,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation!.value), 0.0),
                    child: child));
          });
    }));
  }
}

class _RejectedListingDataWidget extends StatefulWidget {
  const _RejectedListingDataWidget(
      {Key? key,
      required this.animationController,
      this.userId,
      required this.headerTitle,
      required this.status,
      this.animation})
      : super(key: key);

  final AnimationController animationController;
  final String? userId;
  final String headerTitle;
  final String status;
  final Animation<double>? animation;

  @override
  ___RejectedListingDataWidgetState createState() =>
      ___RejectedListingDataWidgetState();
}

class ___RejectedListingDataWidgetState
    extends State<_RejectedListingDataWidget> {
  ProductRepository? itemRepository;

  PsValueHolder? psValueHolder;

  @override
  Widget build(BuildContext context) {
    itemRepository = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(child: Consumer<RejectedProductProvider>(builder:
        (BuildContext context, RejectedProductProvider itemProvider,
            Widget? child) {
      return AnimatedBuilder(
          animation: widget.animationController,
          child: (itemProvider.itemList.data != null &&
                  itemProvider.itemList.data!.isNotEmpty)
              ? Column(children: <Widget>[
                  PsHeaderWidget(
                    headerName: widget.headerTitle,
                    viewAllClicked: () {
                      Navigator.pushNamed(
                          context, RoutePaths.userItemListForProfile,
                          arguments: ItemListIntentHolder(
                              userId: itemProvider.psValueHolder!.loginUserId!,
                              status: widget.status,
                              title: widget.headerTitle));
                    },
                  ),
                  Container(
                      height: PsDimens.space320,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: itemProvider.itemList.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (itemProvider.itemList.status ==
                                PsStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.white,
                                  child: const Row(children: <Widget>[
                                    PsFrameUIForLoading(),
                                  ]));
                            } else {
                              return ProductHorizontalListItemForProfile(
                                product: itemProvider.itemList.data![index],
                                coreTagKey: itemProvider.hashCode.toString() +
                                    itemProvider.itemList.data![index].id!,
                                onTap: () {
                                  print(itemProvider.itemList.data![index]
                                      .defaultPhoto!.imgPath);
                                  final Product product = itemProvider
                                      .itemList.data!.reversed
                                      .toList()[index];
                                  final ProductDetailIntentHolder holder =
                                      ProductDetailIntentHolder(
                                          productId: itemProvider
                                              .itemList.data![index].id!,
                                          heroTagImage:
                                              itemProvider.hashCode.toString() +
                                                  product.id! +
                                                  PsConst.HERO_TAG__IMAGE,
                                          heroTagTitle:
                                              itemProvider.hashCode.toString() +
                                                  product.id! +
                                                  PsConst.HERO_TAG__TITLE);
                                  Navigator.pushNamed(
                                      context, RoutePaths.productDetail,
                                      arguments: holder);
                                },
                              );
                            }
                          }))
                ])
              : Container(),
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
                opacity: widget.animation!,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation!.value), 0.0),
                    child: child));
          });
    }));
  }
}

class _ProfileDetailWidget extends StatefulWidget {
  const _ProfileDetailWidget(
      {Key? key,
      this.animationController,
      this.animation,
      required this.userId,
      required this.provider,
      required this.callLogoutCallBack,
      required this.galleryProvider})
      : super(key: key);

  final AnimationController? animationController;
  final Animation<double>? animation;
  final String? userId;
  final Function callLogoutCallBack;
  final UserProvider provider;
  final GalleryProvider galleryProvider;

  @override
  __ProfileDetailWidgetState createState() => __ProfileDetailWidgetState();
}

class __ProfileDetailWidgetState extends State<_ProfileDetailWidget> {
  @override
  Widget build(BuildContext context) {
    const Widget _dividerWidget = Divider(
      height: 1,
    );

    return SliverToBoxAdapter(
      child: ChangeNotifierProvider<UserProvider>(
          lazy: false,
          create: (BuildContext context) {
            print(widget.provider.getCurrentFirebaseUser());
            if (widget.provider.psValueHolder!.loginUserId == null ||
                widget.provider.psValueHolder!.loginUserId == '') {
              widget.provider.userParameterHolder.id = widget.userId;
              widget.provider.getUser(widget.userId!);
              // provider.getMyUserData(provider.userParameterHolder.toMap());
            } else {
              widget.provider.userParameterHolder.id =
                  widget.provider.psValueHolder!.loginUserId;
              widget.provider
                  .getUser(widget.provider.psValueHolder!.loginUserId!);
              // provider.getMyUserData(provider.userParameterHolder.toMap());
            }

            return widget.provider;
          },
          child: Consumer<UserProvider>(builder:
              (BuildContext context, UserProvider provider, Widget? child) {
            if (
              //provider.user != null &&
                provider.user.data != null &&
                provider.user.data != null) {
              return AnimatedBuilder(
                  animation: widget.animationController!,
                  child: Container(
                    color: PsColors.backgroundColor,
                    child: Column(
                      children: <Widget>[
                        if (provider.user.data!.isVerifyBlueMark == PsConst.TWO)
                          _WaitingForApprovalWidget()
                        else if (provider.user.data!.isVerifyBlueMark ==
                            PsConst.ONE)
                          _ApprovalAgentWidget()
                        else if (provider.user.data!.isVerifyBlueMark ==
                            PsConst.THREE)
                          RejectedAgentWidget(
                              userProvider: widget.provider,
                              galleryProvider: widget.galleryProvider)
                        else
                          ApplyAgentWidget(
                              userProvider: provider,
                              galleryProvider: widget.galleryProvider),
                        _ImageAndTextWidget(userProvider: provider),
                        _dividerWidget,
                        _EditAndHistoryRowWidget(userProvider: provider),
                        _dividerWidget,
                        _FavAndSettingWidget(
                            userProvider: provider,
                            callLogoutCallBack: widget.callLogoutCallBack),
                        _dividerWidget,
                        _JoinDateWidget(userProvider: provider),
                        _VerifiedWidget(
                          data: provider.user.data!,
                        ),
                        _DeactivateAccWidget(
                          userProvider: provider,
                          callLogoutCallBack: widget.callLogoutCallBack,
                        ),
                        _dividerWidget,
                      ],
                    ),
                  ),
                  builder: (BuildContext context, Widget? child) {
                    return FadeTransition(
                        opacity: widget.animation!,
                        child: Transform(
                            transform: Matrix4.translationValues(
                                0.0, 100 * (1.0 - widget.animation!.value), 0.0),
                            child: child));
                  });
            } else {
              return Container();
            }
          })),
    );
  }
}

class _VerifiedWidget extends StatelessWidget {
  const _VerifiedWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  final User data;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space16,
          right: PsDimens.space16,
          top: PsDimens.space8),
      child: Row(
        children: <Widget>[
          Text(
            Utils.getString(context, 'seller_info_tile__verified'),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (data.facebookVerify == '1')
            const Padding(
              padding: EdgeInsets.only(
                  left: PsDimens.space4, right: PsDimens.space4),
              child: Icon(
                FontAwesome.facebook_official,
              ),
            )
          else
            Container(),
          if (data.googleVerify == '1')
            const Padding(
              padding: EdgeInsets.only(
                  left: PsDimens.space4, right: PsDimens.space4),
              child: Icon(
                FontAwesome.google,
              ),
            )
          else
            Container(),
          if (data.phoneVerify == '1')
            const Padding(
              padding: EdgeInsets.only(
                  left: PsDimens.space4, right: PsDimens.space4),
              child: Icon(
                FontAwesome.phone,
              ),
            )
          else
            Container(),
          if (data.emailVerify == '1')
            const Padding(
              padding: EdgeInsets.only(
                  left: PsDimens.space4, right: PsDimens.space4),
              child: Icon(
                Icons.email,
              ),
            )
          else
            Container(),
        ],
      ),
    );
  }
}

class _JoinDateWidget extends StatelessWidget {
  const _JoinDateWidget({this.userProvider});
  final UserProvider? userProvider;

  @override
  Widget build(BuildContext context) {
    final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context);
    return Padding(
        padding: const EdgeInsets.only(
          left: PsDimens.space16,
          right: PsDimens.space16,
          top: PsDimens.space16,
        ),
        child: Align(
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Text(Utils.getString(context, 'profile__join_on'),
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(
                  width: PsDimens.space2,
                ),
                Text(
                  userProvider!.user.data!.addedDateTimeStamp != null &&
                          userProvider!.user.data!.addedDateTimeStamp != ''
                      ? Utils.changeTimeStampToStandardDateTimeFormat(
                          userProvider!.user.data!.addedDateTimeStamp)
                      : Utils.getDateFormat(userProvider!.user.data!.addedDate!, valueHolder.dateFormat!),
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            )));
  }
}

class _DeactivateAccWidget extends StatelessWidget {
  const _DeactivateAccWidget(
      {required this.userProvider, required this.callLogoutCallBack});
  final UserProvider userProvider;
  final Function callLogoutCallBack;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
                    showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return ConfirmDialogView(
                      description: Utils.getString(
                          context, 'profile__deactivate_confirm_text'),
                      leftButtonText:
                          Utils.getString(context, 'dialog__cancel'),
                      rightButtonText: Utils.getString(context, 'dialog__ok'),
                      onAgreeTap: () async {
                        Navigator.pop(context);
                        await PsProgressDialog.showDialog(context);
                        final DeleteUserHolder deleteUserHolder =
                            DeleteUserHolder(
                                userId: userProvider.psValueHolder!.loginUserId);
                        final PsResource<ApiStatus> _apiStatus =
                            await userProvider
                                .postDeleteUser(deleteUserHolder.toMap());
                        if (_apiStatus.data != null) {
                            callLogoutCallBack(userProvider.psValueHolder!.loginUserId);
                        }
                        PsProgressDialog.dismissDialog();
                      });
                });
      },
      child: Padding(
          padding: const EdgeInsets.only(
              left: PsDimens.space16,
              right: PsDimens.space16,
              top: PsDimens.space8,
              bottom: PsDimens.space16),
              child: Align(
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Text(Utils.getString(context, 'profile__deactivate_acc'),
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(
                    width: PsDimens.space2,
                  ),

                ],
              )),
      ),
    );
  }
}

class _FavAndSettingWidget extends StatelessWidget {
  const _FavAndSettingWidget({this.userProvider, this.callLogoutCallBack});

  final UserProvider? userProvider;
  final Function? callLogoutCallBack;

  @override
  Widget build(BuildContext context) {
    final PsValueHolder valueHolder =
                  Provider.of<PsValueHolder>(context, listen: false);
    const Widget _sizedBoxWidget = SizedBox(
      width: PsDimens.space4,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
            flex: 2,
            child: MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RoutePaths.favouriteProductList,
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.favorite,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  _sizedBoxWidget,
                  Text(
                    Utils.getString(context, 'profile__favourite'),
                    textAlign: TextAlign.start,
                    softWrap: false,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
        Container(
          color: Theme.of(context).dividerColor,
          width: PsDimens.space1,
          height: PsDimens.space48,
        ),
        if (valueHolder.isPaidApp == PsConst.ONE)
        Expanded(
            flex: 2,
            child: MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                // Navigator.pushNamed(
                //   context,
                //   RoutePaths.favouriteProductList,
                // );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                 // _sizedBoxWidget,
                  Expanded(
                    child: Text(
                      Utils.getString(context, 'profile__post_left') + '( ${userProvider!.user.data!.remainingPost} )',
                      textAlign: TextAlign.start,
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )),
        if (valueHolder.isPaidApp == PsConst.ONE)    
        Container(
          color: Theme.of(context).dividerColor,
          width: PsDimens.space1,
          height: PsDimens.space48,
        ),
        Expanded(
            flex: 2,
            child: MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () async {
                final dynamic returnData = await Navigator.pushNamed(
                    context, RoutePaths.more,
                    arguments: userProvider!.user.data!.userName);
                if (returnData) {
                  if (callLogoutCallBack != null) {
                    callLogoutCallBack!(userProvider!.psValueHolder!.loginUserId);
                  }
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.more_horiz,
                      color: Theme.of(context).iconTheme.color),
                  _sizedBoxWidget,
                  Text(
                    Utils.getString(context, 'profile__more'),
                    softWrap: false,
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}


class _SoldOutListingDataWidget extends StatefulWidget {
  const _SoldOutListingDataWidget(
      {Key? key,
      required this.animationController,
      this.userId,
      required this.headerTitle,
      required this.isSoldOut,
      this.animation})
      : super(key: key);

  final AnimationController? animationController;
  final String? userId;
  final String headerTitle;
  final String isSoldOut;
  final Animation<double>? animation;

  @override
  ___SoldOutListingDataWidgetState createState() =>
      ___SoldOutListingDataWidgetState();
}

class ___SoldOutListingDataWidgetState
    extends State<_SoldOutListingDataWidget> {
  SoldOutItemRepository? itemRepository;

  PsValueHolder? psValueHolder;

  @override
  Widget build(BuildContext context) {
    itemRepository = Provider.of<SoldOutItemRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(child: Consumer<SoldOutProductProvider>(builder:
        (BuildContext context, SoldOutProductProvider itemProvider,
            Widget? child) {
      return AnimatedBuilder(
          animation: widget.animationController!,
          child: (itemProvider.itemList.data != null &&
                  itemProvider.itemList.data!.isNotEmpty)
              ? Column(children: <Widget>[
                  PsHeaderWidget(
                    headerName: widget.headerTitle,
                    viewAllClicked: () {
                      Navigator.pushNamed(
                          context, RoutePaths.itemSoldOutProductList,
                          );
                    },
                  ),
                  Container(
                      height: PsDimens.space260,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: itemProvider.itemList.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (itemProvider.itemList.status ==
                                PsStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.white,
                                  child: const Row(children: <Widget>[
                                    PsFrameUIForLoading(),
                                  ]));
                            } else {
                              return ProductHorizontalListItemForProfile(
                                product: itemProvider.itemList.data![index],
                                coreTagKey: itemProvider.hashCode.toString() +
                                    itemProvider.itemList.data![index].id!,
                                onTap: () {
                                  print(itemProvider.itemList.data![index]
                                      .defaultPhoto!.imgPath);
                                  final Product product = itemProvider
                                      .itemList.data!.reversed
                                      .toList()[index];
                                  final ProductDetailIntentHolder holder =
                                      ProductDetailIntentHolder(
                                          productId: itemProvider
                                              .itemList.data![index].id,
                                          heroTagImage:
                                              itemProvider.hashCode.toString() +
                                                  product.id! +
                                                  PsConst.HERO_TAG__IMAGE,
                                          heroTagTitle:
                                              itemProvider.hashCode.toString() +
                                                  product.id! +
                                                  PsConst.HERO_TAG__TITLE);
                                  Navigator.pushNamed(
                                      context, RoutePaths.productDetail,
                                      arguments: holder);
                                },
                              );
                            }
                          }))
                ])
              : Container(),
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
                opacity: widget.animation!,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation!.value), 0.0),
                    child: child));
          });
    }));
  }
}

class _EditAndHistoryRowWidget extends StatelessWidget {
  const _EditAndHistoryRowWidget({required this.userProvider});
  final UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    final Widget _verticalLineWidget = Container(
      color: Theme.of(context).dividerColor,
      width: PsDimens.space1,
      height: PsDimens.space48,
    );
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _EditAndHistoryTextWidget(
          userProvider: userProvider,
          checkText: 0,
        ),
        _verticalLineWidget,
        _EditAndHistoryTextWidget(
          userProvider: userProvider,
          checkText: 1,
        ),
        _verticalLineWidget,
        _EditAndHistoryTextWidget(
          userProvider: userProvider,
          checkText: 2,
        )
      ],
    );
  }
}

class _EditAndHistoryTextWidget extends StatelessWidget {
  const _EditAndHistoryTextWidget({
    Key? key,
    required this.userProvider,
    required this.checkText,
  }) : super(key: key);

  final UserProvider userProvider;
  final int checkText;

  @override
  Widget build(BuildContext context) {
    final PsValueHolder psValueHolder = Provider.of<PsValueHolder>(context);
    if (checkText == 0) {
      return MaterialButton(
        child: Text(
          Utils.getString(context, 'profile__edit'),
          softWrap: false,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        height: 50,
        minWidth: 100,
        onPressed: () async {
          final dynamic returnData = await Navigator.pushNamed(
            context,
            RoutePaths.editProfile,
          );
          if (returnData != null && returnData is bool) {
            userProvider.getUser(userProvider.psValueHolder!.loginUserId!);
            final PaidAdItemProvider paidAdItemProvider =
                Provider.of<PaidAdItemProvider>(context, listen: false);
            paidAdItemProvider.resetPaidAdItemList(
                paidAdItemProvider.psValueHolder.loginUserId!);
            final AddedItemProvider addedItemProvider =
                Provider.of<AddedItemProvider>(context, listen: false);
            addedItemProvider.addedUserParameterHolder.mile = psValueHolder.mile;
            addedItemProvider.resetItemList(
                addedItemProvider.psValueHolder!.loginUserId!,
                addedItemProvider.addedUserParameterHolder);
            final PendingProductProvider pendingProductProvider =
                Provider.of<PendingProductProvider>(context, listen: false);
            pendingProductProvider.addedUserParameterHolder.mile = psValueHolder.mile;    
            pendingProductProvider.resetProductList(
                pendingProductProvider.psValueHolder!.loginUserId!,
                pendingProductProvider.addedUserParameterHolder);
            final RejectedProductProvider rejectedProductProvider =
                Provider.of<RejectedProductProvider>(context, listen: false);
            rejectedProductProvider.addedUserParameterHolder.mile = psValueHolder.mile;    
            rejectedProductProvider.resetProductList(
                rejectedProductProvider.psValueHolder!.loginUserId!,
                rejectedProductProvider.addedUserParameterHolder);
            final DisabledProductProvider disabledProductProvider =
                Provider.of<DisabledProductProvider>(context, listen: false);
            disabledProductProvider.addedUserParameterHolder.mile = psValueHolder.mile;  
            disabledProductProvider.resetProductList(
                disabledProductProvider.psValueHolder!.loginUserId!,
                disabledProductProvider.addedUserParameterHolder);
          }
        },
      );
    } else {
      return Expanded(
          child: MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () async {
                if (checkText == 1) {
                  final dynamic returnData = await Navigator.pushNamed(
                    context,
                    RoutePaths.followerUserList,
                  );
                  if (returnData != null && returnData is bool) {
                    userProvider
                        .getUser(userProvider.psValueHolder!.loginUserId!);
                  }
                } else if (checkText == 2) {
                  final dynamic returnData = await Navigator.pushNamed(
                    context,
                    RoutePaths.followingUserList,
                  );
                  if (returnData != null && returnData is bool) {
                    userProvider
                        .getUser(userProvider.psValueHolder!.loginUserId!);
                  }
                }
              },
              child: checkText == 1
                  ? Text(
                      Utils.getString(context, 'profile__follower') +
                          '( ${userProvider.user.data!.followerCount} )',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    )
                  : Text(
                      Utils.getString(context, 'profile__following') +
                          '( ${userProvider.user.data!.followingCount} )',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    )));
    }
  }
}

class _RatingWidget extends StatelessWidget {
  const _RatingWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  final User data;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          data.overallRating!,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          width: PsDimens.space8,
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, RoutePaths.ratingList,
                arguments: data.userId);
          },
          child: SmoothStarRating(
              key: Key(data.ratingDetail!.totalRatingValue!),
              rating: double.parse(data.ratingDetail!.totalRatingValue!),
              allowHalfRating: false,
              starCount: 5,
              isReadOnly: true,
              size: PsDimens.space16,
              color: Colors.yellow,
              borderColor: Colors.blueGrey[200],
              onRated: (double? v) {},
              spacing: 0.0),
        ),
        const SizedBox(
          width: PsDimens.space8,
        ),
        Text(
          '( ${data.ratingCount} )',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class ApplyAgentWidget extends StatefulWidget {
  const ApplyAgentWidget(
      {required this.userProvider, required this.galleryProvider});

  final UserProvider userProvider;
  final GalleryProvider galleryProvider;

  @override
  _ApplyAgentWidgetState createState() => _ApplyAgentWidgetState();
}

class _ApplyAgentWidgetState extends State<ApplyAgentWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: PsDimens.space4),
        InkWell(
          onTap: () async {
            final dynamic returnData = await showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return ApplyBlueMarkDialog(widget.galleryProvider);
                });
            if (returnData != null && returnData) {
              final PsValueHolder valueHolder =
                  Provider.of<PsValueHolder>(context, listen: false);
              widget.userProvider.getUser(valueHolder.loginUserId!);
            }
          },
          child: Container(
            width: double.infinity,
            height: 50,
            color: Colors.blueGrey[200],
            padding: const EdgeInsets.all(PsDimens.space4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  Utils.getString(context, 'profile__apply_blue_mark'),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WaitingForApprovalWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: PsDimens.space4),
        InkWell(
          onTap: () {},
          child: Container(
            width: double.infinity,
            height: 50,
            color: Colors.yellow,
            padding: const EdgeInsets.all(PsDimens.space4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  Utils.getString(
                      context, 'profile__waiting_for_approval_blue_mark'),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ApprovalAgentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: PsDimens.space4),
        InkWell(
          onTap: () {},
          child: Container(
            width: double.infinity,
            height: 50,
            color: Colors.green[400],
            padding: const EdgeInsets.all(PsDimens.space4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  Utils.getString(context, 'seller_info_tile__verified'),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RejectedAgentWidget extends StatefulWidget {
  const RejectedAgentWidget(
      {required this.userProvider, required this.galleryProvider});

  final UserProvider userProvider;
  final GalleryProvider galleryProvider;

  @override
  _RejectedAgentWidgetState createState() => _RejectedAgentWidgetState();
}

class _RejectedAgentWidgetState extends State<RejectedAgentWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: PsDimens.space4),
        InkWell(
          onTap: () async {
            final dynamic returnData = await showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return ApplyBlueMarkDialog(widget.galleryProvider);
                });
            if (returnData != null && returnData) {
              final PsValueHolder valueHolder =
                  Provider.of<PsValueHolder>(context, listen: false);
              widget.userProvider.getUser(valueHolder.loginUserId!);
            }
          },
          child: Container(
            width: double.infinity,
            height: 50,
            color: Colors.orange[300],
            padding: const EdgeInsets.all(PsDimens.space4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  Utils.getString(context, 'profile__rejected_blue_mark'),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ImageAndTextWidget extends StatelessWidget {
  const _ImageAndTextWidget({this.userProvider});
  final UserProvider? userProvider;
  @override
  Widget build(BuildContext context) {
    final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context);
    final Widget _imageWidget = PsNetworkCircleImageForUser(
      photoKey: '',
      imagePath: userProvider!.user.data!.userProfilePhoto,
      // width: PsDimens.space80,
      // height: PsDimens.space80,
      boxfit: BoxFit.cover,
      onTap: () {},
    );
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space4,
    );
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
          top: PsDimens.space16, bottom: PsDimens.space16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const SizedBox(width: PsDimens.space16),
              Container(
                  width: PsDimens.space80,
                  height: PsDimens.space80,
                  child: _imageWidget),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: PsDimens.space12,
                  top: PsDimens.space8,
                  right: PsDimens.space12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        userProvider!.user.data!.userName!,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.titleLarge,
                        maxLines: 1,
                      ),
                      if (userProvider!.user.data!.isVerifyBlueMark ==
                          PsConst.ONE)
                        Container(
                          margin: const EdgeInsets.only(left: PsDimens.space2),
                          child: Icon(
                            Icons.check_circle,
                            color: PsColors.bluemarkColor,
                            size: valueHolder.bluemarkSize,
                          ),
                        )
                    ],
                  ),
                  if (userProvider!.user.data!.isVerifyBlueMark == PsConst.ONE)
                    Visibility(
                      child: Container(
                        width: PsDimens.space140,
                        child: MaterialButton(
                          color: PsColors.mainColor,
                          height: PsDimens.space28,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: PsColors.mainColor!),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(18.0))),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.verified_user,
                                  color: PsColors.white,
                                  size: 20,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: PsDimens.space4,
                                      right: PsDimens.space6),
                                  child: Text(
                                    Utils.getString(
                                        context, 'seller_info_tile__verified'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(color: PsColors.white),
                                  ),
                                ),
                              ]),
                          onPressed: () {},
                        ),
                      ),
                    )
                  else
                    _spacingWidget,
                  // _spacingWidget,
                  _RatingWidget(
                    data: userProvider!.user.data!,
                  ),
                  _spacingWidget,
                  _spacingWidget,
                  Text(
                    userProvider!.user.data!.userPhone != ''
                        ? userProvider!.user.data!.userPhone!
                        : Utils.getString(context, 'profile__phone_no'),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: PsColors.textPrimaryLightColor),
                    maxLines: 1,
                  ),
                  _spacingWidget,
                  _spacingWidget,
                  Text(
                    userProvider!.user.data!.userAboutMe! != ''
                        ? userProvider!.user.data!.userAboutMe!
                        : Utils.getString(context, 'profile__about_me'),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: PsColors.textPrimaryLightColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
