extension OnFuture<T> on T {
  Future<T> toFuture() => Future.value(this);
}