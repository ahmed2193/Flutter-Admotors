import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/provider/entry/item_entry_provider.dart';
import 'package:flutteradmotors/provider/gallery/gallery_provider.dart';
import 'package:flutteradmotors/provider/user/user_provider.dart';
import 'package:flutteradmotors/repository/gallery_repository.dart';
import 'package:flutteradmotors/repository/product_repository.dart';
import 'package:flutteradmotors/repository/user_repository.dart';
import 'package:flutteradmotors/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:flutteradmotors/ui/common/dialog/choose_camera_type_dialog.dart';
import 'package:flutteradmotors/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutteradmotors/ui/common/dialog/error_dialog.dart';
import 'package:flutteradmotors/ui/common/dialog/in_app_purchase_for_package_dialog.dart';
import 'package:flutteradmotors/ui/common/dialog/retry_dialog_view.dart';
import 'package:flutteradmotors/ui/common/dialog/success_dialog.dart';
import 'package:flutteradmotors/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutteradmotors/ui/common/ps_button_widget.dart';
import 'package:flutteradmotors/ui/common/ps_dropdown_base_with_controller_widget.dart';
import 'package:flutteradmotors/ui/common/ps_textfield_widget.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/utils/ps_progress_dialog.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/Item_color.dart';
import 'package:flutteradmotors/viewobject/api_status.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/condition_of_item.dart';
import 'package:flutteradmotors/viewobject/default_photo.dart';
import 'package:flutteradmotors/viewobject/holder/delete_item_image_holder.dart';
import 'package:flutteradmotors/viewobject/holder/image_reorder_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/google_map_pin_call_back_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/map_pin_call_back_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/map_pin_intent_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/model_intent_holder.dart';
import 'package:flutteradmotors/viewobject/holder/item_entry_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/item_build_type.dart';
import 'package:flutteradmotors/viewobject/item_currency.dart';
import 'package:flutteradmotors/viewobject/item_fuel_type.dart';
import 'package:flutteradmotors/viewobject/item_location.dart';
import 'package:flutteradmotors/viewobject/item_location_township.dart';
import 'package:flutteradmotors/viewobject/item_price_type.dart';
import 'package:flutteradmotors/viewobject/item_seller_type.dart';
import 'package:flutteradmotors/viewobject/item_type.dart';
import 'package:flutteradmotors/viewobject/manufacturer.dart';
import 'package:flutteradmotors/viewobject/model.dart';
import 'package:flutteradmotors/viewobject/product.dart';
import 'package:flutteradmotors/viewobject/transmission.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googlemap;
import 'package:latlong2/latlong.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ItemEntryView extends StatefulWidget {
  const ItemEntryView(
      {Key? key, this.flag, this.item, required this.animationController, required this.maxImageCount})
      : super(key: key);
  final AnimationController? animationController;
  final String? flag;
  final Product? item;
  final int maxImageCount;

  @override
  State<StatefulWidget> createState() => _ItemEntryViewState();
}

class _ItemEntryViewState extends State<ItemEntryView> {
  ProductRepository? repo1;
  GalleryRepository? galleryRepository;
  ItemEntryProvider? _itemEntryProvider;
  GalleryProvider? galleryProvider;
  UserProvider? userProvider;
  UserRepository? userRepository;
  PsValueHolder? valueHolder;

  /// user input info
  final TextEditingController userInputListingTitle = TextEditingController();

  final TextEditingController userInputPlateNumber = TextEditingController();
  final TextEditingController userInputEnginePower = TextEditingController();
  final TextEditingController userInputMileage = TextEditingController();
  final TextEditingController userInputLicenseExpDate = TextEditingController();
  final TextEditingController userInputYear = TextEditingController();
  final TextEditingController userInputSteeringPosition =
      TextEditingController();
  final TextEditingController userInputNumOfOwner = TextEditingController();
  final TextEditingController userInputTrimName = TextEditingController();
  final TextEditingController userInputVehicleId = TextEditingController();
  final TextEditingController userInputMaximumPassenger =
      TextEditingController();
  final TextEditingController userInputNumOfDoor = TextEditingController();
  final TextEditingController userInputPriceUnit = TextEditingController();

  final TextEditingController userInputBrand = TextEditingController();
  final TextEditingController userInputHighLightInformation =
      TextEditingController();
  final TextEditingController userInputDiscount = TextEditingController();    
  final TextEditingController userInputDescription = TextEditingController();
  final TextEditingController userInputDealOptionText = TextEditingController();
  final TextEditingController userInputLattitude = TextEditingController();
  final TextEditingController userInputLongitude = TextEditingController();
  final TextEditingController userInputAddress = TextEditingController();
  final TextEditingController userInputPrice = TextEditingController();
  final MapController mapController = MapController();
  googlemap.GoogleMapController? googleMapController;

  /// api info
  final TextEditingController manufacturerController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController transmissionController = TextEditingController();
  final TextEditingController itemColorController = TextEditingController();
  final TextEditingController itemFuelTypeController = TextEditingController();
  final TextEditingController itemBuildTypeController = TextEditingController();
  final TextEditingController itemSellerTypeController =
      TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController itemConditionController = TextEditingController();
  final TextEditingController priceTypeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController dealOptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController locationTownshipController =
      TextEditingController();

  late LatLng latlng;
  final double zoom = 16;
  bool bindDataFirstTime = true;
  bool bindImageFirstTime = true;
  bool isSelectedVideoImagePath = false;
  List<Asset> images = <Asset>[];
  late List<bool> isImageSelected;
  late List<Asset?> galleryImageAsset;
  late List<String?> cameraImagePath;
  late List<DefaultPhoto?> uploadedImages;
  String? videoFilePath;
  String? selectedVideoImagePath;
  String? videoFileThumbnailPath;
  String? selectedVideoPath;
  Asset? defaultAssetImage;

  String isShopCheckbox = '1';

  dynamic updateMapController(googlemap.GoogleMapController mapController) {
    googleMapController = mapController;
  }

  // ProgressDialog progressDialog;

  // File file;
  @override
  void initState() {
    super.initState();
    isImageSelected =
        List<bool>.generate(widget.maxImageCount, (int index) => false);
    galleryImageAsset =
        List<Asset?>.generate(widget.maxImageCount, (int index) => null);
    cameraImagePath =
        List<String?>.generate(widget.maxImageCount, (int index) => null);
    uploadedImages = List<DefaultPhoto?>.generate(widget.maxImageCount,
        (int index) => DefaultPhoto(imgId: '', imgPath: ''));
  }

  @override
  Widget build(BuildContext context) {
    print(
        '............................Build UI Again ............................');
    valueHolder = Provider.of<PsValueHolder>(context);
    void showRetryDialog(String description, Function uploadImage) {
      if (PsProgressDialog.isShowing()) {
        PsProgressDialog.dismissDialog();
      }
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return RetryDialogView(
                description: description,
                rightButtonText: Utils.getString(context, 'item_entry__retry'),
                onAgreeTap: () {
                  Navigator.pop(context);
                  uploadImage();
                });
          });
    }

    Future<dynamic> uploadImage(String itemId) async {
      bool _isVideoDone = isSelectedVideoImagePath;
      final List<ImageReorderParameterHolder> reorderObjList =
          <ImageReorderParameterHolder>[];
      for (int i = 0; i < widget.maxImageCount && isImageSelected.contains(true); i++) {
        
        if (isImageSelected[i]) {
          if (galleryImageAsset[i] != null || cameraImagePath[i] != null) {
            if (!PsProgressDialog.isShowing()) {
              if (!isImageSelected[i]) {
                PsProgressDialog.dismissDialog();
              } else {
                await PsProgressDialog.showDialog(context,
                    message: Utils.getString(context, 'Image ${i + 1} uploading'));
              }
            }
            final dynamic _apiStatus = await galleryProvider!
                .postItemImageUpload(
                    itemId,
                    uploadedImages[i]!.imgId,
                    '${i + 1}',
                    galleryImageAsset[i] == null
                        ? await Utils.getImageFileFromCameraImagePath(
                            cameraImagePath[i]!, valueHolder!.uploadImageSize!)
                        : await Utils.getImageFileFromAssets(
                            galleryImageAsset[i]!, valueHolder!.uploadImageSize!),
                    valueHolder!.loginUserId!);
            PsProgressDialog.dismissDialog();

            if (_apiStatus != null &&
                _apiStatus.data is DefaultPhoto &&
                _apiStatus.data != null) {
              isImageSelected[i] = false;
              print('${i + 1} image uploaded');
            } else if (_apiStatus != null) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message: _apiStatus.message,
                    );
                  });
            }
          } else if (uploadedImages[i]!.imgPath != '') {
            reorderObjList.add(ImageReorderParameterHolder(
                imgId: uploadedImages[i]!.imgId, ordering: (i + 1).toString()));
          }
        }
      }

      //reordering
      if (reorderObjList.isNotEmpty) {
      await PsProgressDialog.showDialog(context);
      final List<Map<String, dynamic>> reorderMapList =
          <Map<String, dynamic>>[];
      for (ImageReorderParameterHolder? data in reorderObjList) {
        if (data != null) {
          reorderMapList.add(data.toMap());
        }
      }
      final PsResource<ApiStatus>? _apiStatus = await galleryProvider!
          .postReorderImages(reorderMapList, valueHolder!.loginUserId!);
      PsProgressDialog.dismissDialog();
      
      if (_apiStatus!.data != null && _apiStatus.status == PsStatus.SUCCESS) {
        isImageSelected = isImageSelected.map<bool>((bool v) => false).toList();
        reorderObjList.clear();
      } else {
        showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message: _apiStatus.message,
                    );
                  });
      }
      }
      

      if (!PsProgressDialog.isShowing()) {
        if (!isSelectedVideoImagePath) {
          PsProgressDialog.dismissDialog();
        } else {
          await PsProgressDialog.showDialog(context,
              message:
                  Utils.getString(context, 'progressloading_video_uploading'));
        }
      }

      if (isSelectedVideoImagePath) {
        final PsResource<DefaultPhoto> _apiStatus = await galleryProvider!
            .postVideoUpload(
                itemId, '', File(videoFilePath!), valueHolder!.loginUserId!);
        final PsResource<DefaultPhoto> _apiStatus2 = await galleryProvider!
            .postVideoThumbnailUpload(itemId, '', File(videoFileThumbnailPath!),
                valueHolder!.loginUserId!);
        if (_apiStatus.data != null && _apiStatus2.data != null) {
          PsProgressDialog.dismissDialog();
          isSelectedVideoImagePath = false;
          _isVideoDone = isSelectedVideoImagePath;
        } else {
          showRetryDialog(
              Utils.getString(context, 'item_entry__fail_to_upload_video'), () {
            uploadImage(itemId);
          });
          return;
        }
      }
      PsProgressDialog.dismissDialog();

      if (!(isImageSelected.contains(true) || _isVideoDone)) {
        
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return SuccessDialog(
                message: Utils.getString(context, 'item_entry_item_uploaded'),
                onPressed: () {
                  Navigator.pop(context, true);
                  // Navigator.pop(context, true);
                },
              );
            });
      }

      return;
    }

    dynamic updateImagesFromVideo(String imagePath, int index) {
      if (mounted) {
        setState(() {
          //for single select image
          if (index == -2 && imagePath.isNotEmpty) {
            videoFilePath = imagePath;
            // selectedVideoImagePath = imagePath;
            isSelectedVideoImagePath = true;
          }
          //end single select image
        });
      }
    }

    dynamic _getImageFromVideo(String videoPathUrl) async {
      videoFileThumbnailPath = await VideoThumbnail.thumbnailFile(
        video: videoPathUrl,
        imageFormat: ImageFormat.JPEG,
        maxWidth:
            128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 25,
      );
      return videoFileThumbnailPath;
    }

    dynamic updateImagesFromCustomCamera(String imagePath, int index) {
      if (mounted) {
        setState(() {
          //for single select image
          if (imagePath.isNotEmpty) {
            int indexToStart = 0; //find the right starting_index for storing images
            for (indexToStart = 0; indexToStart < index; indexToStart++) {
              if (!isImageSelected[indexToStart] &&
                  indexToStart > galleryProvider!.selectedImageList.length - 1)
                break;
            }
            galleryImageAsset[indexToStart] = null;
            cameraImagePath[indexToStart] = imagePath;
            isImageSelected[indexToStart] = true;
          }
          //end single select image
        });
      }
    }

    dynamic updateImages(List<Asset> resultList, int index, int currentIndex) {
      setState(() {
        images = resultList;

        //for single select image
        if (index != -1 && resultList.isNotEmpty) {
          galleryImageAsset[currentIndex] = resultList[0];
          isImageSelected[currentIndex] = true;
        }
        //end single select image

        //for multi select
        if (index == -1) {
          int indexToStart =
              0; //find the right starting_index for storing images
          for (indexToStart = 0; indexToStart < currentIndex; indexToStart++) {
            if (!isImageSelected[indexToStart] &&
                indexToStart > galleryProvider!.selectedImageList.length - 1)
              break;
          }
          for (int i = 0;
              i < resultList.length && indexToStart < widget.maxImageCount;
              i++, indexToStart++) {
            galleryImageAsset[indexToStart] = resultList[i];
            isImageSelected[indexToStart] = true;
          }
        }
        //end multi select
      });
    }

    dynamic onReorder(int oldIndex, int newIndex) {
      if (galleryImageAsset[oldIndex] != null) {
        if (galleryImageAsset[newIndex] != null) {
          setState(() {
            final Asset? temp = galleryImageAsset[oldIndex];
            galleryImageAsset[oldIndex] = galleryImageAsset[newIndex];
            galleryImageAsset[newIndex] = temp;
          });
        } else if (cameraImagePath[newIndex] != null &&
            cameraImagePath[newIndex] != '') {
          setState(() {
            cameraImagePath[oldIndex] = cameraImagePath[newIndex];
            galleryImageAsset[newIndex] = galleryImageAsset[oldIndex];
            galleryImageAsset[oldIndex] = null;
            cameraImagePath[newIndex] = null;
          });
        } else if (uploadedImages[newIndex]!.imgPath != '' &&
            uploadedImages[newIndex]!.imgId != '') {
          setState(() {
            uploadedImages[oldIndex] = uploadedImages[newIndex];
            uploadedImages[newIndex] = DefaultPhoto(imgId: '', imgPath: '');
            galleryImageAsset[newIndex] = galleryImageAsset[oldIndex];
            galleryImageAsset[oldIndex] = null;

            isImageSelected[newIndex] = true;
            isImageSelected[oldIndex] = true;
          });
        }
      } else if (cameraImagePath[oldIndex] != null &&
          cameraImagePath[oldIndex] != '') {
        if (galleryImageAsset[newIndex] != null) {
          setState(() {
            galleryImageAsset[oldIndex] = galleryImageAsset[newIndex];
            cameraImagePath[newIndex] = cameraImagePath[oldIndex];
            cameraImagePath[oldIndex] = null;
            galleryImageAsset[newIndex] = null;
          });
        } else if (cameraImagePath[newIndex] != null &&
            cameraImagePath[newIndex] != '') {
          setState(() {
            final String? temp = cameraImagePath[oldIndex];
            cameraImagePath[oldIndex] = cameraImagePath[newIndex];
            cameraImagePath[newIndex] = temp;
          });
        } else if (uploadedImages[newIndex]!.imgPath != '' &&
            uploadedImages[newIndex]!.imgId != '') {
          setState(() {
            uploadedImages[oldIndex] = uploadedImages[newIndex];
            uploadedImages[newIndex] = DefaultPhoto(imgId: '', imgPath: '');
            cameraImagePath[newIndex] = cameraImagePath[oldIndex];
            cameraImagePath[oldIndex] = null;

            isImageSelected[newIndex] = true;
            isImageSelected[oldIndex] = true;
          });
        }
      } else if (uploadedImages[oldIndex]!.imgPath != '' &&
          uploadedImages[oldIndex]!.imgId != '') {
        if (galleryImageAsset[newIndex] != null) {
          setState(() {
            uploadedImages[newIndex] = uploadedImages[oldIndex];
            uploadedImages[oldIndex] = DefaultPhoto(imgId: '', imgPath: '');
            galleryImageAsset[oldIndex] = galleryImageAsset[newIndex];
            galleryImageAsset[newIndex] = null;

            isImageSelected[newIndex] = true;
            isImageSelected[oldIndex] = true;
          });
        } else if (cameraImagePath[newIndex] != null &&
            cameraImagePath[newIndex] != '') {
          setState(() {
            uploadedImages[newIndex] = uploadedImages[oldIndex];
            uploadedImages[oldIndex] = DefaultPhoto(imgId: '', imgPath: '');
            cameraImagePath[oldIndex] = cameraImagePath[newIndex];
            cameraImagePath[newIndex] = null;

            isImageSelected[newIndex] = true;
            isImageSelected[oldIndex] = true;
          });
        } else if (uploadedImages[newIndex]!.imgPath != '' &&
            uploadedImages[newIndex]!.imgId != '') {
          setState(() {
            final DefaultPhoto? temp = uploadedImages[newIndex];
            uploadedImages[newIndex] = uploadedImages[oldIndex];
            uploadedImages[oldIndex] = temp;

            isImageSelected[oldIndex] = true;
            isImageSelected[newIndex] = true;
          });
        }
      }
    }

    repo1 = Provider.of<ProductRepository>(context);
    galleryRepository = Provider.of<GalleryRepository>(context);
    userRepository = Provider.of<UserRepository>(context);
    widget.animationController!.forward();
    return PsWidgetWithMultiProvider(
      child: MultiProvider(
          providers: <SingleChildWidget>[
            ChangeNotifierProvider<ItemEntryProvider?>(
                lazy: false,
                create: (BuildContext context) {
                  _itemEntryProvider = ItemEntryProvider(
                      repo: repo1, psValueHolder: valueHolder);

                  _itemEntryProvider!.item = widget.item;

                  if (valueHolder!.isSubLocation == PsConst.ONE) {
                    latlng = LatLng(
                        double.parse(_itemEntryProvider!
                            .psValueHolder!.locationTownshipLat),
                        double.parse(_itemEntryProvider!
                            .psValueHolder!.locationTownshipLng));
                    if (
                        //_itemEntryProvider!.itemLocationTownshipId != null ||
                        _itemEntryProvider!.itemLocationTownshipId != '') {
                      _itemEntryProvider!.itemLocationTownshipId =
                          _itemEntryProvider!
                              .psValueHolder!.locationTownshipId;
                    }
                    if (userInputLattitude.text.isEmpty)
                      userInputLattitude.text = _itemEntryProvider!
                          .psValueHolder!.locationTownshipLat;
                    if (userInputLongitude.text.isEmpty)
                      userInputLongitude.text = _itemEntryProvider!
                          .psValueHolder!.locationTownshipLng;
                  } else {
                    latlng = LatLng(
                        double.parse(
                            _itemEntryProvider!.psValueHolder!.locationLat!),
                        double.parse(
                            _itemEntryProvider!.psValueHolder!.locationLng!));
                    if (userInputLattitude.text.isEmpty)
                      userInputLattitude.text =
                          _itemEntryProvider!.psValueHolder!.locationLat!;
                    if (userInputLongitude.text.isEmpty)
                      userInputLongitude.text =
                          _itemEntryProvider!.psValueHolder!.locationLng!;
                  }
                  if (
                      //_itemEntryProvider.itemLocationId != null ||
                      _itemEntryProvider!.itemLocationId != '') {
                    _itemEntryProvider!.itemLocationId =
                        _itemEntryProvider!.psValueHolder!.locationId!;
                  }
                  _itemEntryProvider!.itemCurrencyId =
                      _itemEntryProvider!.psValueHolder!.defaultCurrencyId;
                  priceController.text =
                      _itemEntryProvider!.psValueHolder!.defaultCurrency;
                  _itemEntryProvider!.getItemFromDB(widget.item!.id);

                  return _itemEntryProvider!;
                }),
            ChangeNotifierProvider<GalleryProvider?>(
                lazy: false,
                create: (BuildContext context) {
                  galleryProvider = GalleryProvider(repo: galleryRepository!);
                  if (widget.flag == PsConst.EDIT_ITEM) {
                    galleryProvider!.loadImageList(
                        widget.item!.defaultPhoto!.imgParentId!,
                        PsConst.ITEM_TYPE);

                    // firstImageId = galleryProvider.galleryList.data[0].imgId;
                    // secondImageId = galleryProvider.galleryList.data[1].imgId;
                    // thirdImageId = galleryProvider.galleryList.data[2].imgId;
                    // fourthImageId = galleryProvider.galleryList.data[3].imgId;
                    // fiveImageId = galleryProvider.galleryList.data[4].imgId;

                    // Utils.psPrint(firstImageId);
                    // Utils.psPrint(secondImageId);
                    // Utils.psPrint(thirdImageId);
                    // Utils.psPrint(fourthImageId);
                    // Utils.psPrint(fiveImageId);
                  }
                  return galleryProvider!;
                }),
            ChangeNotifierProvider<UserProvider?>(
              lazy: false,
              create: (BuildContext context) {
                userProvider = UserProvider(
                    repo: userRepository, psValueHolder: valueHolder);
                userProvider!.getUser(valueHolder!.loginUserId ?? '');
                return userProvider;
              },
            )
          ],
          child: Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider provider, Widget? child) {
          if (widget.flag == PsConst.ADD_NEW_ITEM && valueHolder!.isPaidApp == PsConst.ONE && provider.user.data == null) 
              return Container(
                color: PsColors.backgroundColor
              ); 
          if (widget.flag == PsConst.EDIT_ITEM || (valueHolder!.isPaidApp != PsConst.ONE || 
                                (provider.user.data != null  &&
                                int.parse( provider.user.data!.remainingPost!) > 0)))
              return SingleChildScrollView(
            child: AnimatedBuilder(
                animation: widget.animationController!,
                child: Container(
                  color: PsColors.backgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: PsDimens.space16,
                            left: PsDimens.space10,
                            right: PsDimens.space10),
                        child: Text(
                            Utils.getString(
                                context, 'item_entry__listing_today'),
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: PsDimens.space16,
                            left: PsDimens.space10,
                            right: PsDimens.space10,
                            bottom: PsDimens.space10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                  Utils.getString(context,
                                      'item_entry__choose_photo_showcase'),
                                  style: Theme.of(context).textTheme.bodyMedium),
                            ),
                            Text(' *',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: PsColors.mainColor))
                          ],
                        ),
                      ),
                      //  _largeSpacingWidget,
                      Consumer<GalleryProvider>(builder: (BuildContext context,
                          GalleryProvider provider, Widget? child) {
                          if (bindImageFirstTime &&
                                provider.galleryList.data!.isNotEmpty) {
                              for (int i = 0;
                                  i < widget.maxImageCount && i < provider.galleryList.data!.length;
                                  i++) {
                                if (provider.galleryList.data![i].imgId !=
                                    null) {
                                  uploadedImages[i] =
                                      provider.galleryList.data![i];
                                }
                              }
                              bindImageFirstTime = false;
                          }

                        return ImageUploadHorizontalList(
                              flag: widget.flag,
                              images: images,
                              selectedImageList: uploadedImages,
                              updateImages: updateImages,
                              updateImagesFromCustomCamera:
                                  updateImagesFromCustomCamera,
                              videoFilePath: videoFilePath,
                              videoFileThumbnailPath: videoFileThumbnailPath,
                              selectedVideoImagePath: selectedVideoImagePath,
                              updateImagesFromVideo: updateImagesFromVideo,
                              selectedVideoPath: selectedVideoPath,
                              getImageFromVideo: _getImageFromVideo,
                              imageDesc1Controller:
                                  galleryProvider!.imageDesc1Controller,
                              provider: _itemEntryProvider,
                              galleryProvider: provider,
                              onReorder: onReorder,
                              cameraImagePath: cameraImagePath,
                              galleryImagePath: galleryImageAsset,
                            );
                      }),

                      Consumer<ItemEntryProvider>(builder:
                          (BuildContext context, ItemEntryProvider provider,
                              Widget? child) {
                        if (
                            //provider != null &&
                            provider.item != null &&
                                provider.item!.id != null) {
                          if (bindDataFirstTime) {
                            userInputListingTitle.text = provider.item!.title!;
                            manufacturerController.text =
                                provider.item!.manufacturer!.name!;
                            modelController.text = provider.item!.model!.name!;
                            userInputPlateNumber.text =
                                provider.item!.plateNumber!;
                            userInputEnginePower.text =
                                provider.item!.enginePower!;
                            transmissionController.text =
                                provider.item!.transmission!.name!;
                            userInputMileage.text = provider.item!.mileage!;
                            userInputLicenseExpDate.text =
                                provider.item!.licenseExpirationDate!;
                            userInputYear.text = provider.item!.year!;
                            itemColorController.text =
                                provider.item!.itemColor!.colorValue!;
                            itemFuelTypeController.text =
                                provider.item!.fuelType!.name!;
                            userInputSteeringPosition.text =
                                provider.item!.steeringPosition!;
                            userInputNumOfOwner.text =
                                provider.item!.noOfOwner!;
                            userInputTrimName.text = provider.item!.vehicleId!;
                            itemBuildTypeController.text =
                                provider.item!.buildType!.name!;
                            userInputMaximumPassenger.text =
                                provider.item!.maxPassengers!;
                            userInputNumOfDoor.text = provider.item!.noOfDoors!;
                            itemSellerTypeController.text =
                                provider.item!.sellerType!.name!;
                            userInputPriceUnit.text = provider.item!.priceUnit!;

                            userInputDiscount.text = provider.item!.discountRate!;
                            userInputHighLightInformation.text =
                                provider.item!.highlightInformation!;
                            userInputDescription.text =
                                provider.item!.description!;
                            // userInputDealOptionText.text =
                            //     provider.item.data.dealOptionRemark;

                            if (valueHolder!.isSubLocation == PsConst.ONE) {
                              userInputLattitude.text =
                                  provider.item!.itemLocationTownship!.lat!;
                              userInputLongitude.text =
                                  provider.item!.itemLocationTownship!.lng!;
                              provider.itemLocationTownshipId =
                                  provider.item!.itemLocationTownship!.id!;
                              // locationTownshipController.text = provider
                              //     .item.itemLocationTownship.townshipName;
                            } else {
                              userInputLattitude.text = provider.item!.lat!;
                              userInputLongitude.text = provider.item!.lng!;
                            }

                            provider.itemLocationId =
                                provider.item!.itemLocation!.id!;
                            locationController.text =
                                provider.item!.itemLocation!.name!;
                            userInputAddress.text = provider.item!.address!;
                            userInputPrice.text = provider.item!.price!;

                            typeController.text =
                                provider.item!.itemType!.name!;
                            itemConditionController.text =
                                provider.item!.conditionOfItem!.name!;
                            priceTypeController.text =
                                provider.item!.itemPriceType!.name!;
                            priceController.text =
                                provider.item!.itemCurrency!.currencySymbol!;
                            locationController.text =
                                provider.item!.itemLocation!.name!;

                            provider.manufacturerId =
                                provider.item!.manufacturer!.id!;
                            provider.modelId = provider.item!.model!.id!;
                            provider.transmissionId =
                                provider.item!.transmissionId!;
                            provider.itemColorId =
                                provider.item!.itemColor!.id!;
                            provider.fuelTypeId = provider.item!.fuelType!.id!;
                            provider.buildTypeId =
                                provider.item!.buildType!.id!;
                            provider.sellerTypeId =
                                provider.item!.sellerType!.id!;
                            provider.itemTypeId = provider.item!.itemType!.id!;
                            provider.itemConditionId =
                                provider.item!.conditionOfItem!.id!;
                            provider.itemCurrencyId =
                                provider.item!.itemCurrency!.id!;

                            if (valueHolder!.isSubLocation == PsConst.ONE) {
                              userInputLattitude.text =
                                  provider.item!.itemLocationTownship!.lat!;
                              userInputLongitude.text =
                                  provider.item!.itemLocationTownship!.lng!;
                              provider.itemLocationTownshipId =
                                  provider.item!.itemLocationTownship!.id!;
                              // locationTownshipController.text = provider
                              //     .item.itemLocationTownship.townshipName;
                            } else {
                              userInputLattitude.text = provider.item!.lat!;
                              userInputLongitude.text = provider.item!.lng!;
                            }

                            provider.itemLocationId =
                                provider.item!.itemLocation!.id!;
                            provider.itemPriceTypeId =
                                provider.item!.itemPriceType!.id!;
                            selectedVideoImagePath =
                                provider.item!.videoThumbnail!.imgPath!;
                            selectedVideoPath = provider.item!.video!.imgPath!;
                            bindDataFirstTime = false;
                            if (provider.item!.licenceStatus == '1') {
                              provider.isLicenseCheckBoxSelect = true;
                              LicenseCheckbox(
                                provider: provider,
                                onCheckBoxClick: () {
                                  if (mounted) {
                                    setState(() {
                                      updateLicenseCheckBox(context, provider);
                                    });
                                  }
                                },
                              );
                            } else {
                              provider.isLicenseCheckBoxSelect = false;

                              LicenseCheckbox(
                                provider: provider,
                                onCheckBoxClick: () {
                                  if (mounted) {
                                    setState(() {
                                      updateLicenseCheckBox(context, provider);
                                    });
                                  }
                                },
                              );
                            }
                            if (provider.item!.businessMode == '1') {
                              provider.isCheckBoxSelect = true;
                              _BusinessModeCheckbox();
                            } else {
                              provider.isCheckBoxSelect = false;

                              _BusinessModeCheckbox();
                            }
                          }
                        }
                        return AllControllerTextWidget(
                          userInputListingTitle: userInputListingTitle,
                          userInputPlateNumber: userInputPlateNumber,
                          userInputEnginePower: userInputEnginePower,
                          userInputMileage: userInputMileage,
                          userInputLicenseExpDate: userInputLicenseExpDate,
                          userInputYear: userInputYear,
                          userInputSteeringPosition: userInputSteeringPosition,
                          userInputNumOfOwner: userInputNumOfOwner,
                          userInputTrimName: userInputTrimName,
                          userInputVehicleId: userInputVehicleId,
                          userInputMaximumPassenger: userInputMaximumPassenger,
                          userInputNumOfDoor: userInputNumOfDoor,
                          userInputPriceUnit: userInputPriceUnit,
                          manufacturerController: manufacturerController,
                          modelController: modelController,
                          transmissionController: transmissionController,
                          itemColorController: itemColorController,
                          itemFuelTypeController: itemFuelTypeController,
                          itemBuildTypeController: itemBuildTypeController,
                          itemSellerTypeController: itemSellerTypeController,
                          typeController: typeController,
                          itemConditionController: itemConditionController,
                          userInputBrand: userInputBrand,
                          priceTypeController: priceTypeController,
                          priceController: priceController,
                          userInputDiscount: userInputDiscount,
                          userInputHighLightInformation:
                              userInputHighLightInformation,
                          userInputDescription: userInputDescription,
                          dealOptionController: dealOptionController,
                          userInputDealOptionText: userInputDealOptionText,
                          locationController: locationController,
                          locationTownshipController:
                              locationTownshipController,
                          userInputLattitude: userInputLattitude,
                          userInputLongitude: userInputLongitude,
                          userInputAddress: userInputAddress,
                          userInputPrice: userInputPrice,
                          mapController: mapController,
                          zoom: zoom,
                          flag: widget.flag!,
                          item: widget.item!,
                          provider: provider,
                          galleryProvider: galleryProvider!,
                          latlng: latlng,
                          uploadImage: (String itemId) {
                            uploadImage(itemId);
                          },
                          isImageSelected: isImageSelected,
                          isSelectedVideoImagePath: isSelectedVideoImagePath,
                          updateMapController: updateMapController,
                          googleMapController: googleMapController,
                        );
                      })
                    ],
                  ),
                ),
                builder: (BuildContext context, Widget? child) {
                  return child!;
                }),
          );
          else 
                   return InAppPurchaseBuyPackageDialog(
                onInAppPurchaseTap: () async {
                  // InAppPurchase View
                  final dynamic returnData = await Navigator.pushNamed(
                      context, RoutePaths.buyPackage,
                      arguments: <String, dynamic>{
                        'android': valueHolder?.packageAndroidKeyList,
                        'ios': valueHolder?.packageIOSKeyList
                      });

                  if (returnData != null) {
                    setState(() {
                      userProvider!.user.data!.remainingPost = returnData;
                    });
                  } else {
                    provider.getUser(valueHolder!.loginUserId ?? '');
                  }
                },
              );  
        },),
    ));
  }
}

