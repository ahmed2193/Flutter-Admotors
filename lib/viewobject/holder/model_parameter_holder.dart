import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/viewobject/common/ps_holder.dart';

class ModelParameterHolder extends PsHolder<dynamic> {
  ModelParameterHolder() {
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__ASC;
    keyword = '';
    manufacturerId = '';
  }

   String? orderBy;
   String? orderType;
   String? keyword;
   String? manufacturerId;

  ModelParameterHolder getTrendingParameterHolder() {
    orderBy = PsConst.FILTERING__TRENDING;
    orderType = PsConst.FILTERING__ASC;
    keyword = '';
    manufacturerId = '';

    return this;
  }

  ModelParameterHolder getLatestParameterHolder() {
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__ASC;
    keyword = '';
    manufacturerId = '';

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['order_by'] = orderBy;
    map['order_type'] = orderType;
    map['keyword'] = keyword;
    map['manufacturer_id'] = manufacturerId;

    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__ASC;
    keyword = dynamicData['keyword'];
    manufacturerId = dynamicData['manufacturer_id'];

    return this;
  }

  @override
  String getParamKey() {
    String result = '';

    if (orderBy != '') {
      result += orderBy! + ':';
    }
    if (orderType != '') {
      result += orderType! + ':';
    }
    if (keyword != '') {
      result += keyword! + ':';
    }
    if (manufacturerId != '') {
      result += manufacturerId!;
    }

    return result;
  }
}
