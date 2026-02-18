/// Syntax highlighting themes for the Markdown editor.
library;

import 'package:flutter/material.dart';

/// Light theme for syntax highlighting.
final Map<String, TextStyle> highlightLightTheme = {
  'root': const TextStyle(
    color: Color(0xFF24292F),
    backgroundColor: Colors.transparent,
  ),
  'comment': const TextStyle(color: Color(0xFF6E7781)),
  'quote': const TextStyle(color: Color(0xFF6E7781)),
  'keyword': const TextStyle(
    color: Color(0xFFCF222E),
    fontWeight: FontWeight.bold,
  ),
  'selector-tag': const TextStyle(
    color: Color(0xFFCF222E),
    fontWeight: FontWeight.bold,
  ),
  'subst': const TextStyle(color: Color(0xFFCF222E)),
  'number': const TextStyle(color: Color(0xFF0969DA)),
  'literal': const TextStyle(color: Color(0xFF0969DA)),
  'variable': const TextStyle(color: Color(0xFF0969DA)),
  'template-variable': const TextStyle(color: Color(0xFF0969DA)),
  'string': const TextStyle(color: Color(0xFF0A3069)),
  'title': const TextStyle(
    color: Color(0xFF8250DF),
    fontWeight: FontWeight.bold,
  ),
  'section': const TextStyle(
    color: Color(0xFF8250DF),
    fontWeight: FontWeight.bold,
  ),
  'selector-id': const TextStyle(
    color: Color(0xFF8250DF),
    fontWeight: FontWeight.bold,
  ),
  'emphasis': const TextStyle(fontStyle: FontStyle.italic),
  'strong': const TextStyle(fontWeight: FontWeight.bold),
  'bullet': const TextStyle(color: Color(0xFF57606A)),
  'code': const TextStyle(
    color: Color(0xFF24292F),
    backgroundColor: Color(0xFFF6F8FA),
  ),
  'formula': const TextStyle(color: Color(0xFF24292F)),
  'link': const TextStyle(
    color: Color(0xFF0969DA),
    decoration: TextDecoration.underline,
  ),
  'attribute': const TextStyle(color: Color(0xFF0550AE)),
  'attr': const TextStyle(color: Color(0xFF0550AE)),
  'tag': const TextStyle(color: Color(0xFF0550AE)),
  'name': const TextStyle(color: Color(0xFF0550AE)),
  'built_in': const TextStyle(color: Color(0xFF0550AE)),
  'regexp': const TextStyle(color: Color(0xFF0A3069)),
  'deletion': const TextStyle(
    color: Color(0xFF82071E),
    backgroundColor: Color(0xFFFFE7E9),
  ),
  'addition': const TextStyle(
    color: Color(0xFF116329),
    backgroundColor: Color(0xFFDAFBE1),
  ),
  'meta': const TextStyle(color: Color(0xFF6E7781)),
};

/// Dark theme for syntax highlighting.
final Map<String, TextStyle> highlightDarkTheme = {
  'root': const TextStyle(
    color: Color(0xFFE6EDF3),
    backgroundColor: Colors.transparent,
  ),
  'comment': const TextStyle(color: Color(0xFF8B949E)),
  'quote': const TextStyle(color: Color(0xFF8B949E)),
  'keyword': const TextStyle(
    color: Color(0xFFFF7B72),
    fontWeight: FontWeight.bold,
  ),
  'selector-tag': const TextStyle(
    color: Color(0xFFFF7B72),
    fontWeight: FontWeight.bold,
  ),
  'subst': const TextStyle(color: Color(0xFFFF7B72)),
  'number': const TextStyle(color: Color(0xFF79C0FF)),
  'literal': const TextStyle(color: Color(0xFF79C0FF)),
  'variable': const TextStyle(color: Color(0xFF79C0FF)),
  'template-variable': const TextStyle(color: Color(0xFF79C0FF)),
  'string': const TextStyle(color: Color(0xFFA5D6FF)),
  'title': const TextStyle(
    color: Color(0xFFD2A8FF),
    fontWeight: FontWeight.bold,
  ),
  'section': const TextStyle(
    color: Color(0xFFD2A8FF),
    fontWeight: FontWeight.bold,
  ),
  'selector-id': const TextStyle(
    color: Color(0xFFD2A8FF),
    fontWeight: FontWeight.bold,
  ),
  'emphasis': const TextStyle(fontStyle: FontStyle.italic),
  'strong': const TextStyle(fontWeight: FontWeight.bold),
  'bullet': const TextStyle(color: Color(0xFF8B949E)),
  'code': const TextStyle(
    color: Color(0xFFE6EDF3),
    backgroundColor: Color(0xFF343A41),
  ),
  'formula': const TextStyle(color: Color(0xFFE6EDF3)),
  'link': const TextStyle(
    color: Color(0xFF79C0FF),
    decoration: TextDecoration.underline,
  ),
  'attribute': const TextStyle(color: Color(0xFF79C0FF)),
  'attr': const TextStyle(color: Color(0xFF79C0FF)),
  'tag': const TextStyle(color: Color(0xFF7EE787)),
  'name': const TextStyle(color: Color(0xFF7EE787)),
  'built_in': const TextStyle(color: Color(0xFF79C0FF)),
  'regexp': const TextStyle(color: Color(0xFFA5D6FF)),
  'deletion': const TextStyle(
    color: Color(0xFFFFCDD2),
    backgroundColor: Color(0xFF67060C),
  ),
  'addition': const TextStyle(
    color: Color(0xFFAFF5B4),
    backgroundColor: Color(0xFF033A16),
  ),
  'meta': const TextStyle(color: Color(0xFF8B949E)),
};