class AllControllerTextWidget extends StatefulWidget {
  const AllControllerTextWidget({
    Key? key,
    this.userInputListingTitle,
    this.userInputPlateNumber,
    this.userInputEnginePower,
    this.userInputMileage,
    this.userInputLicenseExpDate,
    this.userInputYear,
    this.userInputSteeringPosition,
    this.userInputNumOfOwner,
    this.userInputTrimName,
    this.userInputVehicleId,
    this.userInputMaximumPassenger,
    this.userInputNumOfDoor,
    this.userInputPriceUnit,
    this.manufacturerController,
    this.modelController,
    this.transmissionController,
    this.itemColorController,
    this.itemFuelTypeController,
    this.itemBuildTypeController,
    this.itemSellerTypeController,
    this.typeController,
    this.itemConditionController,
    this.userInputBrand,
    this.priceTypeController,
    this.priceController,
    this.userInputDiscount,
    this.userInputHighLightInformation,
    this.userInputDescription,
    this.dealOptionController,
    this.userInputDealOptionText,
    this.locationController,
    this.locationTownshipController,
    this.userInputLattitude,
    this.userInputLongitude,
    this.userInputAddress,
    this.userInputPrice,
    this.mapController,
    this.provider,
    this.latlng,
    this.zoom,
    this.flag,
    this.item,
    this.uploadImage,
    this.galleryProvider,
    required this.isImageSelected,
    this.isSelectedVideoImagePath,
    this.googleMapController,
    this.updateMapController,
  }) : super(key: key);

  final TextEditingController? userInputListingTitle;
  final TextEditingController? userInputPlateNumber;
  final TextEditingController? userInputEnginePower;
  final TextEditingController? userInputMileage;
  final TextEditingController? userInputLicenseExpDate;
  final TextEditingController? userInputYear;
  final TextEditingController? userInputSteeringPosition;
  final TextEditingController? userInputNumOfOwner;
  final TextEditingController? userInputTrimName;
  final TextEditingController? userInputVehicleId;
  final TextEditingController? userInputMaximumPassenger;
  final TextEditingController? userInputNumOfDoor;
  final TextEditingController? userInputPriceUnit;
  final TextEditingController? manufacturerController;
  final TextEditingController? modelController;
  final TextEditingController? transmissionController;
  final TextEditingController? itemColorController;
  final TextEditingController? itemFuelTypeController;
  final TextEditingController? itemBuildTypeController;
  final TextEditingController? itemSellerTypeController;
  final TextEditingController? typeController;
  final TextEditingController? itemConditionController;
  final TextEditingController? userInputBrand;
  final TextEditingController? priceTypeController;
  final TextEditingController? priceController;
  final TextEditingController? userInputDiscount;
  final TextEditingController? userInputHighLightInformation;
  final TextEditingController? userInputDescription;
  final TextEditingController? dealOptionController;
  final TextEditingController? userInputDealOptionText;
  final TextEditingController? locationController;
  final TextEditingController? locationTownshipController;
  final TextEditingController? userInputLattitude;
  final TextEditingController? userInputLongitude;
  final TextEditingController? userInputAddress;
  final TextEditingController? userInputPrice;
  final MapController? mapController;
  final ItemEntryProvider? provider;
  final double? zoom;
  final String? flag;
  final Product? item;
  final LatLng? latlng;
  final Function? uploadImage;
  final GalleryProvider? galleryProvider;
  final List<bool> isImageSelected;
  final bool? isSelectedVideoImagePath;
  final googlemap.GoogleMapController? googleMapController;
  final Function? updateMapController;

  @override
  _AllControllerTextWidgetState createState() =>
      _AllControllerTextWidgetState();
}

class _AllControllerTextWidgetState extends State<AllControllerTextWidget> {
  LatLng? _latlng;
  googlemap.CameraPosition? _kLake;
  PsValueHolder? valueHolder;
  ItemEntryProvider? itemEntryProvider;
  googlemap.CameraPosition? kGooglePlex;

  @override
  Widget build(BuildContext context) {
    itemEntryProvider = Provider.of<ItemEntryProvider>(context, listen: false);
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);
    _latlng ??= widget.latlng;
    kGooglePlex = googlemap.CameraPosition(
      target: googlemap.LatLng(_latlng!.latitude, _latlng!.longitude),
      zoom: widget.zoom!,
    );
    if ((widget.flag == PsConst.ADD_NEW_ITEM &&
            widget.locationController!.text ==
                itemEntryProvider!.psValueHolder!.locactionName) ||
        (widget.flag == PsConst.ADD_NEW_ITEM &&
            widget.locationController!.text.isEmpty)) {
      widget.locationController!.text =
          itemEntryProvider!.psValueHolder!.locactionName!;
      // widget.locationTownshipController.text =
      //     itemEntryProvider.psValueHolder.locationTownshipName;
    }
    if (itemEntryProvider!.item != null && widget.flag == PsConst.EDIT_ITEM) {
      if (valueHolder!.isSubLocation == PsConst.ONE && 
          itemEntryProvider!.item!.itemLocationTownship!.lat != '') {
        _latlng = LatLng(
            double.parse(itemEntryProvider!.item!.itemLocationTownship!.lat!),
            double.parse(itemEntryProvider!.item!.itemLocationTownship!.lng!));
        kGooglePlex = googlemap.CameraPosition(
          target: googlemap.LatLng(
              double.parse(itemEntryProvider!.item!.itemLocationTownship!.lat!),
              double.parse(
                  itemEntryProvider!.item!.itemLocationTownship!.lng!)),
          zoom: widget.zoom!,
        );
      } else {
        _latlng = LatLng(double.parse(itemEntryProvider!.item!.lat!),
            double.parse(itemEntryProvider!.item!.lng!));
        kGooglePlex = googlemap.CameraPosition(
          target: googlemap.LatLng(double.parse(itemEntryProvider!.item!.lat!),
              double.parse(itemEntryProvider!.item!.lng!)),
          zoom: widget.zoom!,
        );
      }
    }

