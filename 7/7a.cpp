#include <fstream>
#include <iostream>
#include <vector>
#include <algorithm>
#include <climits>

int main() {
    std::ifstream infile("input.txt");

    std::vector<int> positions {};

    int curr = 0;
    char comma;
    while (infile >> curr) {
        positions.push_back(curr);
        infile >> comma;
    }

    int lowest = *std::min_element(std::begin(positions), std::end(positions));
    int highest = *std::max_element(std::begin(positions), std::end(positions));

    int lowest_cost = INT_MAX;
    int best_position = 0;

    for (int i = lowest; i < highest; i++) {
        int fuel_cost = 0;
        for (const auto &p : positions) {
            fuel_cost += std::abs(p - i);
        }

        if (fuel_cost < lowest_cost) {
            lowest_cost = fuel_cost;
            best_position = i;
        }
    }

    std::cout << lowest_cost << std::endl;
}