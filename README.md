# Physiological Signal Analysis Dashboard

A web-based dashboard for analyzing physiological signals (respiration and PPG) concurrent with fMRI data collection, featuring z-score normalization and interactive quality assessment tools.

## Features

### Manual QA Tab
- **Interactive Time Series**: Drag to zoom, Shift+drag to pan signal visualizations
- **QA Buttons**: Rate signal quality as Good, Fixable, Bad, or Uncertain for each signal type
- **Comments Section**: Record detailed QA notes with auto-save functionality
- **Real-time Stats**: Display z-score metrics and signal quality percentages

### Fix Tab
- **Signal Correction Tools**: Drift removal, bandpass filtering, artifact rejection
- **Status Tracking**: Before/after comparison table showing applied corrections
- **Quality Improvement**: Track z-score improvements after fixes

### Group Results Tab  
- **Participant Statistics**: Overview of 24 participants with demographic data
- **Interactive Scatter Plot**: Click points to view individual participant reports
- **Signal Quality Distribution**: Histogram showing quality score distribution
- **Export Functionality**: Download data in MATLAB, Python, or CSV formats

## How to Run the Dashboard

### ⚠️ Important: Always Use HTTP Server

**Direct file opening (`open dashboard.html`) will NOT work properly** due to browser security restrictions. Always use an HTTP server:

### Method 1: Python HTTP Server (Recommended)

```bash
# Navigate to project directory
cd /path/to/v1_mockup

# Start HTTP server on port 8080
python3 -m http.server 8080

# Open in browser
# Local: http://localhost:8080/dashboard.html
# Remote: http://[your-server-ip]:8080/dashboard.html
```

### Method 2: Alternative Ports
```bash
# If port 8080 is busy, try different ports
python3 -m http.server 8081
python3 -m http.server 9000
```

### Method 3: Remote Access via SSH Tunnel
```bash
# On your local machine, create SSH tunnel
ssh -L 8080:localhost:8080 user@your-server

# Start server on remote machine
python3 -m http.server 8080

# Access locally: http://localhost:8080/dashboard.html
```

## After Making Code Changes

When you modify `dashboard.html`:

1. **Changes are automatic** - HTTP server serves updated file immediately
2. **Hard refresh browser**: 
   - Windows/Linux: `Ctrl + F5`
   - Mac: `Cmd + Shift + R`
3. **Clear cache if needed**: Use incognito/private browsing mode
4. **Check for errors**: Open browser console (F12) for JavaScript errors

### Troubleshooting Loading Issues

**Dashboard shows blank page or doesn't load:**

1. **Check server is running:**
   ```bash
   ps aux | grep http.server
   ```

2. **Verify port availability:**
   ```bash
   netstat -tulpn | grep :8080
   curl -I http://localhost:8080/dashboard.html
   ```

3. **Kill old servers and restart:**
   ```bash
   # Find process ID
   ps aux | grep http.server
   # Kill it (replace XXXX with actual PID)
   kill XXXX
   # Restart
   python3 -m http.server 8080
   ```

4. **Try different browser or incognito mode**

5. **Check JavaScript console for errors** (Press F12)

## Data Persistence

The dashboard automatically saves:
- **QA Ratings**: Respiration and PPG quality assessments
- **Comments**: User notes and observations
- **Session Data**: Persisted across browser sessions using localStorage

Data is stored locally in browser - export functionality simulates backend integration.

## Interactive Features

### Manual QA Tab
- **Chart Navigation**: 
  - Drag to zoom into time ranges
  - Shift+drag to pan across signals
  - Reset zoom buttons to return to full view
- **QA Assessment**: Click quality buttons to rate each signal
- **Auto-save Comments**: Typing automatically saves after 2 seconds

### Group Results Tab
- **Scatter Plot Interaction**: Click correlation points to view individual reports
- **Dynamic Reports**: Participant details load based on selection
- **Export Simulation**: Buttons demonstrate data export workflow

## Browser Compatibility

**Supported:**
- Chrome/Chromium 80+ (recommended)
- Firefox 75+
- Safari 13+
- Edge 80+

**Requires:**
- HTML5 Canvas support
- ES6 JavaScript (arrow functions, const/let)
- localStorage API

## File Structure

```
v1_mockup/
├── dashboard.html          # Main application (single file)
├── README.md              # Documentation
└── test.html              # Server connectivity test
```

## Development Notes

- **Single File Application**: Everything contained in `dashboard.html`
- **No Build Process**: Direct browser execution
- **Mock Data**: Simulated physiological signals and participant data
- **Responsive Design**: Works on desktop and tablet screens
- **Canvas Rendering**: Custom chart implementation for performance

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Blank dashboard | Use HTTP server, not direct file opening |
| Changes not visible | Hard refresh (Ctrl+F5) or use incognito mode |
| Port conflict | Use different port: `python3 -m http.server 8081` |
| Slow loading | Check for JavaScript errors in browser console |
| QA buttons not working | Ensure HTTP server is serving the latest file |

## Next Steps for Production

1. **Backend Integration**: Replace localStorage with database
2. **Real Data**: Connect to actual physiological signal processing pipeline  
3. **Authentication**: Add user login and session management
4. **Export Implementation**: Create actual file download endpoints
5. **Performance**: Optimize for large datasets