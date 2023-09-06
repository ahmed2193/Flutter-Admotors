import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/viewobject/common/ps_holder.dart';

class ManufacturerParameterHolder extends PsHolder<dynamic> {
  ManufacturerParameterHolder() {
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__ASC;
    keyword = '';
  }

  String? keyword;
  String? orderBy;
  String? orderType;

  ManufacturerParameterHolder getTrendingParameterHolder() {
    orderBy = PsConst.FILTERING__TRENDING;
    orderType = PsConst.FILTERING__ASC;
    keyword = '';

    return this;
  }

  ManufacturerParameterHolder getLatestParameterHolder() {
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__ASC;
    keyword = '';

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['order_by'] = orderBy;
    map['order_type'] = orderType;
    map['keyword'] = keyword;

    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    keyword = dynamicData['keyword'];
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
      result += keyword!;
    }

    return result;
  }
}
