Option _Explicit

' Test 05
' This is a regression test for _MEMIMAGE.
'
' Important clarification:
' _MEMIMAGE is NOT the feature used for nested static arrays inside TYPE.
' _MEMIMAGE still works only with image handles.
' The new nested-array support uses _MEM(...) on a whole nested member array, not _MEMIMAGE(...).
'
' This program exists to verify that the nested-array compiler changes did not break the classic image-memory path.
' In other words:
'   Use _MEM(Parent(0).Grid) for nested static arrays inside TYPE.
'   Use _MEMIMAGE(imageHandle) for image pixel memory.

Declare Sub ReportCheck (caption As String, ok As Integer)

Dim Shared PassCount As Long
Dim Shared FailCount As Long

Dim img As Long
Dim m As _MEM
Dim pixelValue As _Unsigned Long

Print "=== TEST 05: _MEMIMAGE REGRESSION ==="
Print
Print "This test verifies that _MEMIMAGE remains an image-only feature."
Print

img = _NewImage(4, 4, 32)
_Dest img
Cls , _RGB32(0, 0, 0)
PSet (0, 0), _RGB32(17, 34, 51)
PSet (1, 0), _RGB32(68, 85, 102)

m = _MemImage(img)
_MemGet m, m.OFFSET, pixelValue

ReportCheck "_MEMIMAGE returns a live memory block", _MemExists(m)
ReportCheck "_MEMIMAGE remembers the image handle", m.IMAGE = img
ReportCheck "32-bit image memory reports 4-byte elements", m.ELEMENTSIZE = 4
ReportCheck "32-bit 4x4 image memory reports at least 64 bytes", m.SIZE >= 64
ReportCheck "_MEMGET can read the first 32-bit pixel from the image memory block", pixelValue <> 0

_MemFree m
_FreeImage img

Print
Print "Pass count: "; PassCount
Print "Fail count: "; FailCount

If FailCount = 0 Then
    Print "RESULT: PASS"
Else
    Print "RESULT: FAIL"
End If

Sleep
End

Sub ReportCheck (caption As String, ok As Integer)
    If ok Then
        PassCount = PassCount + 1
        Print "PASS - "; caption
    Else
        FailCount = FailCount + 1
        Print "FAIL - "; caption
    End If
End Sub
