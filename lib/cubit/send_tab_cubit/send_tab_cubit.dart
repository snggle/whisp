import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrumru/mrumru.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whisp/cubit/send_tab_cubit/a_send_tab_state.dart';
import 'package:whisp/cubit/send_tab_cubit/states/send_tab_emitting_state.dart';
import 'package:whisp/cubit/send_tab_cubit/states/send_tab_empty_state.dart';
import 'package:whisp/shared/audio_settings_mode.dart';
import 'package:whisp/shared/utils/file_utils.dart';

class SendTabCubit extends Cubit<ASendTabState> {
  late final AudioGenerator _audioGenerator;
  late AudioSettingsModel audioSettingsModel = AudioSettingsModel(
    frequencyGenerator: MusicalFrequencyGenerator(
      frequencies: MusicalFrequencies.fdm9FullScaleAMaj,
    ),
  );

  SendTabCubit() : super(SendTabEmptyState()) {
    _audioGenerator = AudioGenerator(onGenerationCompleted: () {
      emit(SendTabEmptyState());
    });
  }

  void switchAudioType(AudioSettingsMode audioSettingsMode) {
    if (audioSettingsMode == AudioSettingsMode.rocket) {
      audioSettingsModel = AudioSettingsModel(frequencyGenerator: StandardFrequencyGenerator(subbandCount: 32));
    } else {
      audioSettingsModel = AudioSettingsModel(
        frequencyGenerator: MusicalFrequencyGenerator(
          frequencies: MusicalFrequencies.fdm9FullScaleAMaj,
        ),
      );
    }
  }

  Future<void> playSound(String text) async {
    Uint8List textBytes = utf8.encode(text);
    await _audioGenerator.startGenerating(AudioGeneratorParams(
      audioSettingsModel: audioSettingsModel,
      bytes: textBytes,
      audioSinkArgs: StreamAudioSinkArgs(),
    ));
    emit(SendTabEmittingState());
  }

  void stopSound() {
    _audioGenerator.cancelGenerating();
  }

  Future<void> saveFile(String text) async {
    String? outputPath = await FilePicker.platform.saveFile(
      allowedExtensions: <String>['wav'],
      type: FileType.audio,
      dialogTitle: 'save file',
      fileName: 'generated-sound.wav',
      // For mobile platforms, the file_picker's saveFile() actually saves the file.
      // For desktop platforms (Linux, macOS & Windows), this function does not actually
      // save a file. It only opens the dialog to let the user choose a location and
      // file name. This function only returns the **path** to this (non-existing) file.
      // Since FileAudioSink handles saving the files in both cases,
      // creating a temporary empty file is needed for Android.
      bytes: Platform.isWindows ? null : Uint8List(0),
    );
    if (outputPath == null) {
      return;
    }
    await _deleteTemporaryFile(outputPath);

    if (outputPath.toLowerCase().endsWith('.wav') == false) {
      String directoryPath = p.dirname(outputPath);
      Directory directory = Directory(directoryPath);
      List<FileSystemEntity> files = await directory.list().toList();
      List<String> existingFileNamesList = files.map((FileSystemEntity fileSystemEntity) => p.basename(fileSystemEntity.path)).toList();
      outputPath = await FileUtils.fixFileNameCounter(outputPath, existingFileNamesList);
    }

    await _writeFile(text, outputPath);
  }

  Future<void> shareFile(String text) async {
    Directory tempDir = await getTemporaryDirectory();

    Uint8List textBytes = utf8.encode(text);
    String filePath = '${tempDir.path}/generated_audio_message.wav';
    File wavFile = File(filePath);
    await _audioGenerator.startGenerating(AudioGeneratorParams(
      audioSettingsModel: audioSettingsModel,
      bytes: textBytes,
      audioSinkArgs: FileAudioSinkArgs(file: wavFile),
    ));

    await _audioGenerator.future;
    XFile xWavFile = XFile(filePath);
    await Share.shareXFiles(<XFile>[xWavFile], text: 'Share');

    Future<void>.delayed(const Duration(seconds: 5), () {
      File file = File(filePath);
      if (file.existsSync()) {
        file.deleteSync();
      }
    });
  }

  Future<void> _deleteTemporaryFile(String outputPath) async {
    File temp = File(outputPath);
    try {
      if (await temp.exists() && (await temp.length()) == 0) {
        await temp.delete();
      }
    } catch (_) {}
  }

  Future<void> _writeFile(String text, String outputPath) async {
    Uint8List bytes = Uint8List.fromList(utf8.encode(text));
    File sinkFile = File(outputPath);

    await _audioGenerator.startGenerating(AudioGeneratorParams(
      audioSettingsModel: audioSettingsModel,
      bytes: bytes,
      audioSinkArgs: FileAudioSinkArgs(file: sinkFile),
    ));
  }
}
