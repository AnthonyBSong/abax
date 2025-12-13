// to interpret the tests, run:
// interpreter_main dslx.x

// to generate verilog, run:
// - ir_converter_main --top=<func> dslx.x > <func>.ir
// - opt_main <func>.ir > <func>.opt.ir
// - codegen_main --pipeline_stages=1 --delay_model=unit <func>.opt.ir > <func>.v

// addition
fn add(a: s32, b: s32) -> s32 {
  a + b
}

// vector-vector add
fn vvadd<N: u32>(a: s32[N], b: s32[N]) -> s32[N] {
  for (i, arr) in u32:0..N {
    update(arr, i, a[i] + b[i])
  }(s32[N]:[s32:0, ...])
}

// matrix-vector multiply
fn mv<N: u32>(a: s32[N][N], x: s32[N]) -> s32[N] {
  for (i, arr) in u32:0..N {
    let dot = 
      for (j, acc) in u32:0..N {
        acc + a[i][j] * x[j]
      }(s32:0);
    update(arr, i, dot)
  }(s32[N]:[s32:0, ...])
}

// matrix-matrix multiply
fn mm<N: u32>(a: s32[N][N], b: s32[N][N]) -> s32[N][N] {
  for (i, mat) in u32:0..N {
    let row = 
      for (j, row) in u32:0..N {
        let dot = 
          for (k, acc) in u32:0..N {
            acc + a[i][k] * b[k][j]
          }(s32:0);
        update(row, j, dot)
      }(s32[N]:[s32:0, ...]);
    update(mat, i, row)
  }(s32[N][N]:[[s32:0, ...], ...])
}

fn mm4(a: s32[4][4], b: s32[4][4]) -> s32[4][4] {
  mm<4>(a, b)
}

#[test]
fn add_test() {
  assert_eq(add(s32:4, s32:5), s32:9);
}

#[test]
fn vvadd_test() {
  let in_a = s32[8]:[0, 0, 1, 1, 2, 2, 3, 3];
  let in_b = s32[8]:[0, 1, 2, 3, 4, 5, 6, 7];
  assert_eq(vvadd<8>(in_a, in_b), s32[8]:[0, 1, 3, 4, 6, 7, 9, 10]);
}

#[test]
fn mv_test() {
  let a = s32[2][2]:[
    [s32:1, s32:2],
    [s32:3, s32:4]
  ];
  let x = s32[2]:[s32:10, s32:20];
  let b = s32[2]:[s32:50, s32:110];
  assert_eq(mv<2>(a, x), b);
}

#[test]
fn mm_test() {
  let a = s32[2][2]:[
    [s32:1, s32:2],
    [s32:3, s32:4]
  ];
  let b = s32[2][2]:[
    [s32:5, s32:6],
    [s32:7, s32:8]
  ];
  let c = s32[2][2]:[
    [s32:19, s32:22],
    [s32:43, s32:50]
  ];
  assert_eq(mm<2>(a, b), c);
}
