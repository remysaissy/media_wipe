import 'package:sortmaster_photos/src/globals/device_type.dart';
import 'package:sortmaster_photos/src/models/abstract_model.dart';
import 'package:sortmaster_photos/src/utils.dart';

class OnboardingData {
  final String urlImage;
  final String title;
  final String description;

  OnboardingData(
      {required this.urlImage, required this.title, required this.description});

  OnboardingData.fromJson(Map<String, dynamic> json)
      : urlImage = json['urlImage'],
        title = json['title'],
        description = json['description'];
}

class AppModel extends AbstractModel {
  late bool _appReady;

  bool get appReady => _appReady;

  set appReady(bool value) {
    _appReady = value;
    notifyListeners();
  }

  bool getDefaultTouchMode() => DeviceType.isMobile == true;

  // Touch mode, determines density of views
  late bool _touchMode;

  bool get touchMode => _touchMode;

  set touchMode(bool value) {
    _touchMode = value;
    notifyListeners();
  }

  void toggleTouchMode() => touchMode = !touchMode;
  late bool _canRequestInAppReview;

  bool get canRequestInAppReview => _canRequestInAppReview;

  set canRequestInAppReview(bool canRequestInAppReview) {
    _canRequestInAppReview = canRequestInAppReview;
    notifyListeners();
  }

  late List<OnboardingData> _onboardingPages;

  List<OnboardingData> get onboardingPages => _onboardingPages;

  set onboardingPages(List<OnboardingData> value) {
    _onboardingPages = value;
    notifyListeners();
  }

  @override
  void reset([bool notify = true]) {
    Utils.logger.i("[AppModel] Reset");
    copyFromJson({});
    super.reset(notify);
  }

  /////////////////////////////////////////////////////////////////////
  // Define serialization methods

  //Json Serialization
  @override
  AppModel copyFromJson(Map<String, dynamic> json) {
    _appReady = false;
    _onboardingPages = [];
    _canRequestInAppReview = false;
    _touchMode = getDefaultTouchMode();
    return this;
  }
}
