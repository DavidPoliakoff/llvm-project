#include <iostream>

enum MemorySpace { CPU, GPU };

std::string spaceName(MemorySpace in){
  return in == MemorySpace::CPU ? "CPU" : "GPU";
}

template<typename T>
struct ManagedArray{
  T* arr;
  MemorySpace space = CPU;
  ManagedArray(T* in, MemorySpace sp = CPU) : arr(in), space(sp){}
};

template<typename T>
struct ManagedArrayLike{
  T* arr;
  MemorySpace space = CPU;
  int size = 0;
  ManagedArrayLike(T* in, MemorySpace sp = CPU, int size_in = 0) : arr(in), space(sp), size(size_in){}
};

template<typename T>
ManagedArray<T>& make_gpu(ManagedArray<T>& in){
  if(in.space == MemorySpace::CPU){
    std::cout << "Moving to GPU\n";
  }
  in.space = MemorySpace::GPU;
  return in;
}

template<typename T>
ManagedArray<T>& make_cpu(ManagedArray<T>& in){
  if(in.space == MemorySpace::GPU){
    std::cout << "Moving to CPU\n";
  }
  in.space = MemorySpace::CPU;
  return in;
}

template<typename T>
ManagedArray<int> const& intify(ManagedArray<T>& in){
  std::cout << "In intify\n";
  ManagedArray<int> out((int*)in.arr,in.space);
  return std::move(out);
}

template<typename T>
ManagedArrayLike<T> const& sizeup(ManagedArray<T>& in){
  std::cout << "In intify\n";
  ManagedArrayLike<T> out(in.arr,in.space, 0);
  return std::move(out);
}

int main(){
  float* x = (float*)malloc(sizeof(float)*10);
  ManagedArray<float> managed_x(x);
  [make_gpu,=](){
    for(int i=0;i<10;i++){
      managed_x.arr[i] = i * 1.0f;
    }
  }();
  [make_gpu,=](){
    for(int i=0;i<10;i++){
      managed_x.arr[i] = i * 1.0f;
    }
  }();
  [make_cpu,=](){
    for(int i=0;i<10;i++){
      managed_x.arr[i] = i * 1.0f;
    }
  }();
  [intify,=](){
    std::cout << managed_x.arr[0] << "\n";
  }();
  std::cout << spaceName(managed_x.space) << "\n";
}
