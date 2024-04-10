part of 'network_cubit.dart';

@freezed
class NetworkState with _$NetworkState {
  const factory NetworkState({required NetworkStatus status}) = _NetworkState;
  
  factory NetworkState.initial() {
    return const NetworkState(status: NetworkStatus.disconnected);
  }
}
