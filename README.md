# Physiological Signal Analysis Dashboard

A web-based dashboard for analyzing physiological signals including respiration, PPG, and fMRI data with z-score normalization.

## Features

- **Manual QA**: Review signal quality with z-score metrics and time series visualization
- **Fix**: Apply corrections like drift removal, bandpass filtering, and artifact rejection
- **Group Results**: Statistical analysis and fMRI-physiology coupling analysis

## Running the Dashboard

### Method 1: Direct File Opening
```bash
# Open directly in your web browser
open dashboard.html
# or
xdg-open dashboard.html  # Linux
# or
start dashboard.html     # Windows
```

### Method 2: HTTP Server (Recommended)
```bash
# Start a local HTTP server
python3 -m http.server 9000

# Then open in your browser:
# http://localhost:9000/dashboard.html
```

### Method 3: Alternative HTTP Server
```bash
# Using Node.js (if installed)
npx serve .

# Or using PHP (if installed)
php -S localhost:8080
```

## Usage

1. Open the dashboard in your web browser
2. Navigate between tabs:
   - **Manual QA**: Review signal quality metrics and charts
   - **Fix**: View and apply signal corrections
   - **Group Results**: Analyze group statistics and correlations
3. The dashboard displays z-score normalized physiological data
4. All interactions are handled through the web interface

## Requirements

- Modern web browser (Chrome, Firefox, Safari, Edge)
- No additional dependencies required for basic usage
- Python 3 for HTTP server method (optional)

## Technical Details

- Pure HTML/CSS/JavaScript implementation
- Responsive design for various screen sizes
- Tab-based navigation with interactive content
- Mock data for demonstration purposes