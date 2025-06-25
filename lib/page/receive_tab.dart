import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whisp/cubit/receive_tab_cubit/a_receive_tab_state.dart';
import 'package:whisp/cubit/receive_tab_cubit/receive_tab_cubit.dart';
import 'package:whisp/cubit/receive_tab_cubit/states/receive_tab_empty_state.dart';
import 'package:whisp/cubit/receive_tab_cubit/states/receive_tab_failed_state.dart';
import 'package:whisp/cubit/receive_tab_cubit/states/receive_tab_recording_state.dart';
import 'package:whisp/cubit/receive_tab_cubit/states/receive_tab_result_state.dart';
import 'package:whisp/cubit/theme_cubit/theme_assets.dart';
import 'package:whisp/widgets/action_button.dart';
import 'package:whisp/widgets/cartoon_cloud.dart';
import 'package:whisp/widgets/decoded_msg/decoded_msg_section.dart';
import 'package:whisp/widgets/device_selector.dart';
import 'package:whisp/widgets/settings_button.dart';
import 'package:win32audio/win32audio.dart';

class ReceiveTab extends StatefulWidget {
  final ReceiveTabCubit receiveTabCubit;
  final ThemeAssets themeAssets;

  const ReceiveTab({
    required this.receiveTabCubit,
    required this.themeAssets,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ReceiveTabState();
}

class _ReceiveTabState extends State<ReceiveTab> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late AnimationController _cloudFadeInController;
  late AnimationController _cloudExpansionController;
  late AnimationController _cloudBackgroundFadeInController;
  late AnimationController _actionButtonFadeOutController;
  late AnimationController _settingsButtonFadeOutController;
  late AnimationController _snggleFaceFadeInController;
  late AnimationController _msgFadeInController;
  late AnimationController _backButtonFadeInController;

  bool _actionButtonDisabledBool = false;
  List<int> _brokenMessageIndexList = <int>[];
  List<String>? _decodedMessagePartList;
  List<AudioDevice> audioDeviceList = <AudioDevice>[];

  @override
  void initState() {
    super.initState();
    _initAnimationControllers();
    _requestMicPermission();
    _cloudFadeInController.forward();
  }

  @override
  void dispose() {
    _cloudFadeInController.dispose();
    _cloudExpansionController.dispose();
    _cloudBackgroundFadeInController.dispose();
    _actionButtonFadeOutController.dispose();
    _settingsButtonFadeOutController.dispose();
    _snggleFaceFadeInController.dispose();
    _msgFadeInController.dispose();
    _backButtonFadeInController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<ReceiveTabCubit, AReceiveTabState>(
      bloc: widget.receiveTabCubit,
      listener: _animate,
      builder: (BuildContext context, AReceiveTabState state) {
        bool recordingInProgressBool = state is ReceiveTabRecordingState;
        bool initialStateBool = state is ReceiveTabEmptyState;

        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (Platform.isWindows)
                    SafeArea(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Opacity(
                              opacity: state is ReceiveTabEmptyState ? 1 : 0.5,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: SettingsButton(
                                  color: widget.themeAssets.primaryColor,
                                  fadeOutAnimationController: _settingsButtonFadeOutController,
                                  onPressed: state is ReceiveTabEmptyState ? () => _showDeviceSelectionDialog(context) : null,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(flex: 5),
                        ],
                      ),
                    )
                  else
                    const Spacer(flex: 1),
                  Expanded(
                    flex: 9,
                    child: CartoonCloud(
                      recordingFinishingBool: _actionButtonDisabledBool,
                      cloudMovingBool: _actionButtonDisabledBool || initialStateBool == false,
                      fadeInAnimationController: _cloudFadeInController,
                      expansionAnimationController: _cloudExpansionController,
                      snggleFaceFadeInController: _snggleFaceFadeInController,
                      themeAssets: widget.themeAssets,
                    ),
                  ),
                  const Spacer(flex: 2),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: ActionButton(
                        recordingInProgressBool: recordingInProgressBool,
                        recordingFinishingBool: _actionButtonDisabledBool,
                        fadeOutAnimationController: _actionButtonFadeOutController,
                        themeAssets: widget.themeAssets,
                        onStartRecording: _startRecording,
                        onStopRecording: _stopRecording,
                      ),
                    ),
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
            IgnorePointer(
              ignoring: state is ReceiveTabResultState == false,
              child: DecodedMsgSection(
                backButtonFadeInController: _backButtonFadeInController,
                cloudBackgroundFadeInController: _cloudBackgroundFadeInController,
                msgFadeInController: _msgFadeInController,
                brokenMessageIndexList: _brokenMessageIndexList,
                decodedMessagePartList: _decodedMessagePartList,
                onBackButtonPressed: widget.receiveTabCubit.resetScreen,
                themeAssets: widget.themeAssets,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _requestMicPermission() async {
    Permission micPermission = Permission.microphone;
    if (await micPermission.isGranted == false) {
      PermissionStatus permissionStatus = await micPermission.request();
      return permissionStatus.isGranted;
    }
    return true;
  }

  Future<void> _showDeviceSelectionDialog(BuildContext context) async {
    await _fetchAudioDevices();
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          audioDeviceList.isEmpty ? 'No microphone detected - plug audio input device' : 'Select input device',
          style: const TextStyle(fontSize: 16),
        ),
        content: const DeviceSelector(),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDeviceInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('No microphone detected'),
        content: const Text(
          'In order to use this feature, you need plug audio input device',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showMicPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('No access to microphone'),
        content: const Text(
          'In order to use this feature, you need to allow the application to use the microphone in system settings.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              await openAppSettings();
              Navigator.of(context).pop();
            },
            child: const Text('Go to settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _startRecording() async {
    if (Platform.isWindows) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _fetchAudioDevices();
        if (audioDeviceList.isEmpty) {
          _showDeviceInfoDialog(context);
        } else {
          widget.receiveTabCubit.startRecording();
        }
      });
    } else {
      bool micPermissionGrantedBool = await _requestMicPermission();
      if (micPermissionGrantedBool) {
        widget.receiveTabCubit.startRecording();
      } else {
        _showMicPermissionDialog(context);
      }
    }
  }

  Future<void> _fetchAudioDevices() async {
    if (mounted == false) {
      return;
    }
    audioDeviceList = await Audio.enumDevices(AudioDeviceType.input) ?? <AudioDevice>[];
  }

  void _stopRecording() {
    setState(() {
      _actionButtonDisabledBool = true;
    });
    widget.receiveTabCubit.stopRecording();
  }

  void _initAnimationControllers() {
    Duration animationDuration = const Duration(seconds: 1);
    _cloudFadeInController = AnimationController(vsync: this, duration: animationDuration);
    _cloudExpansionController = AnimationController(vsync: this, duration: animationDuration);
    _cloudBackgroundFadeInController = AnimationController(vsync: this, duration: animationDuration);
    _actionButtonFadeOutController = AnimationController(vsync: this, duration: animationDuration);
    _settingsButtonFadeOutController = AnimationController(vsync: this, duration: animationDuration);
    _snggleFaceFadeInController = AnimationController(vsync: this, duration: animationDuration);
    _msgFadeInController = AnimationController(vsync: this, duration: animationDuration);
    _backButtonFadeInController = AnimationController(vsync: this, duration: animationDuration);
  }

  Future<void> _animate(BuildContext context, AReceiveTabState state) async {
    if (state is ReceiveTabEmptyState) {
      await _snggleFaceFadeInController.reverse();
      await Future.wait(<TickerFuture>[
        _backButtonFadeInController.reverse(),
        _msgFadeInController.reverse(),
        _cloudFadeInController.reverse(),
        _cloudBackgroundFadeInController.reverse(),
      ]);
      setState(() {
        _actionButtonDisabledBool = false;
      });
      await Future.wait(<TickerFuture>[
        _actionButtonFadeOutController.reverse(),
        _cloudFadeInController.forward(),
        _settingsButtonFadeOutController.reverse(),
      ]);
    }

    if (state is ReceiveTabRecordingState) {
      if (state.decodingBool) {
        await _snggleFaceFadeInController.forward();
      }
    }

    if (state is ReceiveTabResultState) {
      _decodedMessagePartList = state.decodedMessagePartList;
      _brokenMessageIndexList = state.brokenMessageIndexList;
      _actionButtonDisabledBool = true;

      await Future.wait(<TickerFuture>[
        _settingsButtonFadeOutController.forward(),
        _snggleFaceFadeInController.reverse(),
      ]);
      await Future.wait(<TickerFuture>[
        _cloudFadeInController.reverse(),
        _cloudExpansionController.forward(),
        _cloudBackgroundFadeInController.forward(),
        _actionButtonFadeOutController.forward(),
      ]);
      _actionButtonDisabledBool = false;
      await Future.wait(<TickerFuture>[
        _msgFadeInController.forward(),
        _backButtonFadeInController.forward(),
        _cloudExpansionController.reverse(),
      ]);
    }

    if (state is ReceiveTabFailedState) {
      _decodedMessagePartList = <String>['too much bad energy'];
      _brokenMessageIndexList = <int>[];
      _actionButtonDisabledBool = true;
      await _snggleFaceFadeInController.reverse();
      await Future.wait(<TickerFuture>[
        _cloudFadeInController.reverse(),
        _actionButtonFadeOutController.forward(),
      ]);
      _actionButtonDisabledBool = false;
      await Future.wait(<TickerFuture>[
        _msgFadeInController.forward(),
      ]);
      widget.receiveTabCubit.resetScreen();
    }
  }
}
