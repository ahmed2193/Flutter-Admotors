import 'dart:async';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/api/ps_api_service.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/db/model_dao.dart';
import 'package:flutteradmotors/repository/Common/ps_repository.dart';
import 'package:flutteradmotors/viewobject/api_status.dart';
import 'package:flutteradmotors/viewobject/model.dart';
import 'package:sembast/sembast.dart';

class ModelRepository extends PsRepository {
  ModelRepository(
      {required PsApiService psApiService, required ModelDao modelDao}) {
    _psApiService = psApiService;
    _modelDao = modelDao;
  }

 late PsApiService _psApiService;
 late ModelDao _modelDao;
  final String _primaryKey = 'id';

  Future<dynamic> insert(Model model) async {
    return _modelDao.insert(_primaryKey, model);
  }

  Future<dynamic> update(Model model) async {
    return _modelDao.update(model);
  }

  Future<dynamic> delete(Model model) async {
    return _modelDao.delete(model);
  }

  Future<dynamic> getModelListByManufacturerId(
      StreamController<PsResource<List<Model>>> modelListStream,
      Map<dynamic, dynamic> jsonMap,
      String loginUserId,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
    //  String categoryId,
      {bool isLoadFromServer = true}) async {
    // final Finder finder =
    //     Finder(filter: Filter.equals('manufacturer_id', categoryId));

    modelListStream.sink
        .add(await _modelDao.getAll(status: status));

    final PsResource<List<Model>> _resource =
        await _psApiService.getModelList(jsonMap,loginUserId,limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      await _modelDao.deleteAll();
      await _modelDao.insertAll(_primaryKey, _resource.data!);
    } else {
      if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        await _modelDao.deleteAll();
      }
    }
    modelListStream.sink.add(await _modelDao.getAll());
  }

  Future<dynamic> getAllModelListByManufacturerId(
      StreamController<PsResource<List<Model>>> modelListStream,
      bool isConnectedToIntenet,
      PsStatus status,
      Map<dynamic, dynamic> jsonMap,
      String categoryId,
      {bool isLoadFromServer = true}) async {
    final Finder finder =
        Finder(filter: Filter.equals('manufacturer_id', categoryId));

    modelListStream.sink
        .add(await _modelDao.getAll(status: status, finder: finder));

    final PsResource<List<Model>> _resource =
        await _psApiService.getAllModelList(jsonMap);

    if (_resource.status == PsStatus.SUCCESS) {
      await _modelDao.deleteWithFinder(finder);
      await _modelDao.insertAll(_primaryKey, _resource.data!);
    } else {
      if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        await _modelDao.deleteWithFinder(finder);
      }
    }
    modelListStream.sink.add(await _modelDao.getAll(finder: finder));
  }

  Future<dynamic> getNextPageModelList(
      StreamController<PsResource<List<Model>>> modelListStream,
      Map<dynamic, dynamic> jsonMap,
      String loginUserId,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
 //     String categoryId,
      {bool isLoadFromServer = true}) async {
    // final Finder finder =
    //     Finder(filter: Filter.equals('manufacturer_id', categoryId));
    modelListStream.sink
        .add(await _modelDao.getAll(status: status));

    final PsResource<List<Model>> _resource =
        await _psApiService.getModelList(jsonMap,loginUserId,limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      _modelDao
          .insertAll(_primaryKey, _resource.data!)
          .then((dynamic data) async {
        modelListStream.sink.add(await _modelDao.getAll());
      });
    } else {
      modelListStream.sink.add(await _modelDao.getAll());
    }
  }

  Future<PsResource<ApiStatus>> postModelSubscribe(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.postModelSubscribe(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }
}
