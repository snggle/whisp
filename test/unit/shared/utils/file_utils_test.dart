import 'package:flutter_test/flutter_test.dart';
import 'package:whisp/shared/utils/file_utils.dart';

void main() {
  group('Tests of FileUtils.fixFileNameCounter()', () {
    test('Should [move the number] before the extension', () async {
      // Act
      String actualFixedPath = await FileUtils.fixFileNameCounter('test/generated-sound.wav (1)', <String>[]);

      // Assert
      String expectedFixedPath = 'test/generated-sound (1).wav';

      expect(actualFixedPath, expectedFixedPath);
    });

    test('Should [move the number] before the extension and [increment it], if the [name already exists]', () async {
      // Act
      String actualFixedPath = await FileUtils.fixFileNameCounter('test/generated-sound.wav (1)', <String>[
        'generated-sound.wav',
        'generated-sound (1).wav',
        'generated-sound (2).wav',
      ]);

      // Assert
      String expectedFixedPath = 'test/generated-sound (3).wav';

      expect(actualFixedPath, expectedFixedPath);
    });

    test('Should [move the suffix] before the extension', () async {
      // Act
      String actualFixedPath = await FileUtils.fixFileNameCounter('test/generated-sound.wavaaa', <String>[]);

      // Assert
      String expectedFixedPath = 'test/generated-soundaaa.wav';

      expect(actualFixedPath, expectedFixedPath);
    });

    test('Should [add the missing .wav] extension', () async {
      // Act
      String actualFixedPath = await FileUtils.fixFileNameCounter('test/generated-sound', <String>[]);

      // Assert
      String expectedFixedPath = 'test/generated-sound.wav';

      expect(actualFixedPath, expectedFixedPath);
    });

    test('Should [do nothing] if [name correct]', () async {
      // Act
      String actualFixedPath = await FileUtils.fixFileNameCounter('test/generated-sound.wav', <String>[]);

      // Assert
      String expectedFixedPath = 'test/generated-sound.wav';

      expect(actualFixedPath, expectedFixedPath);
    });
  });
}