    final Widget _uploadItemWidget = Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space16,
            right: PsDimens.space16,
            top: PsDimens.space16,
            bottom: PsDimens.space48),
        width: double.infinity,
        height: PsDimens.space44,
        child: PSButtonWidget(
          hasShadow: true,
          width: double.infinity,
          titleText: Utils.getString(context, 'login__submit'),
          onPressed: () async {
            if (!widget.isImageSelected.contains(true) &&
                      widget.galleryProvider!.galleryList.data!.isEmpty) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                        message:
                            Utils.getString(context, 'item_entry_need_image'),
                        onPressed: () {});
                  });
            } else if (
                //widget.userInputListingTitle!.text == null ||
                widget.userInputListingTitle!.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                        message: Utils.getString(
                            context, 'item_entry__need_listing_title'),
                        onPressed: () {});
                  });
            } else if (
                //widget.manufacturerController!.text == null ||
                widget.manufacturerController!.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                        message: Utils.getString(
                            context, 'item_entry__need_manufacturer'),
                        onPressed: () {});
                  });
            } else if (widget.modelController!.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                        message:
                            Utils.getString(context, 'item_entry__need_model'),
                        onPressed: () {});
                  });
            } 
            // else if (widget.userInputPlateNumber!.text == '') {
            //   showDialog<dynamic>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return WarningDialog(
            //             message: Utils.getString(
            //                 context, 'item_entry__need_plate_number'),
            //             onPressed: () {});
            //       });
            // } 
            // else if (widget.userInputEnginePower!.text == '') {
            //   showDialog<dynamic>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return WarningDialog(
            //             message: Utils.getString(
            //                 context, 'item_entry__need_engine_power'),
            //             onPressed: () {});
            //       });
            // } 
            // else if (widget.transmissionController!.text == '') {
            //   showDialog<dynamic>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return WarningDialog(
            //             message: Utils.getString(
            //                 context, 'item_entry__need_transmission'),
            //             onPressed: () {});
            //       });
            // }
            //  else if (widget.userInputYear!.text == '') {
            //   showDialog<dynamic>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return WarningDialog(
            //             message:
            //                 Utils.getString(context, 'item_entry__need_year'),
            //             onPressed: () {});
            //       });
            // } else if (widget.typeController!.text == '') {
            //   showDialog<dynamic>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return WarningDialog(
            //             message:
            //                 Utils.getString(context, 'item_entry_need_type'),
            //             onPressed: () {});
            //       });
            // } else if (widget.itemConditionController!.text == '') {
            //   showDialog<dynamic>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return WarningDialog(
            //             message: Utils.getString(
            //                 context, 'item_entry_need_item_condition'),
            //             onPressed: () {});
            //       });
            // }
             else if (widget.priceController!.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                        message: Utils.getString(
                            context, 'item_entry_need_currency_symbol'),
                        onPressed: () {});
                  });
            } else if (widget.userInputPrice!.text == '' || int.parse(widget.userInputPrice!.text) <= 0) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                        message:
                            Utils.getString(context, 'item_entry_need_price'),
                        onPressed: () {});
                  });
            } else if (widget.userInputDescription!.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                        message: Utils.getString(
                            context, 'item_entry_need_description'),
                        onPressed: () {});
                  });
            } 
            // else if (valueHolder!.isSubLocation == PsConst.ONE &&
            //     (
            //         //widget.locationTownshipController!.text == null ||
            //         widget.locationTownshipController!.text == '')) {
            //   showDialog<dynamic>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return WarningDialog(
            //           message: Utils.getString(
            //               context, 'item_entry_need_location_township'),
            //           onPressed: () {},
            //         );
            //       });
            // } 
            else if (widget.provider!.itemLocationId == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_entry_need_location_id'),
                      onPressed: () {},
                    );
                  });
              //  } else if (valueHolder.isSubLocation == PsConst.ONE &&
              //     (widget.locationTownshipController.text == null ||
              //         widget.locationTownshipController.text == '')) {
              //   showDialog<dynamic>(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return WarningDialog(
              //           message: Utils.getString(
              //               context, 'item_entry_need_location_township'),
              //           onPressed: () {},
              //         );
              //       });
            } else if (widget.userInputLattitude!.text == PsConst.ZERO ||
                widget.userInputLattitude!.text == PsConst.ZERO ||
                widget.userInputLattitude!.text == PsConst.INVALID_LAT_LNG ||
                widget.userInputLattitude!.text == PsConst.INVALID_LAT_LNG) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message:
                          Utils.getString(context, 'item_entry_pick_location'),
                      onPressed: () {},
                    );
                  });
            } else {
              if (!PsProgressDialog.isShowing()) {
                await PsProgressDialog.showDialog(context,
                    message: Utils.getString(
                        context, 'progressloading_item_uploading'));
              }
              if (widget.flag == PsConst.ADD_NEW_ITEM) {
                //add new
                final ItemEntryParameterHolder itemEntryParameterHolder =
                    ItemEntryParameterHolder(
                  manufacturerId: widget.provider!.manufacturerId,
                  modelId: widget.provider!.modelId,
                  itemTypeId: widget.provider!.itemTypeId,
                  itemPriceTypeId: widget.provider!.itemPriceTypeId,
                  itemCurrencyId: widget.provider!.itemCurrencyId,
                  conditionOfItemId: widget.provider!.itemConditionId,
                  itemLocationId: widget.provider!.itemLocationId,
                  itemLocationTownshipId:
                      widget.provider!.itemLocationTownshipId,
                  colorId: widget.provider!.itemColorId,
                  fuelTypeId: widget.provider!.fuelTypeId,
                  buildTypeId: widget.provider!.buildTypeId,
                  sellerTypeId: widget.provider!.sellerTypeId,
                  transmissionId: widget.provider!.transmissionId,
                  description: widget.userInputDescription!.text,
                  highlightInfomation:
                      widget.userInputHighLightInformation!.text,
                  price: widget.userInputPrice!.text,
                  discountRate: widget.userInputDiscount!.text,
                  businessMode: widget.provider!.checkOrNotShop,
                  isSoldOut: '',
                  title: widget.userInputListingTitle!.text,
                  address: widget.userInputAddress!.text,
                  latitude: widget.userInputLattitude!.text,
                  longitude: widget.userInputLongitude!.text,
                  plateNumber: widget.userInputPlateNumber!.text,
                  enginePower: widget.userInputEnginePower!.text,
                  steeringPosition: widget.userInputSteeringPosition!.text,
                  noOfOwner: widget.userInputNumOfOwner!.text,
                  trimName: widget.userInputTrimName!.text,
                  vehicleId: widget.userInputVehicleId!.text,
                  priceUnit: widget.userInputPriceUnit!.text,
                  year: widget.userInputYear!.text,
                  // licenceStatus: widget.provider.licenceStatus,
                  maxPassengers: widget.userInputMaximumPassenger!.text,
                  noOfDoors: widget.userInputNumOfDoor!.text,
                  mileage: widget.userInputMileage!.text,
                  licenseEexpirationDate: widget.userInputLicenseExpDate!.text,
                  id: widget.provider!.itemId,
                  addedUserId: widget.provider!.psValueHolder!.loginUserId,
                );

                final PsResource<Product> itemData = await widget.provider!
                    .postItemEntry(itemEntryParameterHolder.toMap(), widget.provider!.psValueHolder!.loginUserId!);
                PsProgressDialog.dismissDialog();

                if (itemData.status == PsStatus.SUCCESS) {
                  widget.provider!.itemId = itemData.data!.id!;
                  if (itemData.data != null) {
                    if (widget.isImageSelected.contains(true)) {
                      widget.uploadImage!(itemData.data!.id);
                    }
                  }
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: itemData.message,
                        );
                      });
                }
              } else {
                // edit item

                final ItemEntryParameterHolder itemEntryParameterHolder =
                    ItemEntryParameterHolder(
                  manufacturerId: widget.provider!.manufacturerId,
                  modelId: widget.provider!.modelId,
                  itemTypeId: widget.provider!.itemTypeId,
                  itemPriceTypeId: widget.provider!.itemPriceTypeId,
                  itemCurrencyId: widget.provider!.itemCurrencyId,
                  conditionOfItemId: widget.provider!.itemConditionId,
                  itemLocationId: widget.provider!.itemLocationId,
                  itemLocationTownshipId:
                      widget.provider!.itemLocationTownshipId,
                  colorId: widget.provider!.itemColorId,
                  fuelTypeId: widget.provider!.fuelTypeId,
                  buildTypeId: widget.provider!.buildTypeId,
                  sellerTypeId: widget.provider!.sellerTypeId,
                  transmissionId: widget.provider!.transmissionId,
                  description: widget.userInputDescription!.text,
                  highlightInfomation:
                      widget.userInputHighLightInformation!.text,
                  price: widget.userInputPrice!.text,
                  discountRate: widget.userInputDiscount!.text,
                  businessMode: widget.provider!.checkOrNotShop,
                  isSoldOut: widget.item!.isSoldOut,
                  title: widget.userInputListingTitle!.text,
                  address: widget.userInputAddress!.text,
                  latitude: widget.userInputLattitude!.text,
                  longitude: widget.userInputLongitude!.text,
                  plateNumber: widget.userInputPlateNumber!.text,
                  enginePower: widget.userInputEnginePower!.text,
                  steeringPosition: widget.userInputSteeringPosition!.text,
                  noOfOwner: widget.userInputNumOfOwner!.text,
                  trimName: widget.userInputTrimName!.text,
                  vehicleId: widget.userInputVehicleId!.text,
                  priceUnit: widget.userInputPriceUnit!.text,
                  year: widget.userInputYear!.text,
                  // licenceStatus: widget.provider.licenceStatus,
                  maxPassengers: widget.userInputMaximumPassenger!.text,
                  noOfDoors: widget.userInputNumOfDoor!.text,
                  mileage: widget.userInputMileage!.text,
                  licenseEexpirationDate: widget.userInputLicenseExpDate!.text,
                  id: widget.item!.id,
                  addedUserId: widget.provider!.psValueHolder!.loginUserId,
                );

                final PsResource<Product> itemData = await widget.provider!
                    .postItemEntry(itemEntryParameterHolder.toMap(),widget.provider!.psValueHolder!.loginUserId!);
                PsProgressDialog.dismissDialog();
                if (itemData.status == PsStatus.SUCCESS) {
                  if (itemData.data != null) {
                    Fluttertoast.showToast(
                        msg: 'Item Uploaded',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white);

                    if (widget.isImageSelected.contains(true) || widget.isSelectedVideoImagePath!) {
                      widget.uploadImage!(itemData.data!.id);
                    }
                  }
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: itemData.message,
                        );
                      });
                }
              }
            }
          },
        ));

    return Column(children: <Widget>[
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__listing_title'),
        textAboutMe: false,
        hintText: Utils.getString(context, 'item_entry__entry_title'),
        textEditingController: widget.userInputListingTitle,
        isStar: true,
      ),
      PsDropdownBaseWithControllerWidget(
        title: Utils.getString(context, 'item_entry__manufacture'),
        textEditingController: widget.manufacturerController,
        isStar: true,
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          final ItemEntryProvider provider =
              Provider.of<ItemEntryProvider>(context, listen: false);

          final dynamic categoryResult = await Navigator.pushNamed(
              context, RoutePaths.manufacturer,
              arguments: widget.manufacturerController!.text);

          if (categoryResult != null && categoryResult is Manufacturer) {
            provider.manufacturerId = categoryResult.id!;
            widget.manufacturerController!.text = categoryResult.name!;
            provider.modelId = '';
            if (mounted) {
              setState(() {
                widget.manufacturerController!.text = categoryResult.name!;
                widget.modelController!.text = '';
              });
            }
          } else if (categoryResult) {
            widget.manufacturerController!.text = '';
          }
        },
      ),
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__model'),
          textEditingController: widget.modelController,
          isStar: true,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);
            if (provider.manufacturerId != '') {
              final dynamic subCategoryResult = await Navigator.pushNamed(
                  context, RoutePaths.searchSubCategory,
                  arguments: ModelIntentHolder(
                      modelName: widget.modelController!.text,
                      categoryId: provider.manufacturerId));
              if (subCategoryResult != null && subCategoryResult is Model) {
                provider.modelId = subCategoryResult.id!;

                widget.modelController!.text = subCategoryResult.name!;
              } else if (subCategoryResult) {
                widget.modelController!.text = '';
              }
            } else {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message: Utils.getString(
                          context, 'home_search__choose_manufacturer_first'),
                    );
                  });
              const ErrorDialog(message: 'Choose Category first');
            }
          }),
      if (Utils.showUI(valueHolder!.plateNumber))    
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__plate_number'),
        textAboutMe: false,
        textEditingController: widget.userInputPlateNumber,
        isStar: false,
      ),
      if (Utils.showUI(valueHolder!.enginePower))
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__engine_power'),
        textAboutMe: false,
        textEditingController: widget.userInputEnginePower,
        isStar: false,
      ),
      if (Utils.showUI(valueHolder!.transmissionId))
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__transmission'),
          textEditingController: widget.transmissionController,
          isStar: false,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());

            final dynamic transmissionResult = await Navigator.pushNamed(
                context, RoutePaths.transmission,
                arguments: widget.transmissionController!.text);

            if (transmissionResult != null &&
                transmissionResult is Transmission) {
              widget.provider!.transmissionId = transmissionResult.id!;
              widget.transmissionController!.text = transmissionResult.name!;
              if (mounted) {
                setState(() {
                  widget.transmissionController!.text =
                      transmissionResult.name!;
                });
              }
            } else if (transmissionResult) {
              widget.transmissionController!.text = '';
            }
          }),
      if (Utils.showUI(valueHolder!.mileage))    
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__mileage'),
        textAboutMe: false,
        textEditingController: widget.userInputMileage,
        isStar: false,
      ),
      if (Utils.showUI(valueHolder!.licenceExpirationDate))
      PsTextFieldWidget(
        titleText:
            Utils.getString(context, 'item_entry__license_expiration_date'),
        textAboutMe: false,
        textEditingController: widget.userInputLicenseExpDate,
        isStar: false,
      ),
      if (Utils.showUI(valueHolder!.year))
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__year'),
        textAboutMe: false,
        textEditingController: widget.userInputYear,
        isStar: false,
      ),
      if (Utils.showUI(valueHolder!.color))
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__color'),
          textEditingController: widget.itemColorController,
          isStar: false,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());

            final dynamic itemColorResult = await Navigator.pushNamed(
                context, RoutePaths.itemColor,
                arguments: widget.itemColorController!.text);

            if (itemColorResult != null && itemColorResult is ItemColor) {
              widget.provider!.itemColorId = itemColorResult.id!;
              widget.itemColorController!.text = itemColorResult.colorValue!;
              if (mounted) {
                setState(() {
                  widget.itemColorController!.text =
                      itemColorResult.colorValue!;
                });
              }
            } else if (itemColorResult) {
              widget.itemColorController!.text = '';
            }
          }),
      if (Utils.showUI(valueHolder!.fuelType))    
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__fuel_type'),
          textEditingController: widget.itemFuelTypeController,
          isStar: false,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());

            final dynamic itemFuelTypeResult = await Navigator.pushNamed(
                context, RoutePaths.itemFuelType,
                arguments: widget.itemFuelTypeController!.text);

            if (itemFuelTypeResult != null &&
                itemFuelTypeResult is ItemFuelType) {
              widget.provider!.fuelTypeId = itemFuelTypeResult.id!;
              widget.itemFuelTypeController!.text =
                  itemFuelTypeResult.fuelName!;
              if (mounted) {
                setState(() {
                  widget.itemFuelTypeController!.text =
                      itemFuelTypeResult.fuelName!;
                });
              }
            } else if (itemFuelTypeResult) {
              widget.itemFuelTypeController!.text = '';
            }
          }),
      if (Utils.showUI(valueHolder!.steeringPosition))    
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__steering_position'),
        textAboutMe: false,
        textEditingController: widget.userInputSteeringPosition,
        isStar: false,
      ),
      if (Utils.showUI(valueHolder!.noOfOwner))
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__number_of_owner'),
        textAboutMe: false,
        textEditingController: widget.userInputNumOfOwner,
        isStar: false,
      ),
      if (Utils.showUI(valueHolder!.trimName))
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__trim_name'),
        textAboutMe: false,
        textEditingController: widget.userInputTrimName,
        isStar: false,
      ),
      if (Utils.showUI(valueHolder!.vehicleId))
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__vehicle_id'),
        textAboutMe: false,
        textEditingController: widget.userInputVehicleId,
        isStar: false,
      ),
      if (Utils.showUI(valueHolder!.buildType))
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__build_type'),
          textEditingController: widget.itemBuildTypeController,
          isStar: false,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());

            final dynamic itemBuildTypeResult = await Navigator.pushNamed(
                context, RoutePaths.itemBuildType,
                arguments: widget.itemBuildTypeController!.text);

            if (itemBuildTypeResult != null &&
                itemBuildTypeResult is ItemBuildType) {
              widget.provider!.buildTypeId = itemBuildTypeResult.id!;
              widget.itemBuildTypeController!.text =
                  itemBuildTypeResult.carType!;
              if (mounted) {
                setState(() {
                  widget.itemBuildTypeController!.text =
                      itemBuildTypeResult.carType!;
                });
              }
            } else if (itemBuildTypeResult) {
              widget.itemBuildTypeController!.text = '';
            }
          }),
      if (Utils.showUI(valueHolder!.licenceStatus))    
      Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: PsDimens.space12,right: 12),
            child: Text(Utils.getString(context, 'item_entry__licence_status'),
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          LicenseCheckbox(
            provider: widget.provider!,
            onCheckBoxClick: () {
              if (mounted) {
                setState(() {
                  updateLicenseCheckBox(context, widget.provider!);
                });
              }
            },
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: PsDimens.space40),
          //   child: Text(
          //       Utils.getString(context, 'item_entry__show_more_than_one'),
          //       style: Theme.of(context).textTheme.bodyText1),
          // ),
        ],
      ),
      if (Utils.showUI(valueHolder!.maxPassengers))  
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__maximum_passenger'),
        textAboutMe: false,
        textEditingController: widget.userInputMaximumPassenger,
        isStar: false,
      ),
      if (Utils.showUI(valueHolder!.noOfDoors))  
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__number_of_door'),
        textAboutMe: false,
        textEditingController: widget.userInputNumOfDoor,
        isStar: false,
      ),
      if (Utils.showUI(valueHolder!.sellerType))  
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__seller_type'),
          textEditingController: widget.itemSellerTypeController,
          isStar: false,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());

            final dynamic itemSellerTypeResult = await Navigator.pushNamed(
                context, RoutePaths.itemSellerType,
                arguments: widget.itemSellerTypeController!.text);

            if (itemSellerTypeResult != null &&
                itemSellerTypeResult is ItemSellerType) {
              widget.provider!.sellerTypeId = itemSellerTypeResult.id!;
              widget.itemSellerTypeController!.text =
                  itemSellerTypeResult.sellerType!;
              if (mounted) {
                setState(() {
                  widget.itemSellerTypeController!.text =
                      itemSellerTypeResult.sellerType!;
                });
              }
            } else if (itemSellerTypeResult) {
              widget.itemSellerTypeController!.text = '';
            }
          }),
      if (Utils.showUI(valueHolder!.itemType))      
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__type'),
          textEditingController: widget.typeController,
          isStar: false,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);

            final dynamic itemTypeResult = await Navigator.pushNamed(
                context, RoutePaths.itemType,
                arguments: widget.typeController!.text);

            if (itemTypeResult != null && itemTypeResult is ItemType) {
              provider.itemTypeId = itemTypeResult.id!;
              if (mounted) {
                setState(() {
                  widget.typeController!.text = itemTypeResult.name!;
                });
              }
            } else if (itemTypeResult) {
              widget.typeController!.text = '';
            }
          }),
      if (Utils.showUI(valueHolder!.condition))      
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__item_condition'),
          textEditingController: widget.itemConditionController,
          isStar: false,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);

            final dynamic itemConditionResult = await Navigator.pushNamed(
                context, RoutePaths.itemCondition,
                arguments: widget.itemConditionController!.text);

            if (itemConditionResult != null &&
                itemConditionResult is ConditionOfItem) {
              provider.itemConditionId = itemConditionResult.id!;
              if (mounted) {
                setState(() {
                  widget.itemConditionController!.text =
                      itemConditionResult.name!;
                });
              }
            } else if (itemConditionResult) {
              widget.itemConditionController!.text = '';
            }
          }),
      if (Utils.showUI(valueHolder!.priceUnit))      
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__price_unit'),
        textAboutMe: false,
        textEditingController: widget.userInputPriceUnit,
      ),
      if (Utils.showUI(valueHolder!.priceType))  
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__price_type'),
          textEditingController: widget.priceTypeController,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);

            final dynamic itemPriceTypeResult = await Navigator.pushNamed(
                context, RoutePaths.itemPriceType,
                arguments: widget.priceTypeController!.text);

            if (itemPriceTypeResult != null &&
                itemPriceTypeResult is ItemPriceType) {
              provider.itemPriceTypeId = itemPriceTypeResult.id!;
              if (mounted) {
                setState(() {
                  widget.priceTypeController!.text = itemPriceTypeResult.name!;
                });
              }
            } else if (itemPriceTypeResult) {
              widget.priceTypeController!.text = '';
            }
          }),
      PriceDropDownControllerWidget(
          currencySymbolController: widget.priceController!,
          userInputPriceController: widget.userInputPrice!),
      if (Utils.showUI(valueHolder!.discountRate))  
      PsTextFieldWidget(
        //  height: 46,
        titleText: Utils.getString(context, 'item_entry__discount_title'),
        textAboutMe: false,
        hintText: Utils.getString(context, 'item_entry__discount_info'),
        textEditingController: widget.userInputDiscount,
        keyboardType: TextInputType.number,
      ),    
      const SizedBox(height: PsDimens.space8),
      if (Utils.showUI(valueHolder!.businessMode))  
      Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: PsDimens.space12,right: 12),
            child: Text(Utils.getString(context, 'item_entry__for_free_item'),
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(height: PsDimens.space8),
          Padding(
            padding: const EdgeInsets.only(left: PsDimens.space12,right: 12),
            child: Text(Utils.getString(context, 'item_entry__shop_setting'),
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          BusinessModeCheckbox(
            provider: widget.provider!,
            onCheckBoxClick: () {
              if (mounted) {
                setState(() {
                  updateCheckBox(context, widget.provider!);
                });
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: PsDimens.space40,right: 12),
            child: Text(
                Utils.getString(context, 'item_entry__show_more_than_one'),
                style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
      if (Utils.showUI(valueHolder!.highlightInfo))
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__highlight_info'),
        height: PsDimens.space120,
        hintText: Utils.getString(context, 'item_entry__highlight_info'),
        textAboutMe: true,
        textEditingController: widget.userInputHighLightInformation,
      ),
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__description'),
        height: PsDimens.space120,
        hintText: Utils.getString(context, 'item_entry__description'),
        textAboutMe: true,
        textEditingController: widget.userInputDescription,
        isStar: true,
      ),
      // Column(
      //   children: <Widget>[
      //     PsDropdownBaseWithControllerWidget(
      //         title: Utils.getString(context, 'item_entry__deal_option'),
      //         textEditingController: widget.dealOptionController,
      //         isStar: true,
      //         onTap: () async {
      //           FocusScope.of(context).requestFocus(FocusNode());
      //           final ItemEntryProvider provider =
      //               Provider.of<ItemEntryProvider>(context, listen: false);

      //           final dynamic itemDealOptionResult = await Navigator.pushNamed(
      //               context, RoutePaths.itemDealOption);

      //           if (itemDealOptionResult != null &&
      //               itemDealOptionResult is DealOption) {
      //             provider.itemDealOptionId = itemDealOptionResult.id;

      //             setState(() {
      //               widget.dealOptionController.text =
      //                   itemDealOptionResult.name;
      //             });
      //           }
      //         }),
      //     Container(
      //       width: double.infinity,
      //       height: PsDimens.space44,
      //       margin: const EdgeInsets.only(
      //           left: PsDimens.space12,
      //           right: PsDimens.space12,
      //           bottom: PsDimens.space12),
      //       decoration: BoxDecoration(
      //         color:
      //             Utils.isLightMode(context) ? Colors.white60 : Colors.black54,
      //         borderRadius: BorderRadius.circular(PsDimens.space4),
      //         border: Border.all(
      //             color: Utils.isLightMode(context)
      //                 ? Colors.grey[200]
      //                 : Colors.black87),
      //       ),
      //       child: TextField(
      //         keyboardType: TextInputType.text,
      //         maxLines: null,
      //         controller: widget.userInputDealOptionText,
      //         style: Theme.of(context).textTheme.bodyText1,
      //         decoration: InputDecoration(
      //           contentPadding: const EdgeInsets.only(
      //             left: PsDimens.space12,
      //             bottom: PsDimens.space8,
      //           ),
      //           border: InputBorder.none,
      //           hintText: Utils.getString(context, 'item_entry__remark'),
      //           hintStyle: Theme.of(context)
      //               .textTheme
      //               .bodyText1
      //               .copyWith(color: PsColors.textPrimaryLightColor),
      //         ),
      //       ),
      //     )
      //   ],
      // ),
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__location'),
          // selectedText: provider.selectedItemLocation == ''
          //     ? provider.psValueHolder.locactionName
          //     : provider.selectedItemLocation,

          textEditingController:
              // locationController.text == ''
              // ?
              // provider.psValueHolder.locactionName
              // :
              widget.locationController,
          isStar: true,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);

            final dynamic itemLocationResult = await Navigator.pushNamed(
                context, RoutePaths.itemLocation,
                arguments: widget.locationController!.text);

            if (itemLocationResult != null &&
                itemLocationResult is ItemLocation) {
              provider.itemLocationId = itemLocationResult.id!;
              if (mounted) {
                setState(() {
                  widget.locationController!.text = itemLocationResult.name!;
                  if (valueHolder!.isUseGoogleMap! &&
                      valueHolder!.isSubLocation == PsConst.ZERO) {
                    _kLake = googlemap.CameraPosition(
                        target: googlemap.LatLng(
                            _latlng!.latitude, _latlng!.longitude),
                        zoom: widget.zoom!);
                    if (_kLake != null) {
                      widget.googleMapController!.animateCamera(
                          googlemap.CameraUpdate.newCameraPosition(_kLake!));
                    }
                    widget.userInputLattitude!.text = itemLocationResult.lat!;
                    widget.userInputLongitude!.text = itemLocationResult.lng!;
                  } else if (!valueHolder!.isUseGoogleMap! &&
                      valueHolder!.isSubLocation == PsConst.ZERO) {
                    _latlng = LatLng(double.parse(itemLocationResult.lat!),
                        double.parse(itemLocationResult.lng!));
                    widget.mapController!.move(_latlng!, widget.zoom!);
                    widget.userInputLattitude!.text = itemLocationResult.lat!;
                    widget.userInputLongitude!.text = itemLocationResult.lng!;
                  } else {
                    //do nothing
                  }

                  widget.locationTownshipController!.text = '';
                  provider.itemLocationTownshipId = '';
                  widget.userInputAddress!.text = '';
                });
              }
            }
          }),
      if (valueHolder!.isSubLocation == PsConst.ONE)
        PsDropdownBaseWithControllerWidget(
            title: Utils.getString(context, 'item_entry__location_township'),
            textEditingController: widget.locationTownshipController,
            isStar: false,
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              final ItemEntryProvider provider =
                  Provider.of<ItemEntryProvider>(context, listen: false);
              if (provider.itemLocationId != '') {
                final dynamic itemLocationTownshipResult =
                    await Navigator.pushNamed(
                        context, RoutePaths.itemLocationTownship,
                        arguments: provider.itemLocationId);

                if (itemLocationTownshipResult != null &&
                    itemLocationTownshipResult is ItemLocationTownship) {
                  provider.itemLocationTownshipId =
                      itemLocationTownshipResult.id!;
                  setState(() {
                    widget.locationTownshipController!.text =
                        itemLocationTownshipResult.townshipName!;
                    if (valueHolder!.isUseGoogleMap!) {
                      _kLake = googlemap.CameraPosition(
                          target: googlemap.LatLng(
                              _latlng!.latitude, _latlng!.longitude),
                          zoom: widget.zoom!);
                      if (_kLake != null) {
                        widget.googleMapController!.animateCamera(
                            googlemap.CameraUpdate.newCameraPosition(_kLake!));
                      }
                    } else {
                      _latlng = LatLng(
                          double.parse(itemLocationTownshipResult.lat!),
                          double.parse(itemLocationTownshipResult.lng!));
                      widget.mapController!.move(_latlng!, widget.zoom!);
                    }
                    widget.userInputLattitude!.text =
                        itemLocationTownshipResult.lat!;
                    widget.userInputLongitude!.text =
                        itemLocationTownshipResult.lng!;

                    widget.userInputAddress!.text = '';
                  });
                }
              } else {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: Utils.getString(
                            context, 'home_search__choose_city_first'),
                      );
                    });
                const ErrorDialog(message: 'Choose City first');
              }
            })
      else
        Container(),
      if (!valueHolder!.isUseGoogleMap!)
        Column(
          children: <Widget>[
            CurrentLocationWidget(
              androidFusedLocation: true,
              textEditingController: widget.userInputAddress!,
              latController: widget.userInputLattitude!,
              lngController: widget.userInputLongitude!,
              valueHolder: valueHolder!,
              updateLatLng: (Position? currentPosition) {
                if (currentPosition != null) {
                  setState(() {
                    _latlng = LatLng(
                        currentPosition.latitude, currentPosition.longitude);
                    widget.mapController!.move(_latlng!, widget.zoom!);
                  });
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: Container(
                height: 250,
                child: 
                FlutterMap(
                  mapController: widget.mapController,
                  options: MapOptions(
                      center:
                          _latlng, //LatLng(51.5, -0.09), //LatLng(45.5231, -122.6765),
                      zoom: widget.zoom!, //10.0,
                      onTap: (dynamic tapPosition, LatLng latLngr) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _handleTap(_latlng!, widget.mapController!);
                      }),
                      children: [
                         TileLayer(
                        urlTemplate:'https://tile.openstreetmap.org/{z}/{x}/{y}.png',   
                         ),
                         MarkerLayer(
                          markers: <Marker>[
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _latlng!,
                        builder: (BuildContext ctx) => Container(
                          child: IconButton(
                            icon: Icon(
                              Icons.location_on,
                              color: PsColors.mainColor,
                            ),
                            iconSize: 45,
                            onPressed: () {},
                          ),
                        ),
                      )
                    ],
                         )
                      ],
               
                ),
            
              ),
            ),
          ],
        )
      else
        Column(
          children: <Widget>[
            CurrentLocationWidget(
              androidFusedLocation: true,
              textEditingController: widget.userInputAddress!,
              latController: widget.userInputLattitude!,
              lngController: widget.userInputLongitude!,
              valueHolder: valueHolder!,
              updateLatLng: (Position? currentPosition) {
                if (currentPosition != null) {
                  setState(() {
                    _latlng = LatLng(
                        currentPosition.latitude, currentPosition.longitude);
                    _kLake = googlemap.CameraPosition(
                        target: googlemap.LatLng(
                            _latlng!.latitude, _latlng!.longitude),
                        zoom: widget.zoom!);
                    if (_kLake != null) {
                      widget.googleMapController!.animateCamera(
                          googlemap.CameraUpdate.newCameraPosition(_kLake!));
                    }
                  });
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18, left: 18),
              child: Container(
                height: 250,
                child: googlemap.GoogleMap(
                    onMapCreated: widget.updateMapController as void Function(
                        googlemap.GoogleMapController)?,
                    initialCameraPosition: kGooglePlex!,
                    circles: <googlemap.Circle>{}..add(googlemap.Circle(
                        circleId: googlemap.CircleId(
                            widget.userInputAddress.toString()),
                        center: googlemap.LatLng(
                            _latlng!.latitude, _latlng!.longitude),
                        radius: 50,
                        fillColor: Colors.blue.withOpacity(0.7),
                        strokeWidth: 3,
                        strokeColor: Colors.redAccent,
                      )),
                    onTap: (googlemap.LatLng latLngr) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _handleGoogleMapTap(
                          _latlng!, widget.googleMapController!);
                    }),
              ),
            ),
          ],
        ),
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__latitude'),
        textAboutMe: false,
        textEditingController: widget.userInputLattitude,
      ),
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__longitude'),
        textAboutMe: false,
        textEditingController: widget.userInputLongitude,
      ),
      if (Utils.showUI(valueHolder!.address))  
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__address'),
        textAboutMe: false,
        height: PsDimens.space160,
        textEditingController: widget.userInputAddress,
        hintText: Utils.getString(context, 'item_entry__address'),
      ),
      _uploadItemWidget
    ]);
  }

  dynamic _handleTap(LatLng latLng, MapController mapController) async {
    final dynamic result = await Navigator.pushNamed(context, RoutePaths.mapPin,
        arguments: MapPinIntentHolder(
            flag: PsConst.PIN_MAP,
            mapLat: _latlng!.latitude.toString(),
            mapLng: _latlng!.longitude.toString()));
    if (result != null && result is MapPinCallBackHolder) {
      if (mounted) {
        setState(() {
          _latlng = result.latLng;
          mapController.move(_latlng!, widget.zoom!);
          widget.userInputAddress!.text = result.address;
          // tappedPoints = <LatLng>[];
          // tappedPoints.add(latlng);
        });
      }
      widget.userInputLattitude!.text = result.latLng.latitude.toString();
      widget.userInputLongitude!.text = result.latLng.longitude.toString();
    }
  }

  dynamic _handleGoogleMapTap(
      LatLng latLng, googlemap.GoogleMapController googleMapController) async {
    final dynamic result = await Navigator.pushNamed(
        context, RoutePaths.googleMapPin,
        arguments: MapPinIntentHolder(
            flag: PsConst.PIN_MAP,
            mapLat: _latlng!.latitude.toString(),
            mapLng: _latlng!.longitude.toString()));
    if (result != null && result is GoogleMapPinCallBackHolder) {
      setState(() {
        _latlng = LatLng(result.latLng.latitude, result.latLng.longitude);
        _kLake = googlemap.CameraPosition(
            target: googlemap.LatLng(_latlng!.latitude, _latlng!.longitude),
            zoom: widget.zoom!);
        if (_kLake != null) {
          googleMapController
              .animateCamera(googlemap.CameraUpdate.newCameraPosition(_kLake!));
          widget.userInputAddress!.text = result.address;
          widget.userInputAddress!.text = '';
          // tappedPoints = <LatLng>[];
          // tappedPoints.add(latlng);
        }
      });
      widget.userInputLattitude!.text = result.latLng.latitude.toString();
      widget.userInputLongitude!.text = result.latLng.longitude.toString();
    }
  }
}

class ImageUploadHorizontalList extends StatefulWidget {
  const ImageUploadHorizontalList({
    required this.flag,
    required this.images,
    required this.selectedImageList,
    required this.updateImages,
    required this.updateImagesFromCustomCamera,
    required this.updateImagesFromVideo,
    required this.selectedVideoImagePath,
    required this.videoFilePath,
    required this.videoFileThumbnailPath,
    required this.selectedVideoPath,
    required this.galleryImagePath,
    required this.cameraImagePath,
    required this.getImageFromVideo,
    required this.imageDesc1Controller,
    required this.galleryProvider,
    required this.onReorder,
    this.provider,
  });
  final String? flag;
  final List<Asset>? images;
  final List<DefaultPhoto?>? selectedImageList;
  final Function? updateImages;
  final Function? updateImagesFromCustomCamera;
  final String? selectedVideoImagePath;
  final String? videoFilePath;
  final String? selectedVideoPath;
  final String? videoFileThumbnailPath;
  final Function? updateImagesFromVideo;
  final List<Asset?> galleryImagePath;
  final List<String?> cameraImagePath;
  final Function? getImageFromVideo;
  final TextEditingController? imageDesc1Controller;
  final ItemEntryProvider? provider;
  final GalleryProvider? galleryProvider;
  final Function onReorder;

  @override
  State<StatefulWidget> createState() {
    return ImageUploadHorizontalListState();
  }
}

