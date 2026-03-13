Option _Explicit

' Test 00
' This file is a small reference and smoke test.
' It shows how to declare nested static arrays inside TYPE and how to use the new syntax.
'
' Declaration example:
'   TYPE Example
'       Grid(0 TO 3, 0 TO 2, 0 TO 1) AS INTEGER
'       Value AS LONG
'   END TYPE
'   DIM Items(0 TO 4) AS Example
'
' New whole-member-array operations supported by the compiler changes:
'   PRINT LBOUND(Items(0).Grid, 3)
'   PRINT UBOUND(Items(0).Grid, 2)
'   PRINT _OFFSET(Items(0).Grid)
'   m = _MEM(Items(0).Grid)
'   _MEMGET m, m.OFFSET, Other(0).Grid
'   _MEMPUT m, m.OFFSET, Other(0).Grid
'   _MEMFILL m, m.OFFSET, m.SIZE, 0 AS INTEGER
'   _MEMFILL m, m.OFFSET, m.SIZE, Other(0).Grid
'   _MEMCOPY sourceMem, sourceMem.OFFSET, sourceMem.SIZE TO destMem, destMem.OFFSET
'   ERASE Items(0).Grid
'   ERASE Items
'
' Clarification about _MEMIMAGE:
'   _MEMIMAGE is not used for nested static arrays in TYPE.
'   _MEMIMAGE remains the image-memory API and still requires an image handle.
'   For nested static arrays, use _MEM(memberArray) instead.

Type Example
    Grid( 0 To 3 , 0 To 2 , 0 To 1) As Integer
    Value As Long
End Type

Dim Items(0 To 1) As Example
Dim Other(0) As Example
Dim m As _MEM
Dim sourceMem As _MEM
Dim destMem As _MEM
Dim i As Long
Dim j As Long
Dim k As Long
Dim n As Long

Print "=== TEST 00: USAGE REFERENCE / SMOKE TEST ==="
Print
Print "This file demonstrates the new nested static array syntax in one place."
Print

n = 1
For i = 0 To 3
    For j = 0 To 2
        For k = 0 To 1
            Items(0).Grid(i, j, k) = n
            n = n + 1
        Next k
    Next j
Next i
Items(0).Value = 12345
Other(0).Value = 54321

Print "LBOUND dimension 1:"; LBound(Items(0).Grid)
Print "UBOUND dimension 2:"; UBound(Items(0).Grid, 2)
Print "LBOUND dimension 3:"; LBound(Items(0).Grid, 3)
Print "_OFFSET(Grid):"; _Offset(Items(0).Grid)
Print "_OFFSET(Value):"; _Offset(Items(0).Value)

m = _Mem(Items(0).Grid)
Print "_MEM size:"; m.SIZE
Print "_MEM element size:"; m.ELEMENTSIZE
_MemGet m, m.OFFSET, Other(0).Grid
Print "After _MEMGET, Other first value:"; Other(0).Grid(0, 0, 0)

Other(0).Grid(0, 0, 0) = 777
_MemPut m, m.OFFSET, Other(0).Grid
Print "After _MEMPUT, Items first value:"; Items(0).Grid(0, 0, 0)

_MemFill m, m.OFFSET, m.SIZE, 0 As Integer
Print "After numeric _MEMFILL, Items first value:"; Items(0).Grid(0, 0, 0)

sourceMem = _Mem(Other(0).Grid)
destMem = _Mem(Items(0).Grid)
_MemCopy sourceMem, sourceMem.OFFSET, sourceMem.SIZE To destMem, destMem.OFFSET
Print "After _MEMCOPY, Items first value:"; Items(0).Grid(0, 0, 0)

Erase Other ( 0 ) . Grid
Print "After ERASE Other(0).Grid, Other first value:"; Other(0).Grid(0, 0, 0)
Print "After ERASE Other(0).Grid, Other scalar still exists:"; Other(0).Value

Erase Items
Print "After ERASE Items, Items first value:"; Items(0).Grid(0, 0, 0)
Print "After ERASE Items, Items scalar value:"; Items(0).Value

_MemFree m
_MemFree sourceMem
_MemFree destMem

Print
Print "SMOKE TEST FINISHED"
Sleep
End
