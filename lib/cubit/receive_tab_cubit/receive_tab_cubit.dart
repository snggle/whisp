import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrumru/mrumru.dart';
import 'package:whisp/cubit/receive_tab_cubit/a_receive_tab_state.dart';
import 'package:whisp/cubit/receive_tab_cubit/states/receive_tab_empty_state.dart';
import 'package:whisp/cubit/receive_tab_cubit/states/receive_tab_failed_state.dart';
import 'package:whisp/cubit/receive_tab_cubit/states/receive_tab_recording_state.dart';
import 'package:whisp/cubit/receive_tab_cubit/states/receive_tab_result_state.dart';
import 'package:whisp/shared/audio_settings_mode.dart';
import 'package:whisp/shared/utils/logger/app_logger.dart';

class ReceiveTabCubit extends Cubit<AReceiveTabState> {
  AudioSettingsModel _audioSettingsModel = AudioSettingsModel(
    frequencyGenerator: MusicalFrequencyGenerator(
      frequencies: MusicalFrequencies.fdm9FullScaleAMaj,
    ),
  );
  late AudioDecoder _audioDecoder;
  bool _canceledByUserBool = false;

  ReceiveTabCubit() : super(const ReceiveTabEmptyState());

  void resetScreen() {
    emit(const ReceiveTabEmptyState());
  }

  void switchAudioType(AudioSettingsMode audioSettingsMode) {
    if (audioSettingsMode == AudioSettingsMode.rocket) {
      _audioSettingsModel = AudioSettingsModel(frequencyGenerator: StandardFrequencyGenerator(subbandCount: 32));
    } else {
      _audioSettingsModel = AudioSettingsModel(
        frequencyGenerator: MusicalFrequencyGenerator(
          frequencies: MusicalFrequencies.fdm9FullScaleAMaj,
        ),
      );
    }
  }

  void startRecording() {
    try {
      _audioDecoder = AudioDecoder(
        audioSettingsModel: _audioSettingsModel,
        onMetadataFrameReceived: _handleMetadataFrameReceived,
        onDecodingCompleted: _handleDecodingCompleted,
        onDecodingFailed: _handleDecodingFailed,
      );
      emit(const ReceiveTabRecordingState());
      _audioDecoder.startRecording();
    } catch (e) {
      AppLogger().log(message: 'Cannot start recording: $e');
      emit(const ReceiveTabEmptyState());
    }
  }

  void stopRecording() {
    _canceledByUserBool = true;
    emit(const ReceiveTabEmptyState());
    _audioDecoder.cancelRecording();
  }

  void _handleDecodingCompleted(FrameCollectionModel frameCollectionModel) {
    if (_canceledByUserBool == false) {
      List<String> decodedMessagePartList = frameCollectionModel.getMessageParts();
      emit(ReceiveTabResultState(
        decodedMessagePartList: decodedMessagePartList,
        brokenMessageIndexList: frameCollectionModel.getBrokenDataFrameIndexes(),
      ));
    }
    _canceledByUserBool = false;
  }

  void _handleDecodingFailed() {
    emit(const ReceiveTabFailedState());
  }

  void _handleMetadataFrameReceived(MetadataFrameModel metadataFrameModel) {
    emit(const ReceiveTabRecordingState(decodingBool: true));
  }
}
