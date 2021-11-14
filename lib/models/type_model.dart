import 'package:equatable/equatable.dart';

class TypeModel extends Equatable{
  final int id;
  final String name;

  TypeModel({
    required this.id,
    required this.name
  });

  @override
  // TODO: implement props
  List<Object?> get props => [name];

  static List<TypeModel> types = [
    TypeModel(
        id: 1,
        name: 'Villa'),
    TypeModel(
        id: 2,
        name: 'House'),
    TypeModel(
        id: 3,
        name: 'Pen-house'),
    TypeModel(
        id: 4,
        name: 'Apartment'),
  ];
}

class FurnitureModel extends Equatable{
  final int id;
  final String name;

  FurnitureModel({
    required this.id,
    required this.name
  });

  @override
  // TODO: implement props
  List<Object?> get props => [name];

  static List<FurnitureModel> furniture = [
    FurnitureModel(
        id: 1,
        name: 'Furnished'),
    FurnitureModel(
        id: 2,
        name: 'Unfurnished'),
    FurnitureModel(
        id: 3,
        name: 'Part-Furnished'),
  ];
}