import allo
from allo.ir.types import int32
import numpy as np

def add(a: int32, b: int32) -> int32:
  return a + b

def vvadd[N](A: int32[N], B: int32[N]) -> int32[N]:
  C: int32[N] = 0
  for i in range(N):
    C[i] = A[i] + B[i]
  return C

def mv[N](A: int32[N, N], x: int32[N]) -> int32[N]:
  C: int32[N] = 0
  for i, j in allo.grid(N, N):
    C[i] += A[i, j] * x[j]
  return C

def mm[N](A: int32[N, N], B: int32[N, N]) -> int32[N, N]:
  C: int32[N, N] = 0
  for i, j, k in allo.grid(N, N, N):
    C[i, j] += A[i, k] * B[k, j]
  return C