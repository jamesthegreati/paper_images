#!/usr/bin/env python3
"""
KCSE Exam Paper Transcription Validator

This script validates a transcribed KCSE exam paper JSON file against the schema
and performs additional quality checks.

Usage:
    python3 validate_transcription.py <json_file>

Example:
    python3 validate_transcription.py kcse_2024_complete.json
"""

import sys
import json
from pathlib import Path


def load_json(filepath):
    """Load and parse a JSON file.
    
    Args:
        filepath (str): Path to the JSON file to load
        
    Returns:
        dict: Parsed JSON data, or None if file not found or invalid
    """
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"❌ Error: File '{filepath}' not found")
        return None
    except json.JSONDecodeError as e:
        print(f"❌ Error: Invalid JSON in '{filepath}'")
        print(f"   {str(e)}")
        return None


def validate_schema(data):
    """Validate against JSON schema if jsonschema is available.
    
    Args:
        data (dict): The transcription data to validate
        
    Returns:
        bool: True if validation passed or was skipped, False if failed
    """
    try:
        from jsonschema import validate, ValidationError
        
        schema_path = Path(__file__).parent / 'schema.json'
        if not schema_path.exists():
            print("⚠️  Warning: schema.json not found, skipping schema validation")
            return True
        
        schema = load_json(schema_path)
        if not schema:
            return False
        
        try:
            validate(instance=data, schema=schema)
            print("✅ Schema validation: PASSED")
            return True
        except ValidationError as e:
            print("❌ Schema validation: FAILED")
            print(f"   Error: {e.message}")
            print(f"   Path: {' > '.join(str(p) for p in e.path)}")
            return False
    except ImportError:
        print("⚠️  Warning: jsonschema module not installed")
        print("   Install with: pip install jsonschema")
        print("   Skipping schema validation")
        return True


def validate_structure(data):
    """Validate the basic structure of the transcription.
    
    Checks for required fields, verifies subject/paper/question structure,
    validates mark totals, and ensures counts match stated values.
    
    Args:
        data (dict): The transcription data to validate
        
    Returns:
        bool: True if structure validation passed, False otherwise
    """
    print("\n📋 Structure Validation:")
    errors = []
    warnings = []
    
    # Check required top-level fields
    required_fields = ['year', 'generatedAt', 'totalSubjects', 'totalPapers', 
                      'totalQuestions', 'subjects']
    for field in required_fields:
        if field not in data:
            errors.append(f"Missing required field: {field}")
        else:
            print(f"   ✓ {field}: {data[field]}")
    
    if errors:
        for error in errors:
            print(f"   ❌ {error}")
        return False
    
    # Check subjects
    if 'subjects' not in data:
        return False
    
    subject_count = 0
    paper_count = 0
    question_count = 0
    
    for subject_name, subject_data in data['subjects'].items():
        if 'papers' not in subject_data:
            warnings.append(f"Subject '{subject_name}' has no papers")
            continue
        
        subject_count += 1
        for paper_name, paper_data in subject_data['papers'].items():
            paper_count += 1
            
            # Check paper structure
            if 'questions' in paper_data:
                question_count += len(paper_data['questions'])
                
                # Validate mark totals
                if 'totalMarks' in paper_data and 'questions' in paper_data:
                    calculated_marks = sum(
                        q.get('marks', 0) or 0 
                        for q in paper_data['questions']
                    )
                    stated_marks = paper_data['totalMarks']
                    
                    if calculated_marks != stated_marks:
                        warnings.append(
                            f"{subject_name} - {paper_name}: "
                            f"Mark mismatch (stated: {stated_marks}, "
                            f"calculated: {calculated_marks})"
                        )
    
    print(f"\n📊 Content Summary:")
    print(f"   Subjects: {subject_count}")
    print(f"   Papers: {paper_count}")
    print(f"   Questions: {question_count}")
    
    # Check totals match
    if data.get('totalSubjects', 0) != subject_count:
        warnings.append(f"totalSubjects mismatch: stated {data.get('totalSubjects')}, found {subject_count}")
    
    if data.get('totalPapers', 0) != paper_count:
        warnings.append(f"totalPapers mismatch: stated {data.get('totalPapers')}, found {paper_count}")
    
    if data.get('totalQuestions', 0) != question_count:
        warnings.append(f"totalQuestions mismatch: stated {data.get('totalQuestions')}, found {question_count}")
    
    if warnings:
        print(f"\n⚠️  Warnings ({len(warnings)}):")
        for warning in warnings:
            print(f"   • {warning}")
    
    if errors:
        return False
    
    print("\n✅ Structure validation: PASSED")
    if warnings:
        print(f"   (with {len(warnings)} warnings)")
    
    return True


