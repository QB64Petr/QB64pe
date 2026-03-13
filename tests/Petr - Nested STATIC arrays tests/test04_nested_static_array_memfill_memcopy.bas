Option _Explicit

' Test 04
' This program verifies _MEMFILL and _MEMCOPY with whole nested static array members.
'
' New usage that must work after the compiler changes:
'   dstMem = _MEM(Target(0).Grid)
'   _MEMFILL dstMem, dstMem.OFFSET, dstMem.SIZE, 0 AS INTEGER
'   _MEMFILL dstMem, dstMem.OFFSET, dstMem.SIZE, Source(0).Grid
'   _MEMCOPY srcMem, srcMem.OFFSET, srcMem.SIZE TO dstMem, dstMem.OFFSET
'
' Important note about _MEMFILL:
' The classic usage still works exactly as before.
' The new extension allows the fill value to be a whole nested static array member.
' If the fill byte count matches the member-array size exactly, the result acts like a full byte-for-byte clone.

Declare Sub ReportCheck (caption As String, ok As Integer)
Declare Sub FillPattern (item As Example, seed As Long)
Declare Sub CheckPattern (caption As String, item As Example, seed As Long)
Declare Sub CheckAllZero (caption As String, item As Example)

Type Example
    Grid(0 To 2, 0 To 1, 0 To 3) As Integer
    Value As Long
End Type

Dim Shared PassCount As Long
Dim Shared FailCount As Long

Dim Source(0 To 1) As Example
Dim Target(0 To 1) As Example
Dim srcMem As _MEM
Dim dstMem As _MEM

Print "=== TEST 04: _MEMFILL / _MEMCOPY ==="
Print
Print "This test verifies fill and copy operations on whole nested static arrays."
Print

FillPattern Source(0), 10
FillPattern Target(0), 500

srcMem = _Mem(Source(0).Grid)
dstMem = _Mem(Target(0).Grid)

_MemFill dstMem, dstMem.OFFSET, dstMem.SIZE, 0 As Integer
CheckAllZero "_MEMFILL with a numeric value clears the whole nested array member", Target(0)

_MemFill dstMem, dstMem.OFFSET, dstMem.SIZE, Source(0).Grid
CheckPattern "_MEMFILL with a whole nested array member clones matching bytes correctly", Target(0), 10

FillPattern Source(0), 700
_MemCopy srcMem, srcMem.OFFSET, srcMem.SIZE To dstMem, dstMem.OFFSET
CheckPattern "_MEMCOPY transfers the whole nested array member correctly", Target(0), 700

_MemFree srcMem
_MemFree dstMem

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

Sub CheckPattern (caption As String, item As Example, seed As Long)
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

    ReportCheck caption, ok
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
