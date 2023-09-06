import 'dart:async';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/provider/common/ps_provider.dart';
import 'package:flutteradmotors/repository/model_repository.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/api_status.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/holder/model_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/holder/product_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/holder/subscribe_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/model.dart';

class ModelProvider extends PsProvider {
  ModelProvider({required ModelRepository repo, this.psValueHolder,  int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('Model Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    modelListStream = StreamController<PsResource<List<Model>>>.broadcast();
    subscription = modelListStream.stream.listen((dynamic resource) {
      updateOffset(resource.data.length);

      _modelList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

 late StreamController<PsResource<List<Model>>> modelListStream;
 late ModelRepository _repo;

  PsResource<List<Model>> _modelList =
      PsResource<List<Model>>(PsStatus.NOACTION, '', <Model>[]);

  PsResource<List<Model>> get modelList => _modelList;
 late StreamSubscription<PsResource<List<Model>>> subscription;

 PsResource<ApiStatus> _apiStatus =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get apiStatus => _apiStatus;

//  String manufacturerId = '';
  PsValueHolder? psValueHolder;
  ProductParameterHolder itemByManufacturerIdParamenterHolder =
      ProductParameterHolder().getItemByManufacturerIdParameterHolder();
  final ModelParameterHolder modelParameterHolder = ModelParameterHolder().getLatestParameterHolder();

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Model Provider Dispose: $hashCode');
    super.dispose();
  }

  // ProductParameterHolder productParameterHolder;
  Future<dynamic> loadModelList(Map<dynamic, dynamic> jsonMap, String loginUserId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getModelListByManufacturerId(
        modelListStream,
        jsonMap,
        loginUserId,
        isConnectedToInternet,
        limit,
        offset!,
        PsStatus.PROGRESS_LOADING,
        );
  }

  Future<dynamic> loadAllModelList(Map<dynamic, dynamic> jsonMap, String manufacturerId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllModelListByManufacturerId(modelListStream,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING,jsonMap, manufacturerId);
  }

  Future<dynamic> nextModelList(Map<dynamic, dynamic> jsonMap, String loginUserId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo.getNextPageModelList(modelListStream,jsonMap,loginUserId, isConnectedToInternet,
          limit, offset!, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetModelList(Map<dynamic, dynamic> jsonMap, String loginUserId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    isLoading = true;

    updateOffset(0);

    await _repo.getModelListByManufacturerId(
        modelListStream,
        jsonMap,
        loginUserId,
        isConnectedToInternet,
        limit,
        offset!,
        PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }

Future<dynamic> postModelSubscribe(
    String userId, String manufacturerId, List<String?> modelList) async {

    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
      final SubscribeParameterHolder subscribeParameterHolder = 
        SubscribeParameterHolder(
          userId: userId,
          catId: manufacturerId,
          selectedModels: modelList);

    _apiStatus = await _repo.postModelSubscribe(
        subscribeParameterHolder.toMap(), isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }
}
