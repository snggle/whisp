import 'package:whisp/cubit/send_tab_cubit/a_send_tab_state.dart';
import 'package:whisp/cubit/send_tab_cubit/send_tab_cubit.dart';
import 'package:whisp/cubit/send_tab_cubit/states/send_tab_emitting_state.dart';
import 'package:whisp/cubit/theme_cubit/theme_assets.dart';
import 'package:whisp/widgets/send_tab/buttons_panel.dart';
import 'package:whisp/widgets/send_tab/message_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    _focusNode.addListener(_handleFocusNodeChange);
  }

  @override
  void dispose() {
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
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              MessageForm(
                clearButtonDisabledBool: buttonsDisabledBool,
                emissionInProgressBool: emissionInProgressBool,
                showPlaceholderBool: _showPlaceholderBool,
                focusNode: _focusNode,
                themeAssets: widget.themeAssets,
                messageTextController: widget.messageTextController,
                onClearButtonPressed: _clearMessage,
              ),
              const SizedBox(height: 160),
              ButtonsPanel(
                emissionInProgressBool: emissionInProgressBool,
                msgEmptyBool: _msgEmptyBool,
                themeAssets: widget.themeAssets,
                onSaveButtonPressed: () => widget.sendTabCubit.saveFile(widget.messageTextController.text),
                onPlayButtonPressed: () => widget.sendTabCubit.playSound(widget.messageTextController.text),
                onStopButtonPressed: widget.sendTabCubit.stopSound,
                onShareButtonPressed: () => widget.sendTabCubit.shareFile(widget.messageTextController.text),
              ),
            ],
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

  void _handleFocusNodeChange() {
    _updatePlaceholderVisibility();
  }

  void _updatePlaceholderVisibility() {
    bool msgEmptyBool = widget.messageTextController.text.isEmpty;
    setState(() {
      _showPlaceholderBool = _focusNode.hasFocus == false && msgEmptyBool;
    });
  }
}
