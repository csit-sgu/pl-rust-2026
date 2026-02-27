#include <iostream>
class MyString {
  char *str;

public:
  MyString() {
    this->str = new char[100];
    std::cout << "Constructor is called";
  }
  ~MyString() { delete[] str; }
};

int main() {
  MyString x;
  auto y = x;
}