class ImageUploadHorizontalListState extends State<ImageUploadHorizontalList> {
  late ItemEntryProvider provider;
  late PsValueHolder psValueHolder;
  Future<void> loadPickMultiImage(int index) async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: psValueHolder.maxImageCount - index,
        enableCamera: true,
        // selectedAssets: widget.images,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: 'chat'),
        materialOptions: MaterialOptions(
          actionBarColor: Utils.convertColorToString(PsColors.black!),
          actionBarTitleColor: Utils.convertColorToString(PsColors.white!),
          statusBarColor: Utils.convertColorToString(PsColors.black!),
          lightStatusBar: false,
          actionBarTitle: '',
          allViewTitle: 'All Photos',
          useDetailsView: false,
          selectCircleStrokeColor:
              Utils.convertColorToString(PsColors.mainColor!),
        ),
      );
    } on Exception catch (e) {
      e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    for (int i = 0; i < resultList.length; i++) {
      if (resultList[i].name!.contains('.webp')) {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString(context, 'error_dialog__webp_image'),
              );
            });
        return;
      }
    }
    widget.updateImages!(resultList, -1, index);
  }

  Future<void> loadSingleImage(int index) async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
      //  selectedAssets: widget.images!, //widget.images,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: 'chat'),
        materialOptions: MaterialOptions(
          actionBarColor: Utils.convertColorToString(PsColors.black!),
          actionBarTitleColor: Utils.convertColorToString(PsColors.white!),
          statusBarColor: Utils.convertColorToString(PsColors.black!),
          lightStatusBar: false,
          actionBarTitle: '',
          allViewTitle: 'All Photos',
          useDetailsView: false,
          selectCircleStrokeColor:
              Utils.convertColorToString(PsColors.mainColor!),
        ),
      );
    } on Exception catch (e) {
      e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    if (resultList[0].name!.contains('.webp')) {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString(context, 'error_dialog__webp_image'),
            );
          });
    } else {
      widget.updateImages!(resultList, index, index);
    }
  }

  List<Widget> _imageWidgetList = <Widget>[];
  late Widget _videoWidget;
  late Widget _firstImageWidget;
  @override
  Widget build(BuildContext context) {
    Asset? defaultAssetImage;
    DefaultPhoto? defaultUrlImage;
    psValueHolder = Provider.of<PsValueHolder>(context);
    provider = Provider.of<ItemEntryProvider>(context, listen: false);
    List<PlatformFile>? videoFilePath = <PlatformFile>[];

    final Widget _defaultWidget = Container(
      width: 94,
      height: 25,
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
      ),
      margin: const EdgeInsets.only(
          top: PsDimens.space4, left: PsDimens.space6, right: PsDimens.space4),
      child: Material(
        color: PsColors.soldOutUIColor,
        type: MaterialType.card,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(PsDimens.space16))),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
                left: PsDimens.space8, right: PsDimens.space8),
            child: Text(
              Utils.getString(context, 'item_entry__default_image'),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: PsColors.white),
            ),
          ),
        ),
      ),
    );

    _videoWidget = Visibility(
      visible:
          Utils.showUI(provider.psValueHolder!.video), //PsConfig.showVideo,
      child: ItemEntryImageWidget(
        galleryProvider: widget.galleryProvider,
        index: -1, //video
        images: defaultAssetImage,
        selectedVideoImagePath: (widget.selectedVideoImagePath != null)
            ? widget.selectedVideoImagePath
            : null,
        videoFilePath:
            (widget.videoFilePath != null) ? widget.videoFilePath : null,
        videoFileThumbnailPath: (widget.videoFileThumbnailPath != null)
            ? widget.videoFileThumbnailPath
            : null,
        selectedVideoPath: widget.selectedVideoPath,
        cameraImagePath: null,
        provider: provider,
        selectedImage:
            widget.selectedVideoImagePath == null ? defaultUrlImage : null,
        onDeletItemImage: () {
          setState(() {
            final ItemEntryProvider itemEntryProvider =
                Provider.of<ItemEntryProvider>(context, listen: false);
            itemEntryProvider.item!.video!.imgId = '';
            itemEntryProvider.item!.videoThumbnail!.imgId = '';
            itemEntryProvider.item!.video = null;
            itemEntryProvider.item!.videoThumbnail = null;
          });
        },
        hideDesc: true,
        onTap: () async {
          try {
            videoFilePath = (await FilePicker.platform.pickFiles(
              type: FileType.video,
              allowMultiple: true,
            ))
                ?.files;
          } on PlatformException catch (e) {
            print('Unsupported operation' + e.toString());
          } catch (ex) {
            print(ex);
          }
          if (videoFilePath != null) {
            // await PsProgressDialog.showDialog(context);

                     if (videoFilePath != null) {
              final File pickedVideo = File(videoFilePath![0].path!);
              final VideoPlayerController videoPlayer =
                  VideoPlayerController.file(pickedVideo);
              await videoPlayer.initialize();

               final int maximumSecond = int.parse(psValueHolder.videoDuration ?? '60000');
              final int videoDuration = videoPlayer.value.duration.inMilliseconds;

              if (videoDuration < maximumSecond) {
                await widget.getImageFromVideo!(pickedVideo.path);
                widget.updateImagesFromVideo!(pickedVideo.path, -2);
              } else {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                          message: Utils.getString(
                              context, 'error_dialog__select_video'));
                    });
              }
            }

            // PsProgressDialog.dismissDialog();
          }
        },
      ),
    );

    _firstImageWidget = Stack(
      key: const Key('0'),
      children: <Widget>[
        ItemEntryImageWidget(
          galleryProvider: widget.galleryProvider,
          index: 0,
          images: (widget.galleryImagePath[0] != null)
              ? widget.galleryImagePath[0]
              : defaultAssetImage,
          selectedVideoImagePath: null,
          selectedVideoPath: widget.selectedVideoPath,
          videoFilePath: null,
          videoFileThumbnailPath: null,
          cameraImagePath: (widget.cameraImagePath[0] != null)
              ? widget.cameraImagePath[0]
              : defaultAssetImage as String?,
          selectedImage: (widget.selectedImageList!.isNotEmpty &&
                  widget.galleryImagePath[0] == null &&
                  widget.cameraImagePath[0] == null)
              ? widget.selectedImageList![0]
              : null,
          onDeletItemImage: () {},
          hideDesc: false,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            if (provider.psValueHolder!.isCustomCamera) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ChooseCameraTypeDialog(
                      onCameraTap: () async {
                        final dynamic returnData = await Navigator.pushNamed(
                            context, RoutePaths.cameraView);
                        if (returnData is String) {
                          widget.updateImagesFromCustomCamera!(returnData, 0);
                        }
                      },
                      onGalleryTap: () {
                        if (widget.flag == PsConst.ADD_NEW_ITEM) {
                          loadPickMultiImage(0);
                        } else {
                          loadSingleImage(0);
                        }
                      },
                    );
                  });
            } else {
              if (widget.flag == PsConst.ADD_NEW_ITEM) {
                loadPickMultiImage(0);
              } else {
                loadSingleImage(0);
              }
            }
          },
        ),
        Positioned(
          child: _defaultWidget,
          left: 1,
          top: 1,
        ),
      ],
    );

    _imageWidgetList = List<Widget>.generate(
        psValueHolder.maxImageCount - 1,
        (int index) => ItemEntryImageWidget(
              galleryProvider: widget.galleryProvider,
              key: Key('${index + 1}'),
              index: index + 1,
              images: (widget.galleryImagePath[index + 1] != null)
                  ? widget.galleryImagePath[index + 1]
                  : defaultAssetImage,
              selectedVideoImagePath: null,
              selectedVideoPath: widget.selectedVideoPath,
              videoFilePath: null,
              videoFileThumbnailPath: null,
              cameraImagePath: (widget.cameraImagePath[index + 1] != null)
                  ? widget.cameraImagePath[index + 1]
                  : defaultAssetImage as String?,
              selectedImage:
                  // (widget.secondImagePath != null) ? null : defaultUrlImage,
                  (widget.selectedImageList!.length > index + 1 &&
                          widget.galleryImagePath[index + 1] == null &&
                          widget.cameraImagePath[index + 1] == null)
                      ? widget.selectedImageList![index + 1]
                      : null,
              hideDesc: false,
              onDeletItemImage: () {
                setState(() {
                  widget.selectedImageList![index + 1]!.imgId = '';
                  widget.selectedImageList![index + 1] =
                      DefaultPhoto(imgId: '', imgPath: '');
                });
              },
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());

                if (provider.psValueHolder!.isCustomCamera) {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ChooseCameraTypeDialog(
                          onCameraTap: () async {
                            final dynamic returnData =
                                await Navigator.pushNamed(
                                    context, RoutePaths.cameraView);
                            if (returnData is String) {
                              widget.updateImagesFromCustomCamera!(
                                  returnData, index + 1);
                            }
                          },
                          onGalleryTap: () {
                            if (widget.flag == PsConst.ADD_NEW_ITEM) {
                              loadPickMultiImage(index + 1);
                            } else {
                              loadSingleImage(index + 1);
                            }
                          },
                        );
                      });
                } else {
                  if (widget.flag == PsConst.ADD_NEW_ITEM) {
                    loadPickMultiImage(index + 1);
                  } else {
                    loadSingleImage(index + 1);
                  }
                }
              },
            ));

    _imageWidgetList.insert(
        0, _firstImageWidget); // add firt default image widget at index 0

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
            height: PsDimens.space180,
            child: ReorderableListView(
              scrollDirection: Axis.horizontal,
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  widget.onReorder(oldIndex, newIndex);
                });
              },
              header: _videoWidget,
              children: _imageWidgetList,
            ),
          ),
    );
  }
}

class ItemEntryImageWidget extends StatefulWidget {
  const ItemEntryImageWidget(
      {Key? key,
      required this.index,
      required this.images,
      required this.cameraImagePath,
      required this.selectedVideoImagePath,
      required this.selectedVideoPath,
      required this.videoFilePath,
      required this.videoFileThumbnailPath,
      required this.selectedImage,
      required this.hideDesc,
      this.onTap,
      this.provider,
      required this.onDeletItemImage,
      required this.galleryProvider})
      : super(key: key);

  final Function? onTap;
  final Function? onDeletItemImage;
  final int? index;
  final Asset? images;
  final String? cameraImagePath;
  final String? selectedVideoImagePath;
  final String? selectedVideoPath;
  final String? videoFilePath;
  final String? videoFileThumbnailPath;
  final DefaultPhoto? selectedImage;
  final ItemEntryProvider? provider;
  final GalleryProvider? galleryProvider;
  final bool hideDesc;
  @override
  State<StatefulWidget> createState() {
    return ItemEntryImageWidgetState();
  }
}

