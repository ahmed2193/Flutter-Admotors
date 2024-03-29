import 'dart:async';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/api/ps_api_service.dart';
import 'package:flutteradmotors/viewobject/coupon_discount.dart';

import 'Common/ps_repository.dart';

class CouponDiscountRepository extends PsRepository {
  CouponDiscountRepository({
    required PsApiService psApiService,
  }) {
    _psApiService = psApiService;
  }
  String primaryKey = 'id';
 late PsApiService _psApiService;

  Future<PsResource<CouponDiscount>> postCouponDiscount(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<CouponDiscount> _resource =
        await _psApiService.postCouponDiscount(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<CouponDiscount>> completer =
          Completer<PsResource<CouponDiscount>>();
      completer.complete(_resource);
      return completer.future;
    }
  }
}
