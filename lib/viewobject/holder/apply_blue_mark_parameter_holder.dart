import 'package:flutter/cupertino.dart';
import 'package:flutteradmotors/viewobject/common/ps_holder.dart'
    show PsHolder;

class ApplyBluemarkParameterHolder
    extends PsHolder<ApplyBluemarkParameterHolder> {
  ApplyBluemarkParameterHolder(
      {@required this.userId, @required this.note});

  final String? userId;
  final String? note;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['user_id'] = userId;
    map['note'] = note;

    return map;
  }

  @override
  ApplyBluemarkParameterHolder fromMap(dynamic dynamicData) {
    return ApplyBluemarkParameterHolder(
      userId: dynamicData['user_id'],
      note: dynamicData['note'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (userId != '') {
      key += userId!;
    }
    if (note != '') {
      key += note!;
    }
    return key;
  }
}