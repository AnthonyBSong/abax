#include <cstdint>

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
    // Streamed inputs
    InputChannel<int> matrix;
    InputChannel<int> vector;

    OutputChannel<int> out; 

    Memory<int, col_s> store;

    #pragma hls_top
    void Run() {
        // load the vector x from the vector channel into memory
        for (int j = 0; j < col_s; ++j) {
            int xj = vector.read();
            store[j] = xj;
        }

        #pragma hls_pipeline_init_interval 1
        for (int i = 0; i < row_s; ++i) {
            int sum = 0;
            for (int j = 0; j < col_s; ++j) {
                int a_ij = matrix.read();
                int xj = store[j];

                sum += a_ij * xj;
            }
            out.write(sum);
        }
    }
};
