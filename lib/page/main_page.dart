import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisp/cubit/receive_tab_cubit/a_receive_tab_state.dart';
import 'package:whisp/cubit/receive_tab_cubit/receive_tab_cubit.dart';
import 'package:whisp/cubit/receive_tab_cubit/states/receive_tab_failed_state.dart';
import 'package:whisp/cubit/receive_tab_cubit/states/receive_tab_recording_state.dart';
import 'package:whisp/cubit/theme_cubit/a_theme_state.dart';
import 'package:whisp/cubit/theme_cubit/theme_cubit.dart';
import 'package:whisp/page/receive_tab.dart';
import 'package:whisp/shared/audio_settings_mode.dart';
import 'package:whisp/widgets/outlined_icon.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ReceiveTabCubit _receiveTabCubit = ReceiveTabCubit();
  final ThemeCubit _themeCubit = ThemeCubit();

  bool _iconsDisabledBool = false;
  AudioSettingsMode _selectedSettingsMode = AudioSettingsMode.musical;
  late PageController _pageController;
  late final StreamSubscription<AReceiveTabState> _receiveSub;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _receiveSub = _receiveTabCubit.stream.listen((AReceiveTabState state) => _toggleIcons());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _receiveTabCubit.close();
    _receiveSub.cancel();
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
                  child: ReceiveTab(
                    receiveTabCubit: _receiveTabCubit,
                    themeAssets: state.themeAssets,
                  ),
                ),
                SafeArea(
                  child: Opacity(
                    opacity: _iconsDisabledBool ? 0.5 : 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Spacer(flex: 5),
                          Expanded(
                            flex: 1,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: IconButton(
                                icon: OutlinedIcon(
                                  icon: _selectedSettingsMode == AudioSettingsMode.musical ? Icons.music_note : Icons.rocket_launch,
                                  outlineColor: Colors.black,
                                  fillColor: state.themeAssets.primaryColor,
                                  outlineWidth: 4,
                                  size: 40,
                                ),
                                onPressed: _iconsDisabledBool ? null : _handleSettingsSwitched,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: IconButton(
                                icon: state.themeAssets.themeChangeIcon,
                                onPressed: _iconsDisabledBool ? null : _themeCubit.switchTheme,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
  }

  void _toggleIcons() {
    setState(() {
      _iconsDisabledBool = _receiveTabCubit.state is ReceiveTabRecordingState || _receiveTabCubit.state is ReceiveTabFailedState;
    });
  }
}
