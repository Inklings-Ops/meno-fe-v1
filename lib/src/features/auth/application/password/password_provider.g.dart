// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$passwordRuleHash() => r'e78110c29554a6f18ccdf8e97a42f49977b81a80';

/// See also [passwordRule].
@ProviderFor(passwordRule)
final passwordRuleProvider = AutoDisposeProvider<PasswordRule>.internal(
  passwordRule,
  name: r'passwordRuleProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$passwordRuleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PasswordRuleRef = AutoDisposeProviderRef<PasswordRule>;
String _$passwordHash() => r'7830df5eef41b8cbfce813bb8fd07e1f751a2927';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [password].
@ProviderFor(password)
const passwordProvider = PasswordFamily();

/// See also [password].
class PasswordFamily extends Family<IPassword> {
  /// See also [password].
  const PasswordFamily();

  /// See also [password].
  PasswordProvider call(
    String input,
  ) {
    return PasswordProvider(
      input,
    );
  }

  @override
  PasswordProvider getProviderOverride(
    covariant PasswordProvider provider,
  ) {
    return call(
      provider.input,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'passwordProvider';
}

/// See also [password].
class PasswordProvider extends AutoDisposeProvider<IPassword> {
  /// See also [password].
  PasswordProvider(
    String input,
  ) : this._internal(
          (ref) => password(
            ref as PasswordRef,
            input,
          ),
          from: passwordProvider,
          name: r'passwordProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$passwordHash,
          dependencies: PasswordFamily._dependencies,
          allTransitiveDependencies: PasswordFamily._allTransitiveDependencies,
          input: input,
        );

  PasswordProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.input,
  }) : super.internal();

  final String input;

  @override
  Override overrideWith(
    IPassword Function(PasswordRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PasswordProvider._internal(
        (ref) => create(ref as PasswordRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        input: input,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<IPassword> createElement() {
    return _PasswordProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PasswordProvider && other.input == input;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, input.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PasswordRef on AutoDisposeProviderRef<IPassword> {
  /// The parameter `input` of this provider.
  String get input;
}

class _PasswordProviderElement extends AutoDisposeProviderElement<IPassword>
    with PasswordRef {
  _PasswordProviderElement(super.provider);

  @override
  String get input => (origin as PasswordProvider).input;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
