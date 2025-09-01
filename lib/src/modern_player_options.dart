import 'package:flutter/material.dart';

import 'modern_player_menus.dart';

class ModernPlayerVideo {
  List<ModernPlayerVideoData> videosData = [];
  bool? fetchQualities;

  ModernPlayerVideo.single({required String source, required ModernPlayerSourceType sourceType}) {
    late ModernPlayerVideoData videoData;

    switch (sourceType) {
      case ModernPlayerSourceType.file:
        videoData = ModernPlayerVideoData.file(label: 'Default', path: source);
        break;
      case ModernPlayerSourceType.asset:
        videoData = ModernPlayerVideoData.asset(label: 'Default', path: source);
        break;
      case ModernPlayerSourceType.youtube:
        videoData = source.contains('https') || source.contains('youtube')
            ? ModernPlayerVideoData.youtubeWithUrl(label: 'Default', url: source)
            : ModernPlayerVideoData.youtubeWithId(label: 'Default', id: source);
        break;
      default:
        videoData = ModernPlayerVideoData.network(label: 'Default', url: source);
        break;
    }

    videosData = [videoData];
  }

  ModernPlayerVideo.multiple(this.videosData);

  ModernPlayerVideo.youtubeWithId({required String id, this.fetchQualities}) {
    videosData = [ModernPlayerVideoData.youtubeWithId(label: 'Default', id: id)];
  }

  ModernPlayerVideo.youtubeWithUrl({required String url, this.fetchQualities}) {
    videosData = [ModernPlayerVideoData.youtubeWithUrl(label: 'Default', url: url)];
  }
}

class ModernPlayerVideoData {
  String label = '';

  String source = '';

  ModernPlayerSourceType sourceType = ModernPlayerSourceType.asset;

  ModernPlayerVideoData.network({required this.label, required String url}) {
    source = url;
    sourceType = ModernPlayerSourceType.network;
  }

  ModernPlayerVideoData.file({required this.label, required String path}) {
    source = path;
    sourceType = ModernPlayerSourceType.file;
  }

  ModernPlayerVideoData.youtubeWithUrl({required this.label, required String url}) {
    String? videoId = _youtubeParser(url);

    if (videoId == null) {
      throw Exception('Cannot get video from url. Please try with ID');
    }

    source = videoId;
    sourceType = ModernPlayerSourceType.youtube;
  }

  ModernPlayerVideoData.youtubeWithId({required this.label, required String id}) {
    source = id;
    sourceType = ModernPlayerSourceType.youtube;
  }

  ModernPlayerVideoData.asset({required this.label, required String path}) {
    source = path;
    sourceType = ModernPlayerSourceType.asset;
  }

  String? _youtubeParser(String url) {
    final regExp = RegExp(r'^.*((youtu.be/)|(v/)|(/u/\w/)|(embed/)|(watch\?))\??v?=?([^#&?]*).*');
    final match = regExp.firstMatch(url);
    return (match != null && match.group(7)!.length == 11) ? match.group(7) : null;
  }
}

class ModernPlayerVideoDataYoutube extends ModernPlayerVideoData {
  String? audioOverride;

  ModernPlayerVideoDataYoutube.network({required super.label, required super.url, required this.audioOverride})
      : super.network();
}

class ModernPlayerOptions {
  bool autoVisibilityPause;

  int? videoStartAt;

  bool? allowScreenSleep;

  ModernPlayerOptions({this.autoVisibilityPause = true, this.videoStartAt, this.allowScreenSleep});
}

class ModernPlayerControlsOptions {
  bool showControls;

  bool showMute;

  bool showMenu;

  bool showBottomBar;

  bool showBackbutton;

  bool enableVolumeSlider;

  bool enableBrightnessSlider;

  bool doubleTapToSeek;

  Duration? autoHideTime;

  List<ModernPlayerCustomActionButton>? customActionButtons;

  ModernPlayerControlsOptions(
      {this.showControls = true,
      this.showMenu = true,
      this.showMute = true,
      this.showBackbutton = true,
      this.showBottomBar = true,
      this.enableVolumeSlider = true,
      this.enableBrightnessSlider = true,
      this.doubleTapToSeek = true,
      this.customActionButtons,
      this.autoHideTime});
}

class ModernPlayerThemeOptions {
  Color? backgroundColor;

  Color? menuBackgroundColor;

  Color? loadingColor;

  Icon? menuIcon;

  Icon? muteIcon;

  Icon? unmuteIcon;

  Icon? backIcon;

  Widget? customLoadingWidget;

  ModernPlayerProgressSliderTheme? progressSliderTheme;

  ModernPlayerToastSliderThemeOption? brightnessSlidertheme;

