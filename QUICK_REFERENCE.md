# KCSE Transcription Quick Reference

## Files in This Repository

| File | Purpose |
|------|---------|
| `TRANSCRIPTION_PROMPT.md` | Complete AI prompt template for transcribing exam papers |
| `schema.json` | JSON Schema defining the output structure |
| `example_output.json` | Example of properly formatted transcription output |
| `prepare_transcription.sh` | Helper script to prepare for transcription |
| `QUICK_REFERENCE.md` | This file - quick start guide |

## Quick Start (3 Steps)

### Step 1: Choose a Year
```bash
./prepare_transcription.sh 2024
```

This will:
- Verify the year folder exists
- Count total images
- Generate a summary file
- Show you what to do next

### Step 2: Customize the Prompt

Open `TRANSCRIPTION_PROMPT.md` and replace:
- `{{YEAR}}` → Your chosen year (e.g., 2024)
- `{{CURRENT_DATE}}` → Today's date (e.g., 2024-12-15)

### Step 3: Run Transcription

1. Copy the customized prompt
2. Collect ALL PNG files from `<year>/*/paper*/*.png`
3. Send prompt + images to AI vision model (GPT-4V, Claude, etc.)
4. Save output as `kcse_<year>_complete.json`

## AI Vision Models You Can Use

### GPT-4 Vision (OpenAI)
- Best for: Detailed diagram descriptions
- Max images: ~50-100 per request (use batches)
- Cost: Higher but very accurate

### Claude 3 Opus/Sonnet (Anthropic)
- Best for: Large volumes, good accuracy
- Max images: ~20 per message
- Cost: Medium, good value

### Gemini Pro Vision (Google)
- Best for: Free tier available
- Max images: Varies by model
- Cost: Free tier available

## Transcription Tips

### For Best Results:
1. **Process one subject at a time** if hitting image limits
2. **Include all pages** even if some seem blank (instructions matter)
3. **Verify mark totals** add up correctly
4. **Check diagram descriptions** are detailed enough to locate them

### Common Issues:
- **Too many images**: Split by subject or paper
- **Mark detection errors**: Manually verify totals
- **Missing questions**: Check page numbering
- **Diagram descriptions too vague**: Ask AI to be more specific

## Validation

After getting your JSON output:

### Using the Python Validator (Recommended)

```bash
# Run the validator
python3 validate_transcription.py kcse_2024_complete.json
```

The validator checks:
- ✅ JSON schema compliance
- ✅ Structure and required fields
- ✅ Mark totals match stated values
- ✅ Diagram descriptions are complete
- ✅ Question counts are accurate
- ✅ All metadata is present

### Manual Validation (Alternative)

```bash
# Install a JSON validator (if you have Node.js)
npm install -g ajv-cli

# Validate against schema
ajv validate -s schema.json -d kcse_2024_complete.json
```

Or use online validators:
- https://www.jsonschemavalidator.net/
- https://jsonschemalint.com/

## Output File Naming

Use this convention:
- `kcse_2024_complete.json` - Full year transcription
- `kcse_2024_biology.json` - Single subject
- `kcse_2024_biology_paper1.json` - Single paper

## Example Workflow

```bash
# 1. Prepare
./prepare_transcription.sh 2017

# 2. The script tells you what to do
# Follow the instructions displayed

# 3. Process with AI
# Copy prompt from TRANSCRIPTION_PROMPT.md
# Attach images from 2017/
# Send to AI vision model

# 4. Save output
# Save as kcse_2017_complete.json

# 5. Validate
python3 validate_transcription.py kcse_2017_complete.json
```

## Schema Overview

```
Root
├── year (integer)
├── generatedAt (date)
├── totalSubjects (integer)
├── totalPapers (integer)
├── totalQuestions (integer)
└── subjects (object)
    ├── Biology
    │   └── papers
    │       ├── Paper 1
    │       │   ├── totalPages
    │       │   ├── totalQuestions
    │       │   ├── totalMarks
    │       │   ├── instructions[]
    │       │   └── questions[]
    │       │       ├── questionNumber
    │       │       ├── questionText
    │       │       ├── marks
    │       │       ├── topic
    │       │       ├── pageNumber
    │       │       ├── hasSubQuestions
    │       │       ├── subQuestions[]
    │       │       ├── hasDiagram
    │       │       └── diagram{}
    │       ├── Paper 2
    │       └── Paper 3
    └── [Other subjects...]
```

## Diagram Types Reference

When describing diagrams, use these types:

- `labeled_diagram` - Scientific diagram with parts labeled
- `graph` - Line graph, bar chart, scatter plot
- `table` - Data table with rows and columns
- `chart` - Pie chart, flow chart, organizational chart
- `apparatus_setup` - Lab equipment arrangement
- `map` - Geographic or topographic map
- `cross_section` - Cross-sectional view of object
- `schematic` - Circuit diagram or flow diagram
- `geometric_figure` - Mathematical shapes and constructions
- `equation_or_formula` - Complex mathematical expressions

## Position Reference

Describe diagram positions as: `<vertical>-<horizontal>`

**Vertical:** top, middle, bottom  
**Horizontal:** left, center, right

**Examples:**
- `top-center`
- `middle-left`
- `bottom-right`

## Size Reference

- `small` - Less than 1/4 page
- `medium` - About 1/4 to 1/2 page
- `large` - More than 1/2 page
- `full-page` - Entire page

## Support

For issues or questions:
1. Check `example_output.json` for reference
2. Review `schema.json` for structure requirements
3. See `TRANSCRIPTION_PROMPT.md` for detailed rules
4. Open an issue on GitHub

---

**Last Updated:** December 2024  
**Maintained by:** KCSE Digital Transcription Project
