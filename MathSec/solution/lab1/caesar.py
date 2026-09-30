"""ЛР 1. Шифр Цезаря.

Методичка «Математические основы защиты информации», с. 5–9.
Кодирование — таблица 1 (с. 5): а = 0 … я = 31, е и ё имеют один код 5, m = 32.
Шифрование  y = (x + k) mod m, расшифрование  x = (y - k) mod m (с. 6–7).
"""

from pathlib import Path

ALPHABET = "абвгдежзийклмнопрстуфхцчшщъыьэюя"  # таблица 1, индекс = код буквы
M = len(ALPHABET)  # 32
OUT_DIR = Path(__file__).parent  # файлы результатов пишутся рядом с программой


def encrypt(text, k):
    """Шифрует text ключом k: y = (x + k) mod 32.

    Текст приводится к нижнему регистру, ё кодируется как е (таблица 1).
    Символы не из таблицы 1 (пробелы, знаки, латиница, цифры) не меняются.
    """
    result = ""
    for ch in text.lower().replace("ё", "е"):
        if ch in ALPHABET:
            result += ALPHABET[(ALPHABET.index(ch) + k) % M]
        else:
            result += ch
    return result


def decrypt(text, k):
    """Расшифровывает text ключом k: x = (y - k) mod 32. Правила — как в encrypt."""
    result = ""
    for ch in text.lower().replace("ё", "е"):
        if ch in ALPHABET:
            result += ALPHABET[(ALPHABET.index(ch) - k) % M]
        else:
            result += ch
    return result


if __name__ == "__main__":
    # Часть 1 (задание 2.1–2.2): шифрование и расшифрование с ключом пользователя
    print("Часть 1. Шифрование и расшифрование")
    while True:
        raw = input(f"Введите ключ k (целое число от 1 до {M}): ").strip()
        try:
            k = int(raw)
        except ValueError:
            print("Ошибка: ключ должен быть целым числом.")
            continue
        if 1 <= k <= M:
            break
        if k < 0:
            # отрицательный ключ заменяем сравнимым по модулю 32 из диапазона 1..32
            k = k % M or M
            print(f"Отрицательный ключ заменён сравнимым по модулю {M}: k = {k}")
            break
        print(f"Ошибка: ключ должен быть от 1 до {M}.")

    text = input("Введите текст: ")
    cipher = encrypt(text, k)
    plain = decrypt(cipher, k)
    print("Ключ:", k)
    print("Зашифрованный текст: ", cipher)
    print("Расшифрованный текст:", plain)
    (OUT_DIR / "encrypted.txt").write_text(f"Ключ: {k}\nШифр-текст: {cipher}\n", encoding="utf-8")
    (OUT_DIR / "decrypted.txt").write_text(f"Ключ: {k}\nРасшифрованный текст: {plain}\n", encoding="utf-8")
    print("Сохранено в encrypted.txt и decrypted.txt")

    # Часть 2 (задание 2.3): полный перебор ключа для шифровки варианта
    print()
    print("Часть 2. Взлом шифровки варианта перебором ключа")
    cipher = input("Введите зашифрованную фразу: ")

    # Частоты букв русского языка, % (е и ё вместе) — подсказка, какой вариант осмысленный
    freq = dict(zip(ALPHABET, [
        8.0, 1.6, 4.5, 1.7, 3.0, 8.5, 0.9, 1.6, 7.4, 1.2, 3.5, 4.4, 3.2, 6.7, 11.0, 2.8,
        4.7, 5.5, 6.3, 2.6, 0.3, 1.0, 0.5, 1.4, 0.7, 0.4, 0.04, 1.9, 1.7, 0.3, 0.6, 2.0,
    ]))
    lines = [f"ШИФР-ТЕКСТ (ШТ): {cipher}", "Варианты расшифрования при различных значениях ключа:"]
    best_k, best_score = 1, -1.0
    for key in range(1, M):  # ключи 1..31, k = 32 ≡ 0 оставляет текст без изменений
        variant = decrypt(cipher, key)
        lines.append(f"k = {key}: {variant}")
        print(f"k = {key:2}: {variant}")
        score = sum(freq.get(ch, 0) for ch in variant)
        if score > best_score:
            best_k, best_score = key, score

    answer = decrypt(cipher, best_k)
    print()
    print(f"Осмысленная фраза при k = {best_k}: {answer}")
    author_title = input("Введите фамилию автора и название произведения (без инициалов и кавычек): ")
    author_title = "".join(ch for ch in author_title.lower().replace("ё", "е") if ch in ALPHABET)
    author_title_cipher = encrypt(author_title, best_k)
    print("Зашифрованные фамилия и название:", author_title_cipher)

    lines[1:1] = [
        f"РАСШИФРОВАННЫЙ ТЕКСТ (ОТ): {answer}",
        f"КЛЮЧ: {best_k}",
        f"АВТОР И ПРОИЗВЕДЕНИЕ (ОТ): {author_title}",
        f"ЗАШИФРОВАННЫЕ ФАМИЛИЯ И НАЗВАНИЕ (ШТ): {author_title_cipher}",
    ]
    (OUT_DIR / "bruteforce.txt").write_text("\n".join(lines) + "\n", encoding="utf-8")
    print("Сохранено в bruteforce.txt")
