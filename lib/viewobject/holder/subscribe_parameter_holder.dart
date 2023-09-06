
import 'package:flutteradmotors/viewobject/common/ps_holder.dart'
    show PsHolder;

class SubscribeParameterHolder
    extends PsHolder<SubscribeParameterHolder> {
  SubscribeParameterHolder({
    required this.userId,
    required this.catId,
    required this.selectedModels,
  });
  final String userId;
  final String catId;
  final List<String?>  selectedModels;
  
  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['user_id'] = userId;
    map['manufacturer_id'] = catId;
    map['model_ids'] = selectedModels;
    return map;
  }

  @override
  SubscribeParameterHolder fromMap(dynamic dynamicData) {
    return SubscribeParameterHolder(
      userId: dynamicData['user_id'],
      catId: dynamicData['manufacturer_id'],
      selectedModels: dynamicData['model_ids'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (userId != '') {
      key += userId;
    }
    if (catId != '') {
      key += catId;
    }
    if (selectedModels.toString()  != '') {
      key += selectedModels.toString();
    }

    return key;
  }
}