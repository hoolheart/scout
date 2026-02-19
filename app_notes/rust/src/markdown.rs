//! Markdown processing and parsing.
//!
//! This module provides functions for parsing Markdown content and converting
//! it to various formats.

use crate::api::MarkdownConfig;
use pulldown_cmark::{Event, HeadingLevel, Options, Parser, Tag, TagEnd};
use serde::{Deserialize, Serialize};
use tracing::debug;

// =============================================================================
// Core Types for Task R4
// =============================================================================

/// Markdown parsing result for FFI API.
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct ParseResult {
    /// Rendered HTML content.
    pub html: String,
    /// Word count.
    pub word_count: u32,
    /// Character count.
    pub char_count: u32,
    /// Extracted headings.
    pub headings: Vec<Heading>,
}

/// Represents a markdown heading with anchor.
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct Heading {
    /// Heading level (1-6).
    pub level: u8,
    /// Heading text.
    pub text: String,
    /// Heading anchor ID.
    pub anchor: String,
}

// =============================================================================
// Core API Functions for Task R4
// =============================================================================

/// Parse markdown content and return comprehensive parsing result.
///
/// # Arguments
///
/// * `content` - The markdown content to parse.
///
/// # Returns
///
/// Returns a `ParseResult` containing HTML, word count, char count, and headings.
///
/// # Example
///
/// ```rust
/// use app_notes_rust::markdown::parse_markdown;
///
/// let result = parse_markdown("# Hello\n\nThis is a test.");
/// assert!(result.html.contains("<h1>"));
/// assert_eq!(result.word_count, 5); // "Hello", "This", "is", "a", "test."
/// ```
pub fn parse_markdown(content: &str) -> ParseResult {
    let html = markdown_to_html(content);
    let plain_text = extract_plain_text(content);
    let (word_count, char_count) = count_words(&plain_text);
    let headings = extract_headings(content);

    ParseResult {
        html,
        word_count,
        char_count,
        headings,
    }
}

/// Convert markdown content to HTML.
///
/// # Arguments
///
/// * `content` - The markdown content to convert.
///
/// # Returns
///
/// Returns the rendered HTML string with GFM features enabled.
///
/// # Example
///
/// ```rust
/// use app_notes_rust::markdown::markdown_to_html;
///
/// let html = markdown_to_html("# Hello\n\nWorld");
/// assert!(html.contains("<h1>Hello</h1>"));
/// assert!(html.contains("<p>World</p>"));
/// ```
pub fn markdown_to_html(content: &str) -> String {
    let mut options = Options::empty();
    options.insert(Options::ENABLE_TABLES);
    options.insert(Options::ENABLE_TASKLISTS);
    options.insert(Options::ENABLE_STRIKETHROUGH);
    options.insert(Options::ENABLE_SMART_PUNCTUATION);
    options.insert(Options::ENABLE_HEADING_ATTRIBUTES);

    let parser = Parser::new_ext(content, options);
    let mut html = String::new();
    pulldown_cmark::html::push_html(&mut html, parser);

    html
}

/// Extract plain text from markdown (removes all formatting).
///
/// # Arguments
///
/// * `content` - The markdown content.
///
/// # Returns
///
/// Returns the plain text without markdown syntax.
///
/// # Example
///
/// ```rust
/// use app_notes_rust::markdown::extract_plain_text;
///
/// let text = extract_plain_text("# Title\n\n**Bold** text.");
/// assert!(text.contains("Title"));
/// assert!(text.contains("Bold"));
/// assert!(!text.contains("#"));
/// ```
pub fn extract_plain_text(content: &str) -> String {
    let mut options = Options::empty();
    options.insert(Options::ENABLE_TABLES);
    options.insert(Options::ENABLE_TASKLISTS);
    options.insert(Options::ENABLE_STRIKETHROUGH);
    options.insert(Options::ENABLE_SMART_PUNCTUATION);

    let parser = Parser::new_ext(content, options);
    let mut text = String::new();

    for event in parser {
        match event {
            Event::End(TagEnd::CodeBlock) => {
                text.push('\n');
            }
            Event::Text(t) => {
                text.push_str(&t);
            }
            Event::Code(t) => {
                text.push_str(&t);
            }
            Event::End(TagEnd::Heading(_)) | Event::End(TagEnd::Paragraph) | Event::HardBreak => {
                text.push('\n');
            }
            _ => {}
        }
    }

    // Clean up multiple consecutive newlines
    text.lines()
        .map(|line| line.trim())
        .collect::<Vec<_>>()
        .join("\n")
        .trim()
        .to_string()
}

