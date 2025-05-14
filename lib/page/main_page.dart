import 'dart:async';

import 'package:whisp/cubit/receive_tab_cubit/a_receive_tab_state.dart';
import 'package:whisp/cubit/receive_tab_cubit/receive_tab_cubit.dart';
import 'package:whisp/cubit/receive_tab_cubit/states/receive_tab_recording_state.dart';
import 'package:whisp/cubit/send_tab_cubit/a_send_tab_state.dart';
import 'package:whisp/cubit/send_tab_cubit/send_tab_cubit.dart';
import 'package:whisp/cubit/send_tab_cubit/states/send_tab_emitting_state.dart';
import 'package:whisp/cubit/theme_cubit/a_theme_state.dart';
import 'package:whisp/cubit/theme_cubit/theme_cubit.dart';
import 'package:whisp/page/receive_tab.dart';
import 'package:whisp/page/send_tab.dart';
import 'package:whisp/shared/audio_settings_mode.dart';
import 'package:whisp/widgets/outlined_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  final ReceiveTabCubit _receiveTabCubit = ReceiveTabCubit();
  final SendTabCubit _sendTabCubit = SendTabCubit();
  final ThemeCubit _themeCubit = ThemeCubit();
  final TextEditingController _messageTextController = TextEditingController();

  bool _transferModeBool = false;
  AudioSettingsMode _selectedSettingsMode = AudioSettingsMode.musical;
  int _currentPage = 0;
  late PageController _pageController;
  late final StreamSubscription<AReceiveTabState> _receiveSub;
  late final StreamSubscription<ASendTabState> _sendSub;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _receiveSub = _receiveTabCubit.stream.listen((AReceiveTabState state) => _toggleIcons());
    _sendSub = _sendTabCubit.stream.listen((ASendTabState state) => _toggleIcons());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _receiveTabCubit.close();
    _receiveSub.cancel();
    _sendSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AThemeState>(
        bloc: _themeCubit,
        builder: (BuildContext context, AThemeState state) {
          return Scaffold(
            backgroundColor: state.themeAssets.backgroundColor,
            body: Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (int index) {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        int previousPage = _currentPage;
                        _currentPage = index;
                        if (previousPage == 0 && _currentPage != 0 && _receiveTabCubit.state is ReceiveTabRecordingState) {
                          _receiveTabCubit.stopRecording();
                        }
                      });
                    },
                    children: <Widget>[
                      ReceiveTab(
                        receiveTabCubit: _receiveTabCubit,
                        themeAssets: state.themeAssets,
                      ),
                      SendTab(
                        sendTabCubit: _sendTabCubit,
                        messageTextController: _messageTextController,
                        themeAssets: state.themeAssets,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 55,
                  child: Opacity(
                    opacity: _transferModeBool ? 0.5 : 1,
                    child: IconButton(
                      icon: state.themeAssets.themeChangeIcon,
                      onPressed: _transferModeBool ? null : _themeCubit.switchTheme,
                    ),
                  ),
                ),
                Positioned(
                  right: 60,
                  top: 55,
                  child: Opacity(
                    opacity: _transferModeBool ? 0.5 : 1,
                    child: IconButton(
                        icon: OutlinedIcon(
                          icon: _selectedSettingsMode == AudioSettingsMode.musical ? Icons.music_note : Icons.rocket_launch,
                          outlineColor: Colors.black,
                          fillColor: state.themeAssets.primaryColor,
                          outlineWidth: 4,
                          size: 35,
                        ),
                        onPressed: _transferModeBool ? null : _handleSettingsSwitched),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.92,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(2, (int index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: _currentPage == index ? 16 : 11,
                          height: _currentPage == index ? 16 : 11,
                          decoration: BoxDecoration(
                            color: _currentPage == index ? state.themeAssets.primaryColor : Colors.black.withOpacity(0.3),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                        );
                      }),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  void _handleSettingsSwitched() {
    setState(() {
      int nextIndex = (_selectedSettingsMode.index + 1) % AudioSettingsMode.values.length;
      _selectedSettingsMode = AudioSettingsMode.values[nextIndex];
    });

    _receiveTabCubit.switchAudioType(_selectedSettingsMode);
    _sendTabCubit.switchAudioType(_selectedSettingsMode);
  }

  void _toggleIcons() {
    setState(() {
      _transferModeBool = _receiveTabCubit.state is ReceiveTabRecordingState || _sendTabCubit.state is SendTabEmittingState;
    });
  }
}
