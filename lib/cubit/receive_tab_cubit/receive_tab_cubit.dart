import 'package:whisp/cubit/receive_tab_cubit/a_receive_tab_state.dart';
import 'package:whisp/cubit/receive_tab_cubit/states/receive_tab_empty_state.dart';
import 'package:whisp/cubit/receive_tab_cubit/states/receive_tab_failed_state.dart';
import 'package:whisp/cubit/receive_tab_cubit/states/receive_tab_recording_state.dart';
import 'package:whisp/cubit/receive_tab_cubit/states/receive_tab_result_state.dart';
import 'package:whisp/shared/audio_settings_mode.dart';
import 'package:whisp/shared/utils/app_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrumru/mrumru.dart';

class ReceiveTabCubit extends Cubit<AReceiveTabState> {
  AudioSettingsModel audioSettingsModel = AudioSettingsModel(
      frequencyGenerator: MusicalFrequencyGenerator(
    frequencies: MusicalFrequencies.pentatonicAMaj,
  ));
  late AudioDecoder _audioDecoder;
  bool _canceledByUserBool = false;

  ReceiveTabCubit() : super(const ReceiveTabEmptyState());

  void resetScreen() {
    emit(const ReceiveTabEmptyState());
  }

  void switchAudioType(AudioSettingsMode audioSettingsMode) {
    if (audioSettingsMode == AudioSettingsMode.rocket) {
      audioSettingsModel = AudioSettingsModel(frequencyGenerator: StandardFrequencyGenerator(subbandCount: 32));
    } else {
      audioSettingsModel = AudioSettingsModel(
          frequencyGenerator: MusicalFrequencyGenerator(
        frequencies: MusicalFrequencies.pentatonicAMaj,
      ));
    }
  }

  void startRecording() {
    try {
      _audioDecoder = AudioDecoder(
        audioSettingsModel: audioSettingsModel,
        onMetadataFrameReceived: _handleMetadataFrameReceived,
        onDataFrameReceived: _handleDataFrameReceived,
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
      List<String> decodedMessageParts = frameCollectionModel.getMessageParts();
      emit(ReceiveTabResultState(
        decodedMessageParts: decodedMessageParts,
        brokenMessageIndexes: frameCollectionModel.getBrokenDataFrameIndexes(),
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

  void _handleDataFrameReceived(DataFrameModel dataFrameModel) {}
}
