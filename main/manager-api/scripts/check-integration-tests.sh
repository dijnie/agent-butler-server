#!/usr/bin/env bash
# Check that the integration tests that connect to MySQL and Redis really ran.
# If the guard ever accidentally skips all of them, CI must go red; it must not quietly run half the gate.
set -uo pipefail

REPORT_DIR="${1:-target/surefire-reports}"

WATCHED=(
  "xiaozhi.modules.device.DeviceTest"
  "xiaozhi.modules.model.service.impl.ModelConfigPersistenceTest"
  "xiaozhi.modules.sys.loginControllerTest"
)

if [ ! -d "$REPORT_DIR" ]; then
  echo "Test report directory not found: $REPORT_DIR"
  exit 1
fi

missing=()
for class in "${WATCHED[@]}"; do
  count=0
  for report in "$REPORT_DIR"/TEST-*.xml; do
    [ -e "$report" ] || continue
    name=$(sed -n 's/.*<testsuite[^>]*name="\([^"]*\)".*/\1/p' "$report" | head -1)
    if [ "$name" = "$class" ]; then
      count=$(sed -n 's/.*<testsuite[^>]*tests="\([0-9]*\)".*/\1/p' "$report" | head -1)
      count=${count:-0}
      break
    fi
  done
  if [ "$count" -eq 0 ]; then
    missing+=("$class")
  else
    echo "OK  $class ran $count tests"
  fi
done

if [ ${#missing[@]} -ne 0 ]; then
  echo "None of these integration tests ran: ${missing[*]}"
  echo "The guard hollowed out the gate; the build must fail"
  exit 1
fi

echo "All integration tests ran"
