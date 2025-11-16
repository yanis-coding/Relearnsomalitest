import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:flutter_sound/flutter_sound.dart';

class AudioService {
  final Record _recorder = Record();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isRecorderInitialized = false;
  bool _isPlayerInitialized = false;
  String? _recordingPath;

  Future<void> initialize() async {
    if (!_isRecorderInitialized) {
      await _recorder.hasPermission();
      _isRecorderInitialized = true;
    }
    
    if (!_isPlayerInitialized) {
      await _player.openPlayer();
      _isPlayerInitialized = true;
    }
  }

  Future<void> startRecording() async {
    if (!_isRecorderInitialized) {
      await initialize();
    }

    final directory = await getTemporaryDirectory();
    _recordingPath = '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';
    
    await _recorder.start(
      path: _recordingPath,
      encoder: AudioEncoder.aacLc,
      bitRate: 128000,
      samplingRate: 44100,
    );
  }

  Future<String?> stopRecording() async {
    if (!_isRecorderInitialized || !await _recorder.isRecording()) {
      return null;
    }
    
    await _recorder.stop();
    return _recordingPath;
  }

  Future<void> playAudio(String path) async {
    if (!_isPlayerInitialized) {
      await initialize();
    }
    
    await _player.startPlayer(
      fromURI: path,
      whenFinished: () {
        debugPrint('Audio playback completed');
      },
    );
  }

  Future<void> stopPlayback() async {
    if (_isPlayerInitialized && _player.isPlaying) {
      await _player.stopPlayer();
    }
  }

  Future<String?> getAudioAsBase64() async {
    if (_recordingPath == null) return null;
    
    final file = File(_recordingPath!);
    if (!await file.exists()) return null;
    
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> dispose() async {
    if (_isRecorderInitialized) {
      await _recorder.dispose();
      _isRecorderInitialized = false;
    }
    
    if (_isPlayerInitialized) {
      await _player.closePlayer();
      _isPlayerInitialized = false;
    }
  }
}
