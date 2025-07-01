import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whisp/cubit/send_tab_cubit/a_send_tab_state.dart';
import 'package:whisp/cubit/send_tab_cubit/send_tab_cubit.dart';
import 'package:whisp/cubit/send_tab_cubit/states/send_tab_emitting_state.dart';
import 'package:whisp/cubit/theme_cubit/theme_assets.dart';
import 'package:whisp/widgets/buttons_panel.dart';
import 'package:whisp/widgets/custom_app_bar.dart';
import 'package:whisp/widgets/message_form/message_form.dart';
import 'package:whisp/widgets/tab_layout.dart';

class SendTab extends StatefulWidget {
  final SendTabCubit sendTabCubit;
  final TextEditingController messageTextController;
  final ThemeAssets themeAssets;

  const SendTab({
    required this.sendTabCubit,
    required this.messageTextController,
    required this.themeAssets,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SendTabState();
}

class _SendTabState extends State<SendTab> {
  bool _showPlaceholderBool = true;
  bool _msgEmptyBool = true;

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _showPlaceholderBool = widget.messageTextController.text.isEmpty;
    _msgEmptyBool = widget.messageTextController.text.isEmpty;
    widget.messageTextController.addListener(_handleTextControllerChange);
    _focusNode = FocusNode();
    _focusNode.addListener(_updatePlaceholderVisibility);
  }

  @override
  void dispose() {
    widget.messageTextController.removeListener(_handleTextControllerChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendTabCubit, ASendTabState>(
      bloc: widget.sendTabCubit,
      builder: (BuildContext context, ASendTabState state) {
        bool emissionInProgressBool = state is SendTabEmittingState;
        bool buttonsDisabledBool = emissionInProgressBool || _msgEmptyBool;
        return TabLayout(
          customAppBar: const CustomAppBar(),
          topWidget: MessageForm(
            clearButtonDisabledBool: buttonsDisabledBool,
            emissionInProgressBool: emissionInProgressBool,
            showPlaceholderBool: _showPlaceholderBool,
            focusNode: _focusNode,
            themeAssets: widget.themeAssets,
            messageTextController: widget.messageTextController,
            onClearButtonPressed: _clearMessage,
          ),
          bottomWidget: ButtonsPanel(
            emissionInProgressBool: emissionInProgressBool,
            msgEmptyBool: _msgEmptyBool,
            themeAssets: widget.themeAssets,
            onSaveButtonPressed: _saveFile,
            onPlayButtonPressed: () => widget.sendTabCubit.playSound(widget.messageTextController.text),
            onStopButtonPressed: widget.sendTabCubit.stopSound,
            onShareButtonPressed: () => widget.sendTabCubit.shareFile(widget.messageTextController.text),
          ),
        );
      },
    );
  }

  void _clearMessage() {
    widget.messageTextController.clear();
    setState(() {
      _msgEmptyBool = true;
    });
  }

  void _handleTextControllerChange() {
    bool msgEmptyBool = widget.messageTextController.text.isEmpty;
    if (msgEmptyBool != _msgEmptyBool) {
      setState(() {
        _msgEmptyBool = msgEmptyBool;
      });
    }
    _updatePlaceholderVisibility();
  }

  void _updatePlaceholderVisibility() {
    bool msgEmptyBool = widget.messageTextController.text.isEmpty;
    setState(() {
      _showPlaceholderBool = _focusNode.hasFocus == false && msgEmptyBool;
    });
  }

  Future<void> _saveFile() async {
    if (Platform.isAndroid) {
      Permission storagePermission = Permission.manageExternalStorage;
      if (await storagePermission.isGranted) {
        await widget.sendTabCubit.saveFile(widget.messageTextController.text);
      } else {
        _showStoragePermissionDialog(context);
      }
    } else {
      await widget.sendTabCubit.saveFile(widget.messageTextController.text);
    }
  }

  void _showStoragePermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'No access to files',
          overflow: TextOverflow.ellipsis,
        ),
        content: const Text(
          'In order to use this feature, you need to allow the application to access files in system settings.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _requestStoragePermission();
              Navigator.of(context).pop();
            },
            child: const Text('Go to settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _requestStoragePermission() async {
    Permission storagePermission = Permission.manageExternalStorage;
    if (await storagePermission.isGranted == false) {
      await storagePermission.request();
    }
  }
}