/// Count words and characters in text.
///
/// # Arguments
///
/// * `text` - The plain text to count.
///
/// # Returns
///
/// Returns a tuple of (word_count, char_count).
///
/// # Example
///
/// ```rust
/// use app_notes_rust::markdown::count_words;
///
/// let (words, chars) = count_words("Hello world!");
/// assert_eq!(words, 2);
/// assert_eq!(chars, 11); // "Helloworld!"
/// ```
pub fn count_words(text: &str) -> (u32, u32) {
    let trimmed = text.trim();

    // Count words (split by whitespace)
    let word_count = if trimmed.is_empty() {
        0
    } else {
        trimmed.split_whitespace().count() as u32
    };

    // Count characters (excluding whitespace)
    let char_count = trimmed.chars().filter(|c| !c.is_whitespace()).count() as u32;

    (word_count, char_count)
}

/// Extract headings from markdown content.
///
/// # Arguments
///
/// * `content` - The markdown content.
///
/// # Returns
///
/// Returns a list of headings with anchors.
///
/// # Example
///
/// ```rust
/// use app_notes_rust::markdown::extract_headings;
///
/// let headings = extract_headings("# Title\n\n## Section");
/// assert_eq!(headings.len(), 2);
/// assert_eq!(headings[0].level, 1);
/// assert_eq!(headings[0].text, "Title");
/// ```
pub fn extract_headings(content: &str) -> Vec<Heading> {
    let mut options = Options::empty();
    options.insert(Options::ENABLE_HEADING_ATTRIBUTES);

    let parser = Parser::new_ext(content, options);
    let mut headings = Vec::new();
    let mut current_heading: Option<(u8, String)> = None;

    for event in parser {
        match event {
            Event::Start(Tag::Heading { level, .. }) => {
                current_heading = Some((heading_level_to_u8(&level), String::new()));
            }
            Event::End(TagEnd::Heading(_)) => {
                if let Some((level, text)) = current_heading.take() {
                    let anchor = generate_anchor(&text);
                    headings.push(Heading {
                        level,
                        text,
                        anchor,
                    });
                }
            }
            Event::Text(t) | Event::Code(t) => {
                if let Some((_, ref mut heading_text)) = current_heading {
                    heading_text.push_str(&t);
                }
            }
            _ => {}
        }
    }

    headings
}

/// Generate an anchor ID from heading text.
fn generate_anchor(text: &str) -> String {
    text.to_lowercase()
        .replace(|c: char| c.is_whitespace() || c == '_', "-")
        .replace(|c: char| !c.is_alphanumeric() && c != '-', "")
        .trim_matches('-')
        .to_string()
}

fn heading_level_to_u8(level: &HeadingLevel) -> u8 {
    match level {
        HeadingLevel::H1 => 1,
        HeadingLevel::H2 => 2,
        HeadingLevel::H3 => 3,
        HeadingLevel::H4 => 4,
        HeadingLevel::H5 => 5,
        HeadingLevel::H6 => 6,
    }
}

// =============================================================================
// Legacy/Extended Types and Functions
// =============================================================================

/// Represents a parsed markdown document structure.
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct MarkdownDocument {
    /// The original markdown content.
    pub content: String,
    /// Rendered HTML content.
    pub html: String,
    /// Extracted headings.
    pub headings: Vec<Heading>,
    /// Extracted links.
    pub links: Vec<Link>,
    /// Extracted images.
    pub images: Vec<Image>,
    /// Word count.
    pub word_count: usize,
    /// Character count.
    pub char_count: usize,
}

/// Represents a markdown link.
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct Link {
    /// Link text.
    pub text: String,
    /// Link URL.
    pub url: String,
    /// Whether it's an external link.
    pub is_external: bool,
}

/// Represents a markdown image.
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct Image {
    /// Image alt text.
    pub alt: String,
    /// Image source URL.
    pub src: String,
    /// Optional title.
    pub title: Option<String>,
}

