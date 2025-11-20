# AI-Powered PDF Highlighter

Automatically highlight important content in academic PDFs using OpenAI GPT. Preserves original layout while adding intelligent, multi-color highlights.

## Features

- 🤖 **AI-Powered**: Uses OpenAI GPT to identify key phrases and concepts
- 🎨 **Multi-Color Highlighting**: Different colors for different content types
- 📄 **Layout Preservation**: Maintains original PDF formatting, figures, and layout
- ⚡ **Easy to Use**: Simple command-line interface
- 🔧 **Customizable**: Single-color or multi-color highlighting options

## Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/ai-pdf-highlighter.git
cd ai-pdf-highlighter
```

2. Install dependencies:
```bash
pip install pymupdf openai
```

3. Set your OpenAI API key:
```bash
export OPENAI_API_KEY='your-api-key-here'
```

## Usage

### Using the bash script (recommended):
```bash
# Basic usage - creates paper_highlighted.pdf
./highlight.sh paper.pdf

# Specify output filename
./highlight.sh paper.pdf highlighted_paper.pdf

# Single color highlighting
./highlight.sh paper.pdf output.pdf --single-color

# Show help
./highlight.sh --help
```

### Using Python directly:
```bash
python pdf_highlighter.py input.pdf output.pdf
python pdf_highlighter.py input.pdf output.pdf --single-color
```

## Color Coding

The multi-color highlighting uses different colors for different content types:

- 🟡 **Yellow**: Core concepts, AI-identified key phrases
- 🟢 **Green**: Technical terms (model, architecture, layer, etc.)
- 🔵 **Blue**: Datasets and benchmarks (accuracy, performance, results)
- 🟠 **Orange**: Training methods (pre-training, fine-tuning, optimization)
- 🟣 **Pink**: Comparisons and improvements (baseline, state-of-the-art)

## Examples

```bash
# Highlight a research paper
./highlight.sh "Vision Transformer Paper.pdf"

# Create a single-color highlighted version
./highlight.sh research_paper.pdf simple_highlights.pdf --single-color
```

## Requirements

- Python 3.7+
- OpenAI API key
- Internet connection (for OpenAI API calls)

## Dependencies

- `pymupdf` - PDF manipulation
- `openai` - OpenAI API client

## How It Works

1. **Text Extraction**: Extracts text from the first few pages of the PDF
2. **AI Analysis**: Sends text to OpenAI GPT to identify important phrases
3. **Smart Highlighting**: Searches the entire PDF for identified terms
4. **Color Categorization**: Applies different colors based on content type
5. **Layout Preservation**: Overlays highlights while maintaining original formatting

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

MIT License - see LICENSE file for details

## Troubleshooting

**Error: OPENAI_API_KEY not set**
- Make sure you've exported your OpenAI API key as an environment variable

**Error: Module not found**
- Install dependencies: `pip install pymupdf openai`

**Poor highlighting quality**
- The AI works best with academic papers and technical documents
- Ensure your PDF has extractable text (not just images)

## Acknowledgments

- Built with PyMuPDF for PDF manipulation
- Powered by OpenAI GPT for intelligent content analysis
