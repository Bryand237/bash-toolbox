newproject() {
    local out
    if ! out=$("$HOME/dev-tools/project-setup/setup.sh" "$@"); then
        return 1
    fi
    cd "$out" || return 1
    echo "Project créé et prêt : $out"
}