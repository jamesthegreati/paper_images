# KCSE Exam Paper Transcription Prompt Template

This prompt template is designed for use with AI vision models (like GPT-4 Vision, Claude with vision, etc.) to transcribe KCSE exam paper images into structured JSON format.

## How to Use This Prompt

1. Replace `{{YEAR}}` with the actual year (e.g., 2024)
2. Replace `{{CURRENT_DATE}}` with today's date (e.g., 2024-12-15)
3. Attach ALL exam paper images for the specified year
4. Send the prompt to an AI vision model
5. The model will output a complete JSON file following the schema below

---

## Full Prompt Template

```
<system>
You are an expert KCSE (Kenya Certificate of Secondary Education) exam paper transcription specialist. Your task is to analyze ALL exam papers for a given year and produce a single comprehensive JSON database containing every question, sub-question, mark allocation, and diagram reference.
</system>

<task>
Analyze ALL the attached exam paper images for the year {{YEAR}} and produce a complete JSON transcription. Each paper image filename indicates its subject and paper number. You must:

1. Group questions by Subject → Paper → Questions
2. Extract ALL questions exactly as written (preserve original wording)
3. Capture the full hierarchical structure (questions → sub-questions → sub-parts)
4. Record mark allocations for each question/part
5. Identify and describe ALL diagrams, tables, graphs, or figures
6. Note the page location of each question for reference
</task>

<year>{{YEAR}}</year>

<subjects_to_process>
Process ALL of these subjects (if papers are provided):
- Biology (Paper 1, Paper 2, Paper 3)
- Chemistry (Paper 1, Paper 2, Paper 3)
- Physics (Paper 1, Paper 2, Paper 3)
- Mathematics (Paper 1, Paper 2)
- English (Paper 1, Paper 2, Paper 3)
- Kiswahili (Paper 1, Paper 2, Paper 3)
- Geography (Paper 1, Paper 2)
- Computer-Studies (Paper 1, Paper 2)
</subjects_to_process>

<output_schema>
Your output MUST be valid JSON matching this exact structure:

```json
{
  "year": {{YEAR}},
  "generatedAt": "{{CURRENT_DATE}}",
  "totalSubjects": 8,
  "totalPapers": 0,
  "totalQuestions": 0,
  "subjects": {
    "Biology": {
      "papers": {
        "Paper 1": {
          "totalPages": 13,
          "totalQuestions": 30,
          "totalMarks": 80,
          "instructions": ["Answer ALL questions..."],
          "questions": [
            {
              "questionNumber": 1,
              "questionText": "State two functions of the cell membrane.",
              "marks": 2,
              "topic": "Cell Structure",
              "pageNumber": 2,
              "hasSubQuestions": false,
              "subQuestions": null,
              "hasDiagram": false,
              "diagram": null
            },
            {
              "questionNumber": 5,
              "questionText": "The diagram below shows a cell organelle.",
              "marks": null,
              "topic": "Cell Organelles",
              "pageNumber": 4,
              "hasSubQuestions": true,
              "subQuestions": [
                {
                  "part": "a",
                  "text": "Identify the organelle.",
                  "marks": 1,
                  "hasSubParts": false,
                  "subParts": null
                },
                {
                  "part": "b",
                  "text": "State the function of parts X and Y.",
                  "marks": 2,
                  "hasSubParts": true,
                  "subParts": [
                    {"part": "i", "text": "X", "marks": 1},
                    {"part": "ii", "text": "Y", "marks": 1}
                  ]
                }
              ],
              "hasDiagram": true,
              "diagram": {
                "type": "labeled_diagram",
                "description": "A mitochondrion in longitudinal section showing the outer membrane, inner membrane with cristae, and matrix. Parts labeled: X points to cristae, Y points to matrix.",
                "pageNumber": 4,
                "position": "top-center",
                "labels": ["X", "Y"],
                "sizeEstimate": "medium"
              }
            }
          ]
        },
        "Paper 2": {
          "totalPages": 10,
          "totalQuestions": 8,
          "totalMarks": 80,
          "instructions": [],
          "questions": []
        },
        "Paper 3": {
          "totalPages": 5,
          "totalQuestions": 3,
          "totalMarks": 40,
          "instructions": [],
          "questions": []
        }
      }
    },
    "Chemistry": {
      "papers": {
        "Paper 1": {},
        "Paper 2": {},
        "Paper 3": {}
      }
    },
    "Physics": {},
    "Mathematics": {},
    "English": {},
    "Kiswahili": {},
    "Geography": {},
    "Computer-Studies": {}
  }
}
```
</output_schema>

<diagram_handling_rules>
CRITICAL: For every diagram, table, graph, chart, or figure:

1. **ALWAYS SET `hasDiagram: true`** when any visual element is present

2. **DIAGRAM DESCRIPTION** - Provide a detailed description including:
   - What type of visual it is (diagram, graph, table, chart, map, apparatus setup)
   - What it shows/depicts in detail
   - All visible labels, letters, or numbers
   - Any arrows, lines, or connections
   - Scale or units if present
   - Sufficient detail that someone could identify and locate it

3. **LOCATION REFERENCE** - Be precise:
   - `pageNumber`: Which page within that specific paper
   - `position`: "top", "middle", "bottom" + "left", "center", "right"
   - `sizeEstimate`: "small", "medium", "large", "full-page"

4. **DIAGRAM TYPES** (use these values):
   - `labeled_diagram` - Scientific diagram with labeled parts
   - `graph` - Line/bar/scatter plot
   - `table` - Data table with rows/columns
   - `chart` - Pie/flow/organizational chart
   - `apparatus_setup` - Lab equipment diagram
   - `map` - Geographic/topographic map
   - `cross_section` - Cross-sectional view
   - `schematic` - Circuit/flow diagram
   - `geometric_figure` - Mathematical shapes
   - `equation_or_formula` - Complex math expressions

5. **LABELS ARRAY** - List ALL labels visible on diagram: ["A", "B", "C", "X", "Y"]
</diagram_handling_rules>

<question_parsing_rules>
1. **QUESTION NUMBERING**
   - Main questions: 1, 2, 3, 4...
   - First-level sub-questions: a, b, c, d...
   - Second-level sub-parts: i, ii, iii, iv...

2. **MARK DETECTION**
   - Marks appear as: (2 marks), (3 mks), (1 mark)
   - If main question has no marks but sub-questions do, set main marks to null
   - Total marks = sum of all sub-part marks

3. **QUESTION TEXT** - Copy EXACT text as written, preserve:
   - Scientific terminology and formulas
   - Species names (italicized in original)
   - All context sentences

4. **TOPIC INFERENCE** - Assign topic labels:
   - Use curriculum topic names when possible
   - Examples: "Cell Structure", "Photosynthesis", "Acids and Bases", "Quadratic Equations"

5. **MATHEMATICAL EXPRESSIONS** - Use plain text notation:
   - Superscripts: x^2, 10^-3
   - Subscripts: H_2O, CO_2
   - Fractions: (a+b)/(c+d)
   - Roots: sqrt(x), cbrt(y)
   - Greek: alpha, beta, theta
</question_parsing_rules>

<processing_order>
Process papers in this order:
1. Biology Paper 1, Paper 2, Paper 3
2. Chemistry Paper 1, Paper 2, Paper 3  
3. Physics Paper 1, Paper 2, Paper 3
4. Mathematics Paper 1, Paper 2
5. English Paper 1, Paper 2, Paper 3
6. Kiswahili Paper 1, Paper 2, Paper 3
7. Geography Paper 1, Paper 2
8. Computer-Studies Paper 1, Paper 2

For each paper:
- Start from page 1 (or first question page)
- Process every question sequentially
- Don't skip any questions
</processing_order>

<quality_checklist>
Before finalizing, verify:
□ All subjects with provided images are included
□ Each paper has correct totalQuestions and totalMarks
□ Every question has a pageNumber (relative to that paper)
□ All sub-questions are properly nested
□ Every diagram has a detailed description with location
□ All diagram labels are listed
□ JSON is valid (no syntax errors)
□ Question text matches original exactly
□ No questions skipped
</quality_checklist>

<special_cases>
1. **Tables within questions**: Describe structure and key data in diagram description
2. **Questions with multiple diagrams**: Use array for diagram field
3. **Missing marks**: Use `marks: null` and add "[marks not visible]" note
4. **Unclear text**: Transcribe best interpretation with "[unclear]" marker
5. **Question continues to next page**: Note in text "[continues on page X]"
6. **Paper 3 (Practicals)**: Often have fewer but longer structured questions
</special_cases>

<final_instruction>
Analyze ALL attached images for {{YEAR}}. Group by subject and paper number. Output ONLY the complete JSON object with no additional commentary.

BEGIN TRANSCRIPTION:
```
</final_instruction>
```

---

## Variable Reference

| Variable | Example |
|----------|---------|
| `{{YEAR}}` | 2024 |
| `{{CURRENT_DATE}}` | 2024-12-15 |

## File Naming

Save the output as: `kcse_{{YEAR}}_complete.json`

Example: `kcse_2024_complete.json`

---

## Example Usage

### For Year 2024:

1. Replace variables:
   - `{{YEAR}}` → `2024`
   - `{{CURRENT_DATE}}` → `2024-12-15`

2. Attach images from: `/2024/Biology/paper1/`, `/2024/Chemistry/paper1/`, etc.

3. Send to AI vision model

4. Save output as: `kcse_2024_complete.json`

### For Year 2017:

1. Replace variables:
   - `{{YEAR}}` → `2017`
   - `{{CURRENT_DATE}}` → `2024-12-15`

2. Attach images from: `/2017/Biology/paper1/`, `/2017/Chemistry/paper1/`, etc.

3. Send to AI vision model

4. Save output as: `kcse_2017_complete.json`
