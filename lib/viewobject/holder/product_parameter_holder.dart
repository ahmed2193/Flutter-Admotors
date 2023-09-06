
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/viewobject/common/ps_holder.dart';

class   ProductParameterHolder extends PsHolder<dynamic> {
  ProductParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    modelId = '';
    itemTypeId = '';
    itemTypeName = '';
    itemPriceTypeId = '';
    itemPriceTypeName = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    conditionOfItemId = '';
    itemConditionName = '';
    colorId = '';
    colorName = '';
    isSoldOut = '';
    soldOutName = '';
    fuelTypeId = '';
    fuelTypeName = '';
    buildTypeId = '';
    buildTypeName = '';
    sellerTypeId = '';
    sellerTypeName = '';
    transmissionId = '';
    transmissionName = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    addedUserId = '';
    isPaid = '';
    status = '1';
    isDiscount = '';
  }

  String? searchTerm;
  String? manufacturerId;
  String? modelId;
  String? itemTypeId;
  String? itemTypeName;
  String? itemPriceTypeId;
  String? itemPriceTypeName;
  String? itemCurrencyId;
  String? itemLocationId;
  String? itemLocationName;
  String? itemLocationTownshipId;
  String? itemLocationTownshipName;
  String? conditionOfItemId;
  String? itemConditionName;
  String? colorId;
  String? colorName;
  String? isSoldOut;
  String? soldOutName;
  String? fuelTypeId;
  String? fuelTypeName;
  String? buildTypeId;
  String? buildTypeName;
  String? sellerTypeId;
  String? sellerTypeName;
  String? transmissionId;
  String? transmissionName;
  String? maxPrice;
  String? minPrice;
  String? brand;
  String? lat;
  String? lng;
  String? mile;
  String? orderBy;
  String? orderType;
  String? addedUserId;
  String? isPaid;
  String? status;
  String? isDiscount;

  bool isFiltered() {
    return !(
        // isAvailable == '' &&
        //   (isDiscount == '0' || isDiscount == '') &&
        //   (isFeatured == '0' || isFeatured == '') &&
        orderBy == '' &&
            orderType == '' &&
            minPrice == '' &&
            maxPrice == '' &&
            itemTypeId == '' &&
            conditionOfItemId == '' &&
            itemPriceTypeId == '' &&
            fuelTypeId == '' &&
            buildTypeId == '' &&
            sellerTypeId == '' &&
            transmissionId == '' &&
            isSoldOut == '' &&
            searchTerm == '' &&
            lat == '' &&
            lng == '' &&
            mile == '');
  }

  bool isCatAndSubCatFiltered() {
    return !(manufacturerId == '' && modelId == '');
  }

  ProductParameterHolder getRecentParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    modelId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    conditionOfItemId = '';
    colorId = '';
    isSoldOut = '';
    fuelTypeId = '';
    buildTypeId = '';
    sellerTypeId = '';
    transmissionId = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '';

    return this;
  }

  ProductParameterHolder getDiscountParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    modelId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    conditionOfItemId = '';
    colorId = '';
    isSoldOut = '';
    fuelTypeId = '';
    buildTypeId = '';
    sellerTypeId = '';
    transmissionId = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '1';

    return this;
  }

      ProductParameterHolder getSoldOutParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    modelId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    conditionOfItemId = '';
    colorId = '';
    isSoldOut = '1';
    fuelTypeId = '';
    buildTypeId = '';
    sellerTypeId = '';
    transmissionId = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '';

    return this;
  }

  ProductParameterHolder getNearestParameterHolder() {
    searchTerm = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';

    return this;
  }

  ProductParameterHolder getPaidItemParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    modelId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    conditionOfItemId = '';
    colorId = '';
    isSoldOut = '';
    fuelTypeId = '';
    buildTypeId = '';
    sellerTypeId = '';
    transmissionId = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = PsConst.ONLY_PAID_ITEM;
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '';

    return this;
  }

  ProductParameterHolder getPendingItemParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    modelId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    conditionOfItemId = '';
    colorId = '';
    isSoldOut = '';
    fuelTypeId = '';
    buildTypeId = '';
    sellerTypeId = '';
    transmissionId = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '0';
    isDiscount = '';

    return this;
  }

  ProductParameterHolder getRejectedItemParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    modelId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    conditionOfItemId = '';
    colorId = '';
    isSoldOut = '';
    fuelTypeId = '';
    buildTypeId = '';
    sellerTypeId = '';
    transmissionId = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '3';
    isDiscount = '';

    return this;
  }

  ProductParameterHolder getDisabledProductParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    modelId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    conditionOfItemId = '';
    colorId = '';
    isSoldOut = '';
    fuelTypeId = '';
    buildTypeId = '';
    sellerTypeId = '';
    transmissionId = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '2';
    isDiscount = '';

    return this;
  }

  ProductParameterHolder getItemByManufacturerIdParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    modelId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    conditionOfItemId = '';
    colorId = '';
    isSoldOut = '';
    fuelTypeId = '';
    buildTypeId = '';
    sellerTypeId = '';
    transmissionId = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '';

    return this;
  }

  ProductParameterHolder getPopularParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    modelId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    conditionOfItemId = '';
    colorId = '';
    isSoldOut = '';
    fuelTypeId = '';
    buildTypeId = '';
    sellerTypeId = '';
    transmissionId = '';
    maxPrice = '';
    minPrice = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING_TRENDING;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '';

    return this;
  }

  ProductParameterHolder getLatestParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    modelId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    conditionOfItemId = '';
    colorId = '';
    isSoldOut = '';
    fuelTypeId = '';
    buildTypeId = '';
    sellerTypeId = '';
    transmissionId = '';
    maxPrice = '';
    minPrice = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '';

    return this;
  }

  ProductParameterHolder resetParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    modelId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    conditionOfItemId = '';
    colorId = '';
    isSoldOut = '';
    fuelTypeId = '';
    buildTypeId = '';
    sellerTypeId = '';
    transmissionId = '';
    maxPrice = '';
    minPrice = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '';

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['searchterm'] = searchTerm;
    map['manufacturer_id'] = manufacturerId;
    map['model_id'] = modelId;
    map['item_type_id'] = itemTypeId;
    map['item_price_type_id'] = itemPriceTypeId;
    map['item_currency_id'] = itemCurrencyId;
    map['item_location_id'] = itemLocationId;
    map['item_location_township_id'] = itemLocationTownshipId;
    map['condition_of_item_id'] = conditionOfItemId;
    map['color_id'] = colorId;
    map['is_sold_out'] = isSoldOut;
    map['fuel_type_id'] = fuelTypeId;
    map['build_type_id'] = buildTypeId;
    map['seller_type_id'] = sellerTypeId;
    map['transmission_id'] = transmissionId;
    map['max_price'] = maxPrice;
    map['min_price'] = minPrice;
    map['lat'] = lat;
    map['lng'] = lng;
    map['miles'] = mile;
    map['added_user_id'] = addedUserId;
    map['ad_post_type'] = isPaid;
    map['order_by'] = orderBy;
    map['order_type'] = orderType;
    map['status'] = status;
    map['is_discount'] = isDiscount;
    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    searchTerm = '';
    manufacturerId = '';
    modelId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationTownshipId = '';
    conditionOfItemId = '';
    colorId = '';
    isSoldOut = '';
    fuelTypeId = '';
    buildTypeId = '';
    sellerTypeId = '';
    transmissionId = '';
    maxPrice = '';
    minPrice = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '';
    isDiscount = '';

    return this;
  }

  @override
  String getParamKey() {
    String result = '';

    if (searchTerm != '') {
      result += searchTerm! + ':';
    }
    if (manufacturerId != '') {
      result += manufacturerId! + ':';
    }
    if (modelId != '') {
      result += modelId! + ':';
    }
    if (itemTypeId != '') {
      result += itemTypeId! + ':';
    }
    if (itemPriceTypeId != '') {
      result += itemPriceTypeId! + ':';
    }
    if (itemCurrencyId != '') {
      result += itemCurrencyId! + ':';
    }
    if (itemLocationId != '') {
      result += itemLocationId! + ':';
    }
    if (itemLocationTownshipId != '') {
      result += itemLocationTownshipId! + ':';
    }
    if (conditionOfItemId != '') {
      result += conditionOfItemId !+ ':';
    }
    if (colorId != '') {
      result += colorId! + ':';
    }
    if (isSoldOut != '') {
      result += isSoldOut! + ':';
    }
    if (fuelTypeId != '') {
      result += fuelTypeId! + ':';
    }
    if (buildTypeId != '') {
      result += buildTypeId! + ':';
    }
    if (sellerTypeId != '') {
      result += sellerTypeId! + ':';
    }
    if (transmissionId != '') {
      result += transmissionId! + ':';
    }
    if (maxPrice != '') {
      result += maxPrice! + ':';
    }
    if (minPrice != '') {
      result += minPrice! + ':';
    }
    if (brand != '') {
      result += brand! + ':';
    }
    if (lat != '') {
      result += lat! + ':';
    }
    if (lng != '') {
      result += lng! + ':';
    }
    if (mile != '') {
      result += mile! + ':';
    }
    if (addedUserId != '') {
      result += addedUserId! + ':';
    }
    if (isPaid != '') {
      result += isPaid! + ':';
    }
    if (status != '') {
      result += status! + ':';
    }
    if (orderBy != '') {
      result += orderBy! + ':';
    }
    if (orderType != '') {
      result += orderType! + ':';
    }
    if (isDiscount != '') {
      result += isDiscount!;
    }

    return result;
  }
}
