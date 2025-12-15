#!/bin/bash

# KCSE Exam Paper Transcription Helper Script
# This script helps prepare exam paper images for AI transcription

set -e

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}KCSE Exam Paper Transcription Helper${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if year parameter is provided
if [ -z "$1" ]; then
    echo -e "${YELLOW}Usage: ./prepare_transcription.sh <year>${NC}"
    echo ""
    echo "Example: ./prepare_transcription.sh 2024"
    echo ""
    echo "Available years in this repository:"
    ls -d */ 2>/dev/null | grep -E "^[0-9]{4}/$" | sed 's/\///' | sort || echo "No year folders found"
    exit 1
fi

YEAR=$1
CURRENT_DATE=$(date +%Y-%m-%d)

# Check if year folder exists
if [ ! -d "$YEAR" ]; then
    echo -e "${YELLOW}Error: Year folder '$YEAR' not found!${NC}"
    echo ""
    echo "Available years:"
    ls -d */ 2>/dev/null | grep -E "^[0-9]{4}/$" | sed 's/\///' | sort || echo "No year folders found"
    exit 1
fi

echo -e "${GREEN}✓ Found year folder: $YEAR${NC}"
echo ""

# Count total images
TOTAL_IMAGES=$(find "$YEAR" -name "*.png" | wc -l)
echo -e "${GREEN}✓ Found $TOTAL_IMAGES image files${NC}"

# List subjects available
echo ""
echo "Subjects found in $YEAR:"
ls -1 "$YEAR" 2>/dev/null | while read subject; do
    if [ -d "$YEAR/$subject" ]; then
        PAPERS=$(ls -1 "$YEAR/$subject" 2>/dev/null | wc -l)
        echo "  - $subject ($PAPERS papers)"
    fi
done

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Next Steps:${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "1. Open: TRANSCRIPTION_PROMPT.md"
echo ""
echo "2. Replace these variables:"
echo "   {{YEAR}} → $YEAR"
echo "   {{CURRENT_DATE}} → $CURRENT_DATE"
echo ""
echo "3. Collect all images from:"
echo "   $YEAR/*/paper*/*.png"
echo ""
echo "4. Send the customized prompt + all images to an AI vision model"
echo "   (e.g., GPT-4 Vision, Claude with vision)"
echo ""
echo "5. Save the output as:"
echo "   kcse_${YEAR}_complete.json"
echo ""
echo "6. Validate the JSON against schema.json"
echo ""
echo -e "${GREEN}Total images to process: $TOTAL_IMAGES${NC}"
echo ""

# Create a summary file
SUMMARY_FILE="transcription_summary_${YEAR}.txt"
echo "KCSE Exam Paper Transcription - Year $YEAR" > "$SUMMARY_FILE"
echo "Generated: $CURRENT_DATE" >> "$SUMMARY_FILE"
echo "" >> "$SUMMARY_FILE"
echo "Total Images: $TOTAL_IMAGES" >> "$SUMMARY_FILE"
echo "" >> "$SUMMARY_FILE"
echo "Subjects and Papers:" >> "$SUMMARY_FILE"
ls -1 "$YEAR" 2>/dev/null | while read subject; do
    if [ -d "$YEAR/$subject" ]; then
        echo "" >> "$SUMMARY_FILE"
        echo "$subject:" >> "$SUMMARY_FILE"
        ls -1 "$YEAR/$subject" 2>/dev/null | while read paper; do
            if [ -d "$YEAR/$subject/$paper" ]; then
                IMG_COUNT=$(find "$YEAR/$subject/$paper" -name "*.png" | wc -l)
                echo "  - $paper: $IMG_COUNT images" >> "$SUMMARY_FILE"
            fi
        done
    fi
done

echo -e "${GREEN}✓ Summary saved to: $SUMMARY_FILE${NC}"
echo ""
