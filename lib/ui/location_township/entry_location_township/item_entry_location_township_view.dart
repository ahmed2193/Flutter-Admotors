import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/provider/item_location_township/item_location_township_provider.dart';
import 'package:flutteradmotors/repository/item_location_township_repository.dart';
import 'package:flutteradmotors/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradmotors/ui/common/ps_frame_loading_widget.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/ui/location_township/item_location_township_view.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'item_entry_location_township_list_view_item.dart';

class ItemEntryLocationTownshipView extends StatefulWidget {
  const ItemEntryLocationTownshipView({required this.cityId});

  final String cityId;
  @override
  State<StatefulWidget> createState() {
    return ItemEntryLocationTownshipViewState();
  }
}

class ItemEntryLocationTownshipViewState
    extends State<ItemEntryLocationTownshipView> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  ItemLocationTownshipProvider? _itemLocationTownshipProvider;
  AnimationController? animationController;
  Animation<double>? animation;
  PsValueHolder? valueHolder;

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
        _itemLocationTownshipProvider!.nextItemLocationTownshipListByCityId(
            _itemLocationTownshipProvider!.latestLocationParameterHolder.toMap(),
            _itemLocationTownshipProvider!.psValueHolder!.loginUserId!,
            widget.cityId);
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    animation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(animationController!);
    super.initState();
  }

  ItemLocationTownshipRepository? repo1;

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context);
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

    repo1 = Provider.of<ItemLocationTownshipRepository>(context);

    print(
        '............................Build UI Again ............................');

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<ItemLocationTownshipProvider>(
          appBarTitle:
              Utils.getString(context, 'item_entry__location_township'),
          initProvider: () {
            return ItemLocationTownshipProvider(
                repo: repo1!, psValueHolder: valueHolder);
          },
          onProviderReady: (ItemLocationTownshipProvider provider) {
            provider.latestLocationParameterHolder.keyword =
                searchNameController.text;
            provider.loadItemLocationTownshipListByCityId(
                provider.latestLocationParameterHolder.toMap(),
                Utils.checkUserLoginId(provider.psValueHolder),
                widget.cityId);
            _itemLocationTownshipProvider = provider;
          },
          builder: (BuildContext context, ItemLocationTownshipProvider provider,
              Widget? child) {
            return Stack(children: <Widget>[
              Container(
                  child: RefreshIndicator(
                child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: provider.itemLocationTownshipList.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (provider.itemLocationTownshipList.status ==
                          PsStatus.BLOCK_LOADING) {
                        return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.white,
                            child: const Column(children: <Widget>[
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                            ]));
                      } else {
                        final int count =
                            provider.itemLocationTownshipList.data!.length;
                        animationController!.forward();
                        return FadeTransition(
                            opacity: animation!,
                            child: ItemEntryLocationTownshipListViewItem(
                              itemLocationTownship:
                                  provider.itemLocationTownshipList.data![index],
                              onTap: () {
                                Navigator.pop(
                                    context,
                                    provider
                                        .itemLocationTownshipList.data![index]);
                                print(provider.itemLocationTownshipList
                                    .data![index].townshipName);
                              },
                              animationController: animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animationController!,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                            ));
                      }
                    }),
                onRefresh: () {
                  return provider.resetItemLocationTownshipListByCityId(
                      provider.latestLocationParameterHolder.toMap(),
                      Utils.checkUserLoginId(provider.psValueHolder),
                      widget.cityId);
                },
              )),
              PSProgressIndicator(provider.itemLocationTownshipList.status)
            ]);
          }),
    );
  }
}
