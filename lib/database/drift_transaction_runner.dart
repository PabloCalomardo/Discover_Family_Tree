import 'package:family_history/database/database.dart';
import 'package:family_history/services/transaction_runner.dart';

final class DriftTransactionRunner implements TransactionRunner {
  const DriftTransactionRunner(this._database);
  final AppDatabase _database;

  @override
  Future<T> run<T>(Future<T> Function() action) =>
      _database.transaction(action);
}
