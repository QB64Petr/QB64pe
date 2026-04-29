Array-return function examples

This folder demonstrates BASIC source functions that return dynamic arrays.

Basic syntax:

FUNCTION MakeValues() AS LONG()
    REDIM MakeValues(1 TO 10) AS LONG
END FUNCTION

REDIM values(0) AS LONG
values() = MakeValues()

Currently supported use:

    target() = FunctionReturningArray(...)

Not supported intentionally:

    PRINT FunctionReturningArray()
    x = FunctionReturningArray()
    UBOUND(FunctionReturningArray())
    SomeSub FunctionReturningArray()
    target(1) = FunctionReturningArray()