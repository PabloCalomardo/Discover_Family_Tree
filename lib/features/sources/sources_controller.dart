import 'dart:io';

import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/source/media_asset.dart';
import 'package:family_history/domain/source/source.dart';
import 'package:family_history/services/source/source_service.dart';

final class SourcesController {
  const SourcesController(this._service);
  final SourceService _service;

  Future<void> create(Source source) => _service.create(source);
  Future<void> update(Source source) => _service.update(source);
  Future<void> delete(SourceId id) => _service.delete(id);
  Future<MediaAsset> attachFile({
    required SourceId sourceId,
    required File input,
    required Directory workspace,
    required MediaType type,
    SourceMediaRole role = SourceMediaRole.attachment,
    String? caption,
  }) => _service.attachFile(
    sourceId: sourceId,
    input: input,
    workspace: workspace,
    type: type,
    role: role,
    caption: caption,
  );
}
