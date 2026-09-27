#!/usr/bin/env bash
# Stop-хук: изменены <Предмет>/solution/ или <Предмет>/task.md, а <Предмет>/log.md — нет.
# Смотрит только незакоммиченные изменения. Код 2 = не заканчивать ход, текст уходит агенту.
input=$(cat)
# Второй заход после блокировки — не зацикливаться.
echo "$input" | grep -q '"stop_hook_active"[[:space:]]*:[[:space:]]*true' && exit 0

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
status=$(git -c core.quotepath=false status --porcelain -uall 2>/dev/null) || exit 0
[ -z "$status" ] && exit 0

missing=""
for subj in $(echo "$status" | sed -E 's/^.{3}//; s/^"//' | grep -E '^[^/]+/(solution/|task\.md$)' | cut -d/ -f1 | sort -u); do
  echo "$status" | grep -qE "^.{3}\"?$subj/log\.md\"?$" || missing="$missing $subj"
done

if [ -n "$missing" ]; then
  echo "Правило записи (CLAUDE.md): изменены solution/ или task.md, но не log.md в:$missing. Дописать log.md и progress.md, закоммитить." >&2
  exit 2
fi
exit 0
