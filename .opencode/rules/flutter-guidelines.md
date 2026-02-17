# Flutter Development Guidelines

> Based on Flutter Team's official style guide, Effective Dart, and Very Good Analysis

## Overview

These guidelines ensure Flutter code is consistent, maintainable, and follows industry best practices. They combine:
- Flutter team's official lint rules (`flutter/flutter` repo)
- Dart's Effective Dart guidelines
- Very Good Analysis production-proven rules
- Flutter-specific architectural patterns

---

## Analysis Configuration

### Required `analysis_options.yaml`

```yaml
analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
  errors:
    missing_required_param: error
    missing_return: error
    invalid_assignment: warning
    missing_code_block_language_in_doc_comment: warning
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/*.mocks.dart"
    - "build/**"

linter:
  rules:
    # Core Style Rules
    - always_declare_return_types
    - always_put_required_named_parameters_first
    - always_use_package_imports
    - annotate_overrides
    - avoid_bool_literals_in_conditional_expressions
    - avoid_catches_without_on_clauses
    - avoid_catching_errors
    - avoid_double_and_int_checks
    - avoid_dynamic_calls
    - avoid_empty_else
    - avoid_equals_and_hash_code_on_mutable_classes
    - avoid_escaping_inner_quotes
    - avoid_field_initializers_in_const_classes
    - avoid_final_parameters
    - avoid_function_literals_in_foreach_calls
    - avoid_init_to_null
    - avoid_js_rounded_ints
    - avoid_multiple_declarations_per_line
    - avoid_positional_boolean_parameters
    - avoid_print
    - avoid_private_typedef_functions
    - avoid_redundant_argument_values
    - avoid_relative_lib_imports
    - avoid_renaming_method_parameters
    - avoid_return_types_on_setters
    - avoid_returning_null_for_void
    - avoid_returning_this
    - avoid_setters_without_getters
    - avoid_shadowing_type_parameters
    - avoid_single_cascade_in_expression_statements
    - avoid_slow_async_io
    - avoid_type_to_string
    - avoid_types_as_parameter_names
    - avoid_unnecessary_containers
    - avoid_unused_constructor_parameters
    - avoid_void_async
    - avoid_web_libraries_in_flutter
    - await_only_futures
    - camel_case_extensions
    - camel_case_types
    - cancel_subscriptions
    - cast_nullable_to_non_nullable
    - collection_methods_unrelated_type
    - combinators_ordering
    - comment_references
    - conditional_uri_does_not_exist
    - constant_identifier_names
    - control_flow_in_finally
    - curly_braces_in_flow_control_structures
    - dangling_library_doc_comments
    - depend_on_referenced_packages
    - deprecated_consistency
    - directives_ordering
    - discarded_futures
    - document_ignores
    - empty_catches
    - empty_constructor_bodies
    - empty_statements
    - eol_at_end_of_file
    - exhaustive_cases
    - file_names
    - flutter_style_todos
    - hash_and_equals
    - implicit_call_tearoffs
    - implementation_imports
    - implicit_reopen
    - invalid_case_patterns
    - join_return_with_assignment
    - leading_newlines_in_multiline_strings
    - library_annotations
    - library_prefixes
    - library_private_types_in_public_api
    - literal_only_boolean_expressions
    - matching_super_parameters
    - missing_whitespace_between_adjacent_strings
    - no_adjacent_strings_in_list
    - no_default_cases
    - no_duplicate_case_values
    - no_leading_underscores_for_library_prefixes
    - no_leading_underscores_for_local_identifiers
    - no_literal_bool_comparisons
    - no_logic_in_create_state
    - no_runtimeType_toString
    - no_self_assignments
    - no_wildcard_variable_uses
    - non_constant_identifier_names
    - noop_primitive_operations
    - null_check_on_nullable_type_parameter
    - null_closures
    - one_member_abstracts
    - only_throw_errors
    - overridden_fields
    - package_names
    - parameter_assignments
    - prefer_adjacent_string_concatenation
    - prefer_asserts_in_initializer_lists
    - prefer_collection_literals
    - prefer_conditional_assignment
    - prefer_const_constructors
    - prefer_const_constructors_in_immutables
    - prefer_const_declarations
    - prefer_const_literals_to_create_immutables
    - prefer_constructors_over_static_methods
    - prefer_contains
    - prefer_final_fields
    - prefer_final_in_for_each
    - prefer_final_locals
    - prefer_foreach
    - prefer_for_elements_to_map_fromIterable
    - prefer_function_declarations_over_variables
    - prefer_generic_function_type_aliases
    - prefer_if_elements_to_conditional_expressions
    - prefer_if_null_operators
    - prefer_initializing_formals
    - prefer_inlined_adds
    - prefer_int_literals
    - prefer_interpolation_to_compose_strings
    - prefer_is_empty
    - prefer_is_not_empty
    - prefer_is_not_operator
    - prefer_iterable_whereType
    - prefer_null_aware_method_calls
    - prefer_null_aware_operators
    - prefer_single_quotes
    - prefer_spread_collections
    - prefer_typing_uninitialized_variables
    - provide_deprecation_message
    - public_member_api_docs
    - recursive_getters
    - require_trailing_commas
    - secure_pubspec_urls
    - sized_box_for_whitespace
    - sized_box_shrink_expand
    - slash_for_doc_comments
    - sort_child_properties_last
    - sort_constructors_first
    - sort_pub_dependencies
    - sort_unnamed_constructors_first
    - strict_top_level_inference
    - test_types_in_equals
    - throw_in_finally
    - tighten_type_of_initializing_formals
    - type_annotate_public_apis
    - type_init_formals
    - type_literal_in_constant_pattern
    - unawaited_futures
    - unintended_html_in_doc_comment
    - unnecessary_await_in_return
    - unnecessary_breaks
    - unnecessary_brace_in_string_interps
    - unnecessary_const
    - unnecessary_constructor_name
    - unnecessary_getters_setters
    - unnecessary_ignore
    - unnecessary_lambdas
    - unnecessary_late
    - unnecessary_library_directive
    - unnecessary_library_name
    - unnecessary_new
    - unnecessary_null_aware_assignments
    - unnecessary_null_aware_operator_on_extension_on_nullable
    - unnecessary_null_checks
    - unnecessary_null_in_if_null_operators
    - unnecessary_nullable_for_final_variable_declarations
    - unnecessary_overrides
    - unnecessary_parenthesis
    - unnecessary_raw_strings
    - unnecessary_statements
    - unnecessary_string_escapes
    - unnecessary_string_interpolations
    - unnecessary_this
    - unnecessary_to_list_in_spreads
    - unnecessary_unawaited
    - unnecessary_underscores
    - unreachable_from_main
    - unrelated_type_equality_checks
    - use_build_context_synchronously
    - use_colored_box
    - use_enums
    - use_full_hex_values_for_flutter_colors
    - use_function_type_syntax_for_parameters
    - use_if_null_to_convert_nulls_to_bools
    - use_is_even_rather_than_modulo
    - use_key_in_widget_constructors
    - use_late_for_private_fields_and_variables
    - use_named_constants
    - use_null_aware_elements
    - use_raw_strings
    - use_rethrow_when_possible
    - use_setters_to_change_properties
    - use_string_buffers
    - use_string_in_part_of_directives
    - use_super_parameters
    - use_test_throws_matchers
    - use_to_and_as_if_applicable
    - use_truncating_division
    - valid_regexps
    - void_checks
```

