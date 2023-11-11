
######################################################################
# ZSH aliases and helper functions for Rust development with Cargo   #
# Licensed under MIT (C) Alicia Sykes 2022 <https://aliciasykes.com> #
######################################################################

# Cargo Basic Commands
alias cr='cargo run'
alias cb='cargo build'
alias ct='cargo test'

alias carc='cargo clean'
alias caru='cargo update'
alias carch='cargo check'
alias carcl='cargo clippy'
alias card='cargo doc'

alias carbr='cargo build --release'
alias carrr='cargo run --release'
alias carws='cargo workspace'
alias carwsl='cargo workspace list'
alias carad='cargo add'
alias carrm='cargo rm'
alias carp='cargo publish'
alias carau='cargo audit'
alias cargen='cargo generate --git'
alias carfmt='cargo fmt'

# Rustup Commands
alias ru-update='rustup update'
alias ru-default='rustup default'

# Helper function to create a new Rust project
new_rust_project() {
    cargo new $1 --bin && cd $1
}

# Helper function to search crates.io
search_crates() {
    open "https://crates.io/search?q=$1"
}

# Alias for opening Rust documentation
alias rustdoc='open https://doc.rust-lang.org'

# Alias for opening The Rust Programming Language book
alias rustbook='open https://doc.rust-lang.org/book/'

# Helper to update Rust toolchain and all installed components
update_rust() {
    rustup update
    rustup self update
    cargo install-update -a
}

# Alias for running Rust programs with Valgrind (if installed)
alias rvalgrind='valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes'

# Helper to clean up target directory in all workspaces
clean_rust_workspace() {
    find . -name "target" -type d -exec rm -rf {} +
    echo "Cleaned target directories in Rust workspace"
}
