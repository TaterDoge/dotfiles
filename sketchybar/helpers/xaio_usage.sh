#!/bin/bash
# Prints the X-AIO credit-plan JSON for sketchybar.
# Auth token is read straight out of Chrome's cookie jar, so the only thing the
# user ever has to do is be logged in to https://dash.x-aio.com in Chrome.
set -uo pipefail

CHROME_DIR="$HOME/Library/Application Support/Google/Chrome"
COOKIE_NAME="_Secure-XAIO-V2-JWT"
API="https://web-api.x-aio.com/api/credit_plan/account"

db=""
for candidate in "$CHROME_DIR"/*/Cookies; do
    [ -f "$candidate" ] || continue
    if /usr/bin/sqlite3 "$candidate" \
        "select 1 from cookies where name='$COOKIE_NAME' limit 1" 2>/dev/null | grep -q 1; then
        db="$candidate"
        break
    fi
done

if [ -z "$db" ]; then
    echo "no Chrome cookie found" >&2
    exit 1
fi

tmp=$(mktemp -t xaio_cookies) || exit 1
trap 'rm -f "$tmp"' EXIT
cp "$db" "$tmp" 2>/dev/null || exit 1

token=$(
    /usr/bin/python3 - "$tmp" "$COOKIE_NAME" <<'PY'
import hashlib, re, sqlite3, subprocess, sys, time

db, name = sys.argv[1], sys.argv[2]
# Only live cookies from the dashboard hosts; skip rows that already expired
# (Chrome epoch: microseconds since 1601-01-01).
now_us = int((time.time() + 11644473600) * 1000000)
row = sqlite3.connect(db).execute(
    "select value, encrypted_value from cookies "
    "where name=? and host_key in ('.x-aio.com', 'dash.x-aio.com') "
    "and expires_utc > ? "
    "order by expires_utc desc limit 1",
    (name, now_us),
).fetchone()
if not row:
    sys.exit(1)

value, encrypted = row
if not value:
    # macOS Chrome: AES-128-CBC with a key derived from the Keychain password.
    password = subprocess.run(
        ["/usr/bin/security", "find-generic-password", "-s", "Chrome Safe Storage", "-a", "Chrome", "-w"],
        capture_output=True,
    ).stdout.strip()
    key = hashlib.pbkdf2_hmac("sha1", password, b"saltysalt", 1003, 16)
    plain = subprocess.run(
        ["/usr/bin/openssl", "enc", "-aes-128-cbc", "-d", "-nopad",
         "-K", key.hex(), "-iv", "20" * 16],
        input=encrypted[3:],
        capture_output=True,
    ).stdout
    # 32 bytes of Chrome's own prefix, then the cookie, then PKCS7 padding.
    match = re.match(rb"[\w.%\-]+", plain[32:])
    if not match:
        sys.exit(1)
    value = match.group().decode()

print(value)
PY
)

if [ -z "$token" ]; then
    echo "no auth token (log in to dash.x-aio.com in Chrome)" >&2
    exit 1
fi

/usr/bin/curl -s -m 10 \
    -H "authorization: Bearer $token" \
    -H "content-type: application/json" \
    "$API"
