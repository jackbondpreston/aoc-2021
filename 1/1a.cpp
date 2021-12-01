#include <fstream>
#include <climits>
#include <iostream>

int main() {
    std::ifstream infile("input.txt");

    unsigned int curr, prev = UINT_MAX;
    unsigned int increases = 0;

    while (infile >> curr) {
        if (curr > prev) ++increases;
        prev = curr;
    }

    std::cout << increases << std::endl;

    return 0;
}