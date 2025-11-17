import allo
from allo.ir.types import int32
import numpy as np

def add[T](A: "T[1, 1]", B: "T[1, 1]") -> "T[1, 1]":
    C: "T[1, 1]" = A[0, 0] + B[0, 0]
    return C

s = allo.customize(add, instantiate=[int32])
print(s.module)

# Build LLVM module
mod = s.build(target="llvm")

code = s.build(target="vhls")
print(code)

A = np.random.randint(-1000, 1000, size=(1, 1), dtype=np.int32)
B = np.random.randint(-1000, 1000, size=(1, 1), dtype=np.int32)

C = mod(A, B)

C_ref = A + B

print("Input A =", A)
print("Input B =", B)
print("Allo Output C =", C)
print("NumPy Reference C_ref =", C_ref)

if np.array_equal(C, C_ref):
    print("PASS: Allo add output matches NumPy reference!")
else:
    print("FAIL: Outputs differ!")
