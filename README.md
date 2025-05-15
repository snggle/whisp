# Whisp
Demo application for Audio protocol

## Installation
Use git clone to download [Whisp](https://github.com/snggle/whisp) project.
```bash
git clone git@github.com:snggle/whisp.git
```

## Usage
The project runs on flutter version **3.16.9**. You can use [fvm](https://fvm.app/docs/getting_started/installation)
for easy switching between versions
```bash
# Install and use required flutter version
fvm install 3.16.9
fvm use 3.16.9

# Install required packages in pubspec.yaml
fvm flutter pub get

# Run project
fvm flutter run lib/main.dart
```

To generate config files use
```bash
fvm flutter pub run build_runner
```
```bash
# Built-in Commands 
# - build: Runs a single build and exits.
# - watch: Runs a persistent build server that watches the files system for edits and does rebuilds as necessary
# - serve: Same as watch, but runs a development server as well

# Command Line Options
# --delete-conflicting-outputs: Assume conflicting outputs in the users package are from previous builds, and skip the user prompt that would usually be provided.
# 
# Command example:

fvm flutter pub run build_runner watch --delete-conflicting-outputs
```

## Contributing
Pull requests are welcomed. For major changes, please open an issue first, to enable a discussion on what you would like to improve. Please make sure to provide and update tests as well.

## [Licence](./LICENSE.md)

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
