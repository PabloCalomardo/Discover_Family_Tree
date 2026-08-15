import 'package:family_history/core/ids/domain_id.dart';
import 'package:family_history/domain/relationship/partnership.dart';

abstract interface class PartnershipRepository {
  Stream<List<Partnership>> watchAll();
  Future<void> create(Partnership partnership);
  Future<void> update(Partnership partnership);
  Future<void> delete(PartnershipId id);
}
