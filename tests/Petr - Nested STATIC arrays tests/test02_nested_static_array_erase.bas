Option _Explicit

' Test 02
' This program verifies ERASE behavior for nested static arrays inside TYPE.
'
' New usage that must work after the compiler changes:
'   ERASE P(0).Grid   ' clears only the nested array member inside one parent element
'   ERASE P           ' clears the whole parent array, including every nested array member
'
' Expected semantics:
'   1) ERASE P(0).Grid must zero only P(0).Grid and must not destroy P(0).Value or P(1).
'   2) ERASE P must zero the whole parent array, including nested array members and scalar members.

Declare Sub ReportCheck (caption As String, ok As Integer)
Declare Sub FillPattern (item As Example, seed As Long)
Declare Sub CheckAllZero (caption As String, item As Example)
Declare Sub CheckNotTouched (caption As String, item As Example, seed As Long)

Type Example
    Grid( 0 To 2 , 0 To 1 , 0 To 3) As Integer
    Value As Long
End Type

Dim Shared PassCount As Long
Dim Shared FailCount As Long

Dim P(0 To 1) As Example

Print "=== TEST 02: ERASE ON NESTED STATIC ARRAYS ==="
Print
Print "This test verifies both member-only erase and full parent-array erase."
Print

FillPattern P(0), 100
FillPattern P(1), 200

Erase P ( 0 ) . Grid

CheckAllZero "ERASE P(0).Grid clears only the nested array member", P(0)
ReportCheck "ERASE P(0).Grid keeps P(0).Value unchanged", P(0).Value = 100000
CheckNotTouched "ERASE P(0).Grid does not touch other parent elements", P(1), 200

Erase P

CheckAllZero "ERASE P clears P(0) completely", P(0)
CheckAllZero "ERASE P clears P(1) completely", P(1)
ReportCheck "ERASE P resets P(0).Value", P(0).Value = 0
ReportCheck "ERASE P resets P(1).Value", P(1).Value = 0

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

Sub FillPattern (item As Example, seed As Long)
    Dim i As Long
    Dim j As Long
    Dim k As Long
    Dim n As Long

    n = seed
    For i = 0 To 2
        For j = 0 To 1
            For k = 0 To 3
                item.Grid(i, j, k) = n
                n = n + 1
            Next k
        Next j
    Next i

    item.Value = seed * 1000
End Sub

Sub CheckAllZero (caption As String, item As Example)
    Dim i As Long
    Dim j As Long
    Dim k As Long
    Dim ok As Integer

    ok = -1
    For i = 0 To 2
        For j = 0 To 1
            For k = 0 To 3
                If item.Grid(i, j, k) <> 0 Then ok = 0
            Next k
        Next j
    Next i

    ReportCheck caption, ok
End Sub

Sub CheckNotTouched (caption As String, item As Example, seed As Long)
    Dim i As Long
    Dim j As Long
    Dim k As Long
    Dim n As Long
    Dim ok As Integer

    ok = -1
    n = seed
    For i = 0 To 2
        For j = 0 To 1
            For k = 0 To 3
                If item.Grid(i, j, k) <> n Then ok = 0
                n = n + 1
            Next k
        Next j
    Next i

    If item.Value <> seed * 1000 Then ok = 0

    ReportCheck caption, ok
End Sub
