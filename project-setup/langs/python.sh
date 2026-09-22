create_project() {
    local dir="$1"
    local name="$2"

    mkdir -p "$dir"/{"src/$name", tests}

    cat > "$dir/src/$name/__init__.py" << 'EOF'
EOF

    cat > "$dir/src/$name/main.py" << EOF
def main():
    print("Hello, $name!")

if __name__ == "__main__":
    main()
EOF

    cat > "$dir/tests/test_main.py" << EOF
from $name.main import main

def test_main(capsys):
    main()
    captured = capsys.readouterr()
    assert "Hello, $name!" in captured.out
EOF

    cat > "$dir/requirements.txt" << 'EOF'
pytest
EOF

    cat > "$dir/.gitignore" << 'EOF'
__pycache__/
*.pyc
.venv/
EOF
}