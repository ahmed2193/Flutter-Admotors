import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/ui/common/base/ps_widget_with_appbar_with_no_provider.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/map_pin_call_back_holder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

class MapPinView extends StatefulWidget {
  const MapPinView(
      {required this.flag, required this.maplat, required this.maplng});

  final String flag;
  final String maplat;
  final String maplng;

  @override
  _MapPinViewState createState() => _MapPinViewState();
}

class _MapPinViewState extends State<MapPinView> with TickerProviderStateMixin {
  LatLng? latlng;
  double defaultRadius = 3000;
  String address = '';

  Future<void> loadAddress() async {
    await placemarkFromCoordinates(
            latlng!.latitude,
            latlng!.longitude)
        .then((List<Placemark> placemarks) {
      final Placemark place = placemarks[0];
      setState(() {
        address =
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((dynamic e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    latlng ??= LatLng(double.parse(widget.maplat), double.parse(widget.maplng));
    const double value = 16.0;
    // final double scale = defaultRadius / 200; //radius/20
    // final double value = 16 - log(scale) / log(2);
    loadAddress();

    print('value $value');

    return PsWidgetWithAppBarWithNoProvider(
        appBarTitle: Utils.getString(context, 'location_tile__title'),
        actions: widget.flag == PsConst.PIN_MAP
            ? <Widget>[
                InkWell(
                  child: Ink(
                    child: Center(
                      child: Text(
                        Utils.getString(context, 'map_pin__pick_location'),
                        textAlign: TextAlign.justify,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold)
                            .copyWith(color: PsColors.mainColorWithWhite),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context,
                        MapPinCallBackHolder(address: address, latLng: latlng!));
                  },
                ),
                const SizedBox(
                  width: PsDimens.space16,
                ),
              ]
            : <Widget>[],
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Flexible(
                child: FlutterMap(
                  options: MapOptions(
                      center:
                          latlng, //LatLng(51.5, -0.09), //LatLng(45.5231, -122.6765),
                      zoom: value, //10.0,
                      onTap: widget.flag == PsConst.PIN_MAP
                          ? _handleTap
                          : _doNothingTap),
                              children: [
                         CircleLayer( circles: <CircleMarker>[
                        CircleMarker(
                            point: latlng!,
                            color: Colors.blue.withOpacity(0.7),
                            borderStrokeWidth: 2,
                            useRadiusInMeter: true,
                            radius: 200),
                      ],),
                         TileLayer(
                       urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        
                         ),
                
                      ],
         
                    // MarkerLayerOptions(markers: <Marker>[
                    //   Marker(
                    //     width: 80.0,
                    //     height: 80.0,
                    //     point: latlng,
                    //     builder: (BuildContext ctx) => Container(
                    //       child: IconButton(
                    //         icon: Icon(
                    //           Icons.location_on,
                    //           color: PsColors.mainColor,
                    //         ),
                    //         iconSize: 45,
                    //         onPressed: () {},
                    //       ),
                    //     ),
                    //   )
                    // ])
              
                ),
              ),
            ],
          ),
        ));
  }

  void _handleTap(dynamic tapPosition,LatLng latlng) {
    if (mounted) {
      setState(() {
        this.latlng = latlng;
      });
    }
  }

  void _doNothingTap(dynamic tapPosition, LatLng latlng) {}
}
