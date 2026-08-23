enum ConflictResolutionPolicy {
  clientWins,
  serverWins,
  manualReview,
}

class ConflictResolutionMatrix {
  const ConflictResolutionMatrix._();

  static ConflictResolutionPolicy policyFor({
    required String feature,
    required String operation,
  }) {
    if (feature == 'attendance' && operation == 'checkin') {
      return ConflictResolutionPolicy.serverWins;
    }

    if (feature == 'visits' && operation == 'record') {
      return ConflictResolutionPolicy.serverWins;
    }

    return ConflictResolutionPolicy.manualReview;
  }
}
