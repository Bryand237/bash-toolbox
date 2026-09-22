create_project() {
    local dir="$1"
    local name="$2"
    local guard
    guard="$(printf '%s' "$name" | tr '[:lower:]' '[:upper:]' | tr -c '[:alnum:]' '_')_H"

    mkdir -p "$dir"/{bin,src,include}

    cat > "$dir/src/main.c" << EOF
#include <stdio.h>
#include "$name.h"

int main(void) {
    printf("Hello, $name!\n");
    return 0;
}
EOF

    cat > "$dir/include/$name.h" << EOF
#ifndef $guard
#define $guard

#endif /* $guard */
EOF

    cat > "$dir/Makefile" << 'EOF'
CC = gcc
CFLAGS = -Wall -Wextra -std=c11 -Iinclude
SRC = $(wildcard src/*.c)
BIN = bin/app

$(BIN): $(SRC)
    mkdir -p bin
    $(CC) $(CFLAGS) -o $(BIN) $(SRC)

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