import 'package:apartment_project/models/database.dart';
import 'package:equatable/equatable.dart';

class CategoryFilter extends Equatable{
  final String docId;
  final ApartmentField category;
  final bool value;

  CategoryFilter({required this.docId, required this.category, required this.value});

  CategoryFilter copyWith({
  String? docId,
    ApartmentField? category,
    bool? value
  }){
    return CategoryFilter(docId: docId ?? this.docId, category: category ?? this.category, value: value ?? this.value);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    docId,
    category,
    value
  ];

  static Iterable<CategoryFilter> filters = ApartmentField.categories.map((category) =>
      CategoryFilter(docId: category.docId, category: category, value: false)).toList();

}