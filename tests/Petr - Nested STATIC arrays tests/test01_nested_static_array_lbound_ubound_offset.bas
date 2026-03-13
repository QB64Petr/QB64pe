Option _Explicit

' Test 01
' This program verifies basic declaration rules for static nested arrays inside TYPE,
' and it verifies that LBOUND, UBOUND, and _OFFSET now accept a whole nested array member.
'
' New declaration style for nested static arrays inside TYPE:
'   TYPE Example
'       Grid(0 TO 90, 0 TO 25, 0 TO 5) AS INTEGER
'       Value AS LONG
'   END TYPE
'
' New usage that must work after the compiler changes:
'   PRINT LBOUND(P(0).Grid, 3)
'   PRINT UBOUND(P(49).Grid, 2)
'   PRINT _OFFSET(P(0).Grid)
'
' Important note:
' A nested static array member is still a fixed-size part of the parent TYPE.
' Every element of the parent array owns its own full nested array storage.

Declare Sub ReportCheck (caption As String, ok As Integer)

Type Example
    Grid( 0 To 90 , 0 To 25 , 0 To 5) As Integer
    Value As Long
End Type

Dim Shared PassCount As Long
Dim Shared FailCount As Long

Dim P(0 To 50) As Example
Dim gridOffset As _Offset
Dim valueOffset As _Offset

Print "=== TEST 01: DECLARATION / LBOUND / UBOUND / _OFFSET ==="
Print
Print "This test verifies the new whole-member-array syntax for nested static arrays."
Print

gridOffset = _Offset(P(0).Grid)
valueOffset = _Offset(P(0).Value)

ReportCheck "LBOUND of nested array defaults to dimension 1", LBound(P(0).Grid) = 0
ReportCheck "UBOUND of nested array defaults to dimension 1", UBound(P(0).Grid) = 90
ReportCheck "LBOUND of dimension 2", LBound(P(0).Grid, 2) = 0
ReportCheck "UBOUND of dimension 2", UBound(P(0).Grid, 2) = 25
ReportCheck "LBOUND of dimension 3", LBound(P(0).Grid, 3) = 0
ReportCheck "UBOUND of dimension 3", UBound(P(0).Grid, 3) = 5
ReportCheck "_OFFSET of nested array member is before the following scalar member", gridOffset < valueOffset
ReportCheck "_OFFSET of nested array member is stable and non-zero-ish", gridOffset <> 0

Print
Print "Grid offset  : "; gridOffset
Print "Value offset : "; valueOffset
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
