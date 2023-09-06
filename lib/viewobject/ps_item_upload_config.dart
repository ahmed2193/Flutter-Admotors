import 'package:flutteradmotors/viewobject/common/ps_object.dart';
import 'package:quiver/core.dart';

class ItemUploadConfig extends PsObject<ItemUploadConfig> {
  ItemUploadConfig({
    this.itemType, this.priceType, this.condition, this.video, this.discountRate, this.businessMode,
    this.highlightInfo, this.color, this.fuelType, this.buildType, this.sellerType, this.transmissionId,
    this.plateNumber, this.enginePower, this.steeringPosition, this.noOfOwner, this.trimName, this.vehicleId,
    this.priceUnit, this.year, this.licenceStatus, this.maxPassengers, this.noOfDoors, this.mileage, 
    this.licenceExpirationDate, this.address,
    });

  String? itemType, priceType, condition, video, discountRate, businessMode, highlightInfo, color, fuelType, buildType,
    sellerType, transmissionId, plateNumber, enginePower, steeringPosition, noOfOwner, trimName, vehicleId,
    priceUnit, year, licenceStatus, maxPassengers, noOfDoors, mileage, licenceExpirationDate, address;

  @override
  bool operator ==(dynamic other) =>
      other is ItemUploadConfig && itemType == other.itemType;

  @override
  int get hashCode => hash2(itemType.hashCode, itemType.hashCode);

  @override
  String? getPrimaryKey() {
    return itemType;
  }



  @override
  ItemUploadConfig fromMap(dynamic dynamicData) {

      return ItemUploadConfig(
        itemType: dynamicData['item_type_id'],
        priceType: dynamicData['item_price_type_id'],
        condition: dynamicData['condition_of_item_id'], 
        video: dynamicData['video'],
        discountRate: dynamicData['discount_rate_by_percentage'],
        businessMode: dynamicData['business_mode'],
        highlightInfo: dynamicData['highlight_info'], 
        color: dynamicData['color_id'],
        fuelType: dynamicData['fuel_type_id'],
        buildType: dynamicData['build_type_id'],
        sellerType: dynamicData['seller_type_id'],
        transmissionId: dynamicData['transmission_id'],
        plateNumber: dynamicData['plate_number'],
        enginePower: dynamicData['engine_power'],
        steeringPosition: dynamicData['steering_position'],
        noOfOwner: dynamicData['no_of_owner'],
        trimName: dynamicData['trim_name'],
        vehicleId: dynamicData['vehicle_id'],
        priceUnit: dynamicData['price_unit'],
        year: dynamicData['year'],
        licenceStatus: dynamicData['licence_status'],
        maxPassengers: dynamicData['max_passengers'],
        noOfDoors: dynamicData['no_of_doors'],
        mileage: dynamicData['mileage'],
        licenceExpirationDate: dynamicData['licence_expiration_date'],
        address: dynamicData['address'],
      );

  }

  @override
  Map<String, dynamic>? toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['item_type_id'] = object.itemType;
      data['item_price_type_id'] = object.priceType;
      data['condition_of_item_id'] = object.condition;
      data['video'] = object.video;
      data['discount_rate_by_percentage'] = object.discountRate;
      data['business_mode'] = object.businessMode;
      data['highlight_info'] = object.highlightInfo;
      data['color_id'] = object.color;
      data['fuel_type_id'] = object.fuelType;
      data['build_type_id'] = object.buildType;
      data['seller_type_id'] = object.sellerType;
      data['transmission_id'] = object.transmissionId;
      data['plate_number'] = object.plateNumber;
      data['engine_power'] = object.enginePower;
      data['steering_position'] = object.steeringPosition;
      data['no_of_owner'] = object.noOfOwner;
      data['trim_name'] = object.trimName;
      data['vehicle_id'] = object.vehicleId;
      data['price_unit'] = object.priceUnit;
      data['year'] = object.year;
      data['licence_status'] = object.licenceStatus;
      data['max_passengers'] = object.maxPassengers;
      data['no_of_doors'] = object.noOfDoors;
      data['mileage'] = object.mileage;
      data['licence_expiration_date'] = object.licenceExpirationDate;
      data['address'] = object.address;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ItemUploadConfig> fromMapList(List<dynamic> dynamicDataList) {
    final List<ItemUploadConfig> appSettingList = <ItemUploadConfig>[];

      for (dynamic json in dynamicDataList) {
        if (json != null) {
          appSettingList.add(fromMap(json));
        }
      }
    return appSettingList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<ItemUploadConfig> objectList) {
    final List<Map<String, dynamic>?> mapList = <Map<String, dynamic>?>[];
      for (ItemUploadConfig? data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }

    return mapList;
  }
}
