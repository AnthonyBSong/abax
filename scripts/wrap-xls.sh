#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLIBC_DIR="${SCRIPT_DIR}/glibc"
XLS_DIR="${SCRIPT_DIR}/xls"
BIN_DIR="${XLS_DIR}/bin"

mkdir -p "${BIN_DIR}"

for exe in "${XLS_DIR}"/*; do
  if [[ -f "$exe" && -x "$exe" ]]; then
    name="$(basename "$exe")"
    mv "$exe" "${BIN_DIR}/${name}"
    cat > "${XLS_DIR}/${name}" <<EOF
#!/usr/bin/env bash
"${GLIBC_DIR}/lib/ld-linux-x86-64.so.2" --library-path "${GLIBC_DIR}/lib" "${BIN_DIR}/${name}" "\$@"
EOF
    chmod +x "${XLS_DIR}/${name}"
  fi
done
