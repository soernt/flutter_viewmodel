# view_model

[![pub package](https://img.shields.io/pub/v/flutter_view_model.svg)](https://pub.dartlang.org/packages/flutter_view_model)

A view model framework inspired by Microsofts INotifyPropertyChanged interface.  

## Getting Started

Add `view_model` to your `pubspec.yaml` dependencies:
```yaml
...
dependencies:
  flutter:
    sdk: flutter

  view_model: <current version>
...
```


## Usage
A basic view model:
```dart
// Import the packages.
import 'package:view_model/view_model_lib.dart';

// 1. Create a ViewModel
class PersonViewModel extends ViewModel {
  // Properties

  String _firstName;
  static const String firstNamePropName = "firstName";
  String get firstName => _firstName;
  set firstName(String value) {
    // When the value of _firstName and value are not equal, than the _firstName value gets updated 
    // via the provided function and a PropertyChangedEvent is send. 
    if (updateValue(firstNamePropName, _firstName, value, (v) => _firstName = v)) { // When the _firstName changes than also the fullName changes.
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

  // ReadOnly Property
  static const String fullNamePropName = "fullName";
  String get fullName => "$_firstName $lastNamePropName";

  // Methods

  PersonViewModel(this._firstName, this._lastName) : super();
}
```
A view model provider:
```dart
// 2. Create a ViewModelProvider
class PersonViewModelProvider extends ViewModelProvider<PersonViewModel> {
  // Properties

  // Methods
  PersonViewModelProvider({Key key, @required PersonViewModel viewModel, @required WidgetBuilder childBuilder}) : super(key: key, viewModel: viewModel, childBuilder: childBuilder);

  static PersonViewModel of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(PersonViewModelProvider) as PersonViewModelProvider).viewModel;
  }
}
```
The build function within your view:
```dart
// Within your widget build function...
  Widget build(BuildContext context) {
    // Top most Widget is the view model provider
    return LoginPageViewModelProvider( viewModel: PersonViewModel("Fred", "Flinstone")  childBuilder: (ctx) {
      // get the view Model via the PersonViewModelProvider...
      final viewModel = PersonViewModelProvider.of(ctx);
      // ViewModelPropertyWidgetBuilder rebuilds its child whenever the given property (propertyName) of the given view model changes.
      return return ViewModelPropertyWidgetBuilder(
        viewModel: viewModel,
        propertyName: PersonViewModel.fullNamePropName,
        builder: (context, _) {
          return Text(viewModel.fullName)
        }
    }));
  }

```

## Code snipets:
```json
	"ViewModel Class":{
		"prefix": "vmc",
		"body": [
			"class $1ViewModel extends ViewModel {",
			"  // Properties ",
			"",
			"  // Methods ",
			"",
			"  $1ViewModel(): super();",
			"",
			" }"
		]
	},

	"View Model Property":{
		"prefix": "vmp",
		"body": [
			"  ${1:type} _${2:propertyName};",
			"  static const String $2PropName = \"$2\"; ",
			"  $1 get $2 => _$2;",
			"  set $2($1 value){",
			"    updateValue($2PropName, _$2, value, (v) => _$2 = v);",
			"  }"
		]
	},

	"View Model Provider":{
		"prefix": "vmp",
		"body": [
			"class ${1:ViewModel}ViewModelProvider extends ViewModelProvider<${1:ViewModel}ViewModel> {",
			"  // Properties ",
			"",
			"  // Methods ",
			"  $1ViewModelProvider({Key key, @required ${1:ViewModel}ViewModel viewModel, @required WidgetBuilder childBuilder}) : super(key: key, viewModel: viewModel, childBuilder: childBuilder);",
			"",	
			"  static $1ViewModel of(BuildContext context) {",
			"    return (context.inheritFromWidgetOfExactType(${1}ViewModelProvider) as ${1:ViewModel}ViewModelProvider).viewModel;",
			"  }",
			"}"
		]
	},


	"View Model Property Widget Builder":{
		"prefix": "vmpwb",
		"body": [
			"  new ViewModelPropertyWidgetBuilder(",
			"  viewModel: ${1:viewModelIntance},",
			"  propertyName: \"${2:propertyName}\",",
			"  builder: (context, snapshot) {",
			"    return Text(\"$1.$2\");",
			"  ",
			"  }),"
		]
	},
```

