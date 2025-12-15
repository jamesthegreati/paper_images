# KCSE Exam Paper Images Database

A comprehensive collection of Kenya Certificate of Secondary Education (KCSE) exam paper images from 2010 to 2024.

## 📚 Overview

This repository contains scanned images of KCSE examination papers organized by year, subject, and paper number. The collection is intended for educational purposes, exam preparation, and creating digital learning resources.

## 🗂️ Repository Structure

```
paper_images/
├── 2010/
│   ├── Biology/
│   │   ├── paper1/
│   │   ├── paper2/
│   │   └── paper3/
│   ├── Chemistry/
│   ├── Computer-Studies/
│   ├── English/
│   ├── Geography/
│   ├── Kiswahili/
│   ├── Mathematics/
│   └── Physics/
├── 2011/
│   └── [Same subject structure]
├── ...
└── 2024/
    └── [Same subject structure]
```

## 📋 Subjects Covered

- **Biology** (Papers 1, 2, 3)
- **Chemistry** (Papers 1, 2, 3)
- **Computer Studies** (Papers 1, 2)
- **English** (Papers 1, 2, 3)
- **Geography** (Papers 1, 2)
- **Kiswahili** (Papers 1, 2, 3)
- **Mathematics** (Papers 1, 2)
- **Physics** (Papers 1, 2, 3)

## 📊 Collection Statistics

- **Years Covered:** 2010 - 2024 (15 years)
- **Total Images:** ~2,186 pages
- **Format:** PNG images
- **Naming Convention:** `page_1.png`, `page_2.png`, etc.

## 🎯 Use Cases

1. **Exam Preparation:** Students reviewing past papers
2. **AI Transcription:** Converting images to structured JSON data
3. **Educational Apps:** Building question banks and practice systems
4. **Research:** Analysis of exam trends and patterns
5. **OCR Training:** Developing optical character recognition models

## 🚀 Getting Started

### Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/kcse-paper-images.git
cd kcse-paper-images
```

### Browse Papers

Navigate to the year, subject, and paper you need:

```bash
cd 2024/Biology/paper1/
# View page_1.png, page_2.png, etc.
```

## 📝 File Naming Convention

- Each exam paper is split into individual page images
- Files are named sequentially: `page_1.png`, `page_2.png`, `page_3.png`, etc.
- Page 1 typically contains the cover/instructions
- Question pages start from page 2 onwards

## 🔄 Transcription Project

This collection is part of a larger project to transcribe all exam papers into structured JSON format for digital learning platforms. The transcription schema captures:

- Question text and hierarchical structure
- Mark allocations
- Diagram descriptions and locations
- Topic classifications
- Complete metadata

### 📝 How to Transcribe Exam Papers

The repository includes a comprehensive AI transcription system. See [`TRANSCRIPTION_PROMPT.md`](TRANSCRIPTION_PROMPT.md) for the complete prompt template.

**Quick Start:**

1. **Prepare the Prompt**
   - Open [`TRANSCRIPTION_PROMPT.md`](TRANSCRIPTION_PROMPT.md)
   - Replace `{{YEAR}}` with the target year (e.g., 2024)
   - Replace `{{CURRENT_DATE}}` with today's date (e.g., 2024-12-15)

2. **Collect Paper Images**
   - Gather all PNG files from the year's subject folders
   - Example: `2024/Biology/paper1/*.png`, `2024/Chemistry/paper1/*.png`, etc.

3. **Use an AI Vision Model**
   - Send the customized prompt with all images to GPT-4 Vision, Claude with vision, or similar
   - The AI will analyze each page and extract all questions, marks, and diagrams

4. **Save the Output**
   - Save the generated JSON as `kcse_{{YEAR}}_complete.json`
   - Validate against the schema in [`schema.json`](schema.json)

5. **Validate the Output**
   ```bash
   python3 validate_transcription.py kcse_2024_complete.json
   ```
   
   The validator checks:
   - JSON schema compliance
   - Structure and required fields
   - Mark totals match
   - Diagram descriptions are present
   - Question counts are correct

**Files:**
- [`TRANSCRIPTION_PROMPT.md`](TRANSCRIPTION_PROMPT.md) - Complete AI prompt template
- [`schema.json`](schema.json) - JSON Schema for validation
- [`example_output.json`](example_output.json) - Example transcribed output
- [`validate_transcription.py`](validate_transcription.py) - Python validator script
- [`prepare_transcription.sh`](prepare_transcription.sh) - Helper script for preparing transcriptions
- [`QUICK_REFERENCE.md`](QUICK_REFERENCE.md) - Quick start guide

### 🎯 Output Structure

Each transcription produces a comprehensive JSON file with:

```json
{
  "year": 2024,
  "totalSubjects": 8,
  "totalPapers": 24,
  "totalQuestions": 200,
  "subjects": {
    "Biology": {
      "papers": {
        "Paper 1": {
          "questions": [
            {
              "questionNumber": 1,
              "questionText": "...",
              "marks": 2,
              "hasDiagram": true,
              "diagram": { /* detailed diagram info */ }
            }
          ]
        }
      }
    }
  }
}
```

See [`example_output.json`](example_output.json) for a complete working example.

## ⚖️ Legal Notice

These exam papers are copyrighted by the Kenya National Examinations Council (KNEC). This repository is for:
- Educational and research purposes only
- Non-commercial use
- Fair use under educational exceptions

**Please respect copyright laws and KNEC intellectual property rights.**

## 🤝 Contributing

Contributions are welcome! You can help by:

1. Adding missing exam papers
2. Improving image quality
3. Reporting errors or issues
4. Contributing to the transcription project

### Contribution Guidelines

- Ensure images are clear and readable
- Follow the existing folder structure
- Use PNG format for consistency
- Name files according to the convention

## 📧 Contact

For questions, issues, or collaboration opportunities, please open an issue on GitHub.

## 📄 License

This repository structure and organization are provided under the MIT License. However, the exam paper content itself remains the intellectual property of KNEC.

---

**Maintained by:** AI-Assisted Educational Tools Project  
**Last Updated:** December 2025  
**Repository Purpose:** Educational Resource & Digital Preservation
