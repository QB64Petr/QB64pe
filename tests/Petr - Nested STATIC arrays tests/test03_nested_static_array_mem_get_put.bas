Option _Explicit

' Test 03
' This program verifies _MEM, _MEMGET, _MEMPUT, and _OFFSET on a whole nested static array member.
'
' New usage that must work after the compiler changes:
'   m = _MEM(A(0).Grid)
'   _MEMGET m, m.OFFSET, B(0).Grid
'   _MEMPUT m, m.OFFSET, B(0).Grid
'   PRINT _OFFSET(A(0).Grid)
'
' Important note:
' Use _MEM with a nested static array member when you want a memory block that covers
' the entire member array. The returned block starts at the first element of that member array,
' and its size is the full byte size of the member array.

Declare Sub ReportCheck (caption As String, ok As Integer)
Declare Sub FillPattern (item As Example, seed As Long)
Declare Sub CheckPattern (caption As String, item As Example, seed As Long)

Type Example
    Grid( 0 To 2 , 0 To 1 , 0 To 3) As Integer
    Value As Long
End Type

Dim Shared PassCount As Long
Dim Shared FailCount As Long

Dim A(0 To 1) As Example
Dim B(0 To 1) As Example
Dim m As _MEM
Dim expectedBytes As Long
Dim gridOffset As _Offset
Dim valueOffset As _Offset
Dim okSize As Integer
Dim okElem As Integer
Dim intSize As Long
Dim elementByteSize As Integer

Print "=== TEST 03: _MEM / _MEMGET / _MEMPUT / _OFFSET ==="
Print
Print "This test verifies memory access for a whole nested static array member."
Print

FillPattern A(0), 1
FillPattern A(1), 1000
Erase B ( 0 ) . Grid
B(0).Value = 999999

m = _Mem(A(0).Grid)

' Do NOT use LEN(A(0).Grid(0,0,0)) here.
' In the current experimental compiler state, LEN on that expression is still
' being resolved incorrectly and returns the byte size of the whole nested member array.
' Use a plain INTEGER variable instead so the expected element size is unambiguous.
intSize = Len(elementByteSize)

expectedBytes = (3 * 2 * 4) * intSize
gridOffset = _Offset(A(0).Grid)
valueOffset = _Offset(A(0).Value)

Print "Actual _MEM.SIZE ="; m.SIZE
Print "Actual _MEM.ELEMENTSIZE ="; m.ELEMENTSIZE
Print "Expected _MEM.SIZE ="; expectedBytes
Print "Expected _MEM.ELEMENTSIZE ="; intSize
Print

okSize = 0
okElem = 0
If m.SIZE = expectedBytes Then okSize = -1
If m.ELEMENTSIZE = intSize Then okElem = -1

ReportCheck "_MEM size equals the full nested array byte size", okSize
ReportCheck "_MEM element size equals INTEGER size", okElem

If gridOffset < valueOffset Then
    ReportCheck "_OFFSET of nested array member is before _OFFSET of the next scalar member", -1
Else
    ReportCheck "_OFFSET of nested array member is before _OFFSET of the next scalar member", 0
End If

_MemGet m, m.OFFSET, B(0).Grid
CheckPattern "_MEMGET copies a whole nested array member into another nested array member", B(0), 1

If B(0).Value = 999999 Then
    ReportCheck "_MEMGET does not overwrite unrelated scalar data in the destination parent element", -1
Else
    ReportCheck "_MEMGET does not overwrite unrelated scalar data in the destination parent element", 0
End If

B(0).Grid(0, 0, 0) = 777
B(0).Grid(2, 1, 3) = 888
_MemPut m, m.OFFSET, B(0).Grid

If A(0).Grid(0, 0, 0) = 777 Then
    ReportCheck "_MEMPUT writes the first element back into the source nested array member", -1
Else
    ReportCheck "_MEMPUT writes the first element back into the source nested array member", 0
End If

If A(0).Grid(2, 1, 3) = 888 Then
    ReportCheck "_MEMPUT writes the last element back into the source nested array member", -1
Else
    ReportCheck "_MEMPUT writes the last element back into the source nested array member", 0
End If

_MemFree m

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

