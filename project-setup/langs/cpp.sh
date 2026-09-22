create_project() {
    local dir="$1"
    local name="$2"
    local guard
    guard="$(printf '%s' "$name" | tr '[:lower:]' '[:upper:]' | tr -c '[:alnum:]' '_')_HPP"

    mkdir -p "$dir"/{bin,src,include}

    cat > "$dir/src/main.cpp" << EOF
#include <iostream>
#include "$name.hpp"

int main(void) {
    std::cout << "Hello, $name!" << std::endl;
    return 0;
}
EOF

    cat > "$dir/include/$name.hpp" << EOF
#ifndef $guard
#define $guard

#endif /* $guard */
EOF

    cat > "$dir/Makefile" << 'EOF'
CXX = g++
CXXFLAGS = -Wall -Wextra -std=c++17 -Iinclude
SRC = $(wildcard src/*.cpp)
BIN = bin/app

$(BIN): $(SRC)
    mkdir -p bin
    $(CXX) $(CXXFLAGS) -o $(BIN) $(SRC)

run: $(BIN)
    ./$(BIN)

clean:
    rm -rf bin

.PHONY: run clean
EOF

    cat > "$dir/.gitignore" << 'EOF'
bin/
*.o
EOF
}