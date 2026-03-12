import 'package:flutter/material.dart';

/// 根据路径返回合适的 ImageProvider：
/// - 本地资源（assets/...）用 AssetImage
/// - 远程 URL（http/https）用 NetworkImage
ImageProvider getImageProvider(String path) {
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return NetworkImage(path);
  }
  return AssetImage(path);
}
