#include <fstream>
#include <climits>
#include <iostream>
#include <vector>

int main() {
    std::ifstream infile("input.txt");

    std::vector<int> window { 0, 0, 0 };
    int curr = 0;
    unsigned int increases = 0;

    infile >> window[0];
    infile >> window[1];
    infile >> window[2];

    while (infile >> curr) {
        int prev_sum = window[0] + window[1] + window[2];
        int new_sum  = window[1] + window[2] + curr;

        if (new_sum > prev_sum) ++increases;

        window = { window[1], window[2], curr };
    }

    std::cout << increases << std::endl;

    return 0;
}