#!/usr/bin/env python3
"""
AI-Powered PDF Highlighter
Automatically highlights important content in academic PDFs using OpenAI GPT.
"""

import pymupdf as fitz
from openai import OpenAI
import json
import sys
import os
from typing import List, Dict, Tuple

class PDFHighlighter:
    def __init__(self, api_key: str):
        self.client = OpenAI(api_key=api_key)
    
    def get_ai_highlights(self, text: str) -> List[str]:
        """Extract key phrases using OpenAI."""
        try:
            response = self.client.chat.completions.create(
                model="gpt-3.5-turbo",
                messages=[
                    {"role": "system", "content": "Extract key phrases from academic papers for highlighting."},
                    {"role": "user", "content": f"Extract 15-25 important phrases from this academic paper. Return as JSON array: {text[:8000]}"}
                ],
                max_tokens=800,
                temperature=0.2
            )
            
            content = response.choices[0].message.content.strip()
            start = content.find('[')
            end = content.rfind(']') + 1
            if start != -1 and end != 0:
                return json.loads(content[start:end])
        except Exception as e:
            print(f"OpenAI API error: {e}")
        return []

    def highlight_pdf(self, input_path: str, output_path: str, multicolor: bool = True):
        """Highlight PDF with AI-identified content."""
        doc = fitz.open(input_path)
        
        # Extract text for analysis
        text = ""
        for page_num in range(min(6, len(doc))):
            text += doc[page_num].get_text()
        
        print("Analyzing document with AI...")
        ai_highlights = self.get_ai_highlights(text)
        print(f"AI identified {len(ai_highlights)} key phrases")
        
        if multicolor:
            highlight_groups = {
                (1, 1, 0): ai_highlights[:8] + ["transformer", "attention", "self-attention", "multi-head"],
                (0, 1, 0): ["model", "architecture", "layer", "embedding", "encoder", "decoder", "MLP"],
                (0, 0.7, 1): ["dataset", "benchmark", "accuracy", "performance", "results", "evaluation"],
                (1, 0.5, 0): ["training", "pre-training", "fine-tuning", "optimization", "learning"],
                (1, 0, 1): ["comparison", "baseline", "state-of-the-art", "improvement", "efficiency"]
            }
        else:
            highlight_groups = {(1, 1, 0): ai_highlights + ["model", "architecture", "performance", "results"]}
        
        # Apply highlights
        total_highlights = 0
        for page_num in range(len(doc)):
            page = doc[page_num]
            for color, terms in highlight_groups.items():
                for term in terms:
                    instances = page.search_for(term, flags=fitz.TEXT_DEHYPHENATE)
                    for inst in instances:
                        highlight = page.add_highlight_annot(inst)
                        highlight.set_colors(stroke=list(color))
                        highlight.update()
                        total_highlights += 1
        
        doc.save(output_path)
        doc.close()
        print(f"Saved highlighted PDF: {output_path} ({total_highlights} highlights)")

def main():
    if len(sys.argv) < 3:
        print("Usage: python pdf_highlighter.py <input.pdf> <output.pdf> [--single-color]")
        sys.exit(1)
    
    input_pdf = sys.argv[1]
    output_pdf = sys.argv[2]
    multicolor = "--single-color" not in sys.argv
    
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        print("Error: Set OPENAI_API_KEY environment variable")
        sys.exit(1)
    
    highlighter = PDFHighlighter(api_key)
    highlighter.highlight_pdf(input_pdf, output_pdf, multicolor)

if __name__ == "__main__":
    main()
