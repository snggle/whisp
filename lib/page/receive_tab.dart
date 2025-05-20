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
import 'package:whisp/page/device_selector_drawer.dart';
import 'package:whisp/widgets/outlined_icon.dart';
import 'package:whisp/widgets/receive_tab/action_button.dart';
import 'package:whisp/widgets/receive_tab/cartoon_cloud.dart';
import 'package:whisp/widgets/receive_tab/custom_back_button.dart';
import 'package:whisp/widgets/receive_tab/decoded_msg.dart';
import 'package:whisp/widgets/receive_tab/decoded_msg_background.dart';

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

class _ReceiveTabState extends State<ReceiveTab>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late AnimationController _cloudFadeInController;
  late AnimationController _cloudExpansionController;
  late AnimationController _cloudBackgroundFadeInController;
  late AnimationController _buttonFadeOutController;
  late AnimationController _snggleFaceFadeInController;
  late AnimationController _msgFadeInController;
  late AnimationController _backButtonFadeInController;

  bool _buttonDisabledBool = false;
  List<int> _brokenMessageIndexes = <int>[];
  List<String>? _decodedMessageParts;

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
    _buttonFadeOutController.dispose();
    _cloudFadeInController.dispose();
    _cloudExpansionController.dispose();
    _cloudBackgroundFadeInController.dispose();
    _buttonFadeOutController.dispose();
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
            Positioned(
              top: 4,
              left: 10,
              child: IconButton(
                icon: OutlinedIcon(
                  icon: Icons.settings,
                  outlineColor: Colors.black,
                  fillColor: widget.themeAssets.primaryColor,
                  outlineWidth: 4,
                  size: 40,
                ),
                onPressed: () => _showDeviceSelectionDialog(context),
              ),
            ),
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: CartoonCloud(
                      recordingFinishingBool: _buttonDisabledBool,
                      cloudMovingBool:
                          _buttonDisabledBool || initialStateBool == false,
                      fadeInAnimationController: _cloudFadeInController,
                      expansionAnimationController: _cloudExpansionController,
                      snggleFaceFadeInController: _snggleFaceFadeInController,
                      themeAssets: widget.themeAssets,
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: ActionButton(
                        recordingInProgressBool: recordingInProgressBool,
                        recordingFinishingBool: _buttonDisabledBool,
                        fadeOutAnimationController: _buttonFadeOutController,
                        themeAssets: widget.themeAssets,
                        onStartRecording: _startRecording,
                        onStopRecording: _stopRecording,
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecodedMsgBackground(
                  fadeInAnimationController: _cloudBackgroundFadeInController,
                  themeAssets: widget.themeAssets,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                const SizedBox(height: 52),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: CustomBackButton(
                      fadeInAnimationController: _backButtonFadeInController,
                      color: widget.themeAssets.textColor,
                      onPopInvoked: state is ReceiveTabResultState
                          ? () => widget.receiveTabCubit.resetScreen()
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      child: DecodedMsg(
                        fadeInAnimationController: _msgFadeInController,
                        decodedMessageParts: _decodedMessageParts,
                        brokenMessageIndexes: _brokenMessageIndexes,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
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

  void _showDeviceSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Select device'),
        content: const DeviceSelectorDrawer(),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: const Text('Accept'),
          ),
        ],
      ),
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

  Future<void> _startRecording() async {
    bool micPermissionGrantedBool = await _requestMicPermission();
    if (micPermissionGrantedBool) {
      widget.receiveTabCubit.startRecording();
    } else {
      _showMicPermissionDialog(context);
    }
  }

  void _stopRecording() {
    setState(() {
      _buttonDisabledBool = true;
    });
    widget.receiveTabCubit.stopRecording();
  }

  void _initAnimationControllers() {
    Duration animationDuration = const Duration(seconds: 1);
    _cloudFadeInController =
        AnimationController(vsync: this, duration: animationDuration);
    _cloudExpansionController =
        AnimationController(vsync: this, duration: animationDuration);
    _cloudBackgroundFadeInController =
        AnimationController(vsync: this, duration: animationDuration);
    _buttonFadeOutController =
        AnimationController(vsync: this, duration: animationDuration);
    _snggleFaceFadeInController =
        AnimationController(vsync: this, duration: animationDuration);
    _msgFadeInController =
        AnimationController(vsync: this, duration: animationDuration);
    _backButtonFadeInController =
        AnimationController(vsync: this, duration: animationDuration);
  }

  Future<void> _animate(BuildContext context, AReceiveTabState state) async {
    if (state is ReceiveTabEmptyState) {
      await Future.wait(<TickerFuture>[
        _backButtonFadeInController.reverse(),
        _msgFadeInController.reverse(),
        _cloudFadeInController.reverse(),
        _cloudBackgroundFadeInController.reverse(),
      ]);
      setState(() {
        _buttonDisabledBool = false;
      });
      await Future.wait(<TickerFuture>[
        _buttonFadeOutController.reverse(),
        _cloudFadeInController.forward(),
      ]);
    }

    if (state is ReceiveTabRecordingState) {
      if (state.decodingBool) {
        await _snggleFaceFadeInController.forward();
      }
    }

    if (state is ReceiveTabResultState) {
      _decodedMessageParts = state.decodedMessageParts;
      _brokenMessageIndexes = state.brokenMessageIndexes;
      _buttonDisabledBool = true;
      await _snggleFaceFadeInController.reverse();
      await Future.wait(<TickerFuture>[
        _cloudFadeInController.reverse(),
        _cloudExpansionController.forward(),
        _cloudBackgroundFadeInController.forward(),
        _buttonFadeOutController.forward(),
      ]);
      _buttonDisabledBool = false;
      await Future.wait(<TickerFuture>[
        _msgFadeInController.forward(),
        _backButtonFadeInController.forward(),
        _cloudExpansionController.reverse(),
      ]);
    }

    if (state is ReceiveTabFailedState) {
      _decodedMessageParts = <String>['too much bad energy'];
      _brokenMessageIndexes = <int>[];
      _buttonDisabledBool = true;
      await _snggleFaceFadeInController.reverse();
      await Future.wait(<TickerFuture>[
        _cloudFadeInController.reverse(),
        _buttonFadeOutController.forward(),
      ]);
      _buttonDisabledBool = false;
      await Future.wait(<TickerFuture>[
        _msgFadeInController.forward(),
      ]);
      widget.receiveTabCubit.resetScreen();
    }
  }
}
