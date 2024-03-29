import 'dart:async';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/provider/common/ps_provider.dart';
import 'package:flutteradmotors/repository/manufacturer_repository.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/api_status.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/holder/manufacturer_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/manufacturer.dart';

class ManufacturerProvider extends PsProvider {
  ManufacturerProvider(
      {required ManufacturerRepository repo,
      required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    if (limit != 0) {
      super.limit = limit;
    }

    _repo = repo;

    print('Manufacturer Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    manufacturerListStream =
        StreamController<PsResource<List<Manufacturer>>>.broadcast();
    subscription = manufacturerListStream.stream
        .listen((PsResource<List<Manufacturer>> resource) {
      updateOffset(resource.data!.length);

      _manufacturerList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
 late StreamController<PsResource<List<Manufacturer>>> manufacturerListStream;
  final ManufacturerParameterHolder manufacturerParameterHolder= ManufacturerParameterHolder().getLatestParameterHolder();

 late ManufacturerRepository _repo;
  PsValueHolder? psValueHolder;

  PsResource<List<Manufacturer>> _manufacturerList =
      PsResource<List<Manufacturer>>(PsStatus.NOACTION, '', <Manufacturer>[]);

  PsResource<List<Manufacturer>> get manufacturerList => _manufacturerList;
 late StreamSubscription<PsResource<List<Manufacturer>>> subscription;

  PsResource<ApiStatus> _apiStatus =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get user => _apiStatus;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Manufacturer Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadManufacturerList( Map<dynamic, dynamic> jsonMap, String loginUserId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (isConnectedToInternet) {
      await _repo.getManufacturerList(manufacturerListStream,jsonMap, loginUserId,
          isConnectedToInternet,  limit, offset!, PsStatus.PROGRESS_LOADING);
    }

    return isConnectedToInternet;
  }

  Future<dynamic> nextManufacturerList(Map<dynamic, dynamic> jsonMap, String loginUserId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo.getNextPageManufacturerList(manufacturerListStream,jsonMap, loginUserId,
          isConnectedToInternet ,limit, offset!, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<dynamic> resetManufacturerList(Map<dynamic, dynamic> jsonMap, String loginUserId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    if (isConnectedToInternet) {
      await _repo.getManufacturerList(manufacturerListStream,jsonMap, loginUserId, 
          isConnectedToInternet,limit, offset!, PsStatus.PROGRESS_LOADING);
    }

    isLoading = false;
    return isConnectedToInternet;
  }

  Future<dynamic> postTouchCount(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.postTouchCount(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }
}
