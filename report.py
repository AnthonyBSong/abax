"""
Allo -> DSLX flow examples: add, vvadd, mv, and mm
"""

import allo
from allo.ir.types import int32, uint32
import numpy as np

# ============================================================================
# Function Definitions
# ============================================================================

def add(a: uint32, b: uint32) -> uint32:
    return a + b

def vvadd(a: int32[16], b: int32[16]) -> int32[16]:
    c: int32[16] = 0
    for i in range(16):
        c[i] = a[i] + b[i]
    return c

def mv(A: int32[4, 4], x: int32[4]) -> int32[4]:
    C: int32[4] = 0
    for i in range(4):
        acc: int32 = 0
        for j in range(4):
            acc += A[i, j] * x[j]
        C[i] = acc
    return C

def mm(A: int32[4, 4], B: int32[4, 4]) -> int32[4, 4]:
    C: int32[4, 4] = 0
    for i, j in allo.grid(4, 4):
        acc: int32 = 0
        for k in range(4):
            acc += A[i, k] * B[k, j]
        C[i, j] = acc
    return C

# ============================================================================
# Process add function
# ============================================================================

print("=" * 80)
print("Processing add function")
print("=" * 80)

s_add = allo.customize(add)
code_add = s_add.build(target='xls')
code_add.interpret()
code_add.test([(0, 0, 0), (1, 2, 3), (123, 456, 579), (2**16, 2**16, 2**17)])
code_add.to_ir(verbose=False)
code_add.opt(verbose=False)
code_add.to_vlog(verbose=False)

# ============================================================================
# Process vvadd function
# ============================================================================

print("\n" + "=" * 80)
print("Processing vvadd function")
print("=" * 80)

s_vvadd = allo.customize(vvadd)
code_vvadd = s_vvadd.build(target='xls')
code_vvadd.interpret()
vec_len = 16
vec_a = np.arange(vec_len, dtype=np.int32)
vec_b = np.arange(vec_len, dtype=np.int32) * 2
expected_vvadd = vec_a + vec_b
code_vvadd.test(vec_a, vec_b, expected_vvadd)
code_vvadd.to_ir(verbose=False)
code_vvadd.opt(verbose=False)
code_vvadd.to_vlog(ram_latency=1, pipeline_stages=4, verbose=False)

# ============================================================================
# Process mv function
# ============================================================================

print("\n" + "=" * 80)
print("Processing mv function")
print("=" * 80)

mv_sched = allo.customize(mv)
code_mv = mv_sched.build(target='xls')
code_mv.interpret()
mat4 = (np.arange(16, dtype=np.int32).reshape(4, 4) - 3)
vec4 = np.array([1, -2, 3, -4], dtype=np.int32)
expected_mv = mat4 @ vec4
code_mv.test(mat4, vec4, expected_mv)
code_mv.to_ir(verbose=False)
code_mv.opt(verbose=False)
code_mv.to_vlog(ram_latency=1, pipeline_stages=4, verbose=False)

# ============================================================================
# Process mm function
# ============================================================================

print("\n" + "=" * 80)
print("Processing mm function")
print("=" * 80)

mm_sched = allo.customize(mm)
code_mm = mm_sched.build(target='xls')
code_mm.interpret()
mat_a = (np.arange(16, dtype=np.int32).reshape(4, 4) - 1)
mat_b = (np.arange(16, dtype=np.int32).reshape(4, 4) + 2)
expected_mm = mat_a @ mat_b
code_mm.test(mat_a, mat_b, expected_mm)
code_mm.to_ir(verbose=False)
code_mm.opt(verbose=False)
code_mm.to_vlog(ram_latency=1, pipeline_stages=4, verbose=False)

print("\n" + "=" * 80)
print("All processing complete!")
print("=" * 80)

