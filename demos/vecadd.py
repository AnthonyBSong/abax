import allo
from allo.ir.types import int32
import numpy as np

M = 64

def vecadd[T](A: "T[1, M]", B: "T[1, M]") -> "T[1, M]":
    C: "T[1, M]" = 0
    for i, j in allo.grid(1, M):
        C[i, j] += A[i, j] + B[i, j]
    return C

s = allo.customize(vecadd, instantiate=[int32])
s.unroll("j", factor=M)

print(s.module)
mod = s.build(target="llvm")

code = s.build(target="vhls")
print(code)

# Create valid 1xM arrays
A = np.random.randint(-1000, 1000, size=(1, M), dtype=np.int32)
B = np.random.randint(-1000, 1000, size=(1, M), dtype=np.int32)

# Run the module
C = mod(A, B)
C_ref = A + B

#print("Input A =", A)
#print("Input B =", B)
#print("Output C =", C)
#print("Numpy Reference C_ref =", C_ref)

if np.array_equal(C, C_ref):
    print("PASS: Allo output matches NumPy reference!")
else:
    print("FAIL: Outputs differ!")
