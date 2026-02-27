#include <iostream>
#include <memory>

int main() {
    auto x = std::make_unique<int>(42);
    auto y = std::move(x);
    std::cout << *x;
}
