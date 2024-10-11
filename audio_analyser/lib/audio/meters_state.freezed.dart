// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meters_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MetersState {
  double get rms => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MetersStateCopyWith<MetersState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetersStateCopyWith<$Res> {
  factory $MetersStateCopyWith(
          MetersState value, $Res Function(MetersState) then) =
      _$MetersStateCopyWithImpl<$Res, MetersState>;
  @useResult
  $Res call({double rms});
}

/// @nodoc
class _$MetersStateCopyWithImpl<$Res, $Val extends MetersState>
    implements $MetersStateCopyWith<$Res> {
  _$MetersStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rms = null,
  }) {
    return _then(_value.copyWith(
      rms: null == rms
          ? _value.rms
          : rms // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MetersStateImplCopyWith<$Res>
    implements $MetersStateCopyWith<$Res> {
  factory _$$MetersStateImplCopyWith(
          _$MetersStateImpl value, $Res Function(_$MetersStateImpl) then) =
      __$$MetersStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double rms});
}

/// @nodoc
class __$$MetersStateImplCopyWithImpl<$Res>
    extends _$MetersStateCopyWithImpl<$Res, _$MetersStateImpl>
    implements _$$MetersStateImplCopyWith<$Res> {
  __$$MetersStateImplCopyWithImpl(
      _$MetersStateImpl _value, $Res Function(_$MetersStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rms = null,
  }) {
    return _then(_$MetersStateImpl(
      rms: null == rms
          ? _value.rms
          : rms // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$MetersStateImpl implements _MetersState {
  _$MetersStateImpl({required this.rms});

  @override
  final double rms;

  @override
  String toString() {
    return 'MetersState(rms: $rms)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetersStateImpl &&
            (identical(other.rms, rms) || other.rms == rms));
  }

  @override
  int get hashCode => Object.hash(runtimeType, rms);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MetersStateImplCopyWith<_$MetersStateImpl> get copyWith =>
      __$$MetersStateImplCopyWithImpl<_$MetersStateImpl>(this, _$identity);
}

abstract class _MetersState implements MetersState {
  factory _MetersState({required final double rms}) = _$MetersStateImpl;

  @override
  double get rms;
  @override
  @JsonKey(ignore: true)
  _$$MetersStateImplCopyWith<_$MetersStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
