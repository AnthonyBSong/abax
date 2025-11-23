template<typename T>
using InputChannel = __xls_channel<T, __xls_channel_dir_In>;
template<typename T>
using OutputChannel = __xls_channel<T, __xls_channel_dir_Out>;

static constexpr int row_s = 32;
static constexpr int col_s = 32;

// Forward declaration of core
void MatVec(const int A[row_s][col_s],
            const int x[col_s],
            int y[row_s]) {
    // Rolled / sequential nested loops, both pipelined.
    #pragma hls_pipeline_init_interval 1
    for (int i = 0; i < row_s; ++i) {
        int sum = 0;

        #pragma hls_pipeline_init_interval 1
        for (int j = 0; j < col_s; ++j) {
            sum += A[i][j] * x[j];
        }

        y[i] = sum;
    }
}

class MatVecWrapper {
public:
    InputChannel<int> matrix_in;   // streams A row-major
    InputChannel<int> vector_in;   // streams x
    OutputChannel<int> out;        // streams y

    // Local storage for A, x, y
    int A[row_s][col_s];
    int x[col_s];
    int y[row_s];

    // State machine
    int phase = 0;   // 0 = load x, 1 = load A, 2 = compute, 3 = drain y
    int i = 0;
    int j = 0;

    #pragma hls_top
    void Run() {
        if (phase == 0) {
            // load x
            if (j < col_s) {
                x[j] = vector_in.read();
                ++j;
                if (j == col_s) {
                    j = 0;
                    phase = 1;
                }
            }
        } else if (phase == 1) {
            // load A
            if (i < row_s) {
                A[i][j] = matrix_in.read();
                ++j;
                if (j == col_s) {
                    j = 0;
                    ++i;
                    if (i == row_s) {
                        i = 0;
                        phase = 2;
                    }
                }
            }
        } else if (phase == 2) {
            // compute y = A * x using core function
            MatVec(A, x, y);   // this uses pipelined loops internally
            i = 0;
            phase = 3;
        } else { // phase == 3: drain y
            if (i < row_s) {
                out.write(y[i]);
                ++i;
                if (i == row_s) {
                    // Done, restart for another transaction
                    i = 0;
                    j = 0;
                    phase = 0;
                }
            }
        }
    }
};
