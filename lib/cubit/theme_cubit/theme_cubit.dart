import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisp/cubit/theme_cubit/a_theme_state.dart';
import 'package:whisp/cubit/theme_cubit/states/theme_dark_state.dart';
import 'package:whisp/cubit/theme_cubit/states/theme_light_state.dart';

class ThemeCubit extends Cubit<AThemeState> {
  ThemeCubit() : super(ThemeLightState());

  void switchTheme() {
    if (state is ThemeLightState) {
      emit(ThemeDarkState());
    } else {
      emit(ThemeLightState());
    }
  }
}
