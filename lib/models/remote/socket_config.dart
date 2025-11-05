class SocketConfig {
  SocketConfig({required this.privateChannels, this.presenceChannels});

  final Map<String, List<String>> privateChannels;
  final Map<String, List<String>>? presenceChannels;
}
