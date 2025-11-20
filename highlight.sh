#!/bin/bash

# AI-Powered PDF Highlighter
# Usage: ./highlight.sh <input.pdf> [output.pdf] [options]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
INPUT_PDF=""
OUTPUT_PDF=""
SINGLE_COLOR=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --single-color)
            SINGLE_COLOR=true
            shift
            ;;
        --help|-h)
            echo "AI-Powered PDF Highlighter"
            echo ""
            echo "Usage: $0 <input.pdf> [output.pdf] [options]"
            echo ""
            echo "Options:"
            echo "  --single-color    Use single color (yellow) instead of multi-color"
            echo "  --help, -h        Show this help message"
            echo ""
            echo "Environment Variables:"
            echo "  OPENAI_API_KEY    Required: Your OpenAI API key"
            echo ""
            echo "Examples:"
            echo "  $0 paper.pdf                           # Creates paper_highlighted.pdf"
            echo "  $0 paper.pdf highlighted.pdf           # Creates highlighted.pdf"
            echo "  $0 paper.pdf output.pdf --single-color # Single color highlighting"
            exit 0
            ;;
        *)
            if [[ -z "$INPUT_PDF" ]]; then
                INPUT_PDF="$1"
            elif [[ -z "$OUTPUT_PDF" ]]; then
                OUTPUT_PDF="$1"
            else
                echo -e "${RED}Error: Too many arguments${NC}"
                exit 1
            fi
            shift
            ;;
    esac
done

# Validate input
if [[ -z "$INPUT_PDF" ]]; then
    echo -e "${RED}Error: Input PDF file required${NC}"
    echo "Usage: $0 <input.pdf> [output.pdf] [options]"
    exit 1
fi

if [[ ! -f "$INPUT_PDF" ]]; then
    echo -e "${RED}Error: Input file '$INPUT_PDF' not found${NC}"
    exit 1
fi

# Set default output filename
if [[ -z "$OUTPUT_PDF" ]]; then
    filename=$(basename "$INPUT_PDF" .pdf)
    OUTPUT_PDF="${filename}_highlighted.pdf"
fi

# Check for OpenAI API key
if [[ -z "$OPENAI_API_KEY" ]]; then
    echo -e "${RED}Error: OPENAI_API_KEY environment variable not set${NC}"
    echo "Please set your OpenAI API key:"
    echo "export OPENAI_API_KEY='your-api-key-here'"
    exit 1
fi

# Check dependencies
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Error: python3 not found${NC}"
    exit 1
fi

# Install dependencies if needed
echo -e "${YELLOW}Checking dependencies...${NC}"
python3 -c "import pymupdf, openai" 2>/dev/null || {
    echo -e "${YELLOW}Installing required packages...${NC}"
    pip install pymupdf openai
}

# Run the highlighter
echo -e "${GREEN}Highlighting PDF: $INPUT_PDF${NC}"
echo -e "${GREEN}Output file: $OUTPUT_PDF${NC}"

if [[ "$SINGLE_COLOR" == true ]]; then
    python3 pdf_highlighter.py "$INPUT_PDF" "$OUTPUT_PDF" --single-color
else
    python3 pdf_highlighter.py "$INPUT_PDF" "$OUTPUT_PDF"
fi

echo -e "${GREEN}✓ Done! Highlighted PDF saved as: $OUTPUT_PDF${NC}"