  ModernPlayerToastSliderThemeOption? volumeSlidertheme;

  ModernPlayerThemeOptions(
      {this.backgroundColor,
      this.menuBackgroundColor,
      this.loadingColor,
      this.menuIcon,
      this.muteIcon,
      this.unmuteIcon,
      this.backIcon,
      this.customLoadingWidget,
      this.progressSliderTheme,
      this.brightnessSlidertheme,
      this.volumeSlidertheme});
}

class ModernPlayerProgressSliderTheme {
  Color? activeSliderColor;

  Color? inactiveSliderColor;

  Color? bufferSliderColor;

  Color? thumbColor;

  TextStyle? progressTextStyle;

  ModernPlayerProgressSliderTheme(
      {this.activeSliderColor,
      this.inactiveSliderColor,
      this.bufferSliderColor,
      this.thumbColor,
      this.progressTextStyle});
}

class ModernPlayerToastSliderThemeOption {
  Color sliderColor;

  Color? iconColor;

  Color? backgroundColor;

  IconData? unfilledIcon;

  IconData? halfFilledIcon;

  IconData? filledIcon;

  ModernPlayerToastSliderThemeOption(
      {required this.sliderColor,
      this.iconColor,
      this.backgroundColor,
      this.unfilledIcon,
      this.halfFilledIcon,
      this.filledIcon});
}

class ModernPlayerCustomActionButton {
  Icon icon;

  VoidCallback? onPressed;

  VoidCallback? onLongPress;

  VoidCallback? onDoubleTap;

  ModernPlayerCustomActionButton({required this.icon, this.onPressed, this.onDoubleTap, this.onLongPress});
}

sealed class DefaultSelector {}

class DefaultSelectorOff extends DefaultSelector {}

class DefaultSelectorCustom extends DefaultSelector {
  final bool Function(int index, String label) shouldUseTrack;

  DefaultSelectorCustom(this.shouldUseTrack);
}

class DefaultSelectorLabel extends DefaultSelectorCustom {
  DefaultSelectorLabel(String labelSubstring)
      : super((index, label) => label.toLowerCase().contains(labelSubstring.toLowerCase()));
}

class ModernPlayerDefaultSelectionOptions {
  List<DefaultSelector>? defaultSubtitleSelectors;
  List<DefaultSelector>? defaultAudioSelectors;
  List<DefaultSelector>? defaultQualitySelectors;

  ModernPlayerDefaultSelectionOptions(
      {this.defaultSubtitleSelectors, this.defaultAudioSelectors, this.defaultQualitySelectors});
}

class ModernPlayerSubtitleOptions {
  String source;

  ModernPlayerSubtitleSourceType sourceType;

  bool? isSelected;

  ModernPlayerSubtitleOptions({required this.source, required this.sourceType, this.isSelected});
}

class ModernPlayerAudioTrackOptions {
  String source;

  ModernPlayerAudioSourceType sourceType;

  bool? isSelected;

  ModernPlayerAudioTrackOptions({required this.source, required this.sourceType, this.isSelected});
}

class ModernPlayerTranslationOptions {
  String? qualityHeaderText;

  String? playbackSpeedText;

  String? defaultPlaybackSpeedText;

  String? subtitleText;

  String? noneSubtitleText;

  String? unavailableSubtitleText;

  String? audioHeaderText;

  String? loadingAudioText;

  String? unavailableAudioText;

  String? defaultAudioText;

  ModernPlayerTranslationOptions.menu(
      {this.qualityHeaderText,
      this.playbackSpeedText,
      this.defaultPlaybackSpeedText,
      this.subtitleText,
      this.unavailableSubtitleText,
      this.audioHeaderText,
      this.loadingAudioText,
      this.defaultAudioText,
      this.unavailableAudioText});
}

class ModernPlayerCallbackOptions {
  Function? onPlay;

  Function? onPause;

  Function(int milliseconds)? onSeek;

  Function? onSeekForward;

  Function? onSeekBackward;

  Function(String title, String source)? onChangedQuality;

  Function(int selectedSubtitle)? onChangedSubtitle;

  Function(int selectedAudio)? onChangedAudio;

  Function(double selectedSpeed)? onChangedPlaybackSpeed;

  Function? onBackPressed;

  Function? onMenuPressed;

  Function? onMutePressed;

  ModernPlayerCallbackOptions(
      {this.onPlay,
      this.onPause,
      this.onSeek,
      this.onSeekForward,
      this.onSeekBackward,
      this.onChangedQuality,
      this.onChangedSubtitle,
      this.onChangedAudio,
      this.onChangedPlaybackSpeed,
      this.onBackPressed,
      this.onMenuPressed,
      this.onMutePressed});
}
