template<typename T>
using InputChannel = __xls_channel<T, __xls_channel_dir_In>;
template<typename T>
using OutputChannel = __xls_channel<T, __xls_channel_dir_Out>;
template<typename T, int Size>
using Memory = __xls_memory<T, Size>;

static constexpr int N = 32;

class TestBlock {
public:
    // Streamed matrices:
    InputChannel<int> A_stream;
    InputChannel<int> B_stream;

    // Streamed output
    OutputChannel<int> C_stream;

    // Memory for B
    Memory<int, N * N> B_mem;

    // Memory for C
    Memory<int, N * N> C_mem;

    #pragma hls_top
    void Run() {
        // Load B into memory
        for (int idx = 0; idx < N * N; ++idx) {
            int val = B_stream.read();
            B_mem[idx] = val;
        }

        #pragma hls_pipeline_init_interval 1
        for (int i = 0; i < N; ++i) {
            int A_row[N];
            for (int k = 0; k < N; ++k) {
                A_row[k] = A_stream.read();
            }

            for (int j = 0; j < N; ++j) {
                int sum = 0;
                for (int k = 0; k < N; ++k) {
                    int b_kj = B_mem[k * N + j];
                    sum += A_row[k] * b_kj;
                }

                C_mem[i * N + j] = sum;
                C_stream.write(sum);
            }
        }
    }
};
