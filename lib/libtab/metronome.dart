class MetronomeConfig {
  final int bpm;
  final bool enabled;
  final bool muted;
  final bool paused;

  MetronomeConfig(
      {this.bpm = 25,
      this.enabled = true,
      this.muted = false,
      this.paused = false});
}
