import 'package:apartment_project/models/type_model.dart';
import 'package:equatable/equatable.dart';

class TypeFilter extends Equatable{
  final int id;
  final TypeModel type;
  final bool value;

  TypeFilter({required this.id, required this.type, required this.value});

  TypeFilter copyWith({
    int? id,
    TypeModel? type,
    bool? value
  }){
    return TypeFilter(id: id ?? this.id, type: type ?? this.type, value: value ?? this.value);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    type,
    value
  ];

  static Iterable<TypeFilter> filters = TypeModel.types.map((type) =>
      TypeFilter(id: type.id, type: type, value: false)).toList();

}

class FurnitureFilter extends Equatable{
  final int id;
  final FurnitureModel furniture;
  final bool value;

  FurnitureFilter({required this.id, required this.furniture, required this.value});

  FurnitureFilter copyWith({
    int? id,
    FurnitureModel? furniture,
    bool? value
  }){
    return FurnitureFilter(id: id ?? this.id, furniture: furniture ?? this.furniture, value: value ?? this.value);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    furniture,
    value
  ];

  static Iterable<FurnitureFilter> filters = FurnitureModel.furniture.map((furniture) =>
      FurnitureFilter(id: furniture.id, furniture: furniture, value: false)).toList();

}