/// Parse markdown content and return structured information.
///
/// # Arguments
///
/// * `content` - The markdown content to parse.
/// * `config` - Optional parsing configuration.
///
/// # Returns
///
/// Returns a `MarkdownDocument` containing the parsed structure.
pub fn parse_markdown_with_config(
    content: String,
    config: Option<MarkdownConfig>,
) -> MarkdownDocument {
    let config = config.unwrap_or_default();
    parse_markdown_inner(&content, &config)
}

fn parse_markdown_inner(content: &str, config: &MarkdownConfig) -> MarkdownDocument {
    let mut options = Options::empty();

    if config.gfm {
        options.insert(Options::ENABLE_TABLES);
        options.insert(Options::ENABLE_TASKLISTS);
        options.insert(Options::ENABLE_STRIKETHROUGH);
    }
    if config.tables {
        options.insert(Options::ENABLE_TABLES);
    }
    if config.strikethrough {
        options.insert(Options::ENABLE_STRIKETHROUGH);
    }
    if config.tasklists {
        options.insert(Options::ENABLE_TASKLISTS);
    }
    if config.smart_punctuation {
        options.insert(Options::ENABLE_SMART_PUNCTUATION);
    }
    if config.heading_attributes {
        options.insert(Options::ENABLE_HEADING_ATTRIBUTES);
    }

    let parser = Parser::new_ext(content, options);

    // Clone parser for HTML output
    let parser_for_html = Parser::new_ext(content, options);
    let mut html_output = String::new();
    pulldown_cmark::html::push_html(&mut html_output, parser_for_html);

    // Extract structure
    let mut headings = Vec::new();
    let mut links = Vec::new();
    let mut images = Vec::new();

    let mut current_heading: Option<(u8, String)> = None;
    let mut current_link: Option<String> = None;
    let mut current_link_text = String::new();
    let mut current_image_alt = String::new();

    for event in parser {
        match event {
            Event::Start(Tag::Heading { level, .. }) => {
                current_heading = Some((heading_level_to_u8(&level), String::new()));
            }
            Event::End(TagEnd::Heading(_)) => {
                if let Some((lvl, text)) = current_heading.take() {
                    let anchor = generate_anchor(&text);
                    headings.push(Heading {
                        level: lvl,
                        text: text.clone(),
                        anchor,
                    });
                }
            }
            Event::Start(Tag::Link {
                dest_url, title: _, ..
            }) => {
                current_link = Some(dest_url.to_string());
                current_link_text.clear();
            }
            Event::End(TagEnd::Link) => {
                if let Some(url) = current_link.take() {
                    let is_external = url.starts_with("http://") || url.starts_with("https://");
                    links.push(Link {
                        text: current_link_text.clone(),
                        url,
                        is_external,
                    });
                }
            }
            Event::Start(Tag::Image {
                dest_url, title, ..
            }) => {
                current_image_alt.clear();
                images.push(Image {
                    alt: String::new(), // Will be filled by text events
                    src: dest_url.to_string(),
                    title: if title.is_empty() {
                        None
                    } else {
                        Some(title.to_string())
                    },
                });
            }
            Event::End(TagEnd::Image) => {
                // Update the last image's alt text
                if let Some(last_image) = images.last_mut() {
                    last_image.alt = current_image_alt.clone();
                }
            }
            Event::Text(text) => {
                if let Some((_, ref mut heading_text)) = current_heading {
                    heading_text.push_str(&text);
                }
                if current_link.is_some() {
                    current_link_text.push_str(&text);
                }
                if !images.is_empty() && images.last().unwrap().alt.is_empty() {
                    current_image_alt.push_str(&text);
                }
            }
            _ => {}
        }
    }

    // Count words and characters
    let plain_text = extract_plain_text(content);
    let (word_count, char_count) = count_words(&plain_text);

    debug!(
        "Parsed markdown: {} headings, {} links, {} words",
        headings.len(),
        links.len(),
        word_count
    );

    MarkdownDocument {
        content: content.to_string(),
        html: html_output,
        headings,
        links,
        images,
        word_count: word_count as usize,
        char_count: char_count as usize,
    }
}

/// Convert markdown to HTML (legacy version with String argument).
///
/// # Arguments
///
/// * `content` - The markdown content to convert.
///
/// # Returns
///
/// Returns the rendered HTML string.
pub fn markdown_to_html_string(content: String) -> String {
    markdown_to_html(&content)
}

