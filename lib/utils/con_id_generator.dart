String generateConId(String localUid, String remoteUid) {
  return localUid.hashCode <= remoteUid.hashCode
      ? localUid + '_' + remoteUid
      : remoteUid + '_' + localUid;
}
