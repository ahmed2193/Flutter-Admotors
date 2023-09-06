import 'package:flutter/material.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/ui/common/base/ps_widget_with_appbar_with_no_provider.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/product.dart';

import 'item_sold_out_list_item.dart';

class ItemSoldOutListView extends StatefulWidget {
  const ItemSoldOutListView({Key? key, required this.itemSoldOutName})
      : super(key: key);
  final String? itemSoldOutName;
  @override
  State<StatefulWidget> createState() {
    return _ItemSoldOutListViewState();
  }
}

class _ItemSoldOutListViewState extends State<ItemSoldOutListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  // ItemSoldOutProvider _itemSoldOutProvider;
  AnimationController? animationController;
  Animation<double>? animation;
  List<Product>? productSoldOutList;

  @override
  void dispose() {
    animationController!.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     _itemSoldOutProvider.nextItemColorList();
    //   }
    // });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    animation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(animationController!);
    super.initState();
  }

//  ItemColorRepository itemColorRepo;
  String selectedName = 'selectedName';

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController!.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          if (selectedName == '') {
            Navigator.pop(context, true);
          } else {
            Navigator.pop(context, false);
          }
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

//    itemColorRepo = Provider.of<ItemColorRepository>(context);
    productSoldOutList = <Product>[
      Product(isSoldOut: '0'),
      Product(isSoldOut: '1'),
    ];

    print(
        '............................Build UI Again ............................');
    if (widget.itemSoldOutName != null && selectedName != '') {
      selectedName = widget.itemSoldOutName!;
    }
    return WillPopScope(
        onWillPop: _requestPop,
        child: PsWidgetWithAppBarWithNoProvider(
            appBarTitle: Utils.getString(context, 'item_entry__sold_out'
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.read_more, color: PsColors.mainColor),
                  onPressed: () {
                    if (mounted) {
                      setState(() {
                        selectedName = '';
                      });
                    }
                  }),
            ],
            child: Stack(children: <Widget>[
              // Container(
              //     child:
              ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: productSoldOutList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final int count = productSoldOutList!.length;
                    animationController!.forward();
                    return FadeTransition(
                        opacity: animation!,
                        child: ItemSoldOutListItem(
                          animationController: animationController,
                          animation:
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animationController!,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn),
                            ),
                          ),
                          isSoldOutName: productSoldOutList![index].isSoldOut ==
                                  PsConst.ZERO
                              ? 'Not Sold Yet'
                              : 'Sold Out',
                          onTap: () {
                            final Product colorValue =
                                productSoldOutList![index];
                            Navigator.pop(context, colorValue);
                          },
                          selectedName: selectedName,
                        ));
                  }),
            ])));
  }
}
