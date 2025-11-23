template<typename T>
using InputChannel = __xls_channel<T, __xls_channel_dir_In>;
template<typename T>
using OutputChannel = __xls_channel<T, __xls_channel_dir_Out>;
template<typename T, int Size>
using Memory = __xls_memory<T, Size>;

static constexpr int row_s = 32;
static constexpr int col_s = 32;

class TestBlock {
public:
    InputChannel<int> matrix;
    InputChannel<int> vector;
    OutputChannel<int> out;
    Memory<int, col_s> store;

    // State
    int phase = 0;  // 0 = loading x, 1 = computing
    int i = 0;      // row index
    int j = 0;      // col index
    int sum = 0;

    #pragma hls_top
    void Run() {
        if (phase == 0) {
            // Load vector x one element per call
            if (j < col_s) {
                int xj = vector.read();
                store[j] = xj;
                ++j;
                if (j == col_s) {
                    // done loading x
                    j = 0;
                    i = 0;
                    sum = 0;
                    phase = 1;
                }
            }
        } else { // phase == 1: mat-vec compute
            if (i < row_s) {
                int a_ij = matrix.read();
                int xj   = store[j];
                sum += a_ij * xj;

                ++j;
                if (j == col_s) {
                    // finished a row
                    out.write(sum);
                    sum = 0;
                    j = 0;
                    ++i;
                    if (i == row_s) {
                        // done all rows, go back to load phase
                        phase = 0;
                        j = 0;
                    }
                }
            }
        }
    }
};
