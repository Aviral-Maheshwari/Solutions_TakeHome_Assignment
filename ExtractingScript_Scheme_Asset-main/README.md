# AMFI NAV Data Extractor

A lightweight shell script to extract mutual fund scheme names and Net Asset Values (NAV) from the AMFI (Association of Mutual Funds in India) daily NAV data feed.

## Overview

This script downloads the latest NAV data from AMFI's official source and extracts only the scheme names and their corresponding NAV values into a clean, tab-separated values (TSV) format for easy analysis.

## Features

- 🚀 **Simple & Fast** - Pure bash script with no dependencies beyond standard Unix tools
- 📊 **Clean Output** - TSV format for easy import into Excel, pandas, or databases
- 🔍 **Data Validation** - Filters invalid entries and ensures numeric NAV values
- 🐛 **Debug Mode** - Built-in debugging output to troubleshoot data extraction
- 💾 **Lightweight** - Extracts only what you need (scheme name and NAV)

## Prerequisites

- `bash` (version 4.0+)
- `curl` - for downloading data
- `awk` - for data processing
- `column` - for formatted output (optional)

These tools are pre-installed on most Linux/Unix systems and macOS.

## Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/amfi-nav-extractor.git
cd amfi-nav-extractor
```

2. Make the script executable:
```bash
chmod +x extract_nav.sh
```

## Usage

Simply run the script:
```bash
./extract_nav.sh
```

The script will:
1. Download the latest NAV data from AMFI
2. Extract scheme names and NAV values
3. Save results to `scheme_nav_data.tsv`
4. Display a preview of the first 10 records

### Output

The script generates a TSV file with two columns:
```
Scheme Name                                              Net Asset Value
Aditya Birla Sun Life Banking & PSU Debt Fund - Growth   384.1015
Axis Banking & PSU Debt Fund - Direct Plan - Growth      2743.7004
HDFC Banking and PSU Debt Fund - Growth Option           24.1866
```

## Data Source

Data is fetched from the official AMFI NAV feed:
- **URL**: https://www.amfiindia.com/spages/NAVAll.txt
- **Update Frequency**: Daily (business days)
- **Format**: Semicolon-separated values

## File Structure
```
ExtractingScript_Scheme_Asset/
├── extract_nav.sh           # Main extraction script
├── scheme_nav_data.tsv      # Output file (generated)
└── README.md                # This file
```

## Configuration

You can modify these variables in the script:
```bash
URL="https://portal.amfiindia.com/spages/NAVAll.txt"  # Data source
OUTPUT_FILE="scheme_nav_data.tsv"                   # Output filename
TEMP_FILE="/tmp/amfi_nav_temp.txt"                  # Temporary file location
```

## Troubleshooting

### Empty output file

If the TSV file only contains headers:

1. Check the debug output showing the first 20 lines
2. Verify the data source is accessible
3. Ensure the file format hasn't changed

### Network issues

If download fails:
```bash
# Test the URL manually
curl -I https://www.amfiindia.com/spages/NAVAll.txt
```

### Permission errors

Ensure write permissions:
```bash
chmod +w .
```

## Why TSV instead of JSON?

For this use case, TSV is superior:

✅ **Simpler** - Flat tabular data doesn't need nested structure  
✅ **Smaller** - No JSON syntax overhead (important for 40,000+ records)  
✅ **Faster** - Direct import to Excel, pandas, SQL databases  
✅ **Standard** - Financial data is typically distributed as CSV/TSV  

JSON would be better for nested data or API responses, but for pure name-value pairs, TSV is the right choice.

## Benifits of JSON over TSV
JSON, on the other hand:

- ✅ Is structured and self-describing (each value is tied to a key).
- ✅ Plays nicely with APIs, JavaScript, and most programming languages.
- ✅ Supports nested or hierarchical data (e.g., fund house → multiple schemes).
- ✅ Easier for downstream systems (like fintech apps) to consume directly.

## Example: Loading in Python
```python
import pandas as pd

# Load the TSV file
df = pd.read_csv('scheme_nav_data.tsv', sep='\t')

# Quick analysis
print(f"Total schemes: {len(df)}")
print(f"Average NAV: {df['Net Asset Value'].mean():.2f}")
print(f"Highest NAV: {df['Net Asset Value'].max():.2f}")

# Filter specific schemes
equity_funds = df[df['Scheme Name'].str.contains('Equity', case=False)]
```

## Example: Loading in Excel

1. Open Excel
2. Go to **Data** → **From Text/CSV**
3. Select `scheme_nav_data.tsv`
4. Choose **Tab** as delimiter
5. Click **Load**

## Author
[Aviral-Maheshwari](https://github.com/Aviral-Maheshwari)

## Acknowledgments

- Data provided by AMFI (Association of Mutual Funds in India)
- Inspired by the need for simple, scriptable financial data extraction