---

## Naming Conventions

### DO: Name Types Using UpperCamelCase

```dart
// GOOD
class SliderMenu { }
class HttpRequest { }
typedef Predicate<T> = bool Function(T value);

// BAD
class sliderMenu { }
class HTTPRequest { }
```

### DO: Name Packages, Directories, and Files Using lowercase_with_underscores

```dart
// GOOD
my_package/
  lib/
    slider_menu.dart
    http_request.dart

// BAD
my-package/
  lib/
    slider-menu.dart
    HTTPRequest.dart
```

### DO: Name Import Prefixes Using lowercase_with_underscores

```dart
// GOOD
import 'dart:math' as math;
import 'package:angular_components/angular_components.dart' as angular_components;

// BAD
import 'dart:math' as Math;
import 'package:angular_components/angular_components.dart' as angularComponents;
```

### DO: Name Other Identifiers Using lowerCamelCase

```dart
// GOOD
var item;
const Value = () => 10;
void sum(int price) { }

// BAD
var Item;
const VALUE = () => 10;
void Sum(int PRICE) { }
```

### PREFER: Using lowerCamelCase for Constant Names

```dart
// GOOD
const defaultTimeout = 1000;
final pi = 3.14;

// BAD  
const DEFAULT_TIMEOUT = 1000;
const DefaultTimeout = 1000;
```

