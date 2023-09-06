import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:flutteradmotors/api/common/ps_admob_banner_widget.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/provider/model/model_provider.dart';
import 'package:flutteradmotors/repository/model_repository.dart';
import 'package:flutteradmotors/ui/common/dialog/error_dialog.dart';
import 'package:flutteradmotors/ui/common/dialog/filter_dialog.dart';
import 'package:flutteradmotors/ui/common/dialog/success_dialog.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/ui/common/search_bar_view.dart';
import 'package:flutteradmotors/ui/model/item/model_grid_item.dart';
import 'package:flutteradmotors/utils/ps_progress_dialog.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/api_status.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutteradmotors/viewobject/manufacturer.dart';
import 'package:flutteradmotors/viewobject/model.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ModelGridView extends StatefulWidget {
  const ModelGridView({this.manufacturer});
  final Manufacturer? manufacturer;
  @override
  _ModelGridViewState createState() {
    return _ModelGridViewState();
  }
}

class _ModelGridViewState extends State<ModelGridView>
    with SingleTickerProviderStateMixin {
  _ModelGridViewState() {
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
          modelProvider!.modelParameterHolder.keyword = '';
          modelProvider!.resetModelList(
              modelProvider!.modelParameterHolder.toMap(),
              psValueHolder!.loginUserId!);
        });
  }

  final ScrollController _scrollController = ScrollController();

  ModelProvider? modelProvider;

  AnimationController? animationController;
  Animation<double>? animation;
  PsValueHolder? psValueHolder;

  late SearchBarView searchBar;
  late TextEditingController searchTextController = TextEditingController();
  bool subscribeModelNoti = false;
  List<String?> subscribeModelList = <String?>[];
  List<String?> unsubscribeModelListWithMB = <String?>[];
  List<String?> tempList = <String?>[];
  bool needToAdd = true;

  void onSubmitted(String value) {
    modelProvider!.modelParameterHolder.keyword = value;
    modelProvider!.resetModelList(modelProvider!.modelParameterHolder.toMap(),
        Utils.checkUserLoginId(psValueHolder));
  }

  AppBar buildAppBar(BuildContext context) {
    if (modelProvider != null) {
      modelProvider!.modelParameterHolder.keyword = '';
      modelProvider!.resetModelList(modelProvider!.modelParameterHolder.toMap(),
          Utils.checkUserLoginId(psValueHolder));
    }
    searchTextController.clear();
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
      ),
      backgroundColor:
          Utils.isLightMode(context) ? PsColors.mainColor : Colors.black12,
      iconTheme: Theme.of(context).iconTheme.copyWith(color: PsColors.white),
      // color: Utils.isLightMode(context)
      //     ? PsColors.primary500
      //     : PsColors.primaryDarkWhite),
      title: Text(widget.manufacturer!.name!,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold)
              .copyWith(color: PsColors.white)
          // color: Utils.isLightMode(context)
          //     ? PsColors.primary500
          //     : PsColors.primaryDarkWhite)
          ),
      actions: <Widget>[
        //  if (!subscribeModelNoti)
        IconButton(
          icon: Icon(Icons.search, color: PsColors.white),
          onPressed: () {
            searchBar.beginSearch(context);
          },
        ),
        if (psValueHolder!.isModelSubScribe == PsConst.ONE &&
            !subscribeModelNoti)
          IconButton(
            icon: Icon(Icons.notification_add, color: PsColors.white),
            onPressed: () async {
              if (await Utils.checkInternetConnectivity()) {
                Utils.navigateOnUserVerificationView(modelProvider, context,
                    () {
                  setState(() {
                    subscribeModelNoti = true;
                  });
                });
              }
            },
          ),
        if (psValueHolder!.isModelSubScribe == PsConst.ONE &&
            subscribeModelNoti)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () async {
                if (subscribeModelList.isNotEmpty) {
                  final List<String?> subscribeModelListWithMB = <String?>[];
                  for (String? temp in subscribeModelList) {
                    subscribeModelListWithMB.add(temp! + '_MB');
                  }
                  await PsProgressDialog.showDialog(context);
                  final PsResource<ApiStatus> subscribeStatus =
                      await modelProvider!.postModelSubscribe(
                          Utils.checkUserLoginId(psValueHolder),
                          widget.manufacturer!.id!,
                          subscribeModelListWithMB);
                  PsProgressDialog.dismissDialog();
                  if (subscribeStatus.status == PsStatus.SUCCESS) {
                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext contet) {
                          return SuccessDialog(
                            message: Utils.getString(
                                context, 'Success'),
                            onPressed: () {},
                          );
                        });  
                        
                    //substract unscribed_topics from subscribed_topics (subscribe - unsubscribe)
                    Utils.subscribeToModelTopics(List<String>.from(
                        Set<String>.from(subscribeModelListWithMB)
                        .difference(Set<String>.from(unsubscribeModelListWithMB))
                    ));
                    Utils.unSubsribeFromModelTopics(unsubscribeModelListWithMB);

                    setState(() {
                      subscribeModelNoti = false;
                      subscribeModelList.clear();
                      unsubscribeModelListWithMB.clear();
                    });
                    modelProvider!.resetModelList(
                        modelProvider!.modelParameterHolder.toMap(),
                        Utils.checkUserLoginId(psValueHolder));
                  } else {
                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext contet) {
                          return ErrorDialog(
                            message:
                                Utils.getString(context, 'subscribe failed.'),
                          );
                        });
                  }
                } else {
                  setState(() {
                    subscribeModelNoti = false;
                  });
                }
              },
              child: Center(
                child: Text(Utils.getString(context, 'Done'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: PsColors.white)),
              ),
            ),
          )
      ],
      elevation: 0,
    );
  }

  @override
  void dispose() {
    animationController!.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final String categId = widget.manufacturer!.id!;
        Utils.psPrint('CategoryId number is $categId');

        modelProvider!.nextModelList(
            modelProvider!.modelParameterHolder.toMap(),
            Utils.checkUserLoginId(psValueHolder));
      }
    });
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  ModelRepository? repo1;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && psValueHolder!.isShowAdmob!) {
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    psValueHolder = Provider.of<PsValueHolder>(context);
    if (!isConnectedToInternet && psValueHolder!.isShowAdmob!) {
      print('loading ads....');
      checkConnection();
    }
    timeDilation = 1.0;
    repo1 = Provider.of<ModelRepository>(context);
    // final dynamic data = EasyLocalizationProvider.of(context).data;

    // return EasyLocalizationProvider(
    //     data: data,
    //     child:
    return Scaffold(
      appBar: searchBar.build(context),
      body: ChangeNotifierProvider<ModelProvider?>(
        lazy: false,
        create: (BuildContext context) {
          final ModelProvider provider =
              ModelProvider(repo: repo1!, psValueHolder: psValueHolder);
          modelProvider = provider;
          modelProvider!.modelParameterHolder.manufacturerId =
              widget.manufacturer!.id;
          modelProvider!.loadModelList(
              modelProvider!.modelParameterHolder.toMap(),
              Utils.checkUserLoginId(psValueHolder));

          return modelProvider;
        },
        child: Consumer<ModelProvider>(builder:
            (BuildContext context, ModelProvider provider, Widget? child) {
          return Column(
            children: <Widget>[
              const PsAdMobBannerWidget(
                admobSize: AdSize.banner,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(
                    width: PsDimens.space1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: PsDimens.space20, top: PsDimens.space16),
                    child: InkWell(
                      onTap: () {
                        showDialog<dynamic>(
                            context: context,
                            builder: (BuildContext context) {
                              return FilterDialog(
                                onAscendingTap: () async {
                                  modelProvider!.modelParameterHolder.orderBy =
                                      PsConst.FILTERING_MODEL_NAME;
                                  modelProvider!.modelParameterHolder
                                      .orderType = PsConst.FILTERING__ASC;
                                  modelProvider!.resetModelList(
                                    modelProvider!.modelParameterHolder.toMap(),
                                    Utils.checkUserLoginId(psValueHolder),
                                    //  widget.manufacturer!.id!,
                                  );
                                },
                                onDescendingTap: () {
                                  modelProvider!.modelParameterHolder.orderBy =
                                      PsConst.FILTERING_MODEL_NAME;
                                  modelProvider!.modelParameterHolder
                                      .orderType = PsConst.FILTERING__DESC;
                                  modelProvider!.resetModelList(
                                    modelProvider!.modelParameterHolder.toMap(),
                                    Utils.checkUserLoginId(psValueHolder),
                                    //  widget.manufacturer!.id!,
                                  );
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
                            physics: const AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            slivers: <Widget>[
                              SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 240.0,
                                        childAspectRatio: 1.4),
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    if (provider.modelList.status ==
                                        PsStatus.BLOCK_LOADING) {
                                      return Shimmer.fromColors(
                                          baseColor: PsColors.grey!,
                                          highlightColor: PsColors.white!,
                                          child:
                                              const Column(children: <Widget>[
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                          ]));
                                    } else {
                                      final int count = provider.modelList.data!.length; 
                                      final Model? model = provider.modelList.data![index];    

                                      if (model?.isSubscribed != null && model!.isSubscribed == PsConst.ONE 
                                              && !tempList.contains(model.id) && needToAdd) {
                                        tempList.add(model.id);
                                      }   
                                      return ModelGridItem(
                                        subScribeNoti: subscribeModelNoti,
                                        tempList: tempList,
                                        model: model!,
                                        onTap: () {
                                          if (subscribeModelNoti) {
                                              setState(() {
                                                
                                                if (tempList.contains(model.id)) {
                                                  tempList.remove(model.id);
                                                  unsubscribeModelListWithMB.add(model.id! + '_MB');
                                                }
                                                else {
                                                  tempList.add(model.id);
                                                  unsubscribeModelListWithMB.remove(model.id! + '_MB');
                                                }
                                                            

                                                if (subscribeModelList
                                                    .contains(model.id))
                                                  subscribeModelList
                                                      .remove(model.id);
                                                else
                                                  subscribeModelList
                                                      .add(model.id);
                                                needToAdd = false;      
                                              });
                                          } else {
                                            provider.itemByManufacturerIdParamenterHolder
                                                    .manufacturerId =
                                                provider.modelList.data![index]
                                                    .manufacturerId;
                                            provider.itemByManufacturerIdParamenterHolder
                                                    .modelId =
                                                provider
                                                    .modelList.data![index].id;
                                            provider.itemByManufacturerIdParamenterHolder
                                                    .itemLocationId =
                                                psValueHolder!.locationId;
                                            provider.itemByManufacturerIdParamenterHolder.
                                                    mile = 
                                                psValueHolder!.mile;       
                                            provider.itemByManufacturerIdParamenterHolder
                                                    .itemLocationName =
                                                psValueHolder!.locactionName;
                                            if (psValueHolder!.isSubLocation ==
                                                PsConst.ONE) {
                                              provider.itemByManufacturerIdParamenterHolder
                                                      .itemLocationTownshipId =
                                                  psValueHolder!
                                                      .locationTownshipId;
                                              provider.itemByManufacturerIdParamenterHolder
                                                      .itemLocationTownshipName =
                                                  psValueHolder!
                                                      .locationTownshipName;
                                            }
                                            Navigator.pushNamed(context,
                                                RoutePaths.filterProductList,
                                                arguments: ProductListIntentHolder(
                                                    appBarTitle: provider
                                                        .modelList
                                                        .data![index]
                                                        .name!,
                                                    productParameterHolder: provider
                                                        .itemByManufacturerIdParamenterHolder));
                                          }
                                        },
                                        animationController:
                                            animationController,
                                        animation:
                                            Tween<double>(begin: 0.0, end: 1.0)
                                                .animate(CurvedAnimation(
                                          parent: animationController!,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn),
                                        )),
                                      );
                                    }
                                  },
                                  childCount: provider.modelList.data!.length,
                                ),
                              ),
                            ]),
                        onRefresh: () {
                          final String loginUserId =
                              Utils.checkUserLoginId(psValueHolder);
                          return modelProvider!.resetModelList(
                            provider.modelParameterHolder.toMap(),
                            loginUserId,
                            //  widget.manufacturer!.id!
                          );
                        },
                      )),
                  PSProgressIndicator(
                    provider.modelList.status,
                    message: provider.modelList.message,
                  )
                ]),
              )
            ],
          );
        }),
      ),
    );
  }
}

class FrameUIForLoading extends StatelessWidget {
  const FrameUIForLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            height: 70,
            width: 70,
            margin: const EdgeInsets.all(PsDimens.space16),
            decoration: BoxDecoration(color: PsColors.grey)),
        Expanded(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Container(
              height: 15,
              margin: const EdgeInsets.all(PsDimens.space8),
              decoration: BoxDecoration(color: Colors.grey[300])),
          Container(
              height: 15,
              margin: const EdgeInsets.all(PsDimens.space8),
              decoration: const BoxDecoration(color: Colors.grey)),
        ]))
      ],
    );
  }
}