/// Extract plain text from markdown (legacy version with String argument).
///
/// # Arguments
///
/// * `content` - The markdown content.
///
/// # Returns
///
/// Returns the plain text without markdown syntax.
pub fn extract_plain_text_string(content: String) -> String {
    extract_plain_text(&content)
}

/// Get a table of contents from markdown content.
///
/// # Arguments
///
/// * `content` - The markdown content.
///
/// # Returns
///
/// Returns a list of headings for the table of contents.
pub fn get_table_of_contents(content: String) -> Vec<Heading> {
    let doc = parse_markdown_inner(&content, &MarkdownConfig::default());
    doc.headings
}

/// Check if content contains a specific heading.
///
/// # Arguments
///
/// * `content` - The markdown content.
/// * `heading_text` - The heading text to search for.
///
/// # Returns
///
/// Returns true if the heading is found.
pub fn has_heading(content: String, heading_text: String) -> bool {
    let doc = parse_markdown_inner(&content, &MarkdownConfig::default());
    doc.headings.iter().any(|h| h.text == heading_text)
}

/// Validate markdown syntax.
///
/// # Arguments
///
/// * `content` - The markdown content to validate.
///
/// # Returns
///
/// Returns a list of error messages if validation fails.
pub fn validate_markdown(content: String) -> Vec<String> {
    let mut errors = Vec::new();

    // Basic validation: check for unclosed code blocks
    let code_fence_count = content.matches("```").count();
    if !code_fence_count.is_multiple_of(2) {
        errors.push("Unclosed code block detected".to_string());
    }

    // Check for unclosed inline code
    let backtick_count = content.matches('`').count();
    // This is a simplified check; in reality, inline code needs more context
    if !backtick_count.is_multiple_of(2) {
        errors.push("Possible unclosed inline code".to_string());
    }

    errors
}

/// Render markdown with custom options for preview.
///
/// # Arguments
///
/// * `content` - The markdown content.
/// * `config` - Rendering configuration.
///
/// # Returns
///
/// Returns the rendered HTML.
pub fn render_preview(content: String, config: MarkdownConfig) -> String {
    let doc = parse_markdown_inner(&content, &config);
    doc.html
}

// =============================================================================
// Tests
// =============================================================================

#[cfg(test)]
mod tests {
    use super::*;

    // ===== Task R4 Tests =====

