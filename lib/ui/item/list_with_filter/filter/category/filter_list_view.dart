import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_admob_banner_widget.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/provider/manufacturer/manufacturer_provider.dart';
import 'package:flutteradmotors/repository/manufacturer_repository.dart';
import 'package:flutteradmotors/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'filter_expantion_tile_view.dart';

class FilterListView extends StatefulWidget {
  const FilterListView({this.selectedData});

  final dynamic selectedData;

  @override
  State<StatefulWidget> createState() => _FilterListViewState();
}

class _FilterListViewState extends State<FilterListView> {
  final ScrollController _scrollController = ScrollController();

  // final ManufacturerParameterHolder categoryIconList = ManufacturerParameterHolder();
  ManufacturerRepository? categoryRepository;
  PsValueHolder? psValueHolder;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onModelClick(Map<String, String> model) {
    Navigator.pop(context, model);
  }

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
    categoryRepository = Provider.of<ManufacturerRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    if (!isConnectedToInternet && psValueHolder!.isShowAdmob!) {
      print('loading ads....');
      checkConnection();
    }
    
    return PsWidgetWithAppBar<ManufacturerProvider>(
        appBarTitle: Utils.getString(context, 'search__manufacturer'),
        initProvider: () {
          return ManufacturerProvider(
              repo: categoryRepository!, psValueHolder: psValueHolder);
        },
        onProviderReady: (ManufacturerProvider provider) {
          provider.loadManufacturerList(provider.manufacturerParameterHolder.toMap(),
              Utils.checkUserLoginId(provider.psValueHolder));
        },
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.read_more, color: PsColors.mainColor),
            onPressed: () {
              final Map<String, String> dataHolder = <String, String>{};
              dataHolder[PsConst.MANUFACTURER_ID] = '';
              dataHolder[PsConst.MODEL_ID] = '';
              dataHolder[PsConst.MANUFACTURER_NAME] = '';
              onModelClick(dataHolder);
            },
          )
        ],
        builder: (BuildContext context, ManufacturerProvider provider,
            Widget? child) {
          return Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const PsAdMobBannerWidget(
                    admobSize: AdSize.banner,
                  ),
                  Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: provider.manufacturerList.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (provider.manufacturerList.data != null ||
                              provider.manufacturerList.data!.isEmpty) {
                            return FilterExpantionTileView(
                                selectedData: widget.selectedData,
                                category:
                                    provider.manufacturerList.data![index],
                                onModelClick: onModelClick);
                          } else {
                            return Container();
                          }
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }
}
