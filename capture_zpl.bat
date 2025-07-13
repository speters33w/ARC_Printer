@echo off
echo ZPL Capture Tool
echo ================
echo.

echo Step 1: Capturing ZPL data with ncat...
echo Press Ctrl+C when you're done capturing data
echo.

ncat.exe" -l -p 5964 > "C:\OneDrive\Documents\ProblemSolve"

echo.
echo Step 1 complete: ZPL data saved to %USERPROFILE%\Documents\ProblemSolve\saved_zpl.zpl
echo.

echo Step 2: Running Python ZPL capture script...
echo Press Ctrl+C when you're done capturing data
echo.

python "%USERPROFILE%\Documents\ProblemSolve\zpl_capture.py"

echo.
echo Step 2 complete: ZPL data saved to output.zpl
echo.

echo All capture operations completed!
pause