### DO: Capitalize Acronyms and Abbreviations Longer Than Two Letters Like Words

```dart
// GOOD
class HttpConnection { }
class DBConnection { }

// BAD
class HTTPConnection { }
class DbConnection { }
```

---

## Code Organization

### DO: Place `dart:` Imports Before Other Imports

```dart
// GOOD
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_package/my_package.dart';

// BAD
import 'package:flutter/material.dart';
import 'dart:async';
```

### DO: Place `package:` Imports Before Relative Imports

```dart
// GOOD
import 'package:flutter/material.dart';
import 'package:my_package/utils.dart';

import 'src/my_widget.dart';
import 'src/utils.dart';

// BAD
import 'src/my_widget.dart';
import 'package:flutter/material.dart';
```

### DO: Sort Sections Alphabetically

```dart
// GOOD
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'src/a.dart';
import 'src/b.dart';
```

---

## Flutter Widget Guidelines

### DO: Use `const` Constructors Where Possible

```dart
// GOOD
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Hello');
  }
}

// Usage
const MyWidget(),
const Text('Title'),
```

### DO: Use `Key` in Widget Constructors

```dart
// GOOD
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});
  
  // OR with custom key name
  const MyWidget({Key? key, required this.title}) : super(key: key);
  
  final String title;
}

// BAD
class MyWidget extends StatelessWidget {
  const MyWidget(); // Missing key parameter
}
```

### DO: Use `super` Parameters

```dart
// GOOD
class MyWidget extends StatelessWidget {
  const MyWidget({super.key, required this.title});
  
  final String title;
}

// BAD
class MyWidget extends StatelessWidget {
  const MyWidget({Key? key, required this.title}) : super(key: key);
  
  final String title;
}
```

### AVOID: Using `BuildContext` Across Async Gaps Without Checks

```dart
// GOOD
Future<void> loadData(BuildContext context) async {
  final data = await fetchData();
  if (!context.mounted) return;
  showData(context, data);
}

// BAD
Future<void> loadData(BuildContext context) async {
  final data = await fetchData();
  // DANGER: context may not be valid here
  showData(context, data);
}
```

### DO: Use `ColoredBox` Instead of `Container` for Background Color

```dart
// GOOD
ColoredBox(
  color: Colors.red,
  child: Text('Hello'),
)

// BAD
Container(
  color: Colors.red,
  child: Text('Hello'),
)
```

### DO: Use `SizedBox` for Whitespace

```dart
// GOOD
SizedBox(width: 16)
SizedBox(height: 8)
SizedBox.shrink() // For empty placeholders
SizedBox.expand() // For filling available space

// BAD
Container(width: 16)
Container(height: 8)
```

### DO: Sort Child Properties Last

```dart
// GOOD
ElevatedButton(
  onPressed: onPressed,
  style: buttonStyle,
  child: Text('Click Me'),
)

// BAD
ElevatedButton(
  child: Text('Click Me'),
  onPressed: onPressed,
  style: buttonStyle,
)
```

---

## State Management

### DO: Initialize State in `initState()`

```dart
class _MyWidgetState extends State<MyWidget> {
  late final Future<String> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchData();
  }
}
```

### DO: Dispose Resources in `dispose()`

```dart
class _MyWidgetState extends State<MyWidget> {
  final _controller = TextEditingController();
  final _subscription = StreamController<String>().stream.listen((_) {});

  @override
  void dispose() {
    _controller.dispose();
    _subscription.cancel();
    super.dispose();
  }
}
```

### AVOID: No Logic in `createState()`

```dart
// GOOD
class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

// BAD
class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() {
    print('Creating state'); // Logic in createState!
    return _MyWidgetState();
  }
}
```

---

## Documentation

### DO: Use `///` Doc Comments to Document Members and Types

```dart
// GOOD
/// A widget that displays a customizable greeting message.
///
/// The greeting is displayed in a styled text widget and supports
/// both light and dark themes.
///
/// {@tool dartpad}
/// This example shows a basic [GreetingWidget].
///
/// ** See code in examples/api/lib/widgets/greeting_widget.dart **
/// {@end-tool}
///
/// See also:
///
/// * [Text], which is used to display the greeting.
/// * [GreetingTheme], for theming options.
class GreetingWidget extends StatelessWidget {
  /// Creates a [GreetingWidget] with the specified [name].
  ///
  /// The [name] parameter must not be null.
  const GreetingWidget({super.key, required this.name});

  /// The name to include in the greeting.
  ///
  /// This value is displayed after "Hello, " in the greeting text.
  final String name;
}

// BAD
// A widget that displays a greeting
class GreetingWidget extends StatelessWidget { }
```

