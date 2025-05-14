import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:whisp/cubit/send_tab_cubit/a_send_tab_state.dart';
import 'package:whisp/cubit/send_tab_cubit/states/send_tab_emitting_state.dart';
import 'package:whisp/cubit/send_tab_cubit/states/send_tab_empty_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrumru/mrumru.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whisp/shared/audio_settings_mode.dart';

class SendTabCubit extends Cubit<ASendTabState> {
  late AudioSettingsModel audioSettingsModel = AudioSettingsModel(
      frequencyGenerator: MusicalFrequencyGenerator(
    frequencies: MusicalFrequencies.pentatonicAMaj,
  ));
  AudioGenerator? _audioGenerator;

  SendTabCubit() : super(SendTabEmptyState());

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

  Future<void> playSound(String text) async {
    Uint8List textBytes = utf8.encode(text);
    AudioStreamSink audioStreamSink = AudioStreamSink();
    emit(SendTabEmittingState());
    _audioGenerator = AudioGenerator(
      audioSink: audioStreamSink,
      audioSettingsModel: audioSettingsModel,
    );
    await _audioGenerator!.generate(textBytes);

    await audioStreamSink.future;

    emit(SendTabEmptyState());
  }

  void stopSound() {
    _audioGenerator?.stop();
    emit(SendTabEmptyState());
  }

  Future<void> saveFile(String text) async {
    String? outputFile = await FilePicker.platform.saveFile(
      allowedExtensions: <String>['wav'],
      type: FileType.audio,
      dialogTitle: 'save file',
      fileName: 'generated-sound.wav',
    );

    if (outputFile != null) {
      Uint8List textBytes = utf8.encode(text);
      File wavFile = File(outputFile);
      AudioFileSink audioFileSink = AudioFileSink(wavFile);
      emit(SendTabEmittingState());
      _audioGenerator = AudioGenerator(
        audioSink: audioFileSink,
        audioSettingsModel: audioSettingsModel,
      );
      unawaited(_audioGenerator?.generate(textBytes));

      await audioFileSink.future;

      emit(SendTabEmptyState());
    }
  }

  Future<void> shareFile(String text) async {
    Directory tempDir = await getTemporaryDirectory();

    Uint8List textBytes = utf8.encode(text);
    String filePath = '${tempDir.path}/generated_audio_message.wav';
    File wavFile = File(filePath);
    AudioFileSink audioFileSink = AudioFileSink(wavFile);
    _audioGenerator = AudioGenerator(
      audioSink: audioFileSink,
      audioSettingsModel: audioSettingsModel,
    );
    unawaited(_audioGenerator?.generate(textBytes));

    await audioFileSink.future;

    XFile xWavFile = XFile(filePath);
    await Share.shareXFiles(<XFile>[xWavFile], text: 'Share');

    Future<void>.delayed(const Duration(seconds: 5), () {
      final File file = File(filePath);
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    emit(SendTabEmptyState());
  }
}
