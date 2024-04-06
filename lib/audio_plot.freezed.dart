// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_plot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AxisParameters {
  double get minimum => throw _privateConstructorUsedError;
  double get maximum => throw _privateConstructorUsedError;
  Iterable<TickLabel> get ticks => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AxisParametersCopyWith<AxisParameters> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AxisParametersCopyWith<$Res> {
  factory $AxisParametersCopyWith(
          AxisParameters value, $Res Function(AxisParameters) then) =
      _$AxisParametersCopyWithImpl<$Res, AxisParameters>;
  @useResult
  $Res call(
      {double minimum,
      double maximum,
      Iterable<TickLabel> ticks,
      String label});
}

/// @nodoc
class _$AxisParametersCopyWithImpl<$Res, $Val extends AxisParameters>
    implements $AxisParametersCopyWith<$Res> {
  _$AxisParametersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minimum = null,
    Object? maximum = null,
    Object? ticks = null,
    Object? label = null,
  }) {
    return _then(_value.copyWith(
      minimum: null == minimum
          ? _value.minimum
          : minimum // ignore: cast_nullable_to_non_nullable
              as double,
      maximum: null == maximum
          ? _value.maximum
          : maximum // ignore: cast_nullable_to_non_nullable
              as double,
      ticks: null == ticks
          ? _value.ticks
          : ticks // ignore: cast_nullable_to_non_nullable
              as Iterable<TickLabel>,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AxisParametersImplCopyWith<$Res>
    implements $AxisParametersCopyWith<$Res> {
  factory _$$AxisParametersImplCopyWith(_$AxisParametersImpl value,
          $Res Function(_$AxisParametersImpl) then) =
      __$$AxisParametersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double minimum,
      double maximum,
      Iterable<TickLabel> ticks,
      String label});
}

/// @nodoc
class __$$AxisParametersImplCopyWithImpl<$Res>
    extends _$AxisParametersCopyWithImpl<$Res, _$AxisParametersImpl>
    implements _$$AxisParametersImplCopyWith<$Res> {
  __$$AxisParametersImplCopyWithImpl(
      _$AxisParametersImpl _value, $Res Function(_$AxisParametersImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minimum = null,
    Object? maximum = null,
    Object? ticks = null,
    Object? label = null,
  }) {
    return _then(_$AxisParametersImpl(
      minimum: null == minimum
          ? _value.minimum
          : minimum // ignore: cast_nullable_to_non_nullable
              as double,
      maximum: null == maximum
          ? _value.maximum
          : maximum // ignore: cast_nullable_to_non_nullable
              as double,
      ticks: null == ticks
          ? _value.ticks
          : ticks // ignore: cast_nullable_to_non_nullable
              as Iterable<TickLabel>,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AxisParametersImpl extends _AxisParameters {
  _$AxisParametersImpl(
      {required this.minimum,
      required this.maximum,
      required this.ticks,
      required this.label})
      : super._();

  @override
  final double minimum;
  @override
  final double maximum;
  @override
  final Iterable<TickLabel> ticks;
  @override
  final String label;

  @override
  String toString() {
    return 'AxisParameters(minimum: $minimum, maximum: $maximum, ticks: $ticks, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AxisParametersImpl &&
            (identical(other.minimum, minimum) || other.minimum == minimum) &&
            (identical(other.maximum, maximum) || other.maximum == maximum) &&
            const DeepCollectionEquality().equals(other.ticks, ticks) &&
            (identical(other.label, label) || other.label == label));
  }

  @override
  int get hashCode => Object.hash(runtimeType, minimum, maximum,
      const DeepCollectionEquality().hash(ticks), label);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AxisParametersImplCopyWith<_$AxisParametersImpl> get copyWith =>
      __$$AxisParametersImplCopyWithImpl<_$AxisParametersImpl>(
          this, _$identity);
}

abstract class _AxisParameters extends AxisParameters {
  factory _AxisParameters(
      {required final double minimum,
      required final double maximum,
      required final Iterable<TickLabel> ticks,
      required final String label}) = _$AxisParametersImpl;
  _AxisParameters._() : super._();

  @override
  double get minimum;
  @override
  double get maximum;
  @override
  Iterable<TickLabel> get ticks;
  @override
  String get label;
  @override
  @JsonKey(ignore: true)
  _$$AxisParametersImplCopyWith<_$AxisParametersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TickLabel {
  double get value => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TickLabelCopyWith<TickLabel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TickLabelCopyWith<$Res> {
  factory $TickLabelCopyWith(TickLabel value, $Res Function(TickLabel) then) =
      _$TickLabelCopyWithImpl<$Res, TickLabel>;
  @useResult
  $Res call({double value, String label});
}

/// @nodoc
class _$TickLabelCopyWithImpl<$Res, $Val extends TickLabel>
    implements $TickLabelCopyWith<$Res> {
  _$TickLabelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
    Object? label = null,
  }) {
    return _then(_value.copyWith(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TickLabelImplCopyWith<$Res>
    implements $TickLabelCopyWith<$Res> {
  factory _$$TickLabelImplCopyWith(
          _$TickLabelImpl value, $Res Function(_$TickLabelImpl) then) =
      __$$TickLabelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double value, String label});
}

/// @nodoc
class __$$TickLabelImplCopyWithImpl<$Res>
    extends _$TickLabelCopyWithImpl<$Res, _$TickLabelImpl>
    implements _$$TickLabelImplCopyWith<$Res> {
  __$$TickLabelImplCopyWithImpl(
      _$TickLabelImpl _value, $Res Function(_$TickLabelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
    Object? label = null,
  }) {
    return _then(_$TickLabelImpl(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TickLabelImpl implements _TickLabel {
  _$TickLabelImpl({required this.value, required this.label});

  @override
  final double value;
  @override
  final String label;

  @override
  String toString() {
    return 'TickLabel(value: $value, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TickLabelImpl &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.label, label) || other.label == label));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value, label);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TickLabelImplCopyWith<_$TickLabelImpl> get copyWith =>
      __$$TickLabelImplCopyWithImpl<_$TickLabelImpl>(this, _$identity);
}

abstract class _TickLabel implements TickLabel {
  factory _TickLabel(
      {required final double value,
      required final String label}) = _$TickLabelImpl;

  @override
  double get value;
  @override
  String get label;
  @override
  @JsonKey(ignore: true)
  _$$TickLabelImplCopyWith<_$TickLabelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
