// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trigger.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TriggerState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool isAbove) ready,
    required TResult Function(int remainingSamples) postTrigger,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool isAbove)? ready,
    TResult? Function(int remainingSamples)? postTrigger,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool isAbove)? ready,
    TResult Function(int remainingSamples)? postTrigger,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TriggerStateReady value) ready,
    required TResult Function(_TriggerStatePostTrigger value) postTrigger,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_TriggerStateReady value)? ready,
    TResult? Function(_TriggerStatePostTrigger value)? postTrigger,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TriggerStateReady value)? ready,
    TResult Function(_TriggerStatePostTrigger value)? postTrigger,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$TriggerStateCopyWith<$Res> {
  factory _$TriggerStateCopyWith(
          _TriggerState value, $Res Function(_TriggerState) then) =
      __$TriggerStateCopyWithImpl<$Res, _TriggerState>;
}

/// @nodoc
class __$TriggerStateCopyWithImpl<$Res, $Val extends _TriggerState>
    implements _$TriggerStateCopyWith<$Res> {
  __$TriggerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$TriggerStateReadyImplCopyWith<$Res> {
  factory _$$TriggerStateReadyImplCopyWith(_$TriggerStateReadyImpl value,
          $Res Function(_$TriggerStateReadyImpl) then) =
      __$$TriggerStateReadyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool isAbove});
}

/// @nodoc
class __$$TriggerStateReadyImplCopyWithImpl<$Res>
    extends __$TriggerStateCopyWithImpl<$Res, _$TriggerStateReadyImpl>
    implements _$$TriggerStateReadyImplCopyWith<$Res> {
  __$$TriggerStateReadyImplCopyWithImpl(_$TriggerStateReadyImpl _value,
      $Res Function(_$TriggerStateReadyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isAbove = null,
  }) {
    return _then(_$TriggerStateReadyImpl(
      isAbove: null == isAbove
          ? _value.isAbove
          : isAbove // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$TriggerStateReadyImpl implements _TriggerStateReady {
  _$TriggerStateReadyImpl({required this.isAbove});

  @override
  final bool isAbove;

  @override
  String toString() {
    return '_TriggerState.ready(isAbove: $isAbove)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TriggerStateReadyImpl &&
            (identical(other.isAbove, isAbove) || other.isAbove == isAbove));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isAbove);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TriggerStateReadyImplCopyWith<_$TriggerStateReadyImpl> get copyWith =>
      __$$TriggerStateReadyImplCopyWithImpl<_$TriggerStateReadyImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool isAbove) ready,
    required TResult Function(int remainingSamples) postTrigger,
  }) {
    return ready(isAbove);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool isAbove)? ready,
    TResult? Function(int remainingSamples)? postTrigger,
  }) {
    return ready?.call(isAbove);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool isAbove)? ready,
    TResult Function(int remainingSamples)? postTrigger,
    required TResult orElse(),
  }) {
    if (ready != null) {
      return ready(isAbove);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TriggerStateReady value) ready,
    required TResult Function(_TriggerStatePostTrigger value) postTrigger,
  }) {
    return ready(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_TriggerStateReady value)? ready,
    TResult? Function(_TriggerStatePostTrigger value)? postTrigger,
  }) {
    return ready?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TriggerStateReady value)? ready,
    TResult Function(_TriggerStatePostTrigger value)? postTrigger,
    required TResult orElse(),
  }) {
    if (ready != null) {
      return ready(this);
    }
    return orElse();
  }
}

abstract class _TriggerStateReady implements _TriggerState {
  factory _TriggerStateReady({required final bool isAbove}) =
      _$TriggerStateReadyImpl;

  bool get isAbove;
  @JsonKey(ignore: true)
  _$$TriggerStateReadyImplCopyWith<_$TriggerStateReadyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TriggerStatePostTriggerImplCopyWith<$Res> {
  factory _$$TriggerStatePostTriggerImplCopyWith(
          _$TriggerStatePostTriggerImpl value,
          $Res Function(_$TriggerStatePostTriggerImpl) then) =
      __$$TriggerStatePostTriggerImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int remainingSamples});
}

/// @nodoc
class __$$TriggerStatePostTriggerImplCopyWithImpl<$Res>
    extends __$TriggerStateCopyWithImpl<$Res, _$TriggerStatePostTriggerImpl>
    implements _$$TriggerStatePostTriggerImplCopyWith<$Res> {
  __$$TriggerStatePostTriggerImplCopyWithImpl(
      _$TriggerStatePostTriggerImpl _value,
      $Res Function(_$TriggerStatePostTriggerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? remainingSamples = null,
  }) {
    return _then(_$TriggerStatePostTriggerImpl(
      remainingSamples: null == remainingSamples
          ? _value.remainingSamples
          : remainingSamples // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$TriggerStatePostTriggerImpl implements _TriggerStatePostTrigger {
  _$TriggerStatePostTriggerImpl({required this.remainingSamples});

  @override
  final int remainingSamples;

  @override
  String toString() {
    return '_TriggerState.postTrigger(remainingSamples: $remainingSamples)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TriggerStatePostTriggerImpl &&
            (identical(other.remainingSamples, remainingSamples) ||
                other.remainingSamples == remainingSamples));
  }

  @override
  int get hashCode => Object.hash(runtimeType, remainingSamples);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TriggerStatePostTriggerImplCopyWith<_$TriggerStatePostTriggerImpl>
      get copyWith => __$$TriggerStatePostTriggerImplCopyWithImpl<
          _$TriggerStatePostTriggerImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool isAbove) ready,
    required TResult Function(int remainingSamples) postTrigger,
  }) {
    return postTrigger(remainingSamples);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool isAbove)? ready,
    TResult? Function(int remainingSamples)? postTrigger,
  }) {
    return postTrigger?.call(remainingSamples);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool isAbove)? ready,
    TResult Function(int remainingSamples)? postTrigger,
    required TResult orElse(),
  }) {
    if (postTrigger != null) {
      return postTrigger(remainingSamples);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TriggerStateReady value) ready,
    required TResult Function(_TriggerStatePostTrigger value) postTrigger,
  }) {
    return postTrigger(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_TriggerStateReady value)? ready,
    TResult? Function(_TriggerStatePostTrigger value)? postTrigger,
  }) {
    return postTrigger?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TriggerStateReady value)? ready,
    TResult Function(_TriggerStatePostTrigger value)? postTrigger,
    required TResult orElse(),
  }) {
    if (postTrigger != null) {
      return postTrigger(this);
    }
    return orElse();
  }
}

abstract class _TriggerStatePostTrigger implements _TriggerState {
  factory _TriggerStatePostTrigger({required final int remainingSamples}) =
      _$TriggerStatePostTriggerImpl;

  int get remainingSamples;
  @JsonKey(ignore: true)
  _$$TriggerStatePostTriggerImplCopyWith<_$TriggerStatePostTriggerImpl>
      get copyWith => throw _privateConstructorUsedError;
}
