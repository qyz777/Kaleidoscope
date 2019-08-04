#include <iostream>

extern "C" {
    int average(int, int);
}

int main() {
    std::cout << "average of 3.0 and 4.0: " << average(3, 4) << std::endl;
}