class ItemEntryImageWidgetState extends State<ItemEntryImageWidget> {
  GalleryProvider? galleryProvider;
  PsValueHolder? valueHolder;
  // int i = 0;
  @override
  Widget build(BuildContext context) {
    galleryProvider = widget.galleryProvider;
    valueHolder = Provider.of<PsValueHolder>(context, listen:false);
    final Widget _deleteWidget = Container(
      child: IconButton(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: PsDimens.space2),
        iconSize: PsDimens.space24,
        icon: const Icon(
          Icons.delete,
          color: Colors.grey,
        ),
        onPressed: () async {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialogView(
                  description: Utils.getString(
                      context, 'item_entry__confirm_delete_item_image'),
                  leftButtonText: Utils.getString(context, 'dialog__cancel'),
                  rightButtonText: Utils.getString(context, 'dialog__ok'),
                  onAgreeTap: () async {
                    Navigator.pop(context);

                    valueHolder =
                        Provider.of<PsValueHolder>(context, listen: false);
                    final DeleteItemImageHolder deleteItemImageHolder =
                        DeleteItemImageHolder(
                            imageId: widget.selectedImage!.imgId);
                    await PsProgressDialog.showDialog(context);
                    final PsResource<ApiStatus> _apiStatus =
                        await galleryProvider!.deleItemImage(
                            deleteItemImageHolder.toMap(),
                            Utils.checkUserLoginId(valueHolder));
                    PsProgressDialog.dismissDialog();
                    if (_apiStatus.data != null) {
                      widget.onDeletItemImage!();
                      galleryProvider!.loadImageList(widget.selectedImage!.imgParentId, PsConst.ITEM_TYPE);
                    } else {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialog(message: _apiStatus.message);
                          });
                    }
                  },
                );
              });
        },
      ),
      width: PsDimens.space32,
      height: PsDimens.space32,
      decoration: BoxDecoration(
        color: PsColors.backgroundColor,
        borderRadius: BorderRadius.circular(PsDimens.space28),
      ),
    );

    final Widget _deleteVideoWidget = Container(
      child: IconButton(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: PsDimens.space2),
        iconSize: PsDimens.space24,
        icon: const Icon(
          Icons.delete,
          color: Colors.grey,
        ),
        onPressed: () async {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialogView(
                  description: Utils.getString(
                      context, 'item_entry__confirm_delete_item_video'),
                  leftButtonText: Utils.getString(context, 'dialog__cancel'),
                  rightButtonText: Utils.getString(context, 'dialog__ok'),
                  onAgreeTap: () async {
                    Navigator.pop(context);

                    valueHolder =
                        Provider.of<PsValueHolder>(context, listen: false);
                    final DeleteItemImageHolder deleteItemImageHolder =
                        DeleteItemImageHolder(
                            imageId: widget.provider!.item!.video!.imgId);
                    final DeleteItemImageHolder deleteItemImageHolder2 =
                        DeleteItemImageHolder(
                            imageId:
                                widget.provider!.item!.videoThumbnail!.imgId);
                    await PsProgressDialog.showDialog(context);
                    final PsResource<ApiStatus> _apiStatus =
                        await galleryProvider!.deleItemVideo(
                            deleteItemImageHolder.toMap(),
                            Utils.checkUserLoginId(valueHolder));
                    final PsResource<ApiStatus> _apiStatus2 =
                        await galleryProvider!.deleItemVideo(
                            deleteItemImageHolder2.toMap(),
                            Utils.checkUserLoginId(valueHolder));
                    PsProgressDialog.dismissDialog();
                    if (_apiStatus.data != null && _apiStatus2.data != null) {
                      widget.onDeletItemImage!();
                    } else {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialog(message: _apiStatus.message);
                          });
                    }
                  },
                );
              });
        },
      ),
      width: PsDimens.space32,
      height: PsDimens.space32,
      decoration: BoxDecoration(
        color: PsColors.backgroundColor,
        borderRadius: BorderRadius.circular(PsDimens.space28),
      ),
    );

    if (widget.selectedImage != null && widget.selectedImage!.imgPath != '') {
      return Padding(
        padding: const EdgeInsets.only(right: 4, left: 4),
        child: InkWell(
          onTap: widget.onTap as void Function()?,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    child: PsNetworkImageWithUrl(
                      photoKey: '',
                      // width: 100,
                      // height: 100,
                      imageAspectRation: PsConst.Aspect_Ratio_1x,
                      imagePath: widget.selectedImage!.imgPath!,
                    ),
                  ),
                  Positioned(
                    child: widget.index == 0 ? Container() : _deleteWidget,
                    right: 1,
                    bottom: 1,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else if (widget.videoFilePath != null ||
        widget.videoFileThumbnailPath != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 4, left: 4),
        child: Column(
          children: <Widget>[
            if (widget.videoFileThumbnailPath != '')
              Stack(children: <Widget>[
                InkWell(
                  onTap: widget.onTap as void Function()?,
                  child: Image(
                      width: 100,
                      height: 100,
                      fit: BoxFit.fill,
                      image: FileImage(File(widget.videoFileThumbnailPath!))),
                ),
                GestureDetector(
                  onTap: widget.onTap as void Function()?,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.only(top: PsDimens.space14),
                      width: 100,
                      height: 100,
                      child: const Icon(
                        Icons.play_circle,
                        color: Colors.black54,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ])
            else
              InkWell(
                  onTap: widget.onTap as void Function()?,
                  child: Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.only(top: PsDimens.space16),
                    child: const Icon(
                      Icons.play_circle,
                      color: Colors.red,
                      size: 50,
                    ),
                  )),
            Visibility(
              visible: Utils.showUI(valueHolder!.video),
              child: Container(
                width: 80,
                padding: const EdgeInsets.only(top: PsDimens.space16),
                child: InkWell(
                  child: PSButtonWidget(
                      width: 30, titleText: Utils.getString(context, 'Play')),
                  onTap: () {
                    if (widget.videoFilePath == null) {
                      Navigator.pushNamed(context, RoutePaths.video_online,
                          arguments: widget.selectedVideoPath);
                    } else {
                      Navigator.pushNamed(context, RoutePaths.video,
                          arguments: widget.videoFilePath);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      if (widget.images != null) {
        final Asset asset = widget.images!;
        return Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: widget.onTap as void Function()?,
                child: AssetThumb(
                  asset: asset,
                  width: 100,
                  height: 100,
                ),
              ),
            ],
          ),
        );
      } else if (widget.cameraImagePath != null) {
        return Container(
          margin: const EdgeInsets.only(right: 4, left: 4),
          child: Stack(
            children: <Widget>[
              InkWell(
                onTap: widget.onTap as void Function(),
                child: ClipRect(
                  child: Image(
                      alignment: Alignment.center,
                      height: 100,
                      width: 100,
                      fit: BoxFit.fill,
                      image: FileImage(File(widget.cameraImagePath!))),
                ),
              ),
            ],
          ),
        );
      } else if (widget.selectedVideoImagePath != null) {
        return Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: Column(
            children: <Widget>[
              if (widget.selectedVideoImagePath != '')
                Stack(children: <Widget>[
                  InkWell(
                    onTap: widget.onTap as void Function()?,
                    child: Container(
                      width: 100,
                      height: 100,
                      child: PsNetworkImageWithUrl(
                        photoKey: '',
                        imageAspectRation: PsConst.Aspect_Ratio_full_image,
                        imagePath: widget.selectedVideoImagePath!,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: widget.onTap as void Function()?,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.only(top: PsDimens.space14),
                        width: 100,
                        height: 100,
                        child: const Icon(
                          Icons.play_circle,
                          color: Colors.black54,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Column(
                      children: <Widget>[
                        if (widget.provider!.item!.video == null &&
                            widget.provider!.item!.videoThumbnail == null &&
                            widget.provider!.item!.videoThumbnail == null)
                          Container()
                        else
                          _deleteVideoWidget
                      ],
                    ),
                    right: 1,
                    bottom: 1,
                  ),
                ])
              else
                InkWell(
                    onTap: widget.onTap as void Function()?,
                    child: Container(
                      padding: const EdgeInsets.only(top: PsDimens.space16),
                      width: 100,
                      height: 100,
                      child: const Icon(
                        Icons.play_circle,
                        color: Colors.black54,
                        size: 50,
                      ),
                    )),
              Flexible(
                child: Container(
                  width: 80,
                  padding: const EdgeInsets.only(top: PsDimens.space16),
                  child: InkWell(
                    child: PSButtonWidget(
                        width: 30, titleText: Utils.getString(context, 'Play')),
                    onTap: () {
                      if (widget.videoFilePath == null) {
                        Navigator.pushNamed(context, RoutePaths.video_online,
                            arguments: widget.selectedVideoPath);
                      } else {
                        Navigator.pushNamed(context, RoutePaths.video,
                            arguments: widget.videoFilePath);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: Column(
            children: <Widget>[
              if (!widget.hideDesc)
                Container(
                  // margin: const EdgeInsets.only(
                  //   bottom: PsDimens.space60,
                  // ),
                  child: InkWell(
                    onTap: widget.onTap as void Function()?,
                    child: Image.asset(
                      'assets/images/default_image.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                InkWell(
                    onTap: widget.onTap as void Function()?,
                    child: Container(
                      width: 100,
                      height: 100,
                      padding: const EdgeInsets.only(top: PsDimens.space16),
                      child: const Icon(
                        Icons.play_circle,
                        color: Colors.grey,
                        size: 50,
                      ),
                    )),
            ],
          ),
        );
      }
    }
  }
}

class PriceDropDownControllerWidget extends StatelessWidget {
  const PriceDropDownControllerWidget(
      {Key? key,
      // @required this.onTap,
      this.currencySymbolController,
      this.userInputPriceController})
      : super(key: key);

  final TextEditingController? currencySymbolController;
  final TextEditingController? userInputPriceController;
  // final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              top: PsDimens.space4,
              right: PsDimens.space12,
              left: PsDimens.space12),
          child: Row(
            children: <Widget>[
              Text(
                Utils.getString(context, 'item_entry__price'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(' *',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: PsColors.mainColor))
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final ItemEntryProvider provider =
                    Provider.of<ItemEntryProvider>(context, listen: false);

                final dynamic itemCurrencySymbolResult =
                    await Navigator.pushNamed(
                        context, RoutePaths.itemCurrencySymbol,
                        arguments: currencySymbolController!.text);

                if (itemCurrencySymbolResult != null &&
                    itemCurrencySymbolResult is ItemCurrency) {
                  provider.itemCurrencyId = itemCurrencySymbolResult.id!;

                  currencySymbolController!.text =
                      itemCurrencySymbolResult.currencySymbol!;
                }
                //  else if (itemCurrencySymbolResult) {
                //   currencySymbolController.text = '';
                // }
              },
              child: Container(
                // width: PsDimens.space140,
                height: PsDimens.space44,
                margin: const EdgeInsets.all(PsDimens.space12),
                decoration: BoxDecoration(
                  color: Utils.isLightMode(context)
                      ? Colors.white60
                      : Colors.black54,
                  borderRadius: BorderRadius.circular(PsDimens.space4),
                  border: Border.all(
                      color: Utils.isLightMode(context)
                          ? Colors.grey[200]!
                          : Colors.black87),
                ),
                child: Container(
                  margin: const EdgeInsets.all(PsDimens.space12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        child: Ink(
                          color: PsColors.backgroundColor,
                          child: Text(
                            currencySymbolController!.text == ''
                                ? Utils.getString(
                                    context, 'home_search__not_set')
                                : currencySymbolController!.text,
                            style: currencySymbolController!.text == ''
                                ? Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: Colors.grey[600])
                                : Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: PsDimens.space44,
                // margin: const EdgeInsets.only(
                //     top: 24),
                decoration: BoxDecoration(
                  color: Utils.isLightMode(context)
                      ? Colors.white60
                      : Colors.black54,
                  borderRadius: BorderRadius.circular(PsDimens.space4),
                  border: Border.all(
                      color: Utils.isLightMode(context)
                          ? Colors.grey[200]!
                          : Colors.black87),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  maxLines: null,
                  controller: userInputPriceController,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: PsDimens.space12, bottom: PsDimens.space4),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: PsDimens.space8),
          ],
        ),
      ],
    );
  }
}

class LicenseCheckbox extends StatefulWidget {
  const LicenseCheckbox(
      {required this.provider, required this.onCheckBoxClick});

  // final String checkOrNot;
  final ItemEntryProvider? provider;
  final Function? onCheckBoxClick;
  @override
  _LicenseCheckboxState createState() => _LicenseCheckboxState();
}

class _LicenseCheckboxState extends State<LicenseCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Theme(
          data: ThemeData(unselectedWidgetColor: Colors.grey),
          child: Checkbox(
            activeColor: PsColors.mainColor,
            value: widget.provider!.isLicenseCheckBoxSelect,
            onChanged: (bool? value) {
              widget.onCheckBoxClick!();
            },
          ),
        ),
        Expanded(
          child: InkWell(
            child: Text(Utils.getString(context, 'item_entry__is_lince'),
                style: Theme.of(context).textTheme.bodyLarge),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              widget.onCheckBoxClick!();
            },
          ),
        ),
      ],
    );
  }
}

void updateLicenseCheckBox(BuildContext context, ItemEntryProvider provider) {
  if (provider.isLicenseCheckBoxSelect) {
    provider.isLicenseCheckBoxSelect = false;
    provider.checkOrNotLicense = '0';
  } else {
    provider.isLicenseCheckBoxSelect = true;
    provider.checkOrNotLicense = '1';
    // Navigator.pushNamed(context, RoutePaths.privacyPolicy, arguments: 2);
  }
}

class BusinessModeCheckbox extends StatefulWidget {
  const BusinessModeCheckbox(
      {required this.provider, required this.onCheckBoxClick});

  // final String checkOrNot;
  final ItemEntryProvider? provider;
  final Function? onCheckBoxClick;

  @override
  _BusinessModeCheckbox createState() => _BusinessModeCheckbox();
}

class _BusinessModeCheckbox extends State<BusinessModeCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Theme(
          data: ThemeData(unselectedWidgetColor: Colors.grey),
          child: Checkbox(
            activeColor: PsColors.mainColor,
            value: widget.provider!.isCheckBoxSelect,
            onChanged: (bool? value) {
              widget.onCheckBoxClick!();
            },
          ),
        ),
        Expanded(
          child: InkWell(
            child: Text(Utils.getString(context, 'item_entry__is_shop'),
                style: Theme.of(context).textTheme.bodyLarge),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              widget.onCheckBoxClick!();
            },
          ),
        ),
      ],
    );
  }
}

void updateCheckBox(BuildContext context, ItemEntryProvider provider) {
  if (provider.isCheckBoxSelect) {
    provider.isCheckBoxSelect = false;
    provider.checkOrNotShop = '0';
  } else {
    provider.isCheckBoxSelect = true;
    provider.checkOrNotShop = '1';
    // Navigator.pushNamed(context, RoutePaths.privacyPolicy, arguments: 2);
  }
}

class CurrentLocationWidget extends StatefulWidget {
  const CurrentLocationWidget({
    Key? key,

    /// If set, enable the FusedLocationProvider on Android
    required this.androidFusedLocation,
    required this.textEditingController,
    required this.latController,
    required this.lngController,
    required this.valueHolder,
    required this.updateLatLng,
  }) : super(key: key);

  final bool androidFusedLocation;
  final TextEditingController? textEditingController;
  final TextEditingController? latController;
  final TextEditingController? lngController;
  final PsValueHolder? valueHolder;
  final Function? updateLatLng;

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<CurrentLocationWidget> {
  String address = '';
  Position? _currentPosition;
  final MapController mapController = MapController();

  @override
  void initState() {
    super.initState();

    _initCurrentLocation();
  }

  Future<void> loadAddress() async {
    if (_currentPosition != null) {
      if (widget.textEditingController!.text == '') {
        await placemarkFromCoordinates(
                _currentPosition!.latitude, _currentPosition!.longitude)
            .then((List<Placemark> placemarks) {
          final Placemark place = placemarks[0];
          setState(() {
            address =
              '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
              widget.textEditingController!.text = address;
            widget.latController!.text = _currentPosition!.latitude.toString();
            widget.lngController!.text = _currentPosition!.longitude.toString();
            widget.updateLatLng!(_currentPosition);
          });
        }).catchError((dynamic e) {
          debugPrint(e);
        });
      } else {
        address = widget.textEditingController!.text;
      }
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
    dynamic _initCurrentLocation() {
    Geolocator.checkPermission().then((LocationPermission permission) {
      if (permission == LocationPermission.denied) {
        Geolocator.requestPermission().then((LocationPermission permission) {
          if (permission == LocationPermission.denied) {
          } else {
            Geolocator
                    //..forceAndroidLocationManager = !widget.androidFusedLocation
                    .getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.medium,
                        forceAndroidLocationManager: false)
                .then((Position position) {
              print(position);
              //     if (mounted) {
              //  setState(() {
              _currentPosition = position;
              loadAddress();
              //    });
              // _currentPosition = position;

              //    }
            }).catchError((Object e) {
              print(e);
            });
          }
        });
      } else {
        Geolocator
                //..forceAndroidLocationManager = !widget.androidFusedLocation
                .getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.medium,
                    forceAndroidLocationManager: !widget.androidFusedLocation)
            .then((Position position) {
          //    if (mounted) {
          setState(() {
            _currentPosition = position;
            loadAddress();
          });
          //    }
        }).catchError((Object e) {
          print(e);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (_currentPosition == null) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(context, 'map_pin__open_gps'),
                      onPressed: () {},
                    );
                  });
            } else {
              loadAddress();
            }
          },
          child: Container(
            margin: const EdgeInsets.only(
                left: PsDimens.space8,
                right: PsDimens.space8,
                bottom: PsDimens.space8),
            child: Card(
              shape: const BeveledRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(PsDimens.space8)),
              ),
              color: PsColors.baseLightColor,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        height: PsDimens.space32,
                        width: PsDimens.space32,
                        child: Icon(
                          Icons.gps_fixed,
                          color: PsColors.mainColor,
                          size: PsDimens.space20,
                        ),
                      ),
                      onTap: () {
                        if (_currentPosition == null) {
                          showDialog<dynamic>(
                              context: context,
                              builder: (BuildContext context) {
                                return WarningDialog(
                                  message: Utils.getString(
                                      context, 'map_pin__open_gps'),
                                  onPressed: () {},
                                );
                              });
                        } else {
                          loadAddress();
                        }
                      },
                    ),
                    Expanded(
                      child: Text(
                        Utils.getString(context, 'item_entry_pick_location'),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            letterSpacing: 0.8, fontSize: 16, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}



/*
import 'dart:io';

// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/provider/entry/item_entry_provider.dart';
import 'package:flutteradmotors/provider/gallery/gallery_provider.dart';
import 'package:flutteradmotors/provider/user/user_provider.dart';
import 'package:flutteradmotors/repository/gallery_repository.dart';
import 'package:flutteradmotors/repository/product_repository.dart';
import 'package:flutteradmotors/repository/user_repository.dart';
import 'package:flutteradmotors/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:flutteradmotors/ui/common/dialog/choose_camera_type_dialog.dart';
import 'package:flutteradmotors/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutteradmotors/ui/common/dialog/error_dialog.dart';
import 'package:flutteradmotors/ui/common/dialog/in_app_purchase_for_package_dialog.dart';
import 'package:flutteradmotors/ui/common/dialog/retry_dialog_view.dart';
import 'package:flutteradmotors/ui/common/dialog/success_dialog.dart';
import 'package:flutteradmotors/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutteradmotors/ui/common/ps_button_widget.dart';
import 'package:flutteradmotors/ui/common/ps_dropdown_base_with_controller_widget.dart';
import 'package:flutteradmotors/ui/common/ps_textfield_widget.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/utils/ps_progress_dialog.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/Item_color.dart';
import 'package:flutteradmotors/viewobject/api_status.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/condition_of_item.dart';
import 'package:flutteradmotors/viewobject/default_photo.dart';
import 'package:flutteradmotors/viewobject/holder/delete_item_image_holder.dart';
import 'package:flutteradmotors/viewobject/holder/image_reorder_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/google_map_pin_call_back_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/map_pin_call_back_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/map_pin_intent_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/model_intent_holder.dart';
import 'package:flutteradmotors/viewobject/holder/item_entry_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/item_build_type.dart';
import 'package:flutteradmotors/viewobject/item_currency.dart';
import 'package:flutteradmotors/viewobject/item_fuel_type.dart';
import 'package:flutteradmotors/viewobject/item_location.dart';
import 'package:flutteradmotors/viewobject/item_location_township.dart';
import 'package:flutteradmotors/viewobject/item_price_type.dart';
import 'package:flutteradmotors/viewobject/item_seller_type.dart';
import 'package:flutteradmotors/viewobject/item_type.dart';
import 'package:flutteradmotors/viewobject/manufacturer.dart';
import 'package:flutteradmotors/viewobject/model.dart';
import 'package:flutteradmotors/viewobject/product.dart';
import 'package:flutteradmotors/viewobject/transmission.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googlemap;
import 'package:latlong2/latlong.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ItemEntryView extends StatefulWidget {
  const ItemEntryView(
      {Key? key, this.flag, this.item, required this.animationController, required this.maxImageCount})
      : super(key: key);
  final AnimationController? animationController;
  final String? flag;
  final Product? item;
  final int maxImageCount;

  @override
  State<StatefulWidget> createState() => _ItemEntryViewState();
}

class _ItemEntryViewState extends State<ItemEntryView> {
  ProductRepository? repo1;
  GalleryRepository? galleryRepository;
  ItemEntryProvider? _itemEntryProvider;
  GalleryProvider? galleryProvider;
  UserProvider? userProvider;
  UserRepository? userRepository;
  PsValueHolder? valueHolder;

  /// user input info
  final TextEditingController userInputListingTitle = TextEditingController();

  final TextEditingController userInputPlateNumber = TextEditingController();
  final TextEditingController userInputEnginePower = TextEditingController();
  final TextEditingController userInputMileage = TextEditingController();
  final TextEditingController userInputLicenseExpDate = TextEditingController();
  final TextEditingController userInputYear = TextEditingController();
  final TextEditingController userInputSteeringPosition =
      TextEditingController();
  final TextEditingController userInputNumOfOwner = TextEditingController();
  final TextEditingController userInputTrimName = TextEditingController();
  final TextEditingController userInputVehicleId = TextEditingController();
  final TextEditingController userInputMaximumPassenger =
      TextEditingController();
  final TextEditingController userInputNumOfDoor = TextEditingController();
  final TextEditingController userInputPriceUnit = TextEditingController();

  final TextEditingController userInputBrand = TextEditingController();
  final TextEditingController userInputHighLightInformation =
      TextEditingController();
  final TextEditingController userInputDiscount = TextEditingController();    
  final TextEditingController userInputDescription = TextEditingController();
  final TextEditingController userInputDealOptionText = TextEditingController();
  final TextEditingController userInputLattitude = TextEditingController();
  final TextEditingController userInputLongitude = TextEditingController();
  final TextEditingController userInputAddress = TextEditingController();
  final TextEditingController userInputPrice = TextEditingController();
  final MapController mapController = MapController();
  googlemap.GoogleMapController? googleMapController;

  /// api info
  final TextEditingController manufacturerController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController transmissionController = TextEditingController();
  final TextEditingController itemColorController = TextEditingController();
  final TextEditingController itemFuelTypeController = TextEditingController();
  final TextEditingController itemBuildTypeController = TextEditingController();
  final TextEditingController itemSellerTypeController =
      TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController itemConditionController = TextEditingController();
  final TextEditingController priceTypeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController dealOptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController locationTownshipController =
      TextEditingController();

  late LatLng latlng;
  final double zoom = 16;
  bool bindDataFirstTime = true;
  bool bindImageFirstTime = true;
  bool isSelectedVideoImagePath = false;
  List<Asset> images = <Asset>[];
  late List<bool> isImageSelected;
  late List<Asset?> galleryImageAsset;
  late List<String?> cameraImagePath;
  late List<DefaultPhoto?> uploadedImages;
  String? videoFilePath;
  String? selectedVideoImagePath;
  String? videoFileThumbnailPath;
  String? selectedVideoPath;
  Asset? defaultAssetImage;

  String isShopCheckbox = '1';

  dynamic updateMapController(googlemap.GoogleMapController mapController) {
    googleMapController = mapController;
  }

  // ProgressDialog progressDialog;

  // File file;
  @override
  void initState() {
    super.initState();
    isImageSelected =
        List<bool>.generate(widget.maxImageCount, (int index) => false);
    galleryImageAsset =
        List<Asset?>.generate(widget.maxImageCount, (int index) => null);
    cameraImagePath =
        List<String?>.generate(widget.maxImageCount, (int index) => null);
    uploadedImages = List<DefaultPhoto?>.generate(widget.maxImageCount,
        (int index) => DefaultPhoto(imgId: '', imgPath: ''));
  }

  @override
  Widget build(BuildContext context) {
    print(
        '............................Build UI Again ............................');
    valueHolder = Provider.of<PsValueHolder>(context);
    void showRetryDialog(String description, Function uploadImage) {
      if (PsProgressDialog.isShowing()) {
        PsProgressDialog.dismissDialog();
      }
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return RetryDialogView(
                description: description,
                rightButtonText: Utils.getString(context, 'item_entry__retry'),
                onAgreeTap: () {
                  Navigator.pop(context);
                  uploadImage();
                });
          });
    }

    Future<dynamic> uploadImage(String itemId) async {
      bool _isVideoDone = isSelectedVideoImagePath;
      final List<ImageReorderParameterHolder> reorderObjList =
          <ImageReorderParameterHolder>[];
      for (int i = 0; i < widget.maxImageCount && isImageSelected.contains(true); i++) {
        
        if (isImageSelected[i]) {
          if (galleryImageAsset[i] != null || cameraImagePath[i] != null) {
            if (!PsProgressDialog.isShowing()) {
              if (!isImageSelected[i]) {
                PsProgressDialog.dismissDialog();
              } else {
                await PsProgressDialog.showDialog(context,
                    message: Utils.getString(context, 'Image ${i + 1} uploading'));
              }
            }
            final dynamic _apiStatus = await galleryProvider!
                .postItemImageUpload(
                    itemId,
                    uploadedImages[i]!.imgId,
                    '${i + 1}',
                    galleryImageAsset[i] == null
                        ? await Utils.getImageFileFromCameraImagePath(
                            cameraImagePath[i]!, valueHolder!.uploadImageSize!)
                        : await Utils.getImageFileFromAssets(
                            galleryImageAsset[i]!, valueHolder!.uploadImageSize!),
                    valueHolder!.loginUserId!);
            PsProgressDialog.dismissDialog();

            if (_apiStatus != null &&
                _apiStatus.data is DefaultPhoto &&
                _apiStatus.data != null) {
              isImageSelected[i] = false;
              print('${i + 1} image uploaded');
            } else if (_apiStatus != null) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message: _apiStatus.message,
                    );
                  });
            }
          } else if (uploadedImages[i]!.imgPath != '') {
            reorderObjList.add(ImageReorderParameterHolder(
                imgId: uploadedImages[i]!.imgId, ordering: (i + 1).toString()));
          }
        }
      }

      //reordering
      if (reorderObjList.isNotEmpty) {
      await PsProgressDialog.showDialog(context);
      final List<Map<String, dynamic>> reorderMapList =
          <Map<String, dynamic>>[];
      for (ImageReorderParameterHolder? data in reorderObjList) {
        if (data != null) {
          reorderMapList.add(data.toMap());
        }
      }
      final PsResource<ApiStatus>? _apiStatus = await galleryProvider!
          .postReorderImages(reorderMapList, valueHolder!.loginUserId!);
      PsProgressDialog.dismissDialog();
      
      if (_apiStatus!.data != null && _apiStatus.status == PsStatus.SUCCESS) {
        isImageSelected = isImageSelected.map<bool>((bool v) => false).toList();
        reorderObjList.clear();
      } else {
        showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message: _apiStatus.message,
                    );
                  });
      }
      }
      

      if (!PsProgressDialog.isShowing()) {
        if (!isSelectedVideoImagePath) {
          PsProgressDialog.dismissDialog();
        } else {
          await PsProgressDialog.showDialog(context,
              message:
                  Utils.getString(context, 'progressloading_video_uploading'));
        }
      }

      if (isSelectedVideoImagePath) {
        final PsResource<DefaultPhoto> _apiStatus = await galleryProvider!
            .postVideoUpload(
                itemId, '', File(videoFilePath!), valueHolder!.loginUserId!);
        final PsResource<DefaultPhoto> _apiStatus2 = await galleryProvider!
            .postVideoThumbnailUpload(itemId, '', File(videoFileThumbnailPath!),
                valueHolder!.loginUserId!);
        if (_apiStatus.data != null && _apiStatus2.data != null) {
          PsProgressDialog.dismissDialog();
          isSelectedVideoImagePath = false;
          _isVideoDone = isSelectedVideoImagePath;
        } else {
          showRetryDialog(
              Utils.getString(context, 'item_entry__fail_to_upload_video'), () {
            uploadImage(itemId);
          });
          return;
        }
      }
      PsProgressDialog.dismissDialog();

      if (!(isImageSelected.contains(true) || _isVideoDone)) {
        
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return SuccessDialog(
                message: Utils.getString(context, 'item_entry_item_uploaded'),
                onPressed: () {
                  Navigator.pop(context, true);
                  // Navigator.pop(context, true);
                },
              );
            });
      }

      return;
    }

    dynamic updateImagesFromVideo(String imagePath, int index) {
      if (mounted) {
        setState(() {
          //for single select image
          if (index == -2 && imagePath.isNotEmpty) {
            videoFilePath = imagePath;
            // selectedVideoImagePath = imagePath;
            isSelectedVideoImagePath = true;
          }
          //end single select image
        });
      }
    }

    dynamic _getImageFromVideo(String videoPathUrl) async {
      videoFileThumbnailPath = await VideoThumbnail.thumbnailFile(
        video: videoPathUrl,
        imageFormat: ImageFormat.JPEG,
        maxWidth:
            128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 25,
      );
      return videoFileThumbnailPath;
    }

    dynamic updateImagesFromCustomCamera(String imagePath, int index) {
      if (mounted) {
        setState(() {
          //for single select image
          if (imagePath.isNotEmpty) {
            int indexToStart = 0; //find the right starting_index for storing images
            for (indexToStart = 0; indexToStart < index; indexToStart++) {
              if (!isImageSelected[indexToStart] &&
                  indexToStart > galleryProvider!.selectedImageList.length - 1)
                break;
            }
            galleryImageAsset[indexToStart] = null;
            cameraImagePath[indexToStart] = imagePath;
            isImageSelected[indexToStart] = true;
          }
          //end single select image
        });
      }
    }

    dynamic updateImages(List<Asset> resultList, int index, int currentIndex) {
      setState(() {
        images = resultList;

        //for single select image
        if (index != -1 && resultList.isNotEmpty) {
          galleryImageAsset[currentIndex] = resultList[0];
          isImageSelected[currentIndex] = true;
        }
        //end single select image

        //for multi select
        if (index == -1) {
          int indexToStart =
              0; //find the right starting_index for storing images
          for (indexToStart = 0; indexToStart < currentIndex; indexToStart++) {
            if (!isImageSelected[indexToStart] &&
                indexToStart > galleryProvider!.selectedImageList.length - 1)
              break;
          }
          for (int i = 0;
              i < resultList.length && indexToStart < widget.maxImageCount;
              i++, indexToStart++) {
            galleryImageAsset[indexToStart] = resultList[i];
            isImageSelected[indexToStart] = true;
          }
        }
        //end multi select
      });
    }

    dynamic onReorder(int oldIndex, int newIndex) {
      if (galleryImageAsset[oldIndex] != null) {
        if (galleryImageAsset[newIndex] != null) {
          setState(() {
            final Asset? temp = galleryImageAsset[oldIndex];
            galleryImageAsset[oldIndex] = galleryImageAsset[newIndex];
            galleryImageAsset[newIndex] = temp;
          });
        } else if (cameraImagePath[newIndex] != null &&
            cameraImagePath[newIndex] != '') {
          setState(() {
            cameraImagePath[oldIndex] = cameraImagePath[newIndex];
            galleryImageAsset[newIndex] = galleryImageAsset[oldIndex];
            galleryImageAsset[oldIndex] = null;
            cameraImagePath[newIndex] = null;
          });
        } else if (uploadedImages[newIndex]!.imgPath != '' &&
            uploadedImages[newIndex]!.imgId != '') {
          setState(() {
            uploadedImages[oldIndex] = uploadedImages[newIndex];
            uploadedImages[newIndex] = DefaultPhoto(imgId: '', imgPath: '');
            galleryImageAsset[newIndex] = galleryImageAsset[oldIndex];
            galleryImageAsset[oldIndex] = null;

            isImageSelected[newIndex] = true;
            isImageSelected[oldIndex] = true;
          });
        }
      } else if (cameraImagePath[oldIndex] != null &&
          cameraImagePath[oldIndex] != '') {
        if (galleryImageAsset[newIndex] != null) {
          setState(() {
            galleryImageAsset[oldIndex] = galleryImageAsset[newIndex];
            cameraImagePath[newIndex] = cameraImagePath[oldIndex];
            cameraImagePath[oldIndex] = null;
            galleryImageAsset[newIndex] = null;
          });
        } else if (cameraImagePath[newIndex] != null &&
            cameraImagePath[newIndex] != '') {
          setState(() {
            final String? temp = cameraImagePath[oldIndex];
            cameraImagePath[oldIndex] = cameraImagePath[newIndex];
            cameraImagePath[newIndex] = temp;
          });
        } else if (uploadedImages[newIndex]!.imgPath != '' &&
            uploadedImages[newIndex]!.imgId != '') {
          setState(() {
            uploadedImages[oldIndex] = uploadedImages[newIndex];
            uploadedImages[newIndex] = DefaultPhoto(imgId: '', imgPath: '');
            cameraImagePath[newIndex] = cameraImagePath[oldIndex];
            cameraImagePath[oldIndex] = null;

            isImageSelected[newIndex] = true;
            isImageSelected[oldIndex] = true;
          });
        }
      } else if (uploadedImages[oldIndex]!.imgPath != '' &&
          uploadedImages[oldIndex]!.imgId != '') {
        if (galleryImageAsset[newIndex] != null) {
          setState(() {
            uploadedImages[newIndex] = uploadedImages[oldIndex];
            uploadedImages[oldIndex] = DefaultPhoto(imgId: '', imgPath: '');
            galleryImageAsset[oldIndex] = galleryImageAsset[newIndex];
            galleryImageAsset[newIndex] = null;

            isImageSelected[newIndex] = true;
            isImageSelected[oldIndex] = true;
          });
        } else if (cameraImagePath[newIndex] != null &&
            cameraImagePath[newIndex] != '') {
          setState(() {
            uploadedImages[newIndex] = uploadedImages[oldIndex];
            uploadedImages[oldIndex] = DefaultPhoto(imgId: '', imgPath: '');
            cameraImagePath[oldIndex] = cameraImagePath[newIndex];
            cameraImagePath[newIndex] = null;

            isImageSelected[newIndex] = true;
            isImageSelected[oldIndex] = true;
          });
        } else if (uploadedImages[newIndex]!.imgPath != '' &&
            uploadedImages[newIndex]!.imgId != '') {
          setState(() {
            final DefaultPhoto? temp = uploadedImages[newIndex];
            uploadedImages[newIndex] = uploadedImages[oldIndex];
            uploadedImages[oldIndex] = temp;

            isImageSelected[oldIndex] = true;
            isImageSelected[newIndex] = true;
          });
        }
      }
    }

    repo1 = Provider.of<ProductRepository>(context);
    galleryRepository = Provider.of<GalleryRepository>(context);
    userRepository = Provider.of<UserRepository>(context);
    widget.animationController!.forward();
    return PsWidgetWithMultiProvider(
      child: MultiProvider(
          providers: <SingleChildWidget>[
            ChangeNotifierProvider<ItemEntryProvider?>(
                lazy: false,
                create: (BuildContext context) {
                  _itemEntryProvider = ItemEntryProvider(
                      repo: repo1, psValueHolder: valueHolder);

                  _itemEntryProvider!.item = widget.item;

                  if (valueHolder!.isSubLocation == PsConst.ONE) {
                    latlng = LatLng(
                        double.parse(_itemEntryProvider!
                            .psValueHolder!.locationTownshipLat),
                        double.parse(_itemEntryProvider!
                            .psValueHolder!.locationTownshipLng));
                    if (
                        //_itemEntryProvider!.itemLocationTownshipId != null ||
                        _itemEntryProvider!.itemLocationTownshipId != '') {
                      _itemEntryProvider!.itemLocationTownshipId =
                          _itemEntryProvider!
                              .psValueHolder!.locationTownshipId;
                    }
                    if (userInputLattitude.text.isEmpty)
                      userInputLattitude.text = _itemEntryProvider!
                          .psValueHolder!.locationTownshipLat;
                    if (userInputLongitude.text.isEmpty)
                      userInputLongitude.text = _itemEntryProvider!
                          .psValueHolder!.locationTownshipLng;
                  } else {
                    latlng = LatLng(
                        double.parse(
                            _itemEntryProvider!.psValueHolder!.locationLat!),
                        double.parse(
                            _itemEntryProvider!.psValueHolder!.locationLng!));
                    if (userInputLattitude.text.isEmpty)
                      userInputLattitude.text =
                          _itemEntryProvider!.psValueHolder!.locationLat!;
                    if (userInputLongitude.text.isEmpty)
                      userInputLongitude.text =
                          _itemEntryProvider!.psValueHolder!.locationLng!;
                  }
                  if (
                      //_itemEntryProvider.itemLocationId != null ||
                      _itemEntryProvider!.itemLocationId != '') {
                    _itemEntryProvider!.itemLocationId =
                        _itemEntryProvider!.psValueHolder!.locationId!;
                  }
                  _itemEntryProvider!.itemCurrencyId =
                      _itemEntryProvider!.psValueHolder!.defaultCurrencyId;
                  priceController.text =
                      _itemEntryProvider!.psValueHolder!.defaultCurrency;
                  _itemEntryProvider!.getItemFromDB(widget.item!.id);

                  return _itemEntryProvider!;
                }),
            ChangeNotifierProvider<GalleryProvider?>(
                lazy: false,
                create: (BuildContext context) {
                  galleryProvider = GalleryProvider(repo: galleryRepository!);
                  if (widget.flag == PsConst.EDIT_ITEM) {
                    galleryProvider!.loadImageList(
                        widget.item!.defaultPhoto!.imgParentId!,
                        PsConst.ITEM_TYPE);

                    // firstImageId = galleryProvider.galleryList.data[0].imgId;
                    // secondImageId = galleryProvider.galleryList.data[1].imgId;
                    // thirdImageId = galleryProvider.galleryList.data[2].imgId;
                    // fourthImageId = galleryProvider.galleryList.data[3].imgId;
                    // fiveImageId = galleryProvider.galleryList.data[4].imgId;

                    // Utils.psPrint(firstImageId);
                    // Utils.psPrint(secondImageId);
                    // Utils.psPrint(thirdImageId);
                    // Utils.psPrint(fourthImageId);
                    // Utils.psPrint(fiveImageId);
                  }
                  return galleryProvider!;
                }),
            ChangeNotifierProvider<UserProvider?>(
              lazy: false,
              create: (BuildContext context) {
                userProvider = UserProvider(
                    repo: userRepository, psValueHolder: valueHolder);
                userProvider!.getUser(valueHolder!.loginUserId ?? '');
                return userProvider;
              },
            )
          ],
          child: Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider provider, Widget? child) {
          if (widget.flag == PsConst.ADD_NEW_ITEM && valueHolder!.isPaidApp == PsConst.ONE && provider.user.data == null) 
              return Container(
                color: PsColors.backgroundColor
              ); 
          if (widget.flag == PsConst.EDIT_ITEM || (valueHolder!.isPaidApp != PsConst.ONE || 
                                (provider.user.data != null  &&
                                int.parse( provider.user.data!.remainingPost!) > 0)))
              return SingleChildScrollView(
            child: AnimatedBuilder(
                animation: widget.animationController!,
                child: Container(
                  color: PsColors.backgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: PsDimens.space16,
                            left: PsDimens.space10,
                            right: PsDimens.space10),
                        child: Text(
                            Utils.getString(
                                context, 'item_entry__listing_today'),
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: PsDimens.space16,
                            left: PsDimens.space10,
                            right: PsDimens.space10,
                            bottom: PsDimens.space10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                  Utils.getString(context,
                                      'item_entry__choose_photo_showcase'),
                                  style: Theme.of(context).textTheme.bodyMedium),
                            ),
                            Text(' *',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: PsColors.mainColor))
                          ],
                        ),
                      ),
                      //  _largeSpacingWidget,
                      Consumer<GalleryProvider>(builder: (BuildContext context,
                          GalleryProvider provider, Widget? child) {
                          if (bindImageFirstTime &&
                                provider.galleryList.data!.isNotEmpty) {
                              for (int i = 0;
                                  i < widget.maxImageCount && i < provider.galleryList.data!.length;
                                  i++) {
                                if (provider.galleryList.data![i].imgId !=
                                    null) {
                                  uploadedImages[i] =
                                      provider.galleryList.data![i];
                                }
                              }
                              bindImageFirstTime = false;
                          }

                        return ImageUploadHorizontalList(
                              flag: widget.flag,
                              images: images,
                              selectedImageList: uploadedImages,
                              updateImages: updateImages,
                              updateImagesFromCustomCamera:
                                  updateImagesFromCustomCamera,
                              videoFilePath: videoFilePath,
                              videoFileThumbnailPath: videoFileThumbnailPath,
                              selectedVideoImagePath: selectedVideoImagePath,
                              updateImagesFromVideo: updateImagesFromVideo,
                              selectedVideoPath: selectedVideoPath,
                              getImageFromVideo: _getImageFromVideo,
                              imageDesc1Controller:
                                  galleryProvider!.imageDesc1Controller,
                              provider: _itemEntryProvider,
                              galleryProvider: provider,
                              onReorder: onReorder,
                              cameraImagePath: cameraImagePath,
                              galleryImagePath: galleryImageAsset,
                            );
                      }),

                      Consumer<ItemEntryProvider>(builder:
                          (BuildContext context, ItemEntryProvider provider,
                              Widget? child) {
                        if (
                            //provider != null &&
                            provider.item != null &&
                                provider.item!.id != null) {
                          if (bindDataFirstTime) {
                            userInputListingTitle.text = provider.item!.title!;
                            manufacturerController.text =
                                provider.item!.manufacturer!.name!;
                            modelController.text = provider.item!.model!.name!;
                            userInputPlateNumber.text =
                                provider.item!.plateNumber!;
                            userInputEnginePower.text =
                                provider.item!.enginePower!;
                            transmissionController.text =
                                provider.item!.transmission!.name!;
                            userInputMileage.text = provider.item!.mileage!;
                            userInputLicenseExpDate.text =
                                provider.item!.licenseExpirationDate!;
                            userInputYear.text = provider.item!.year!;
                            itemColorController.text =
                                provider.item!.itemColor!.colorValue!;
                            itemFuelTypeController.text =
                                provider.item!.fuelType!.name!;
                            userInputSteeringPosition.text =
                                provider.item!.steeringPosition!;
                            userInputNumOfOwner.text =
                                provider.item!.noOfOwner!;
                            userInputTrimName.text = provider.item!.vehicleId!;
                            itemBuildTypeController.text =
                                provider.item!.buildType!.name!;
                            userInputMaximumPassenger.text =
                                provider.item!.maxPassengers!;
                            userInputNumOfDoor.text = provider.item!.noOfDoors!;
                            itemSellerTypeController.text =
                                provider.item!.sellerType!.name!;
                            userInputPriceUnit.text = provider.item!.priceUnit!;

                            userInputDiscount.text = provider.item!.discountRate!;
                            userInputHighLightInformation.text =
                                provider.item!.highlightInformation!;
                            userInputDescription.text =
                                provider.item!.description!;
                            // userInputDealOptionText.text =
                            //     provider.item.data.dealOptionRemark;

                            if (valueHolder!.isSubLocation == PsConst.ONE) {
                              userInputLattitude.text =
                                  provider.item!.itemLocationTownship!.lat!;
                              userInputLongitude.text =
                                  provider.item!.itemLocationTownship!.lng!;
                              provider.itemLocationTownshipId =
                                  provider.item!.itemLocationTownship!.id!;
                              // locationTownshipController.text = provider
                              //     .item.itemLocationTownship.townshipName;
                            } else {
                              userInputLattitude.text = provider.item!.lat!;
                              userInputLongitude.text = provider.item!.lng!;
                            }

                            provider.itemLocationId =
                                provider.item!.itemLocation!.id!;
                            locationController.text =
                                provider.item!.itemLocation!.name!;
                            userInputAddress.text = provider.item!.address!;
                            userInputPrice.text = provider.item!.price!;

                            typeController.text =
                                provider.item!.itemType!.name!;
                            itemConditionController.text =
                                provider.item!.conditionOfItem!.name!;
                            priceTypeController.text =
                                provider.item!.itemPriceType!.name!;
                            priceController.text =
                                provider.item!.itemCurrency!.currencySymbol!;
                            locationController.text =
                                provider.item!.itemLocation!.name!;

                            provider.manufacturerId =
                                provider.item!.manufacturer!.id!;
                            provider.modelId = provider.item!.model!.id!;
                            provider.transmissionId =
                                provider.item!.transmissionId!;
                            provider.itemColorId =
                                provider.item!.itemColor!.id!;
                            provider.fuelTypeId = provider.item!.fuelType!.id!;
                            provider.buildTypeId =
                                provider.item!.buildType!.id!;
                            provider.sellerTypeId =
                                provider.item!.sellerType!.id!;
                            provider.itemTypeId = provider.item!.itemType!.id!;
                            provider.itemConditionId =
                                provider.item!.conditionOfItem!.id!;
                            provider.itemCurrencyId =
                                provider.item!.itemCurrency!.id!;

                            if (valueHolder!.isSubLocation == PsConst.ONE) {
                              userInputLattitude.text =
                                  provider.item!.itemLocationTownship!.lat!;
                              userInputLongitude.text =
                                  provider.item!.itemLocationTownship!.lng!;
                              provider.itemLocationTownshipId =
                                  provider.item!.itemLocationTownship!.id!;
                              // locationTownshipController.text = provider
                              //     .item.itemLocationTownship.townshipName;
                            } else {
                              userInputLattitude.text = provider.item!.lat!;
                              userInputLongitude.text = provider.item!.lng!;
                            }

                            provider.itemLocationId =
                                provider.item!.itemLocation!.id!;
                            provider.itemPriceTypeId =
                                provider.item!.itemPriceType!.id!;
                            selectedVideoImagePath =
                                provider.item!.videoThumbnail!.imgPath!;
                            selectedVideoPath = provider.item!.video!.imgPath!;
                            bindDataFirstTime = false;
                            if (provider.item!.licenceStatus == '1') {
                              provider.isLicenseCheckBoxSelect = true;
                              LicenseCheckbox(
                                provider: provider,
                                onCheckBoxClick: () {
                                  if (mounted) {
                                    setState(() {
                                      updateLicenseCheckBox(context, provider);
                                    });
                                  }
                                },
                              );
                            } else {
                              provider.isLicenseCheckBoxSelect = false;

                              LicenseCheckbox(
                                provider: provider,
                                onCheckBoxClick: () {
                                  if (mounted) {
                                    setState(() {
                                      updateLicenseCheckBox(context, provider);
                                    });
                                  }
                                },
                              );
                            }
                            if (provider.item!.businessMode == '1') {
                              provider.isCheckBoxSelect = true;
                              _BusinessModeCheckbox();
                            } else {
                              provider.isCheckBoxSelect = false;

                              _BusinessModeCheckbox();
                            }
                          }
                        }
                        return AllControllerTextWidget(
                          userInputListingTitle: userInputListingTitle,
                          userInputPlateNumber: userInputPlateNumber,
                          userInputEnginePower: userInputEnginePower,
                          userInputMileage: userInputMileage,
                          userInputLicenseExpDate: userInputLicenseExpDate,
                          userInputYear: userInputYear,
                          userInputSteeringPosition: userInputSteeringPosition,
                          userInputNumOfOwner: userInputNumOfOwner,
                          userInputTrimName: userInputTrimName,
                          userInputVehicleId: userInputVehicleId,
                          userInputMaximumPassenger: userInputMaximumPassenger,
                          userInputNumOfDoor: userInputNumOfDoor,
                          userInputPriceUnit: userInputPriceUnit,
                          manufacturerController: manufacturerController,
                          modelController: modelController,
                          transmissionController: transmissionController,
                          itemColorController: itemColorController,
                          itemFuelTypeController: itemFuelTypeController,
                          itemBuildTypeController: itemBuildTypeController,
                          itemSellerTypeController: itemSellerTypeController,
                          typeController: typeController,
                          itemConditionController: itemConditionController,
                          userInputBrand: userInputBrand,
                          priceTypeController: priceTypeController,
                          priceController: priceController,
                          userInputDiscount: userInputDiscount,
                          userInputHighLightInformation:
                              userInputHighLightInformation,
                          userInputDescription: userInputDescription,
                          dealOptionController: dealOptionController,
                          userInputDealOptionText: userInputDealOptionText,
                          locationController: locationController,
                          locationTownshipController:
                              locationTownshipController,
                          userInputLattitude: userInputLattitude,
                          userInputLongitude: userInputLongitude,
                          userInputAddress: userInputAddress,
                          userInputPrice: userInputPrice,
                          mapController: mapController,
                          zoom: zoom,
                          flag: widget.flag!,
                          item: widget.item!,
                          provider: provider,
                          galleryProvider: galleryProvider!,
                          latlng: latlng,
                          uploadImage: (String itemId) {
                            uploadImage(itemId);
                          },
                          isImageSelected: isImageSelected,
                          isSelectedVideoImagePath: isSelectedVideoImagePath,
                          updateMapController: updateMapController,
                          googleMapController: googleMapController,
                        );
                      })
                    ],
                  ),
                ),
                builder: (BuildContext context, Widget? child) {
                  return child!;
                }),
          );
          else 
                   return InAppPurchaseBuyPackageDialog(
                onInAppPurchaseTap: () async {
                  // InAppPurchase View
                  final dynamic returnData = await Navigator.pushNamed(
                      context, RoutePaths.buyPackage,
                      arguments: <String, dynamic>{
                        'android': valueHolder?.packageAndroidKeyList,
                        'ios': valueHolder?.packageIOSKeyList
                      });

                  if (returnData != null) {
                    setState(() {
                      userProvider!.user.data!.remainingPost = returnData;
                    });
                  } else {
                    provider.getUser(valueHolder!.loginUserId ?? '');
                  }
                },
              );  
        },),
    ));
  }
}

class AllControllerTextWidget extends StatefulWidget {
  const AllControllerTextWidget({
    Key? key,
    this.userInputListingTitle,
    this.userInputPlateNumber,
    this.userInputEnginePower,
    this.userInputMileage,
    this.userInputLicenseExpDate,
    this.userInputYear,
    this.userInputSteeringPosition,
    this.userInputNumOfOwner,
    this.userInputTrimName,
    this.userInputVehicleId,
    this.userInputMaximumPassenger,
    this.userInputNumOfDoor,
    this.userInputPriceUnit,
    this.manufacturerController,
    this.modelController,
    this.transmissionController,
    this.itemColorController,
    this.itemFuelTypeController,
    this.itemBuildTypeController,
    this.itemSellerTypeController,
    this.typeController,
    this.itemConditionController,
    this.userInputBrand,
    this.priceTypeController,
    this.priceController,
    this.userInputDiscount,
    this.userInputHighLightInformation,
    this.userInputDescription,
    this.dealOptionController,
    this.userInputDealOptionText,
    this.locationController,
    this.locationTownshipController,
    this.userInputLattitude,
    this.userInputLongitude,
    this.userInputAddress,
    this.userInputPrice,
    this.mapController,
    this.provider,
    this.latlng,
    this.zoom,
    this.flag,
    this.item,
    this.uploadImage,
    this.galleryProvider,
    required this.isImageSelected,
    this.isSelectedVideoImagePath,
    this.googleMapController,
    this.updateMapController,
  }) : super(key: key);

  final TextEditingController? userInputListingTitle;
  final TextEditingController? userInputPlateNumber;
  final TextEditingController? userInputEnginePower;
  final TextEditingController? userInputMileage;
  final TextEditingController? userInputLicenseExpDate;
  final TextEditingController? userInputYear;
  final TextEditingController? userInputSteeringPosition;
  final TextEditingController? userInputNumOfOwner;
  final TextEditingController? userInputTrimName;
  final TextEditingController? userInputVehicleId;
  final TextEditingController? userInputMaximumPassenger;
  final TextEditingController? userInputNumOfDoor;
  final TextEditingController? userInputPriceUnit;
  final TextEditingController? manufacturerController;
  final TextEditingController? modelController;
  final TextEditingController? transmissionController;
  final TextEditingController? itemColorController;
  final TextEditingController? itemFuelTypeController;
  final TextEditingController? itemBuildTypeController;
  final TextEditingController? itemSellerTypeController;
  final TextEditingController? typeController;
  final TextEditingController? itemConditionController;
  final TextEditingController? userInputBrand;
  final TextEditingController? priceTypeController;
  final TextEditingController? priceController;
  final TextEditingController? userInputDiscount;
  final TextEditingController? userInputHighLightInformation;
  final TextEditingController? userInputDescription;
  final TextEditingController? dealOptionController;
  final TextEditingController? userInputDealOptionText;
  final TextEditingController? locationController;
  final TextEditingController? locationTownshipController;
  final TextEditingController? userInputLattitude;
  final TextEditingController? userInputLongitude;
  final TextEditingController? userInputAddress;
  final TextEditingController? userInputPrice;
  final MapController? mapController;
  final ItemEntryProvider? provider;
  final double? zoom;
  final String? flag;
  final Product? item;
  final LatLng? latlng;
  final Function? uploadImage;
  final GalleryProvider? galleryProvider;
  final List<bool> isImageSelected;
  final bool? isSelectedVideoImagePath;
  final googlemap.GoogleMapController? googleMapController;
  final Function? updateMapController;

  @override
  _AllControllerTextWidgetState createState() =>
      _AllControllerTextWidgetState();
}

class _AllControllerTextWidgetState extends State<AllControllerTextWidget> {
  LatLng? _latlng;
  googlemap.CameraPosition? _kLake;
  PsValueHolder? valueHolder;
  ItemEntryProvider? itemEntryProvider;
  googlemap.CameraPosition? kGooglePlex;

  @override
  Widget build(BuildContext context) {
    itemEntryProvider = Provider.of<ItemEntryProvider>(context, listen: false);
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);
    _latlng ??= widget.latlng;
    kGooglePlex = googlemap.CameraPosition(
      target: googlemap.LatLng(_latlng!.latitude, _latlng!.longitude),
      zoom: widget.zoom!,
    );
    if ((widget.flag == PsConst.ADD_NEW_ITEM &&
            widget.locationController!.text ==
                itemEntryProvider!.psValueHolder!.locactionName) ||
        (widget.flag == PsConst.ADD_NEW_ITEM &&
            widget.locationController!.text.isEmpty)) {
      widget.locationController!.text =
          itemEntryProvider!.psValueHolder!.locactionName!;
      // widget.locationTownshipController.text =
      //     itemEntryProvider.psValueHolder.locationTownshipName;
    }
    if (itemEntryProvider!.item != null && widget.flag == PsConst.EDIT_ITEM) {
      if (valueHolder!.isSubLocation == PsConst.ONE && 
          itemEntryProvider!.item!.itemLocationTownship!.lat != '') {
        _latlng = LatLng(
            double.parse(itemEntryProvider!.item!.itemLocationTownship!.lat!),
            double.parse(itemEntryProvider!.item!.itemLocationTownship!.lng!));
        kGooglePlex = googlemap.CameraPosition(
          target: googlemap.LatLng(
              double.parse(itemEntryProvider!.item!.itemLocationTownship!.lat!),
              double.parse(
                  itemEntryProvider!.item!.itemLocationTownship!.lng!)),
          zoom: widget.zoom!,
        );
      } else {
        _latlng = LatLng(double.parse(itemEntryProvider!.item!.lat!),
            double.parse(itemEntryProvider!.item!.lng!));
        kGooglePlex = googlemap.CameraPosition(
          target: googlemap.LatLng(double.parse(itemEntryProvider!.item!.lat!),
              double.parse(itemEntryProvider!.item!.lng!)),
          zoom: widget.zoom!,
        );
      }
    }

    final Widget _uploadItemWidget = Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space16,
            right: PsDimens.space16,
            top: PsDimens.space16,
            bottom: PsDimens.space48),
        width: double.infinity,
        height: PsDimens.space44,
        child: PSButtonWidget(
          hasShadow: true,
          width: double.infinity,
          titleText: Utils.getString(context, 'login__submit'),
          onPressed: () async {
            if (!widget.isImageSelected.contains(true) &&
                      widget.galleryProvider!.galleryList.data!.isEmpty) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                        message:
                            Utils.getString(context, 'item_entry_need_image'),
                        onPressed: () {});
                  });
            } else if (
                //widget.userInputListingTitle!.text == null ||
                widget.userInputListingTitle!.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                        message: Utils.getString(
                            context, 'item_entry__need_listing_title'),
                        onPressed: () {});
                  });
            } else if (
                //widget.manufacturerController!.text == null ||
                widget.manufacturerController!.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                        message: Utils.getString(
                            context, 'item_entry__need_manufacturer'),
                        onPressed: () {});
                  });
            } else if (widget.modelController!.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                        message:
                            Utils.getString(context, 'item_entry__need_model'),
                        onPressed: () {});
                  });
            } 
            // else if (widget.userInputPlateNumber!.text == '') {
            //   showDialog<dynamic>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return WarningDialog(
            //             message: Utils.getString(
            //                 context, 'item_entry__need_plate_number'),
            //             onPressed: () {});
            //       });
            // } 
            // else if (widget.userInputEnginePower!.text == '') {
            //   showDialog<dynamic>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return WarningDialog(
            //             message: Utils.getString(
            //                 context, 'item_entry__need_engine_power'),
            //             onPressed: () {});
            //       });
            // } 
            // else if (widget.transmissionController!.text == '') {
            //   showDialog<dynamic>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return WarningDialog(
            //             message: Utils.getString(
            //                 context, 'item_entry__need_transmission'),
            //             onPressed: () {});
            //       });
            // }
            //  else if (widget.userInputYear!.text == '') {
            //   showDialog<dynamic>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return WarningDialog(
            //             message:
            //                 Utils.getString(context, 'item_entry__need_year'),
            //             onPressed: () {});
            //       });
            // } else if (widget.typeController!.text == '') {
            //   showDialog<dynamic>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return WarningDialog(
            //             message:
            //                 Utils.getString(context, 'item_entry_need_type'),
            //             onPressed: () {});
            //       });
            // } else if (widget.itemConditionController!.text == '') {
            //   showDialog<dynamic>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return WarningDialog(
            //             message: Utils.getString(
            //                 context, 'item_entry_need_item_condition'),
            //             onPressed: () {});
            //       });
            // }
             else if (widget.priceController!.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                        message: Utils.getString(
                            context, 'item_entry_need_currency_symbol'),
                        onPressed: () {});
                  });
            } else if (widget.userInputPrice!.text == '' || int.parse(widget.userInputPrice!.text) <= 0) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                        message:
                            Utils.getString(context, 'item_entry_need_price'),
                        onPressed: () {});
                  });
            } else if (widget.userInputDescription!.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                        message: Utils.getString(
                            context, 'item_entry_need_description'),
                        onPressed: () {});
                  });
            } 
            // else if (valueHolder!.isSubLocation == PsConst.ONE &&
            //     (
            //         //widget.locationTownshipController!.text == null ||
            //         widget.locationTownshipController!.text == '')) {
            //   showDialog<dynamic>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return WarningDialog(
            //           message: Utils.getString(
            //               context, 'item_entry_need_location_township'),
            //           onPressed: () {},
            //         );
            //       });
            // } 
            else if (widget.provider!.itemLocationId == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_entry_need_location_id'),
                      onPressed: () {},
                    );
                  });
              //  } else if (valueHolder.isSubLocation == PsConst.ONE &&
              //     (widget.locationTownshipController.text == null ||
              //         widget.locationTownshipController.text == '')) {
              //   showDialog<dynamic>(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return WarningDialog(
              //           message: Utils.getString(
              //               context, 'item_entry_need_location_township'),
              //           onPressed: () {},
              //         );
              //       });
            } else if (widget.userInputLattitude!.text == PsConst.ZERO ||
                widget.userInputLattitude!.text == PsConst.ZERO ||
                widget.userInputLattitude!.text == PsConst.INVALID_LAT_LNG ||
                widget.userInputLattitude!.text == PsConst.INVALID_LAT_LNG) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message:
                          Utils.getString(context, 'item_entry_pick_location'),
                      onPressed: () {},
                    );
                  });
            } else {
              if (!PsProgressDialog.isShowing()) {
                await PsProgressDialog.showDialog(context,
                    message: Utils.getString(
                        context, 'progressloading_item_uploading'));
              }
              if (widget.flag == PsConst.ADD_NEW_ITEM) {
                //add new
                final ItemEntryParameterHolder itemEntryParameterHolder =
                    ItemEntryParameterHolder(
                  manufacturerId: widget.provider!.manufacturerId,
                  modelId: widget.provider!.modelId,
                  itemTypeId: widget.provider!.itemTypeId,
                  itemPriceTypeId: widget.provider!.itemPriceTypeId,
                  itemCurrencyId: widget.provider!.itemCurrencyId,
                  conditionOfItemId: widget.provider!.itemConditionId,
                  itemLocationId: widget.provider!.itemLocationId,
                  itemLocationTownshipId:
                      widget.provider!.itemLocationTownshipId,
                  colorId: widget.provider!.itemColorId,
                  fuelTypeId: widget.provider!.fuelTypeId,
                  buildTypeId: widget.provider!.buildTypeId,
                  sellerTypeId: widget.provider!.sellerTypeId,
                  transmissionId: widget.provider!.transmissionId,
                  description: widget.userInputDescription!.text,
                  highlightInfomation:
                      widget.userInputHighLightInformation!.text,
                  price: widget.userInputPrice!.text,
                  discountRate: widget.userInputDiscount!.text,
                  businessMode: widget.provider!.checkOrNotShop,
                  isSoldOut: '',
                  title: widget.userInputListingTitle!.text,
                  address: widget.userInputAddress!.text,
                  latitude: widget.userInputLattitude!.text,
                  longitude: widget.userInputLongitude!.text,
                  plateNumber: widget.userInputPlateNumber!.text,
                  enginePower: widget.userInputEnginePower!.text,
                  steeringPosition: widget.userInputSteeringPosition!.text,
                  noOfOwner: widget.userInputNumOfOwner!.text,
                  trimName: widget.userInputTrimName!.text,
                  vehicleId: widget.userInputVehicleId!.text,
                  priceUnit: widget.userInputPriceUnit!.text,
                  year: widget.userInputYear!.text,
                  // licenceStatus: widget.provider.licenceStatus,
                  maxPassengers: widget.userInputMaximumPassenger!.text,
                  noOfDoors: widget.userInputNumOfDoor!.text,
                  mileage: widget.userInputMileage!.text,
                  licenseEexpirationDate: widget.userInputLicenseExpDate!.text,
                  id: widget.provider!.itemId,
                  addedUserId: widget.provider!.psValueHolder!.loginUserId,
                );

                final PsResource<Product> itemData = await widget.provider!
                    .postItemEntry(itemEntryParameterHolder.toMap(), widget.provider!.psValueHolder!.loginUserId!);
                PsProgressDialog.dismissDialog();

                if (itemData.status == PsStatus.SUCCESS) {
                  widget.provider!.itemId = itemData.data!.id!;
                  if (itemData.data != null) {
                    if (widget.isImageSelected.contains(true)) {
                      widget.uploadImage!(itemData.data!.id);
                    }
                  }
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: itemData.message,
                        );
                      });
                }
              } else {
                // edit item

                final ItemEntryParameterHolder itemEntryParameterHolder =
                    ItemEntryParameterHolder(
                  manufacturerId: widget.provider!.manufacturerId,
                  modelId: widget.provider!.modelId,
                  itemTypeId: widget.provider!.itemTypeId,
                  itemPriceTypeId: widget.provider!.itemPriceTypeId,
                  itemCurrencyId: widget.provider!.itemCurrencyId,
                  conditionOfItemId: widget.provider!.itemConditionId,
                  itemLocationId: widget.provider!.itemLocationId,
                  itemLocationTownshipId:
                      widget.provider!.itemLocationTownshipId,
                  colorId: widget.provider!.itemColorId,
                  fuelTypeId: widget.provider!.fuelTypeId,
                  buildTypeId: widget.provider!.buildTypeId,
                  sellerTypeId: widget.provider!.sellerTypeId,
                  transmissionId: widget.provider!.transmissionId,
                  description: widget.userInputDescription!.text,
                  highlightInfomation:
                      widget.userInputHighLightInformation!.text,
                  price: widget.userInputPrice!.text,
                  discountRate: widget.userInputDiscount!.text,
                  businessMode: widget.provider!.checkOrNotShop,
                  isSoldOut: widget.item!.isSoldOut,
                  title: widget.userInputListingTitle!.text,
                  address: widget.userInputAddress!.text,
                  latitude: widget.userInputLattitude!.text,
                  longitude: widget.userInputLongitude!.text,
                  plateNumber: widget.userInputPlateNumber!.text,
                  enginePower: widget.userInputEnginePower!.text,
                  steeringPosition: widget.userInputSteeringPosition!.text,
                  noOfOwner: widget.userInputNumOfOwner!.text,
                  trimName: widget.userInputTrimName!.text,
                  vehicleId: widget.userInputVehicleId!.text,
                  priceUnit: widget.userInputPriceUnit!.text,
                  year: widget.userInputYear!.text,
                  // licenceStatus: widget.provider.licenceStatus,
                  maxPassengers: widget.userInputMaximumPassenger!.text,
                  noOfDoors: widget.userInputNumOfDoor!.text,
                  mileage: widget.userInputMileage!.text,
                  licenseEexpirationDate: widget.userInputLicenseExpDate!.text,
                  id: widget.item!.id,
                  addedUserId: widget.provider!.psValueHolder!.loginUserId,
                );

                final PsResource<Product> itemData = await widget.provider!
                    .postItemEntry(itemEntryParameterHolder.toMap(),widget.provider!.psValueHolder!.loginUserId!);
                PsProgressDialog.dismissDialog();
                if (itemData.status == PsStatus.SUCCESS) {
                  if (itemData.data != null) {
                    Fluttertoast.showToast(
                        msg: 'Item Uploaded',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white);

                    if (widget.isImageSelected.contains(true) || widget.isSelectedVideoImagePath!) {
                      widget.uploadImage!(itemData.data!.id);
                    }
                  }
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: itemData.message,
                        );
                      });
                }
              }
            }
          },
        ));

    return Column(children: <Widget>[
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__listing_title'),
        textAboutMe: false,
        hintText: Utils.getString(context, 'item_entry__entry_title'),
        textEditingController: widget.userInputListingTitle,
        isStar: true,
      ),
      PsDropdownBaseWithControllerWidget(
        title: Utils.getString(context, 'item_entry__manufacture'),
        textEditingController: widget.manufacturerController,
        isStar: true,
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          final ItemEntryProvider provider =
              Provider.of<ItemEntryProvider>(context, listen: false);

          final dynamic categoryResult = await Navigator.pushNamed(
              context, RoutePaths.manufacturer,
              arguments: widget.manufacturerController!.text);

          if (categoryResult != null && categoryResult is Manufacturer) {
            provider.manufacturerId = categoryResult.id!;
            widget.manufacturerController!.text = categoryResult.name!;
            provider.modelId = '';
            if (mounted) {
              setState(() {
                widget.manufacturerController!.text = categoryResult.name!;
                widget.modelController!.text = '';
              });
            }
          } else if (categoryResult) {
            widget.manufacturerController!.text = '';
          }
        },
      ),
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__model'),
          textEditingController: widget.modelController,
          isStar: true,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);
            if (provider.manufacturerId != '') {
              final dynamic subCategoryResult = await Navigator.pushNamed(
                  context, RoutePaths.searchSubCategory,
                  arguments: ModelIntentHolder(
                      modelName: widget.modelController!.text,
                      categoryId: provider.manufacturerId));
              if (subCategoryResult != null && subCategoryResult is Model) {
                provider.modelId = subCategoryResult.id!;

                widget.modelController!.text = subCategoryResult.name!;
              } else if (subCategoryResult) {
                widget.modelController!.text = '';
              }
            } else {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message: Utils.getString(
                          context, 'home_search__choose_manufacturer_first'),
                    );
                  });
              const ErrorDialog(message: 'Choose Category first');
            }
          }),
      if (Utils.showUI(valueHolder!.plateNumber))    
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__plate_number'),
        textAboutMe: false,
        textEditingController: widget.userInputPlateNumber,
        isStar: false,
      ),
      if (Utils.showUI(valueHolder!.enginePower))
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__engine_power'),
        textAboutMe: false,
        textEditingController: widget.userInputEnginePower,
        isStar: false,
      ),
      if (Utils.showUI(valueHolder!.transmissionId))
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__transmission'),
          textEditingController: widget.transmissionController,
          isStar: false,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());

            final dynamic transmissionResult = await Navigator.pushNamed(
                context, RoutePaths.transmission,
                arguments: widget.transmissionController!.text);

            if (transmissionResult != null &&
                transmissionResult is Transmission) {
              widget.provider!.transmissionId = transmissionResult.id!;
              widget.transmissionController!.text = transmissionResult.name!;
              if (mounted) {
                setState(() {
                  widget.transmissionController!.text =
                      transmissionResult.name!;
                });
              }
            } else if (transmissionResult) {
              widget.transmissionController!.text = '';
            }
          }),
      if (Utils.showUI(valueHolder!.mileage))    
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__mileage'),
        textAboutMe: false,
        textEditingController: widget.userInputMileage,
        isStar: false,
      ),
      if (Utils.showUI(valueHolder!.licenceExpirationDate))
      PsTextFieldWidget(
        titleText:
            Utils.getString(context, 'item_entry__license_expiration_date'),
        textAboutMe: false,
        textEditingController: widget.userInputLicenseExpDate,
        isStar: false,
      ),
      if (Utils.showUI(valueHolder!.year))
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__year'),
        textAboutMe: false,
        textEditingController: widget.userInputYear,
        isStar: false,
      ),
      if (Utils.showUI(valueHolder!.color))
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__color'),
          textEditingController: widget.itemColorController,
          isStar: false,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());

            final dynamic itemColorResult = await Navigator.pushNamed(
                context, RoutePaths.itemColor,
                arguments: widget.itemColorController!.text);

            if (itemColorResult != null && itemColorResult is ItemColor) {
              widget.provider!.itemColorId = itemColorResult.id!;
              widget.itemColorController!.text = itemColorResult.colorValue!;
              if (mounted) {
                setState(() {
                  widget.itemColorController!.text =
                      itemColorResult.colorValue!;
                });
              }
            } else if (itemColorResult) {
              widget.itemColorController!.text = '';
            }
          }),
      if (Utils.showUI(valueHolder!.fuelType))    
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__fuel_type'),
          textEditingController: widget.itemFuelTypeController,
          isStar: false,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());

            final dynamic itemFuelTypeResult = await Navigator.pushNamed(
                context, RoutePaths.itemFuelType,
                arguments: widget.itemFuelTypeController!.text);

            if (itemFuelTypeResult != null &&
                itemFuelTypeResult is ItemFuelType) {
              widget.provider!.fuelTypeId = itemFuelTypeResult.id!;
              widget.itemFuelTypeController!.text =
                  itemFuelTypeResult.fuelName!;
              if (mounted) {
                setState(() {
                  widget.itemFuelTypeController!.text =
                      itemFuelTypeResult.fuelName!;
                });
              }
            } else if (itemFuelTypeResult) {
              widget.itemFuelTypeController!.text = '';
            }
          }),
      if (Utils.showUI(valueHolder!.steeringPosition))    
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__steering_position'),
        textAboutMe: false,
        textEditingController: widget.userInputSteeringPosition,
        isStar: false,
      ),
      if (Utils.showUI(valueHolder!.noOfOwner))
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__number_of_owner'),
        textAboutMe: false,
        textEditingController: widget.userInputNumOfOwner,
        isStar: false,
      ),
      if (Utils.showUI(valueHolder!.trimName))
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__trim_name'),
        textAboutMe: false,
        textEditingController: widget.userInputTrimName,
        isStar: false,
      ),
      if (Utils.showUI(valueHolder!.vehicleId))
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__vehicle_id'),
        textAboutMe: false,
        textEditingController: widget.userInputVehicleId,
        isStar: false,
      ),
      if (Utils.showUI(valueHolder!.buildType))
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__build_type'),
          textEditingController: widget.itemBuildTypeController,
          isStar: false,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());

            final dynamic itemBuildTypeResult = await Navigator.pushNamed(
                context, RoutePaths.itemBuildType,
                arguments: widget.itemBuildTypeController!.text);

            if (itemBuildTypeResult != null &&
                itemBuildTypeResult is ItemBuildType) {
              widget.provider!.buildTypeId = itemBuildTypeResult.id!;
              widget.itemBuildTypeController!.text =
                  itemBuildTypeResult.carType!;
              if (mounted) {
                setState(() {
                  widget.itemBuildTypeController!.text =
                      itemBuildTypeResult.carType!;
                });
              }
            } else if (itemBuildTypeResult) {
              widget.itemBuildTypeController!.text = '';
            }
          }),
      if (Utils.showUI(valueHolder!.licenceStatus))    
      Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: PsDimens.space12,right: 12),
            child: Text(Utils.getString(context, 'item_entry__licence_status'),
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          LicenseCheckbox(
            provider: widget.provider!,
            onCheckBoxClick: () {
              if (mounted) {
                setState(() {
                  updateLicenseCheckBox(context, widget.provider!);
                });
              }
            },
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: PsDimens.space40),
          //   child: Text(
          //       Utils.getString(context, 'item_entry__show_more_than_one'),
          //       style: Theme.of(context).textTheme.bodyText1),
          // ),
        ],
      ),
      if (Utils.showUI(valueHolder!.maxPassengers))  
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__maximum_passenger'),
        textAboutMe: false,
        textEditingController: widget.userInputMaximumPassenger,
        isStar: false,
      ),
      if (Utils.showUI(valueHolder!.noOfDoors))  
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__number_of_door'),
        textAboutMe: false,
        textEditingController: widget.userInputNumOfDoor,
        isStar: false,
      ),
      if (Utils.showUI(valueHolder!.sellerType))  
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__seller_type'),
          textEditingController: widget.itemSellerTypeController,
          isStar: false,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());

            final dynamic itemSellerTypeResult = await Navigator.pushNamed(
                context, RoutePaths.itemSellerType,
                arguments: widget.itemSellerTypeController!.text);

            if (itemSellerTypeResult != null &&
                itemSellerTypeResult is ItemSellerType) {
              widget.provider!.sellerTypeId = itemSellerTypeResult.id!;
              widget.itemSellerTypeController!.text =
                  itemSellerTypeResult.sellerType!;
              if (mounted) {
                setState(() {
                  widget.itemSellerTypeController!.text =
                      itemSellerTypeResult.sellerType!;
                });
              }
            } else if (itemSellerTypeResult) {
              widget.itemSellerTypeController!.text = '';
            }
          }),
      if (Utils.showUI(valueHolder!.itemType))      
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__type'),
          textEditingController: widget.typeController,
          isStar: false,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);

            final dynamic itemTypeResult = await Navigator.pushNamed(
                context, RoutePaths.itemType,
                arguments: widget.typeController!.text);

            if (itemTypeResult != null && itemTypeResult is ItemType) {
              provider.itemTypeId = itemTypeResult.id!;
              if (mounted) {
                setState(() {
                  widget.typeController!.text = itemTypeResult.name!;
                });
              }
            } else if (itemTypeResult) {
              widget.typeController!.text = '';
            }
          }),
      if (Utils.showUI(valueHolder!.condition))      
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__item_condition'),
          textEditingController: widget.itemConditionController,
          isStar: false,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);

            final dynamic itemConditionResult = await Navigator.pushNamed(
                context, RoutePaths.itemCondition,
                arguments: widget.itemConditionController!.text);

            if (itemConditionResult != null &&
                itemConditionResult is ConditionOfItem) {
              provider.itemConditionId = itemConditionResult.id!;
              if (mounted) {
                setState(() {
                  widget.itemConditionController!.text =
                      itemConditionResult.name!;
                });
              }
            } else if (itemConditionResult) {
              widget.itemConditionController!.text = '';
            }
          }),
      if (Utils.showUI(valueHolder!.priceUnit))      
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__price_unit'),
        textAboutMe: false,
        textEditingController: widget.userInputPriceUnit,
      ),
      if (Utils.showUI(valueHolder!.priceType))  
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__price_type'),
          textEditingController: widget.priceTypeController,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);

            final dynamic itemPriceTypeResult = await Navigator.pushNamed(
                context, RoutePaths.itemPriceType,
                arguments: widget.priceTypeController!.text);

            if (itemPriceTypeResult != null &&
                itemPriceTypeResult is ItemPriceType) {
              provider.itemPriceTypeId = itemPriceTypeResult.id!;
              if (mounted) {
                setState(() {
                  widget.priceTypeController!.text = itemPriceTypeResult.name!;
                });
              }
            } else if (itemPriceTypeResult) {
              widget.priceTypeController!.text = '';
            }
          }),
      PriceDropDownControllerWidget(
          currencySymbolController: widget.priceController!,
          userInputPriceController: widget.userInputPrice!),
      if (Utils.showUI(valueHolder!.discountRate))  
      PsTextFieldWidget(
        //  height: 46,
        titleText: Utils.getString(context, 'item_entry__discount_title'),
        textAboutMe: false,
        hintText: Utils.getString(context, 'item_entry__discount_info'),
        textEditingController: widget.userInputDiscount,
        keyboardType: TextInputType.number,
      ),    
      const SizedBox(height: PsDimens.space8),
      if (Utils.showUI(valueHolder!.businessMode))  
      Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: PsDimens.space12,right: 12),
            child: Text(Utils.getString(context, 'item_entry__for_free_item'),
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(height: PsDimens.space8),
          Padding(
            padding: const EdgeInsets.only(left: PsDimens.space12,right: 12),
            child: Text(Utils.getString(context, 'item_entry__shop_setting'),
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          BusinessModeCheckbox(
            provider: widget.provider!,
            onCheckBoxClick: () {
              if (mounted) {
                setState(() {
                  updateCheckBox(context, widget.provider!);
                });
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: PsDimens.space40,right: 12),
            child: Text(
                Utils.getString(context, 'item_entry__show_more_than_one'),
                style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
      if (Utils.showUI(valueHolder!.highlightInfo))
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__highlight_info'),
        height: PsDimens.space120,
        hintText: Utils.getString(context, 'item_entry__highlight_info'),
        textAboutMe: true,
        textEditingController: widget.userInputHighLightInformation,
      ),
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__description'),
        height: PsDimens.space120,
        hintText: Utils.getString(context, 'item_entry__description'),
        textAboutMe: true,
        textEditingController: widget.userInputDescription,
        isStar: true,
      ),
      // Column(
      //   children: <Widget>[
      //     PsDropdownBaseWithControllerWidget(
      //         title: Utils.getString(context, 'item_entry__deal_option'),
      //         textEditingController: widget.dealOptionController,
      //         isStar: true,
      //         onTap: () async {
      //           FocusScope.of(context).requestFocus(FocusNode());
      //           final ItemEntryProvider provider =
      //               Provider.of<ItemEntryProvider>(context, listen: false);

      //           final dynamic itemDealOptionResult = await Navigator.pushNamed(
      //               context, RoutePaths.itemDealOption);

      //           if (itemDealOptionResult != null &&
      //               itemDealOptionResult is DealOption) {
      //             provider.itemDealOptionId = itemDealOptionResult.id;

      //             setState(() {
      //               widget.dealOptionController.text =
      //                   itemDealOptionResult.name;
      //             });
      //           }
      //         }),
      //     Container(
      //       width: double.infinity,
      //       height: PsDimens.space44,
      //       margin: const EdgeInsets.only(
      //           left: PsDimens.space12,
      //           right: PsDimens.space12,
      //           bottom: PsDimens.space12),
      //       decoration: BoxDecoration(
      //         color:
      //             Utils.isLightMode(context) ? Colors.white60 : Colors.black54,
      //         borderRadius: BorderRadius.circular(PsDimens.space4),
      //         border: Border.all(
      //             color: Utils.isLightMode(context)
      //                 ? Colors.grey[200]
      //                 : Colors.black87),
      //       ),
      //       child: TextField(
      //         keyboardType: TextInputType.text,
      //         maxLines: null,
      //         controller: widget.userInputDealOptionText,
      //         style: Theme.of(context).textTheme.bodyText1,
      //         decoration: InputDecoration(
      //           contentPadding: const EdgeInsets.only(
      //             left: PsDimens.space12,
      //             bottom: PsDimens.space8,
      //           ),
      //           border: InputBorder.none,
      //           hintText: Utils.getString(context, 'item_entry__remark'),
      //           hintStyle: Theme.of(context)
      //               .textTheme
      //               .bodyText1
      //               .copyWith(color: PsColors.textPrimaryLightColor),
      //         ),
      //       ),
      //     )
      //   ],
      // ),
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__location'),
          // selectedText: provider.selectedItemLocation == ''
          //     ? provider.psValueHolder.locactionName
          //     : provider.selectedItemLocation,

          textEditingController:
              // locationController.text == ''
              // ?
              // provider.psValueHolder.locactionName
              // :
              widget.locationController,
          isStar: true,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);

            final dynamic itemLocationResult = await Navigator.pushNamed(
                context, RoutePaths.itemLocation,
                arguments: widget.locationController!.text);

            if (itemLocationResult != null &&
                itemLocationResult is ItemLocation) {
              provider.itemLocationId = itemLocationResult.id!;
              if (mounted) {
                setState(() {
                  widget.locationController!.text = itemLocationResult.name!;
                  if (valueHolder!.isUseGoogleMap! &&
                      valueHolder!.isSubLocation == PsConst.ZERO) {
                    _kLake = googlemap.CameraPosition(
                        target: googlemap.LatLng(
                            _latlng!.latitude, _latlng!.longitude),
                        zoom: widget.zoom!);
                    if (_kLake != null) {
                      widget.googleMapController!.animateCamera(
                          googlemap.CameraUpdate.newCameraPosition(_kLake!));
                    }
                    widget.userInputLattitude!.text = itemLocationResult.lat!;
                    widget.userInputLongitude!.text = itemLocationResult.lng!;
                  } else if (!valueHolder!.isUseGoogleMap! &&
                      valueHolder!.isSubLocation == PsConst.ZERO) {
                    _latlng = LatLng(double.parse(itemLocationResult.lat!),
                        double.parse(itemLocationResult.lng!));
                    widget.mapController!.move(_latlng!, widget.zoom!);
                    widget.userInputLattitude!.text = itemLocationResult.lat!;
                    widget.userInputLongitude!.text = itemLocationResult.lng!;
                  } else {
                    //do nothing
                  }

                  widget.locationTownshipController!.text = '';
                  provider.itemLocationTownshipId = '';
                  widget.userInputAddress!.text = '';
                });
              }
            }
          }),
      if (valueHolder!.isSubLocation == PsConst.ONE)
        PsDropdownBaseWithControllerWidget(
            title: Utils.getString(context, 'item_entry__location_township'),
            textEditingController: widget.locationTownshipController,
            isStar: false,
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              final ItemEntryProvider provider =
                  Provider.of<ItemEntryProvider>(context, listen: false);
              if (provider.itemLocationId != '') {
                final dynamic itemLocationTownshipResult =
                    await Navigator.pushNamed(
                        context, RoutePaths.itemLocationTownship,
                        arguments: provider.itemLocationId);

                if (itemLocationTownshipResult != null &&
                    itemLocationTownshipResult is ItemLocationTownship) {
                  provider.itemLocationTownshipId =
                      itemLocationTownshipResult.id!;
                  setState(() {
                    widget.locationTownshipController!.text =
                        itemLocationTownshipResult.townshipName!;
                    if (valueHolder!.isUseGoogleMap!) {
                      _kLake = googlemap.CameraPosition(
                          target: googlemap.LatLng(
                              _latlng!.latitude, _latlng!.longitude),
                          zoom: widget.zoom!);
                      if (_kLake != null) {
                        widget.googleMapController!.animateCamera(
                            googlemap.CameraUpdate.newCameraPosition(_kLake!));
                      }
                    } else {
                      _latlng = LatLng(
                          double.parse(itemLocationTownshipResult.lat!),
                          double.parse(itemLocationTownshipResult.lng!));
                      widget.mapController!.move(_latlng!, widget.zoom!);
                    }
                    widget.userInputLattitude!.text =
                        itemLocationTownshipResult.lat!;
                    widget.userInputLongitude!.text =
                        itemLocationTownshipResult.lng!;

                    widget.userInputAddress!.text = '';
                  });
                }
              } else {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: Utils.getString(
                            context, 'home_search__choose_city_first'),
                      );
                    });
                const ErrorDialog(message: 'Choose City first');
              }
            })
      else
        Container(),
      if (!valueHolder!.isUseGoogleMap!)
        Column(
          children: <Widget>[
            CurrentLocationWidget(
              androidFusedLocation: true,
              textEditingController: widget.userInputAddress!,
              latController: widget.userInputLattitude!,
              lngController: widget.userInputLongitude!,
              valueHolder: valueHolder!,
              updateLatLng: (Position? currentPosition) {
                if (currentPosition != null) {
                  setState(() {
                    _latlng = LatLng(
                        currentPosition.latitude, currentPosition.longitude);
                    widget.mapController!.move(_latlng!, widget.zoom!);
                  });
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: Container(
                height: 250,
                child: 
                FlutterMap(
                  mapController: widget.mapController,
                  options: MapOptions(
                      center:
                          _latlng, //LatLng(51.5, -0.09), //LatLng(45.5231, -122.6765),
                      zoom: widget.zoom!, //10.0,
                      onTap: (dynamic tapPosition, LatLng latLngr) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _handleTap(_latlng!, widget.mapController!);
                      }),
                      children: [
                         TileLayer(
                        urlTemplate:'https://tile.openstreetmap.org/{z}/{x}/{y}.png',   
                         ),
                         MarkerLayer(
                          markers: <Marker>[
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _latlng!,
                        builder: (BuildContext ctx) => Container(
                          child: IconButton(
                            icon: Icon(
                              Icons.location_on,
                              color: PsColors.mainColor,
                            ),
                            iconSize: 45,
                            onPressed: () {},
                          ),
                        ),
                      )
                    ],
                         )
                      ],
               
                ),
            
              ),
            ),
          ],
        )
      else
        Column(
          children: <Widget>[
            CurrentLocationWidget(
              androidFusedLocation: true,
              textEditingController: widget.userInputAddress!,
              latController: widget.userInputLattitude!,
              lngController: widget.userInputLongitude!,
              valueHolder: valueHolder!,
              updateLatLng: (Position? currentPosition) {
                if (currentPosition != null) {
                  setState(() {
                    _latlng = LatLng(
                        currentPosition.latitude, currentPosition.longitude);
                    _kLake = googlemap.CameraPosition(
                        target: googlemap.LatLng(
                            _latlng!.latitude, _latlng!.longitude),
                        zoom: widget.zoom!);
                    if (_kLake != null) {
                      widget.googleMapController!.animateCamera(
                          googlemap.CameraUpdate.newCameraPosition(_kLake!));
                    }
                  });
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18, left: 18),
              child: Container(
                height: 250,
                child: googlemap.GoogleMap(
                    onMapCreated: widget.updateMapController as void Function(
                        googlemap.GoogleMapController)?,
                    initialCameraPosition: kGooglePlex!,
                    circles: <googlemap.Circle>{}..add(googlemap.Circle(
                        circleId: googlemap.CircleId(
                            widget.userInputAddress.toString()),
                        center: googlemap.LatLng(
                            _latlng!.latitude, _latlng!.longitude),
                        radius: 50,
                        fillColor: Colors.blue.withOpacity(0.7),
                        strokeWidth: 3,
                        strokeColor: Colors.redAccent,
                      )),
                    onTap: (googlemap.LatLng latLngr) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _handleGoogleMapTap(
                          _latlng!, widget.googleMapController!);
                    }),
              ),
            ),
          ],
        ),
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__latitude'),
        textAboutMe: false,
        textEditingController: widget.userInputLattitude,
      ),
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__longitude'),
        textAboutMe: false,
        textEditingController: widget.userInputLongitude,
      ),
      if (Utils.showUI(valueHolder!.address))  
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__address'),
        textAboutMe: false,
        height: PsDimens.space160,
        textEditingController: widget.userInputAddress,
        hintText: Utils.getString(context, 'item_entry__address'),
      ),
      _uploadItemWidget
    ]);
  }

  dynamic _handleTap(LatLng latLng, MapController mapController) async {
    final dynamic result = await Navigator.pushNamed(context, RoutePaths.mapPin,
        arguments: MapPinIntentHolder(
            flag: PsConst.PIN_MAP,
            mapLat: _latlng!.latitude.toString(),
            mapLng: _latlng!.longitude.toString()));
    if (result != null && result is MapPinCallBackHolder) {
      if (mounted) {
        setState(() {
          _latlng = result.latLng;
          mapController.move(_latlng!, widget.zoom!);
          widget.userInputAddress!.text = result.address;
          // tappedPoints = <LatLng>[];
          // tappedPoints.add(latlng);
        });
      }
      widget.userInputLattitude!.text = result.latLng.latitude.toString();
      widget.userInputLongitude!.text = result.latLng.longitude.toString();
    }
  }

  dynamic _handleGoogleMapTap(
      LatLng latLng, googlemap.GoogleMapController googleMapController) async {
    final dynamic result = await Navigator.pushNamed(
        context, RoutePaths.googleMapPin,
        arguments: MapPinIntentHolder(
            flag: PsConst.PIN_MAP,
            mapLat: _latlng!.latitude.toString(),
            mapLng: _latlng!.longitude.toString()));
    if (result != null && result is GoogleMapPinCallBackHolder) {
      setState(() {
        _latlng = LatLng(result.latLng.latitude, result.latLng.longitude);
        _kLake = googlemap.CameraPosition(
            target: googlemap.LatLng(_latlng!.latitude, _latlng!.longitude),
            zoom: widget.zoom!);
        if (_kLake != null) {
          googleMapController
              .animateCamera(googlemap.CameraUpdate.newCameraPosition(_kLake!));
          widget.userInputAddress!.text = result.address;
          widget.userInputAddress!.text = '';
          // tappedPoints = <LatLng>[];
          // tappedPoints.add(latlng);
        }
      });
      widget.userInputLattitude!.text = result.latLng.latitude.toString();
      widget.userInputLongitude!.text = result.latLng.longitude.toString();
    }
  }
}

class ImageUploadHorizontalList extends StatefulWidget {
  const ImageUploadHorizontalList({
    required this.flag,
    required this.images,
    required this.selectedImageList,
    required this.updateImages,
    required this.updateImagesFromCustomCamera,
    required this.updateImagesFromVideo,
    required this.selectedVideoImagePath,
    required this.videoFilePath,
    required this.videoFileThumbnailPath,
    required this.selectedVideoPath,
    required this.galleryImagePath,
    required this.cameraImagePath,
    required this.getImageFromVideo,
    required this.imageDesc1Controller,
    required this.galleryProvider,
    required this.onReorder,
    this.provider,
  });
  final String? flag;
  final List<Asset>? images;
  final List<DefaultPhoto?>? selectedImageList;
  final Function? updateImages;
  final Function? updateImagesFromCustomCamera;
  final String? selectedVideoImagePath;
  final String? videoFilePath;
  final String? selectedVideoPath;
  final String? videoFileThumbnailPath;
  final Function? updateImagesFromVideo;
  final List<Asset?> galleryImagePath;
  final List<String?> cameraImagePath;
  final Function? getImageFromVideo;
  final TextEditingController? imageDesc1Controller;
  final ItemEntryProvider? provider;
  final GalleryProvider? galleryProvider;
  final Function onReorder;

  @override
  State<StatefulWidget> createState() {
    return ImageUploadHorizontalListState();
  }
}

class ImageUploadHorizontalListState extends State<ImageUploadHorizontalList> {
  late ItemEntryProvider provider;
  late PsValueHolder psValueHolder;
  Future<void> loadPickMultiImage(int index) async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: psValueHolder.maxImageCount - index,
        enableCamera: true,
        // selectedAssets: widget.images,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: 'chat'),
        materialOptions: MaterialOptions(
          actionBarColor: Utils.convertColorToString(PsColors.black!),
          actionBarTitleColor: Utils.convertColorToString(PsColors.white!),
          statusBarColor: Utils.convertColorToString(PsColors.black!),
          lightStatusBar: false,
          actionBarTitle: '',
          allViewTitle: 'All Photos',
          useDetailsView: false,
          selectCircleStrokeColor:
              Utils.convertColorToString(PsColors.mainColor!),
        ),
      );
    } on Exception catch (e) {
      e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    for (int i = 0; i < resultList.length; i++) {
      if (resultList[i].name!.contains('.webp')) {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString(context, 'error_dialog__webp_image'),
              );
            });
        return;
      }
    }
    widget.updateImages!(resultList, -1, index);
  }

  Future<void> loadSingleImage(int index) async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
      //  selectedAssets: widget.images!, //widget.images,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: 'chat'),
        materialOptions: MaterialOptions(
          actionBarColor: Utils.convertColorToString(PsColors.black!),
          actionBarTitleColor: Utils.convertColorToString(PsColors.white!),
          statusBarColor: Utils.convertColorToString(PsColors.black!),
          lightStatusBar: false,
          actionBarTitle: '',
          allViewTitle: 'All Photos',
          useDetailsView: false,
          selectCircleStrokeColor:
              Utils.convertColorToString(PsColors.mainColor!),
        ),
      );
    } on Exception catch (e) {
      e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    if (resultList[0].name!.contains('.webp')) {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString(context, 'error_dialog__webp_image'),
            );
          });
    } else {
      widget.updateImages!(resultList, index, index);
    }
  }

  List<Widget> _imageWidgetList = <Widget>[];
  late Widget _videoWidget;
  late Widget _firstImageWidget;
  @override
  Widget build(BuildContext context) {
    Asset? defaultAssetImage;
    DefaultPhoto? defaultUrlImage;
    psValueHolder = Provider.of<PsValueHolder>(context);
    provider = Provider.of<ItemEntryProvider>(context, listen: false);
    // List<PlatformFile>? videoFilePath = <PlatformFile>[];

    final Widget _defaultWidget = Container(
      width: 94,
      height: 25,
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
      ),
      margin: const EdgeInsets.only(
          top: PsDimens.space4, left: PsDimens.space6, right: PsDimens.space4),
      child: Material(
        color: PsColors.soldOutUIColor,
        type: MaterialType.card,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(PsDimens.space16))),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
                left: PsDimens.space8, right: PsDimens.space8),
            child: Text(
              Utils.getString(context, 'item_entry__default_image'),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: PsColors.white),
            ),
          ),
        ),
      ),
    );

    _videoWidget = Visibility(
      visible:
          Utils.showUI(provider.psValueHolder!.video), //PsConfig.showVideo,
      child: ItemEntryImageWidget(
        galleryProvider: widget.galleryProvider,
        index: -1, //video
        images: defaultAssetImage,
        selectedVideoImagePath: (widget.selectedVideoImagePath != null)
            ? widget.selectedVideoImagePath
            : null,
        videoFilePath:
            (widget.videoFilePath != null) ? widget.videoFilePath : null,
        videoFileThumbnailPath: (widget.videoFileThumbnailPath != null)
            ? widget.videoFileThumbnailPath
            : null,
        selectedVideoPath: widget.selectedVideoPath,
        cameraImagePath: null,
        provider: provider,
        selectedImage:
            widget.selectedVideoImagePath == null ? defaultUrlImage : null,
        onDeletItemImage: () {
          setState(() {
            final ItemEntryProvider itemEntryProvider =
                Provider.of<ItemEntryProvider>(context, listen: false);
            itemEntryProvider.item!.video!.imgId = '';
            itemEntryProvider.item!.videoThumbnail!.imgId = '';
            itemEntryProvider.item!.video = null;
            itemEntryProvider.item!.videoThumbnail = null;
          });
        },
        hideDesc: true,
        onTap: () async {
          try {
            // videoFilePath = (await FilePicker.platform.pickFiles(
            //   type: FileType.video,
            //   allowMultiple: true,
            // ))
            //     ?.files;
          } on PlatformException catch (e) {
            print('Unsupported operation' + e.toString());
          } catch (ex) {
            print(ex);
          }
          // if (videoFilePath != null) {
          //   // await PsProgressDialog.showDialog(context);

          //            if (videoFilePath != null) {
          //     final File pickedVideo = File(videoFilePath![0].path!);
          //     final VideoPlayerController videoPlayer =
          //         VideoPlayerController.file(pickedVideo);
          //     await videoPlayer.initialize();

          //      final int maximumSecond = int.parse(psValueHolder.videoDuration ?? '60000');
          //     final int videoDuration = videoPlayer.value.duration.inMilliseconds;

          //     if (videoDuration < maximumSecond) {
          //       await widget.getImageFromVideo!(pickedVideo.path);
          //       widget.updateImagesFromVideo!(pickedVideo.path, -2);
          //     } else {
          //       showDialog<dynamic>(
          //           context: context,
          //           builder: (BuildContext context) {
          //             return ErrorDialog(
          //                 message: Utils.getString(
          //                     context, 'error_dialog__select_video'));
          //           });
          //     }
          //   }

          //   // PsProgressDialog.dismissDialog();
          // }
        },
      ),
    );

    _firstImageWidget = Stack(
      key: const Key('0'),
      children: <Widget>[
        ItemEntryImageWidget(
          galleryProvider: widget.galleryProvider,
          index: 0,
          images: (widget.galleryImagePath[0] != null)
              ? widget.galleryImagePath[0]
              : defaultAssetImage,
          selectedVideoImagePath: null,
          selectedVideoPath: widget.selectedVideoPath,
          videoFilePath: null,
          videoFileThumbnailPath: null,
          cameraImagePath: (widget.cameraImagePath[0] != null)
              ? widget.cameraImagePath[0]
              : defaultAssetImage as String?,
          selectedImage: (widget.selectedImageList!.isNotEmpty &&
                  widget.galleryImagePath[0] == null &&
                  widget.cameraImagePath[0] == null)
              ? widget.selectedImageList![0]
              : null,
          onDeletItemImage: () {},
          hideDesc: false,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            if (provider.psValueHolder!.isCustomCamera) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ChooseCameraTypeDialog(
                      onCameraTap: () async {
                        final dynamic returnData = await Navigator.pushNamed(
                            context, RoutePaths.cameraView);
                        if (returnData is String) {
                          widget.updateImagesFromCustomCamera!(returnData, 0);
                        }
                      },
                      onGalleryTap: () {
                        if (widget.flag == PsConst.ADD_NEW_ITEM) {
                          loadPickMultiImage(0);
                        } else {
                          loadSingleImage(0);
                        }
                      },
                    );
                  });
            } else {
              if (widget.flag == PsConst.ADD_NEW_ITEM) {
                loadPickMultiImage(0);
              } else {
                loadSingleImage(0);
              }
            }
          },
        ),
        Positioned(
          child: _defaultWidget,
          left: 1,
          top: 1,
        ),
      ],
    );

    _imageWidgetList = List<Widget>.generate(
        psValueHolder.maxImageCount - 1,
        (int index) => ItemEntryImageWidget(
              galleryProvider: widget.galleryProvider,
              key: Key('${index + 1}'),
              index: index + 1,
              images: (widget.galleryImagePath[index + 1] != null)
                  ? widget.galleryImagePath[index + 1]
                  : defaultAssetImage,
              selectedVideoImagePath: null,
              selectedVideoPath: widget.selectedVideoPath,
              videoFilePath: null,
              videoFileThumbnailPath: null,
              cameraImagePath: (widget.cameraImagePath[index + 1] != null)
                  ? widget.cameraImagePath[index + 1]
                  : defaultAssetImage as String?,
              selectedImage:
                  // (widget.secondImagePath != null) ? null : defaultUrlImage,
                  (widget.selectedImageList!.length > index + 1 &&
                          widget.galleryImagePath[index + 1] == null &&
                          widget.cameraImagePath[index + 1] == null)
                      ? widget.selectedImageList![index + 1]
                      : null,
              hideDesc: false,
              onDeletItemImage: () {
                setState(() {
                  widget.selectedImageList![index + 1]!.imgId = '';
                  widget.selectedImageList![index + 1] =
                      DefaultPhoto(imgId: '', imgPath: '');
                });
              },
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());

                if (provider.psValueHolder!.isCustomCamera) {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ChooseCameraTypeDialog(
                          onCameraTap: () async {
                            final dynamic returnData =
                                await Navigator.pushNamed(
                                    context, RoutePaths.cameraView);
                            if (returnData is String) {
                              widget.updateImagesFromCustomCamera!(
                                  returnData, index + 1);
                            }
                          },
                          onGalleryTap: () {
                            if (widget.flag == PsConst.ADD_NEW_ITEM) {
                              loadPickMultiImage(index + 1);
                            } else {
                              loadSingleImage(index + 1);
                            }
                          },
                        );
                      });
                } else {
                  if (widget.flag == PsConst.ADD_NEW_ITEM) {
                    loadPickMultiImage(index + 1);
                  } else {
                    loadSingleImage(index + 1);
                  }
                }
              },
            ));

    _imageWidgetList.insert(
        0, _firstImageWidget); // add firt default image widget at index 0

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
            height: PsDimens.space180,
            child: ReorderableListView(
              scrollDirection: Axis.horizontal,
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  widget.onReorder(oldIndex, newIndex);
                });
              },
              header: _videoWidget,
              children: _imageWidgetList,
            ),
          ),
    );
  }
}

class ItemEntryImageWidget extends StatefulWidget {
  const ItemEntryImageWidget(
      {Key? key,
      required this.index,
      required this.images,
      required this.cameraImagePath,
      required this.selectedVideoImagePath,
      required this.selectedVideoPath,
      required this.videoFilePath,
      required this.videoFileThumbnailPath,
      required this.selectedImage,
      required this.hideDesc,
      this.onTap,
      this.provider,
      required this.onDeletItemImage,
      required this.galleryProvider})
      : super(key: key);

  final Function? onTap;
  final Function? onDeletItemImage;
  final int? index;
  final Asset? images;
  final String? cameraImagePath;
  final String? selectedVideoImagePath;
  final String? selectedVideoPath;
  final String? videoFilePath;
  final String? videoFileThumbnailPath;
  final DefaultPhoto? selectedImage;
  final ItemEntryProvider? provider;
  final GalleryProvider? galleryProvider;
  final bool hideDesc;
  @override
  State<StatefulWidget> createState() {
    return ItemEntryImageWidgetState();
  }
}

class ItemEntryImageWidgetState extends State<ItemEntryImageWidget> {
  GalleryProvider? galleryProvider;
  PsValueHolder? valueHolder;
  // int i = 0;
  @override
  Widget build(BuildContext context) {
    galleryProvider = widget.galleryProvider;
    valueHolder = Provider.of<PsValueHolder>(context, listen:false);
    final Widget _deleteWidget = Container(
      child: IconButton(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: PsDimens.space2),
        iconSize: PsDimens.space24,
        icon: const Icon(
          Icons.delete,
          color: Colors.grey,
        ),
        onPressed: () async {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialogView(
                  description: Utils.getString(
                      context, 'item_entry__confirm_delete_item_image'),
                  leftButtonText: Utils.getString(context, 'dialog__cancel'),
                  rightButtonText: Utils.getString(context, 'dialog__ok'),
                  onAgreeTap: () async {
                    Navigator.pop(context);

                    valueHolder =
                        Provider.of<PsValueHolder>(context, listen: false);
                    final DeleteItemImageHolder deleteItemImageHolder =
                        DeleteItemImageHolder(
                            imageId: widget.selectedImage!.imgId);
                    await PsProgressDialog.showDialog(context);
                    final PsResource<ApiStatus> _apiStatus =
                        await galleryProvider!.deleItemImage(
                            deleteItemImageHolder.toMap(),
                            Utils.checkUserLoginId(valueHolder));
                    PsProgressDialog.dismissDialog();
                    if (_apiStatus.data != null) {
                      widget.onDeletItemImage!();
                      galleryProvider!.loadImageList(widget.selectedImage!.imgParentId, PsConst.ITEM_TYPE);
                    } else {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialog(message: _apiStatus.message);
                          });
                    }
                  },
                );
              });
        },
      ),
      width: PsDimens.space32,
      height: PsDimens.space32,
      decoration: BoxDecoration(
        color: PsColors.backgroundColor,
        borderRadius: BorderRadius.circular(PsDimens.space28),
      ),
    );

    final Widget _deleteVideoWidget = Container(
      child: IconButton(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: PsDimens.space2),
        iconSize: PsDimens.space24,
        icon: const Icon(
          Icons.delete,
          color: Colors.grey,
        ),
        onPressed: () async {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialogView(
                  description: Utils.getString(
                      context, 'item_entry__confirm_delete_item_video'),
                  leftButtonText: Utils.getString(context, 'dialog__cancel'),
                  rightButtonText: Utils.getString(context, 'dialog__ok'),
                  onAgreeTap: () async {
                    Navigator.pop(context);

                    valueHolder =
                        Provider.of<PsValueHolder>(context, listen: false);
                    final DeleteItemImageHolder deleteItemImageHolder =
                        DeleteItemImageHolder(
                            imageId: widget.provider!.item!.video!.imgId);
                    final DeleteItemImageHolder deleteItemImageHolder2 =
                        DeleteItemImageHolder(
                            imageId:
                                widget.provider!.item!.videoThumbnail!.imgId);
                    await PsProgressDialog.showDialog(context);
                    final PsResource<ApiStatus> _apiStatus =
                        await galleryProvider!.deleItemVideo(
                            deleteItemImageHolder.toMap(),
                            Utils.checkUserLoginId(valueHolder));
                    final PsResource<ApiStatus> _apiStatus2 =
                        await galleryProvider!.deleItemVideo(
                            deleteItemImageHolder2.toMap(),
                            Utils.checkUserLoginId(valueHolder));
                    PsProgressDialog.dismissDialog();
                    if (_apiStatus.data != null && _apiStatus2.data != null) {
                      widget.onDeletItemImage!();
                    } else {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialog(message: _apiStatus.message);
                          });
                    }
                  },
                );
              });
        },
      ),
      width: PsDimens.space32,
      height: PsDimens.space32,
      decoration: BoxDecoration(
        color: PsColors.backgroundColor,
        borderRadius: BorderRadius.circular(PsDimens.space28),
      ),
    );

    if (widget.selectedImage != null && widget.selectedImage!.imgPath != '') {
      return Padding(
        padding: const EdgeInsets.only(right: 4, left: 4),
        child: InkWell(
          onTap: widget.onTap as void Function()?,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    child: PsNetworkImageWithUrl(
                      photoKey: '',
                      // width: 100,
                      // height: 100,
                      imageAspectRation: PsConst.Aspect_Ratio_1x,
                      imagePath: widget.selectedImage!.imgPath!,
                    ),
                  ),
                  Positioned(
                    child: widget.index == 0 ? Container() : _deleteWidget,
                    right: 1,
                    bottom: 1,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else if (widget.videoFilePath != null ||
        widget.videoFileThumbnailPath != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 4, left: 4),
        child: Column(
          children: <Widget>[
            if (widget.videoFileThumbnailPath != '')
              Stack(children: <Widget>[
                InkWell(
                  onTap: widget.onTap as void Function()?,
                  child: Image(
                      width: 100,
                      height: 100,
                      fit: BoxFit.fill,
                      image: FileImage(File(widget.videoFileThumbnailPath!))),
                ),
                GestureDetector(
                  onTap: widget.onTap as void Function()?,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.only(top: PsDimens.space14),
                      width: 100,
                      height: 100,
                      child: const Icon(
                        Icons.play_circle,
                        color: Colors.black54,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ])
            else
              InkWell(
                  onTap: widget.onTap as void Function()?,
                  child: Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.only(top: PsDimens.space16),
                    child: const Icon(
                      Icons.play_circle,
                      color: Colors.red,
                      size: 50,
                    ),
                  )),
            Visibility(
              visible: Utils.showUI(valueHolder!.video),
              child: Container(
                width: 80,
                padding: const EdgeInsets.only(top: PsDimens.space16),
                child: InkWell(
                  child: PSButtonWidget(
                      width: 30, titleText: Utils.getString(context, 'Play')),
                  onTap: () {
                    if (widget.videoFilePath == null) {
                      Navigator.pushNamed(context, RoutePaths.video_online,
                          arguments: widget.selectedVideoPath);
                    } else {
                      Navigator.pushNamed(context, RoutePaths.video,
                          arguments: widget.videoFilePath);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      if (widget.images != null) {
        final Asset asset = widget.images!;
        return Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: widget.onTap as void Function()?,
                child: AssetThumb(
                  asset: asset,
                  width: 100,
                  height: 100,
                ),
              ),
            ],
          ),
        );
      } else if (widget.cameraImagePath != null) {
        return Container(
          margin: const EdgeInsets.only(right: 4, left: 4),
          child: Stack(
            children: <Widget>[
              InkWell(
                onTap: widget.onTap as void Function(),
                child: ClipRect(
                  child: Image(
                      alignment: Alignment.center,
                      height: 100,
                      width: 100,
                      fit: BoxFit.fill,
                      image: FileImage(File(widget.cameraImagePath!))),
                ),
              ),
            ],
          ),
        );
      } else if (widget.selectedVideoImagePath != null) {
        return Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: Column(
            children: <Widget>[
              if (widget.selectedVideoImagePath != '')
                Stack(children: <Widget>[
                  InkWell(
                    onTap: widget.onTap as void Function()?,
                    child: Container(
                      width: 100,
                      height: 100,
                      child: PsNetworkImageWithUrl(
                        photoKey: '',
                        imageAspectRation: PsConst.Aspect_Ratio_full_image,
                        imagePath: widget.selectedVideoImagePath!,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: widget.onTap as void Function()?,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.only(top: PsDimens.space14),
                        width: 100,
                        height: 100,
                        child: const Icon(
                          Icons.play_circle,
                          color: Colors.black54,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Column(
                      children: <Widget>[
                        if (widget.provider!.item!.video == null &&
                            widget.provider!.item!.videoThumbnail == null &&
                            widget.provider!.item!.videoThumbnail == null)
                          Container()
                        else
                          _deleteVideoWidget
                      ],
                    ),
                    right: 1,
                    bottom: 1,
                  ),
                ])
              else
                InkWell(
                    onTap: widget.onTap as void Function()?,
                    child: Container(
                      padding: const EdgeInsets.only(top: PsDimens.space16),
                      width: 100,
                      height: 100,
                      child: const Icon(
                        Icons.play_circle,
                        color: Colors.black54,
                        size: 50,
                      ),
                    )),
              Flexible(
                child: Container(
                  width: 80,
                  padding: const EdgeInsets.only(top: PsDimens.space16),
                  child: InkWell(
                    child: PSButtonWidget(
                        width: 30, titleText: Utils.getString(context, 'Play')),
                    onTap: () {
                      if (widget.videoFilePath == null) {
                        Navigator.pushNamed(context, RoutePaths.video_online,
                            arguments: widget.selectedVideoPath);
                      } else {
                        Navigator.pushNamed(context, RoutePaths.video,
                            arguments: widget.videoFilePath);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: Column(
            children: <Widget>[
              if (!widget.hideDesc)
                Container(
                  // margin: const EdgeInsets.only(
                  //   bottom: PsDimens.space60,
                  // ),
                  child: InkWell(
                    onTap: widget.onTap as void Function()?,
                    child: Image.asset(
                      'assets/images/default_image.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                InkWell(
                    onTap: widget.onTap as void Function()?,
                    child: Container(
                      width: 100,
                      height: 100,
                      padding: const EdgeInsets.only(top: PsDimens.space16),
                      child: const Icon(
                        Icons.play_circle,
                        color: Colors.grey,
                        size: 50,
                      ),
                    )),
            ],
          ),
        );
      }
    }
  }
}

class PriceDropDownControllerWidget extends StatelessWidget {
  const PriceDropDownControllerWidget(
      {Key? key,
      // @required this.onTap,
      this.currencySymbolController,
      this.userInputPriceController})
      : super(key: key);

  final TextEditingController? currencySymbolController;
  final TextEditingController? userInputPriceController;
  // final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              top: PsDimens.space4,
              right: PsDimens.space12,
              left: PsDimens.space12),
          child: Row(
            children: <Widget>[
              Text(
                Utils.getString(context, 'item_entry__price'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(' *',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: PsColors.mainColor))
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final ItemEntryProvider provider =
                    Provider.of<ItemEntryProvider>(context, listen: false);

                final dynamic itemCurrencySymbolResult =
                    await Navigator.pushNamed(
                        context, RoutePaths.itemCurrencySymbol,
                        arguments: currencySymbolController!.text);

                if (itemCurrencySymbolResult != null &&
                    itemCurrencySymbolResult is ItemCurrency) {
                  provider.itemCurrencyId = itemCurrencySymbolResult.id!;

                  currencySymbolController!.text =
                      itemCurrencySymbolResult.currencySymbol!;
                }
                //  else if (itemCurrencySymbolResult) {
                //   currencySymbolController.text = '';
                // }
              },
              child: Container(
                // width: PsDimens.space140,
                height: PsDimens.space44,
                margin: const EdgeInsets.all(PsDimens.space12),
                decoration: BoxDecoration(
                  color: Utils.isLightMode(context)
                      ? Colors.white60
                      : Colors.black54,
                  borderRadius: BorderRadius.circular(PsDimens.space4),
                  border: Border.all(
                      color: Utils.isLightMode(context)
                          ? Colors.grey[200]!
                          : Colors.black87),
                ),
                child: Container(
                  margin: const EdgeInsets.all(PsDimens.space12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        child: Ink(
                          color: PsColors.backgroundColor,
                          child: Text(
                            currencySymbolController!.text == ''
                                ? Utils.getString(
                                    context, 'home_search__not_set')
                                : currencySymbolController!.text,
                            style: currencySymbolController!.text == ''
                                ? Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: Colors.grey[600])
                                : Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: PsDimens.space44,
                // margin: const EdgeInsets.only(
                //     top: 24),
                decoration: BoxDecoration(
                  color: Utils.isLightMode(context)
                      ? Colors.white60
                      : Colors.black54,
                  borderRadius: BorderRadius.circular(PsDimens.space4),
                  border: Border.all(
                      color: Utils.isLightMode(context)
                          ? Colors.grey[200]!
                          : Colors.black87),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  maxLines: null,
                  controller: userInputPriceController,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: PsDimens.space12, bottom: PsDimens.space4),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: PsDimens.space8),
          ],
        ),
      ],
    );
  }
}

class LicenseCheckbox extends StatefulWidget {
  const LicenseCheckbox(
      {required this.provider, required this.onCheckBoxClick});

  // final String checkOrNot;
  final ItemEntryProvider? provider;
  final Function? onCheckBoxClick;
  @override
  _LicenseCheckboxState createState() => _LicenseCheckboxState();
}

class _LicenseCheckboxState extends State<LicenseCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Theme(
          data: ThemeData(unselectedWidgetColor: Colors.grey),
          child: Checkbox(
            activeColor: PsColors.mainColor,
            value: widget.provider!.isLicenseCheckBoxSelect,
            onChanged: (bool? value) {
              widget.onCheckBoxClick!();
            },
          ),
        ),
        Expanded(
          child: InkWell(
            child: Text(Utils.getString(context, 'item_entry__is_lince'),
                style: Theme.of(context).textTheme.bodyLarge),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              widget.onCheckBoxClick!();
            },
          ),
        ),
      ],
    );
  }
}

void updateLicenseCheckBox(BuildContext context, ItemEntryProvider provider) {
  if (provider.isLicenseCheckBoxSelect) {
    provider.isLicenseCheckBoxSelect = false;
    provider.checkOrNotLicense = '0';
  } else {
    provider.isLicenseCheckBoxSelect = true;
    provider.checkOrNotLicense = '1';
    // Navigator.pushNamed(context, RoutePaths.privacyPolicy, arguments: 2);
  }
}

class BusinessModeCheckbox extends StatefulWidget {
  const BusinessModeCheckbox(
      {required this.provider, required this.onCheckBoxClick});

  // final String checkOrNot;
  final ItemEntryProvider? provider;
  final Function? onCheckBoxClick;

  @override
  _BusinessModeCheckbox createState() => _BusinessModeCheckbox();
}

class _BusinessModeCheckbox extends State<BusinessModeCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Theme(
          data: ThemeData(unselectedWidgetColor: Colors.grey),
          child: Checkbox(
            activeColor: PsColors.mainColor,
            value: widget.provider!.isCheckBoxSelect,
            onChanged: (bool? value) {
              widget.onCheckBoxClick!();
            },
          ),
        ),
        Expanded(
          child: InkWell(
            child: Text(Utils.getString(context, 'item_entry__is_shop'),
                style: Theme.of(context).textTheme.bodyLarge),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              widget.onCheckBoxClick!();
            },
          ),
        ),
      ],
    );
  }
}

void updateCheckBox(BuildContext context, ItemEntryProvider provider) {
  if (provider.isCheckBoxSelect) {
    provider.isCheckBoxSelect = false;
    provider.checkOrNotShop = '0';
  } else {
    provider.isCheckBoxSelect = true;
    provider.checkOrNotShop = '1';
    // Navigator.pushNamed(context, RoutePaths.privacyPolicy, arguments: 2);
  }
}

class CurrentLocationWidget extends StatefulWidget {
  const CurrentLocationWidget({
    Key? key,

    /// If set, enable the FusedLocationProvider on Android
    required this.androidFusedLocation,
    required this.textEditingController,
    required this.latController,
    required this.lngController,
    required this.valueHolder,
    required this.updateLatLng,
  }) : super(key: key);

  final bool androidFusedLocation;
  final TextEditingController? textEditingController;
  final TextEditingController? latController;
  final TextEditingController? lngController;
  final PsValueHolder? valueHolder;
  final Function? updateLatLng;

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<CurrentLocationWidget> {
  String address = '';
  Position? _currentPosition;
  final MapController mapController = MapController();

  @override
  void initState() {
    super.initState();

    _initCurrentLocation();
  }

  Future<void> loadAddress() async {
    if (_currentPosition != null) {
      if (widget.textEditingController!.text == '') {
        await placemarkFromCoordinates(
                _currentPosition!.latitude, _currentPosition!.longitude)
            .then((List<Placemark> placemarks) {
          final Placemark place = placemarks[0];
          setState(() {
            address =
              '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
              widget.textEditingController!.text = address;
            widget.latController!.text = _currentPosition!.latitude.toString();
            widget.lngController!.text = _currentPosition!.longitude.toString();
            widget.updateLatLng!(_currentPosition);
          });
        }).catchError((dynamic e) {
          debugPrint(e);
        });
      } else {
        address = widget.textEditingController!.text;
      }
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
    dynamic _initCurrentLocation() {
    Geolocator.checkPermission().then((LocationPermission permission) {
      if (permission == LocationPermission.denied) {
        Geolocator.requestPermission().then((LocationPermission permission) {
          if (permission == LocationPermission.denied) {
          } else {
            Geolocator
                    //..forceAndroidLocationManager = !widget.androidFusedLocation
                    .getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.medium,
                        forceAndroidLocationManager: false)
                .then((Position position) {
              print(position);
              //     if (mounted) {
              //  setState(() {
              _currentPosition = position;
              loadAddress();
              //    });
              // _currentPosition = position;

              //    }
            }).catchError((Object e) {
              print(e);
            });
          }
        });
      } else {
        Geolocator
                //..forceAndroidLocationManager = !widget.androidFusedLocation
                .getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.medium,
                    forceAndroidLocationManager: !widget.androidFusedLocation)
            .then((Position position) {
          //    if (mounted) {
          setState(() {
            _currentPosition = position;
            loadAddress();
          });
          //    }
        }).catchError((Object e) {
          print(e);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (_currentPosition == null) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(context, 'map_pin__open_gps'),
                      onPressed: () {},
                    );
                  });
            } else {
              loadAddress();
            }
          },
          child: Container(
            margin: const EdgeInsets.only(
                left: PsDimens.space8,
                right: PsDimens.space8,
                bottom: PsDimens.space8),
            child: Card(
              shape: const BeveledRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(PsDimens.space8)),
              ),
              color: PsColors.baseLightColor,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        height: PsDimens.space32,
                        width: PsDimens.space32,
                        child: Icon(
                          Icons.gps_fixed,
                          color: PsColors.mainColor,
                          size: PsDimens.space20,
                        ),
                      ),
                      onTap: () {
                        if (_currentPosition == null) {
                          showDialog<dynamic>(
                              context: context,
                              builder: (BuildContext context) {
                                return WarningDialog(
                                  message: Utils.getString(
                                      context, 'map_pin__open_gps'),
                                  onPressed: () {},
                                );
                              });
                        } else {
                          loadAddress();
                        }
                      },
                    ),
                    Expanded(
                      child: Text(
                        Utils.getString(context, 'item_entry_pick_location'),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            letterSpacing: 0.8, fontSize: 16, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}*/