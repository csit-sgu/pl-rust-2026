#include <iostream>
#include <memory>
#include <unistd.h>

class Checker {
public:
  Checker() { std::cout << "Constructor is called\n"; }

  ~Checker() { std::cout << "Destructor is called\n"; }
};

class Thrower {
public:
  Thrower() { throw 42; }
};

template <class A, class MayThrow> class D {
public:
  D() {
    this->x = std::make_unique<A>();
    this->y = std::make_unique<MayThrow>();
  }

  std::unique_ptr<A> x;
  std::unique_ptr<MayThrow> y;
};

int main() {
  while (true) {
    try {
      D<Checker, Thrower> d;
    } catch (int) {
      std::cout << "Exception is caught\n";
    }
    sleep(5);
  }
}