    #[test]
    fn test_parse_markdown_r4() {
        let content = r#"# Title

This is a paragraph with **bold** and *italic* text.

## Section 1

[Link](https://example.com)

![Alt text](image.png)

- Task 1
- Task 2
"#;

        let result = parse_markdown(content);

        // Check HTML generation
        assert!(result.html.contains("<h1>"));
        assert!(result.html.contains("</h1>"));
        assert!(result.html.contains("Title"));
        assert!(result.html.contains("<strong>bold</strong>"));
        assert!(result.html.contains("<em>italic</em>"));

        // Check headings extraction
        assert_eq!(result.headings.len(), 2);
        assert_eq!(result.headings[0].text, "Title");
        assert_eq!(result.headings[0].level, 1);
        assert_eq!(result.headings[0].anchor, "title");
        assert_eq!(result.headings[1].text, "Section 1");
        assert_eq!(result.headings[1].level, 2);
        assert_eq!(result.headings[1].anchor, "section-1");

        // Check word count
        assert!(result.word_count > 0);
        assert!(result.char_count > 0);
    }

    #[test]
    fn test_markdown_to_html_r4() {
        let html = markdown_to_html("# Hello\n\nWorld");
        assert!(html.contains("<h1>Hello</h1>"));
        assert!(html.contains("<p>World</p>"));
    }

    #[test]
    fn test_gfm_features() {
        // Test tables
        let table_md = "| Header 1 | Header 2 |\n|----------|----------|\n| Cell 1   | Cell 2   |";
        let html = markdown_to_html(table_md);
        assert!(html.contains("<table>"));
        assert!(html.contains("<th>"));
        assert!(html.contains("<td>"));

        // Test strikethrough
        let strike_md = "~~deleted~~";
        let html = markdown_to_html(strike_md);
        assert!(html.contains("<del>deleted</del>"));

        // Test task lists
        let task_md = "- [x] Done\n- [ ] Todo";
        let html = markdown_to_html(task_md);
        assert!(html.contains("<input"));
    }

    #[test]
    fn test_extract_plain_text_r4() {
        let content = "# Title\n\n**Bold** and *italic* text.\n\n```code```\n\nMore text.";
        let text = extract_plain_text(content);
        assert!(text.contains("Title"));
        assert!(text.contains("Bold"));
        assert!(text.contains("italic"));
        assert!(!text.contains("#"));
        assert!(!text.contains("**"));
        assert!(!text.contains("*"));
    }

    #[test]
    fn test_count_words() {
        let (words, chars) = count_words("Hello world!");
        assert_eq!(words, 2);
        assert_eq!(chars, 11); // "Helloworld!"

        let (words, chars) = count_words("  Multiple   spaces   here  ");
        assert_eq!(words, 3);
        assert_eq!(chars, 18); // "Multiple" (8) + "spaces" (6) + "here" (4) = 18

        let (words, chars) = count_words("");
        assert_eq!(words, 0);
        assert_eq!(chars, 0);
    }

    #[test]
    fn test_extract_headings() {
        let content = "# H1\n\nSome text\n\n## H2\n\n### H3\n\n#### H4\n\n##### H5\n\n###### H6";
        let headings = extract_headings(content);
        assert_eq!(headings.len(), 6);
        assert_eq!(headings[0].level, 1);
        assert_eq!(headings[1].level, 2);
        assert_eq!(headings[2].level, 3);
        assert_eq!(headings[3].level, 4);
        assert_eq!(headings[4].level, 5);
        assert_eq!(headings[5].level, 6);
    }

    #[test]
    fn test_generate_anchor() {
        assert_eq!(generate_anchor("Hello World"), "hello-world");
        assert_eq!(generate_anchor("Test_Heading"), "test-heading");
        assert_eq!(generate_anchor("Special!@#Chars"), "specialchars");
        assert_eq!(generate_anchor("  Spaces  "), "spaces");
        assert_eq!(generate_anchor("Multi--Dash"), "multi--dash");
    }

    // ===== Legacy Tests =====

    #[test]
    fn test_parse_markdown_with_config() {
        let content = r#"# Title

This is a paragraph.

## Section 1

[Link](https://example.com)

![Alt text](image.png)
"#
        .to_string();

        let doc = parse_markdown_with_config(content, None);

        assert_eq!(doc.headings.len(), 2);
        assert_eq!(doc.headings[0].text, "Title");
        assert_eq!(doc.headings[0].level, 1);
        assert_eq!(doc.headings[1].text, "Section 1");
        assert_eq!(doc.headings[1].level, 2);

        assert_eq!(doc.links.len(), 1);
        assert_eq!(doc.links[0].url, "https://example.com");
        assert!(doc.links[0].is_external);

        assert_eq!(doc.images.len(), 1);
        assert_eq!(doc.images[0].src, "image.png");

        assert!(doc.word_count > 0);
    }

    #[test]
    fn test_get_table_of_contents() {
        let content = "# H1\n\n## H2\n\n### H3".to_string();
        let toc = get_table_of_contents(content);
        assert_eq!(toc.len(), 3);
        assert_eq!(toc[0].level, 1);
        assert_eq!(toc[1].level, 2);
        assert_eq!(toc[2].level, 3);
    }

    #[test]
    fn test_has_heading() {
        let content = "# Exists\n\n## Another".to_string();
        assert!(has_heading(content.clone(), "Exists".to_string()));
        assert!(has_heading(content.clone(), "Another".to_string()));
        assert!(!has_heading(content, "Missing".to_string()));
    }

    #[test]
    fn test_validate_markdown() {
        let content = "```\ncode".to_string();
        let errors = validate_markdown(content);
        assert!(!errors.is_empty());
    }

    #[test]
    fn test_heading_anchor_generation() {
        let content = "# Hello World!\n\n## Test-Heading".to_string();
        let doc = parse_markdown_with_config(content, None);

        assert_eq!(doc.headings[0].anchor, "hello-world");
        assert_eq!(doc.headings[1].anchor, "test-heading");
    }

    #[test]
    fn test_code_block_with_language() {
        let content = "```rust\nfn main() {}\n```".to_string();
        let html = markdown_to_html(&content);
        assert!(html.contains("<pre>"));
        assert!(html.contains("<code"));
        // Note: pulldown_cmark generates class attribute differently
        assert!(html.contains("language-rust") || html.contains("rust"));
    }
}
