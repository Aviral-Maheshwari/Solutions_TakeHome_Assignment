#!/bin/bash

# AMFI NAV Data Extractor
# Extracts Scheme Name and Net Asset Value from AMFI data
# Output: TSV file with two columns

URL="https://portal.amfiindia.com/spages/NAVAll.txt"
OUTPUT_FILE="scheme_nav_data.tsv"
TEMP_FILE="/tmp/amfi_nav_temp.txt"

echo "Downloading AMFI NAV data..."
if ! curl -s "$URL" -o "$TEMP_FILE"; then
    echo "Error: Failed to download data from $URL"
    exit 1
fi

echo "Processing data..."
echo "File size: $(wc -c < "$TEMP_FILE") bytes"
echo "Total lines: $(wc -l < "$TEMP_FILE")"

# Debug: Show first 20 lines
echo ""
echo "First 20 lines of downloaded file:"
head -20 "$TEMP_FILE"
echo ""

# Create TSV file with header
echo -e "Scheme Name\tNet Asset Value" > "$OUTPUT_FILE"

# Process the file
# The AMFI file format: Scheme Code;ISIN1;ISIN2;Scheme Name;Net Asset Value;Date
awk -F';' '
    BEGIN {
        count = 0
    }
    
    # Skip empty lines
    /^[[:space:]]*$/ { next }
    
    # Skip header line
    /^Scheme Code;/ { next }
    
    # Only process lines with exactly 6 fields (valid data rows)
    NF == 6 {
        scheme_code = $1
        scheme_name = $4
        nav = $5
        
        # Remove leading/trailing whitespace
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", scheme_code)
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", scheme_name)
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", nav)
        
        # Check if this looks like a valid data row
        # scheme_code should be numeric, nav should be numeric
        if (scheme_code ~ /^[0-9]+$/ && nav ~ /^[0-9]+(\.[0-9]+)?$/ && scheme_name != "") {
            gsub(/\t/, " ", scheme_name)
            print scheme_name "\t" nav
            count++
        }
    }
    
    END {
        print "Processed " count " records" > "/dev/stderr"
    }
' "$TEMP_FILE" >> "$OUTPUT_FILE"

# Count records
RECORD_COUNT=$(wc -l < "$OUTPUT_FILE")
RECORD_COUNT=$((RECORD_COUNT - 1))  # Subtract header

echo ""
echo "Extraction complete!"
echo "Output file: $OUTPUT_FILE"
echo "Total records extracted: $RECORD_COUNT"

# Cleanup
rm -f "$TEMP_FILE"

# Display first 10 rows
if [ $RECORD_COUNT -gt 0 ]; then
    echo ""
    echo "First 10 rows:"
    head -11 "$OUTPUT_FILE" | column -t -s $'\t'
else
    echo ""
    echo "WARNING: No records were extracted!"
    echo "Please check the file format or run with debug output above."
fi