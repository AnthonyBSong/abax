template<typename T>
using InputChannel = __xls_channel<T, __xls_channel_dir_In>;
template<typename T>
using OutputChannel = __xls_channel<T, __xls_channel_dir_Out>;

static constexpr int size = 16;

class TestBlock {
public:
    InputChannel<int> a;
    InputChannel<int> b;
    OutputChannel<int> out;

    #pragma hls_top
    void Run() {
        #pragma hls_pipeline_init_interval 1
        for(int i=0; i < size; ++i) {
            int va = a.read();
            int vb = b.read();
            int sum = va + vb;
            out.write(sum);
        }
    }
};