### DO: Start Doc Comments with a Single-Sentence Summary

```dart
// GOOD
/// Returns the sum of two integers.
///
/// This method adds [a] and [b] together and returns the result.
/// If either value is null, returns null.
int? sum(int? a, int? b);

// BAD
/// This method takes two integers and adds them together. It returns
/// the sum. If either is null, it returns null.
int? sum(int? a, int? b);
```

### DO: Format Comments Like Sentences

```dart
// GOOD
/// Calculates the area of a circle given its [radius].
///
/// The [radius] must be non-negative.
/// Returns null if [radius] is negative.
double? circleArea(double radius);

// BAD
/// calculates the area of a circle
/// radius: the radius of the circle
/// returns: the area
double? circleArea(double radius);
```

---

## Error Handling

### DO: Throw Objects That Implement `Error` Only for Programmatic Errors

```dart
// GOOD - For programming errors
void checkPositive(int value) {
  if (value < 0) {
    throw ArgumentError.value(value, 'value', 'must be positive');
  }
}

// GOOD - For expected failures
Future<void> fetchData() async {
  try {
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw FetchException('Failed to fetch: ${response.statusCode}');
    }
  } on SocketException catch (e) {
    throw NetworkException('No internet connection', e);
  }
}
```

### DO: Use `rethrow` to Rethrow a Caught Exception

```dart
// GOOD
try {
  await riskyOperation();
} on FormatException catch (e) {
  logger.warning('Format error: $e');
  rethrow;
}

// BAD
try {
  await riskyOperation();
} on FormatException catch (e) {
  throw e; // Loses stack trace
}
```

### AVOID: Catches Without `on` Clauses

```dart
// GOOD
try {
  await riskyOperation();
} on FormatException catch (e) {
  // Handle format error
} on IOException catch (e) {
  // Handle IO error
}

// BAD
try {
  await riskyOperation();
} catch (e) { // Catches everything including Error types
  // Handle error
}
```

---

## Testing Guidelines

### DO: Write Tests for All Public APIs

```dart
// GOOD
group('Counter', () {
  test('initial value is 0', () {
    final counter = Counter();
    expect(counter.value, 0);
  });

  test('increment increases value by 1', () {
    final counter = Counter();
    counter.increment();
    expect(counter.value, 1);
  });
});
```

### DO: Use `testWidgets` for Widget Tests

```dart
// GOOD
testWidgets('Counter increments when button is tapped', (tester) async {
  await tester.pumpWidget(const MyApp());
  
  expect(find.text('0'), findsOneWidget);
  
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  
  expect(find.text('1'), findsOneWidget);
});
```

### DO: Use `setUp` and `tearDown` for Test Fixtures

```dart
// GOOD
group('UserRepository', () {
  late UserRepository repository;
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabase = MockDatabase();
    repository = UserRepository(database: mockDatabase);
  });

  tearDown(() {
    mockDatabase.dispose();
  });

  test('getUser returns user from database', () async {
    // Test implementation
  });
});
```

---

## Performance Guidelines

### DO: Use `const` for Immutable Widgets

```dart
// GOOD - Better performance, widget is reused
const Padding(
  padding: EdgeInsets.all(8.0),
  child: Text('Hello'),
)

// BAD - Creates new widget instance every build
Padding(
  padding: const EdgeInsets.all(8.0),
  child: const Text('Hello'),
)
```

### DO: Use `ListView.builder` for Long Lists

```dart
// GOOD - Only builds visible items
ListView.builder(
  itemCount: 10000,
  itemBuilder: (context, index) => ListTile(
    title: Text('Item $index'),
  ),
)

// BAD - Builds all items upfront
ListView(
  children: List.generate(10000, (index) => 
    ListTile(title: Text('Item $index')),
  ),
)
```

### AVOID: Unnecessary Rebuilds

```dart
// GOOD - Using const
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Header(),
        Body(),
        Footer(),
      ],
    );
  }
}

// GOOD - Using const constructor parameters
class MyWidget extends StatelessWidget {
  const MyWidget({super.key, this.padding = const EdgeInsets.all(8.0)});
  
  final EdgeInsets padding;
}
```

---

## Asynchronous Programming

### PREFER: Async/Await Over Raw Futures

