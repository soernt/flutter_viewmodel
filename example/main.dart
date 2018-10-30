import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_model/flutter_view_model.dart';


class PersonViewModel extends ViewModel {
  // Properties

  String _firstName;
  static const String firstNamePropName = "firstName";
  String get firstName => _firstName;
  set firstName(String value) {
    if (updateValue(firstNamePropName, _firstName, value, (v) => _firstName = v)) {
      notifyPropertyChanged(fullNamePropName);
    }
  }

  String _lastName;
  static const String lastNamePropName = "lastName";
  String get lastName => _lastName;
  set lastName(String value) {
    if (updateValue(lastNamePropName, _lastName, value, (v) => _lastName = v)) {
      notifyPropertyChanged(fullNamePropName);
    }
  }

  static const String fullNamePropName = "fullName";
  String get fullName => "$_firstName $lastNamePropName";

  // Methods

  PersonViewModel(this._firstName, this._lastName) : super();
}

class PersonViewModelProvider extends ViewModelProvider<PersonViewModel> {
  // Properties

  // Methods
  PersonViewModelProvider({Key key, @required PersonViewModel viewModel, @required WidgetBuilder childBuilder}) : super(key: key, viewModel: viewModel, childBuilder: childBuilder);

  static PersonViewModel of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(PersonViewModelProvider) as PersonViewModelProvider).viewModel;
  }
}
