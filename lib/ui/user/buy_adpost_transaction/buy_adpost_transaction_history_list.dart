import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/provider/package_bought/package_bought_provider.dart';
import 'package:flutteradmotors/provider/package_bought/package_bought_transaction_provider.dart';
import 'package:flutteradmotors/repository/package_bought_repository.dart';
import 'package:flutteradmotors/repository/package_bought_transaction_history_repository.dart';
import 'package:flutteradmotors/ui/common/ps_frame_loading_widget.dart';
import 'package:flutteradmotors/ui/common/ps_header_widget.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/ui/package/package_recommended_shop_widget.dart';
import 'package:flutteradmotors/ui/user/buy_adpost_transaction/buy_adpost_transaction_history_horizontal_item.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/holder/package_transaction_holder.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BuyAdTransactionListView extends StatefulWidget {
  

  // const BuyAdTransactionListView({Key? key,  required this.animationController})
  //     : super(key: key);
  // final AnimationController animationController;
  @override
  _BuyAdTransactionListViewState createState() =>
      _BuyAdTransactionListViewState();
}

class _BuyAdTransactionListViewState extends State<BuyAdTransactionListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  late PsValueHolder valueHolder;
  late PackageTranscationHistoryProvider _historyProvider;
  late Animation<double>? animation;
  late AnimationController? animationController;
  PackageBoughtRepository? repo2;
  PackageBoughtProvider? packageBoughtProvider;

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
    });
    super.initState();
    
  }

  late PackageTranscationHistoryRepository repo1;
  bool isFirstTime = true;

  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<PackageTranscationHistoryRepository>(context);
    repo2 = Provider.of<PackageBoughtRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);
    print(
        '............................Build UI Again ............................');

    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<PackageTranscationHistoryProvider>(
          lazy: false,
          create: (BuildContext context) {
            _historyProvider = PackageTranscationHistoryProvider(
                repo: repo1, psValueHolder: valueHolder);
            final String? loginUserId = Utils.checkUserLoginId(valueHolder);
            final PackgageBoughtTransactionParameterHolder
                packgageBoughtParameterHolder =
                PackgageBoughtTransactionParameterHolder(
              userId: loginUserId,
            );
            _historyProvider.holder = packgageBoughtParameterHolder;
            _historyProvider.loadBuyAdTransactionList(
              packgageBoughtParameterHolder,
            );
            return _historyProvider;
          },
        ),
        ChangeNotifierProvider<PackageBoughtProvider?>(
          lazy: false,
          create: (BuildContext context) {
            packageBoughtProvider = PackageBoughtProvider(repo: repo2);
            packageBoughtProvider!.getAllPackages();
            return packageBoughtProvider;
          },
        ),
      ],
      child: VisibilityDetector(
        key: const Key('my-widget-key'),
        onVisibilityChanged: (VisibilityInfo visibilityInfo) { 
          // ignore: always_specify_types
          final double visiblePercentage = visibilityInfo.visibleFraction * 100;
          if (visiblePercentage == 100) {
            if (!isFirstTime) {
            _historyProvider.resetPackageTransactionDetailList(
              _historyProvider.holder,
            );
            }
            isFirstTime = false;
          }
         },
        child: Consumer<PackageTranscationHistoryProvider>(
          builder: (BuildContext context,
              PackageTranscationHistoryProvider provider, Widget? child) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.only(
                            //  left: PsDimens.space12,
                              right: PsDimens.space10,
                            //  top: PsDimens.space8,
                              bottom: PsDimens.space8),
                          child: RefreshIndicator(
                            child: CustomScrollView(
                                controller: _scrollController,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                slivers: <Widget>[
                                  SliverToBoxAdapter(
                                    child: PsHeaderWidget(
                                      headerName: Utils.getString(context, 'package__purchased'),
                                      viewAllClicked: () {},
                                      showViewAll: false,
                                    ),
                                  ),
                                  if (provider.transactionList.data !=
                                                null &&
                                            provider.transactionList.data!
                                                .isNotEmpty) 
                                  SliverGrid(
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 220.0,
                                            childAspectRatio: 1.7),
                                    delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                          if (provider
                                                  .transactionList.status ==
                                              PsStatus.BLOCK_LOADING) {
                                            return Shimmer.fromColors(
                                                baseColor: PsColors.grey!,
                                                highlightColor:
                                                    PsColors.white!,
                                                child: const Row(
                                                    children: <Widget>[
                                                      PsFrameUIForLoading(),
                                                    ]));
                                          } else {
                                            return BuyAdTransactionHorizontalListItem(
                                              transaction: provider
                                                  .transactionList
                                                  .data![index],
                                              onTap: () {
                                                // Navigator.pushNamed(
                                                //     context, RoutePaths.packageTransactionHistoryDetail,
                                                //     arguments: provider.transactionList.data![index]);
                                              },
                                            );
                                          }
                                      },
                                      childCount: provider
                                          .transactionList.data!.length,
                                    ),
                                  ) else 
                                  SliverToBoxAdapter(
                                    child: Container(
                                      height: 120,
                                      child: Center(
                                        child: Text(
                                                    Utils.getString(context,
                                                        'You have no active package. \n Buy and create post'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                          color: PsColors.textPrimaryLightColor
                                                        ),
                                                    textAlign: TextAlign.center,    ),
                                      ),
                                    ),
                                  ),
                                     PackageRecommendedWidget(
                                    androidKeyList: valueHolder.packageAndroidKeyList,
                                    iosKeyList: valueHolder.packageIOSKeyList,
                                    callToRefresh: () {
                                      provider.resetPackageTransactionDetailList(provider.holder);
                                    },
                                  )
                                ]),
                            onRefresh: () {
                              return provider
                                  .resetPackageTransactionDetailList(
                                provider.holder,
                              );
                            },
                          )),
                      PSProgressIndicator(provider.transactionList.status)
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
