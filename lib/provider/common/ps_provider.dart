import 'package:flutter/foundation.dart';
import 'package:flutteradmotors/repository/Common/ps_repository.dart';
import 'package:flutteradmotors/viewobject/ps_item_upload_config.dart';
import 'package:flutteradmotors/viewobject/ps_mobile_config_setting.dart';

class PsProvider extends ChangeNotifier {
  PsProvider(this.psRepository,int limit){
 if (limit != 0) {
      this.limit = limit;
    }
  }

  bool isConnectedToInternet = false;
  bool isLoading = false;
  PsRepository? psRepository;

  int? offset = 0;
  int limit = 30;
  int? _cacheDataLength = 0;
  int maxDataLoadingCount = 0;
  int maxDataLoadingCountLimit = 4;
  bool isReachMaxData = false;
  bool isDispose = false;

  void updateOffset(int dataLength) {
    if (offset == 0) {
      isReachMaxData = false;
      maxDataLoadingCount = 0;
    }
    if (dataLength == _cacheDataLength) {
      maxDataLoadingCount++;
      if (maxDataLoadingCount == maxDataLoadingCountLimit) {
        isReachMaxData = true;
      }
    } else {
      maxDataLoadingCount = 0;
    }

    offset = dataLength;
    _cacheDataLength = dataLength;
  }

  Future<void> loadValueHolder() async {
   await psRepository!.loadValueHolder();
  }

  Future<void> replaceLoginUserId(String loginUserId) async {
   await psRepository!.replaceLoginUserId(loginUserId);
  }

  Future<void> replaceLoginUserName(String loginUserName) async {
   await psRepository!.replaceLoginUserName(loginUserName);
  }

  Future<void> replaceNotiToken(String notiToken) async {
   await psRepository!.replaceNotiToken(notiToken);
  }

  Future<void> replaceNotiSetting(bool notiSetting) async {
   await psRepository!.replaceNotiSetting(notiSetting);
  }

  Future<void> replaceCustomCameraSetting(bool cameraSetting) async {
   await psRepository!.replaceCustomCameraSetting(cameraSetting);
  }

  Future<void> replaceIsToShowIntroSlider(bool doNotShowAgain) async {
   await psRepository!.replaceIsToShowIntroSlider(doNotShowAgain);
  }

  Future<void> replaceDate(String startDate, String endDate) async {
   await psRepository!.replaceDate(startDate, endDate);
  }

  Future<void> replaceVerifyUserData(
      String? userIdToVerify,
      String? userNameToVerify,
      String? userEmailToVerify,
      String? userPasswordToVerify) async {
   await psRepository!.replaceVerifyUserData(userIdToVerify!, userNameToVerify!,
        userEmailToVerify!, userPasswordToVerify!);
  }

    Future<void> replaceItemLocationTownshipData(
      String locationTownshipId,
      String locationCityId,
      String locationTownshipName,
      String locationTownshipLat,
      String locationTownshipLng) async {
    await psRepository!.replaceItemLocationTownshipData(
        locationTownshipId,
        locationCityId,
        locationTownshipName,
        locationTownshipLat,
        locationTownshipLng);
  }

  Future<void> replaceItemLocationData(String locationId, String locationName,
      String locationLat, String locationLng) async {
    await psRepository!.replaceItemLocationData(
        locationId, locationName, locationLat, locationLng);
  }

  Future<void> replaceVersionForceUpdateData(bool appInfoForceUpdate) async {
   await psRepository!.replaceVersionForceUpdateData(appInfoForceUpdate);
  }

  Future<void> replaceAppInfoData(
      String appInfoVersionNo,
      bool appInfoForceUpdate,
      String appInfoForceUpdateTitle,
      String appInfoForceUpdateMsg) async {
   await psRepository!.replaceAppInfoData(appInfoVersionNo, appInfoForceUpdate,
        appInfoForceUpdateTitle, appInfoForceUpdateMsg);
  }

  Future<void> replaceShopInfoValueHolderData(
    String overAllTaxLabel,
    String overAllTaxValue,
    String shippingTaxLabel,
    String shippingTaxValue,
    String shippingId,
    String shopId,
    String messenger,
    String whatsApp,
    String phone,
  ) async {
  await  psRepository!.replaceShopInfoValueHolderData(
        overAllTaxLabel,
        overAllTaxValue,
        shippingTaxLabel,
        shippingTaxValue,
        shippingId,
        shopId,
        messenger,
        whatsApp,
        phone);
  }

  Future<void> replaceCheckoutEnable(
      String paypalEnabled,
      String stripeEnabled,
      String codEnabled,
      String bankEnabled,
      String standardShippingEnable,
      String zoneShippingEnable,
      String noShippingEnable) async {
   await psRepository!.replaceCheckoutEnable(
        paypalEnabled,
        stripeEnabled,
        codEnabled,
        bankEnabled,
        standardShippingEnable,
        zoneShippingEnable,
        noShippingEnable);
  }

  Future<void> replacePublishKey(String pubKey) async {
   await psRepository!.replacePublishKey(pubKey);
  }

  Future<void> replaceDefaultCurrency(
      String defaultCurrencyId, String defaultCurrency) async {
    await psRepository!.replaceDefaultCurrency(
        defaultCurrencyId, defaultCurrency);
  }

  Future<void> replaceMobileConfigSetting(PSMobileConfigSetting psMobileConfigSetting) async {
    limit = int.parse(psMobileConfigSetting.defaultLoadingLimit ?? '30');
    await psRepository!.replaceMobileConfigSetting(psMobileConfigSetting);
  }

  Future<void> replaceIsSubLocation(String isSubLocation) async {
    await psRepository!.replaceIsSubLocation(isSubLocation);

  }

  Future<void> replaceIsBlockeFeatureDisabled(String isBlockedFeatueDisabled) async {
    await psRepository!.replaceisBlockedFeatueDisabled(isBlockedFeatueDisabled);
  }

  Future<void> replaceIsPaidApp(String isPaidApp) async {
    await psRepository!.replaceIsPaidApp(isPaidApp);
  }

  Future<void> replaceIsModelSubscribe(String isModelSubscribe) async {
    await psRepository!.replaceIsModelSubscribe(isModelSubscribe);
  }

  Future<void> replaceMaxImageCount(int maxImageCount) async {
    await psRepository!.replaceMaxImageCount(maxImageCount);
  }

  Future<void> replaceAdType(String adType) async {
    await psRepository!.replaceAdType(adType);
  }

    Future<void> replacePromoCellNo(String promoCellNo) async {
    await psRepository!.replacePromoCellNo(promoCellNo);
  }

  Future<void> replaceItemUploadConfig(ItemUploadConfig itemUploadConfig) async {
    await psRepository!.replaceItemUploadConfig(itemUploadConfig);
  }

  Future<void> replaceIsThumbnail2x3xGenerate(String isThumbnail2x3xGenerate) async {
    await psRepository!.replaceIsThumbnail2x3xGenerate(isThumbnail2x3xGenerate);

  }

    Future<void> replaceDetailOpenCount(int count) async {
    await psRepository!.replaceDetailOpenCount(count);

  }

    Future<void> replacePackageIAPKeys(String packageAndroidKeyList, String packageIOSKeyList) async {
    await psRepository!.replacePackageIAPKeys(packageAndroidKeyList, packageIOSKeyList);
  }

}
