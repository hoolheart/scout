//! Markdown processing and parsing.
//!
//! This module provides functions for parsing Markdown content and converting
//! it to various formats.

use crate::api::MarkdownConfig;
use pulldown_cmark::{Event, HeadingLevel, Options, Parser, Tag, TagEnd};
use serde::{Deserialize, Serialize};
use tracing::debug;

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

/// Represents a markdown heading.
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct Heading {
    /// Heading level (1-6).
    pub level: u8,
    /// Heading text.
    pub text: String,
    /// Heading anchor ID.
    pub id: String,
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
pub fn parse_markdown(content: String, config: Option<MarkdownConfig>) -> MarkdownDocument {
    let config = config.unwrap_or_default();
    parse_markdown_inner(&content, &config)
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
                    let id = text
                        .to_lowercase()
                        .replace(' ', "-")
                        .replace(|c: char| !c.is_alphanumeric() && c != '-', "");
                    headings.push(Heading {
                        level: lvl,
                        text: text.clone(),
                        id,
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
    let word_count = content.split_whitespace().count();
    let char_count = content.chars().count();

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
        word_count,
        char_count,
    }
}

/// Convert markdown to HTML.
///
/// # Arguments
///
/// * `content` - The markdown content to convert.
///
/// # Returns
///
/// Returns the rendered HTML string.
pub fn markdown_to_html(content: String) -> String {
    let options = Options::all();
    let parser = Parser::new_ext(&content, options);

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
pub fn extract_plain_text(content: String) -> String {
    let parser = Parser::new(&content);
    let mut text = String::new();

    for event in parser {
        if let Event::Text(t) = event {
            text.push_str(&t);
            text.push(' ');
        }
    }

    text.trim().to_string()
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
    if code_fence_count % 2 != 0 {
        errors.push("Unclosed code block detected".to_string());
    }

    // Check for unclosed inline code
    let backtick_count = content.matches('`').count();
    // This is a simplified check; in reality, inline code needs more context
    if backtick_count % 2 != 0 {
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

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_markdown() {
        let content = r#"# Title

This is a paragraph.

## Section 1

[Link](https://example.com)

![Alt text](image.png)
"#
        .to_string();

        let doc = parse_markdown(content, None);

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
    fn test_markdown_to_html() {
        let content = "# Hello\n\nWorld".to_string();
        let html = markdown_to_html(content);
        assert!(html.contains("<h1>"));
        assert!(html.contains("Hello"));
        assert!(html.contains("<p>"));
        assert!(html.contains("World"));
    }

    #[test]
    fn test_extract_plain_text() {
        let content = "# Title\n\n**Bold** and *italic* text.".to_string();
        let text = extract_plain_text(content);
        assert!(text.contains("Title"));
        assert!(text.contains("Bold"));
        assert!(text.contains("italic"));
        assert!(!text.contains("#"));
        assert!(!text.contains("**"));
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
    fn test_gfm_options() {
        let content = "| a | b |\n|---|---|\n| 1 | 2 |".to_string();
        let mut config = MarkdownConfig::default();
        config.tables = true;

        let doc = parse_markdown_inner(&content, &config);
        assert!(doc.html.contains("<table>"));
    }

    #[test]
    fn test_heading_id_generation() {
        let content = "# Hello World!\n\n## Test-Heading".to_string();
        let doc = parse_markdown(content, None);

        assert_eq!(doc.headings[0].id, "hello-world");
        assert_eq!(doc.headings[1].id, "test-heading");
    }
}
