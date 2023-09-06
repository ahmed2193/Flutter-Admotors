import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/ui/common/base/ps_widget_with_appbar_with_no_provider.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/holder/product_parameter_holder.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapFilterView extends StatefulWidget {
  const MapFilterView({required this.productParameterHolder});

  final ProductParameterHolder productParameterHolder;

  @override
  _MapFilterViewState createState() => _MapFilterViewState();
}

class _MapFilterViewState extends State<MapFilterView>
    with TickerProviderStateMixin {
  List<String> seekBarValues = <String>[
    '0.5',
    '1',
    '2.5',
    '5',
    '10',
    '25',
    '50',
    '100',
    '200',
    '500',
    'All'
  ];
  LatLng? latlng;
  final double zoom = 10;
  double radius = -1;
  double defaultRadius = 3000;
  bool isRemoveCircle = false;
  String address = '';
  bool isFirst = true;
   PsValueHolder? valueHolder;

  double _value = 0.3;
  String kmValue = '5';

  int findTheIndexOfTheValue(String value) {
    int index = 0;

    for (int i = 0; i < seekBarValues.length - 1; i++) {
      if (!(value == 'All')) {
        if (getMiles(seekBarValues[i]) == value) {
          index = i;
          break;
        }
      } else {
        index = seekBarValues.length - 1;
      }
    }

    return index;
  }

  String getMiles(String kmValue) {
    final double _km = double.parse(kmValue);
    return (_km * 0.621371).toStringAsFixed(3);
  }

  @override
  Widget build(BuildContext context) {
     valueHolder = Provider.of<PsValueHolder>(context, listen: false);
    latlng ??= LatLng(double.parse(widget.productParameterHolder.lat!),
        double.parse(widget.productParameterHolder.lng!));

    if (widget.productParameterHolder.mile != '' && isFirst) {
      final int _index =
          findTheIndexOfTheValue(widget.productParameterHolder.mile!);
      kmValue = seekBarValues[_index];
      final double _val = double.parse(getMiles(kmValue)) * 1000;
      radius = _val;
      defaultRadius = radius;
      _value = _index / 10;
      isFirst = false;
    }

    final double scale = defaultRadius / 300; //radius/20
    final double value = 16 - log(scale) / log(2);
    // loadAddress();

    print('value $value');

    final List<CircleMarker> circleMarkers = <CircleMarker>[
      CircleMarker(
          point: latlng!, //LatLng(51.5, -0.09),
          color: Colors.blue.withOpacity(0.7),
          borderStrokeWidth: 2,
          useRadiusInMeter: true,
          radius: isRemoveCircle == true
              ? 0.0
              : radius <= 0.0
                  ? defaultRadius
                  : radius //2000 // 2000 meters | 2 km//radius

          ),
    ];

    return PsWidgetWithAppBarWithNoProvider(
        appBarTitle: Utils.getString(context, 'map_filter__title'),
        actions: <Widget>[
          InkWell(
            child: Center(
              child: Text(
                Utils.getString(context, 'map_filter__reset'),
                textAlign: TextAlign.justify,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold)
                    .copyWith(color: PsColors.mainColorWithWhite),
              ),
            ),
            onTap: () {
              if (mounted) {
                setState(() {
                  isRemoveCircle = true;
                  _value = 1.0;
                });
              }
            },
          ),
          const SizedBox(
            width: PsDimens.space20,
          ),
          InkWell(
            child: Center(
              child: Text(
                Utils.getString(context, 'map_filter__apply'),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold)
                    .copyWith(color: PsColors.mainColorWithWhite),
              ),
            ),
            onTap: () {
              if (kmValue == 'All') {
                widget.productParameterHolder.lat = '';
                widget.productParameterHolder.lng = '';
                widget.productParameterHolder.mile = '';
             if (valueHolder!.isSubLocation == PsConst.ONE) {
                  widget.productParameterHolder.itemLocationId = '';
                } else {
                  widget.productParameterHolder.itemLocationId = '';
                  widget.productParameterHolder.itemLocationTownshipId = '';

                }
              } else {
                widget.productParameterHolder.lat = latlng!.latitude.toString();
                widget.productParameterHolder.lng = latlng!.longitude.toString();
                widget.productParameterHolder.mile = getMiles(kmValue);
              }
              Navigator.pop(context, widget.productParameterHolder);
            },
          ),
          const SizedBox(
            width: PsDimens.space16,
          ),
        ],
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Flexible(
                child: FlutterMap(
                  options: MapOptions(
                      center:
                          latlng, //LatLng(51.5, -0.09), //LatLng(45.5231, -122.6765),
                      zoom: value, //10.0,
                      onTap: _handleTap),
                      children: [
                         CircleLayer(circles: circleMarkers),
                         TileLayer(
                       urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: <String>['a', 'b', 'c'] 
                         ),
                
                      ],
                  
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: PsDimens.space8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      Utils.getString(context, 'map_filter__browsing'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Utils.getString(context, 'map_filter__all'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                child: Slider(
                  value: _value,
                  onChanged: (double newValue) {
                    if (mounted) {
                      setState(() {
                        _value = newValue;
                        kmValue = seekBarValues[(_value * 10).toInt()];
                        if (kmValue == 'All') {
                          isRemoveCircle = true;
                        } else {
                          radius = double.parse(getMiles(kmValue)) *
                              1000; //_value * 10000;
                        }
                        _value == 1
                            ? isRemoveCircle = true
                            : isRemoveCircle = false;
                        defaultRadius != 0
                            ? defaultRadius = 500
                            : defaultRadius = 500;
                      });
                    }
                  },
                  divisions: 10,
                  label: _value == 1
                      ? seekBarValues[(_value * 10).toInt()]
                      : seekBarValues[(_value * 10).toInt()] +
                          Utils.getString(context, 'map_filter__km'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: PsDimens.space8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      Utils.getString(context, 'map_filter__lowest_km'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Utils.getString(context, 'map_filter__all'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void _handleTap(dynamic tapPosition, LatLng latlng) {
    if (mounted) {
      setState(() {
        this.latlng = latlng;
      });
    }
  }
}
