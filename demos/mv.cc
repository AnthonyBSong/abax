template<typename T>
using InputChannel = __xls_channel<T, __xls_channel_dir_In>;
template<typename T>
using OutputChannel = __xls_channel<T, __xls_channel_dir_Out>;

class TestBlock {
private: 
    void MatVec(const int A[32][32],
                const int x[32],
                int y[32]) {
        #pragma hls_pipeline_init_interval 1
        for (int i = 0; i < 32; ++i) {
            int sum = 0;

            #pragma hls_pipeline_init_interval 1
            for (int j = 0; j < 32; ++j) {
                sum += A[i][j] * x[j];
            }

            y[i] = sum;
        }
    }
public:
    InputChannel<int> matrix_in; 
    InputChannel<int> vector_in;
    OutputChannel<int> out;

    // Local storage for A, x, y
    int A[32][32];
    int x[32];
    int y[32];

    // State machine
    int phase = 0;
    int i = 0;
    int j = 0;

    #pragma hls_top
    void Run() {
        if (phase == 0) {
            // load x
            if (j < 32) {
                x[j] = vector_in.read();
                ++j;
                if (j == 32) {
                    j = 0;
                    phase = 1;
                }
            }
        } else if (phase == 1) {
            // load A
            if (i < 32) {
                A[i][j] = matrix_in.read();
                ++j;
                if (j == 32) {
                    j = 0;
                    ++i;
                    if (i == 32) {
                        i = 0;
                        phase = 2;
                    }
                }
            }
        } else if (phase == 2) {
            MatVec(A, x, y);
            i = 0;
            phase = 3;
        } else { // phase == 3: drain y
            if (i < 32) {
                out.write(y[i]);
                ++i;
                if (i == 32) {
                    // Done
                    i = 0;
                    j = 0;
                    phase = 0;
                }
            }
        }
    }
};
