"""Текст .docx по абзацам (word/document.xml из zip).

Использование: python .claude/scripts/docx2txt.py <файл.docx> [выход.md]
Рисунки отмечаются строкой [рисунок], таблицы — ячейками через « | ».
"""
import re
import sys
import zipfile

W = "{http://schemas.openxmlformats.org/wordprocessingml/2006/main}"


def paragraph_text(p):
    parts = []
    for el in p.iter():
        if el.tag == W + "t" and el.text:
            parts.append(el.text)
        elif el.tag == W + "tab":
            parts.append("\t")
        elif el.tag in (W + "br", W + "cr"):
            parts.append("\n")
        elif el.tag == W + "drawing" or el.tag.endswith("}pict"):
            parts.append("[рисунок]")
    return "".join(parts)


def convert(path):
    import xml.etree.ElementTree as ET

    root = ET.fromstring(zipfile.ZipFile(path).read("word/document.xml"))
    body = root.find(W + "body")
    lines = []
    for block in body:
        if block.tag == W + "p":
            lines.append(paragraph_text(block))
        elif block.tag == W + "tbl":
            for row in block.iter(W + "tr"):
                cells = [" ".join(paragraph_text(p) for p in tc.iter(W + "p")).strip()
                         for tc in row.iter(W + "tc")]
                lines.append(" | ".join(cells))
    return re.sub(r"\n{3,}", "\n\n", "\n".join(lines)).strip() + "\n"


if __name__ == "__main__":
    text = convert(sys.argv[1])
    if len(sys.argv) > 2:
        open(sys.argv[2], "w", encoding="utf-8").write(text)
    else:
        sys.stdout.reconfigure(encoding="utf-8")
        sys.stdout.write(text)