```dart
// GOOD
Future<String> fetchData() async {
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return response.body;
  }
  throw Exception('Failed to load');
}

// BAD
Future<String> fetchData() {
  return http.get(url).then((response) {
    if (response.statusCode == 200) {
      return response.body;
    }
    throw Exception('Failed to load');
  });
}
```

### DON'T: Use `async` When It Has No Useful Effect

```dart
// GOOD
Future<int> fetchCount() => _database.queryCount();

// BAD
Future<int> fetchCount() async {
  return await _database.queryCount();
}
```

### DO: Use `unawaited` When Intentionally Not Awaiting

```dart
import 'dart:async';

// GOOD
void logAnalytics(String event) {
  unawaited(_analytics.log(event));
}

// BAD
void logAnalytics(String event) {
  _analytics.log(event); // Analyzer warning: unawaited future
}
```

---

## Type Safety

### DO: Type Annotate Variables Without Initializers

```dart
// GOOD
String name;
List<int> values;

// BAD
var name; // dynamic
var values; // dynamic
```

### DON'T: Redundantly Type Annotate Initialized Local Variables

```dart
// GOOD
var name = 'John';
var count = 42;
final values = <int>[];

// BAD
String name = 'John';
int count = 42;
final List<int> values = [];
```

### AVOID: Using `dynamic` Unless You Want to Disable Static Checking

```dart
// GOOD
Object json = jsonDecode(response);
if (json is Map<String, dynamic>) {
  return json['name'] as String;
}

// BAD - Disables all static checking
dynamic json = jsonDecode(response);
return json.name; // No compile-time checking
```

### DO: Use `Future<void>` for Async Members That Don't Produce Values

```dart
// GOOD
Future<void> saveData() async {
  await _database.write(data);
}

// BAD
Future<Null> saveData() async { }
```

---

## Flutter Architecture Guidelines

### DO: Keep Widgets Small and Focused

```dart
// GOOD - Separate concerns
class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserAvatar(user: user),
        UserName(user: user),
        UserBio(user: user),
      ],
    );
  }
}

// BAD - Everything in one widget
class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(/* complex logic */),
        Text(/* formatting logic */),
        Text(/* bio with markdown parsing */),
      ],
    );
  }
}
```

### DO: Use Widget Composition Over Inheritance

```dart
// GOOD - Composition
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: customStyle,
      child: child,
    );
  }
}

// BAD - Inheritance
class CustomButton extends ElevatedButton {
  CustomButton({
    required super.onPressed,
    required super.child,
  }) : super(style: customStyle);
}
```

### DO: Separate Business Logic from UI

```dart
// GOOD - UI layer
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = context.watch<CounterCubit>();
    
    return Scaffold(
      body: Text('Count: ${counter.state}'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<CounterCubit>().increment(),
      ),
    );
  }
}

// Business logic layer
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
}
```

---

## Null Safety Best Practices

### DO: Follow a Consistent Rule for `var` and `final` on Local Variables

```dart
// GOOD - Use var for mutable, final for immutable
var count = 0; // Mutable
count = 5;

final name = 'John'; // Immutable

// OR - Explicit types when not obvious
final User user = fetchUser();
var items = <String>[];
```

### CONSIDER: Type Promotion or Null-Check Patterns for Nullable Types

```dart
// GOOD - Type promotion
if (user != null) {
  print(user.name); // user promoted to non-nullable
}

// GOOD - Null-check pattern
final userName = user?.name ?? 'Anonymous';

// GOOD - Null-aware operators
controller?.dispose();
```

### AVOID: Public `late final` Fields Without Initializers

```dart
// GOOD
class Service {
  final ApiClient _client;
  
  Service({required ApiClient client}) : _client = client;
}

// BAD
class Service {
  late final ApiClient _client; // Can be forgotten
}
```

---

## References

- [Flutter Official Style Guide](https://github.com/flutter/flutter/blob/master/docs/contributing/Style-guide-for-Flutter-repo.md)
- [Effective Dart](https://dart.dev/effective-dart)
- [Flutter Analysis Options](https://github.com/flutter/flutter/blob/master/analysis_options.yaml)
- [Very Good Analysis](https://github.com/VeryGoodOpenSource/very_good_analysis)
- [Dart Linter Rules](https://dart.dev/tools/linter-rules)

---

## Version

- Created: 2025-02-16
- Based on: Flutter 3.4+, Dart 3.0+
- Last Updated: 2025-02-16