def check_diagrams(data):
    """Check diagram descriptions and metadata.
    
    Verifies that diagrams have descriptions and labels listed.
    Reports statistics on total diagrams and any missing metadata.
    
    Args:
        data (dict): The transcription data to check
        
    Returns:
        bool: Always returns True (warnings only, not errors)
    """
    print("\n🖼️  Diagram Check:")
    
    total_diagrams = 0
    diagrams_without_description = []
    diagrams_without_labels = []
    
    for subject_name, subject_data in data.get('subjects', {}).items():
        for paper_name, paper_data in subject_data.get('papers', {}).items():
            for question in paper_data.get('questions', []):
                if question.get('hasDiagram', False):
                    diagram = question.get('diagram')
                    if diagram:
                        if isinstance(diagram, list):
                            total_diagrams += len(diagram)
                            for d in diagram:
                                if not d.get('description'):
                                    diagrams_without_description.append(
                                        f"{subject_name} {paper_name} Q{question['questionNumber']}"
                                    )
                                if not d.get('labels'):
                                    diagrams_without_labels.append(
                                        f"{subject_name} {paper_name} Q{question['questionNumber']}"
                                    )
                        else:
                            total_diagrams += 1
                            if not diagram.get('description'):
                                diagrams_without_description.append(
                                    f"{subject_name} {paper_name} Q{question['questionNumber']}"
                                )
                            if not diagram.get('labels'):
                                diagrams_without_labels.append(
                                    f"{subject_name} {paper_name} Q{question['questionNumber']}"
                                )
    
    print(f"   Total diagrams: {total_diagrams}")
    
    if diagrams_without_description:
        print(f"   ⚠️  {len(diagrams_without_description)} diagram(s) missing descriptions:")
        for loc in diagrams_without_description[:5]:
            print(f"      • {loc}")
        if len(diagrams_without_description) > 5:
            print(f"      ... and {len(diagrams_without_description) - 5} more")
    else:
        print("   ✅ All diagrams have descriptions")
    
    if diagrams_without_labels:
        print(f"   ⚠️  {len(diagrams_without_labels)} diagram(s) have no labels listed")
    else:
        print("   ✅ All diagrams have label information")
    
    return True


def main():
    """Main validation function.
    
    Loads the JSON file, runs all validation checks, and reports results.
    
    Exit codes:
        0: Validation passed
        1: Validation failed or file not found
    """
    if len(sys.argv) != 2:
        print("Usage: python3 validate_transcription.py <json_file>")
        print("\nExample:")
        print("  python3 validate_transcription.py kcse_2024_complete.json")
        sys.exit(1)
    
    filepath = sys.argv[1]
    
    print("=" * 60)
    print("KCSE Transcription Validator")
    print("=" * 60)
    print(f"\nValidating: {filepath}")
    
    # Load the JSON file
    data = load_json(filepath)
    if not data:
        sys.exit(1)
    
    print(f"✅ File loaded successfully ({len(json.dumps(data))} bytes)")
    
    # Run validations
    results = []
    
    # Schema validation
    results.append(validate_schema(data))
    
    # Structure validation
    results.append(validate_structure(data))
    
    # Diagram check
    results.append(check_diagrams(data))
    
    # Final result
    print("\n" + "=" * 60)
    if all(results):
        print("✅ VALIDATION PASSED")
        print("=" * 60)
        sys.exit(0)
    else:
        print("❌ VALIDATION FAILED")
        print("=" * 60)
        sys.exit(1)


if __name__ == '__main__':
    main()
