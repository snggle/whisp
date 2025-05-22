import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:win32audio/win32audio.dart';

class DeviceSelector extends StatefulWidget {
  const DeviceSelector({super.key});

  @override
  State<DeviceSelector> createState() => _DeviceSelectorState();
}

Map<String, Uint8List?> _audioIcons = <String, Uint8List?>{};

class _DeviceSelectorState extends State<DeviceSelector> {
  AudioDevice defaultDevice = AudioDevice();
  List<AudioDevice> audioDevices = <AudioDevice>[];

  double __volume = 0.0;
  String fetchStatus = '';

  @override
  void initState() {
    super.initState();
    Audio.addChangeListener((String type, String id) async {
      print(type);
      print(id);
    });
    fetchAudioDevices();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchAudioDevices() async {
    if (!mounted) {
      return;
    }
    audioDevices =
        await Audio.enumDevices(AudioDeviceType.input) ?? <AudioDevice>[];
    __volume = await Audio.getVolume(AudioDeviceType.input);
    defaultDevice = (await Audio.getDefaultDevice(AudioDeviceType.input))!;

    _audioIcons = <String, Uint8List>{};
    for (AudioDevice audioDevice in audioDevices) {
      if (_audioIcons[audioDevice.id] == null) {
        _audioIcons[audioDevice.id] = await WinIcons()
            .extractFileIcon(audioDevice.iconPath, iconID: audioDevice.iconID);
      }
    }

    setState(() {
      fetchStatus = 'Get';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Center(
              child: Text(
                'Volume: ${(__volume * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Slider(
              value: __volume,
              min: 0,
              max: 1,
              divisions: 25,
              onChanged: (double e) async {
                await Audio.setVolume(e.toDouble(), AudioDeviceType.input);
                __volume = e;
                setState(() {});
              },
            ),
          ),
          Flexible(
              flex: 3,
              fit: FlexFit.loose,
              child: ListView.builder(
                  itemCount: audioDevices.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: (_audioIcons.containsKey(audioDevices[index].id))
                          ? Image.memory(
                              _audioIcons[audioDevices[index].id] ??
                                  Uint8List(0),
                              width: 32,
                              height: 32,
                              gaplessPlayback: true,
                            )
                          : const Icon(Icons.spoke_outlined),
                      title: Text(audioDevices[index].name),
                      trailing: IconButton(
                        icon: Icon(audioDevices[index].isActive == true
                            ? Icons.check_box_outlined
                            : Icons.check_box_outline_blank),
                        onPressed: () async {
                          await Audio.setDefaultDevice(audioDevices[index].id);
                          await fetchAudioDevices();
                          setState(() {});
                        },
                      ),
                    );
                  })),
          const Divider(
            thickness: 5,
            height: 10,
            color: Color.fromARGB(12, 0, 0, 0),
          ),
        ],
      ),
    );
  }
}
