from pathlib import Path

ALPHABET = "абвгдежзийклмнопрстуфхцчшщъыьэюя"
M = len(ALPHABET)
OUT_DIR = Path(__file__).parent


def caesar(text, k, mode):
    shift = k if mode == 0 else -k
    result = ""
    for ch in text.lower().replace("ё", "е"):
        if ch in ALPHABET:
            result += ALPHABET[(ALPHABET.index(ch) + shift) % M]
        else:
            result += ch
    return result


def main():
    print("Часть 1. Шифрование и расшифрование")
    while True:
        raw = input("Выберите режим (0 - шифрование, 1 - расшифрование): ").strip()
        if raw in ("0", "1"):
            mode = int(raw)
            break
        print("Ошибка: режим должен быть 0 или 1.")

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
            k = k % M or M
            print(f"Отрицательный ключ заменён сравнимым по модулю {M}: k = {k}")
            break
        print(f"Ошибка: ключ должен быть от 1 до {M}.")

    text = input("Введите текст: ")
    result = caesar(text, k, mode)
    print("Ключ:", k)
    if mode == 0:
        print("Зашифрованный текст:", result)
        (OUT_DIR / "encrypted.txt").write_text(f"Ключ: {k}\nШифр-текст: {result}\n", encoding="utf-8")
        print("Сохранено в encrypted.txt")
    else:
        print("Расшифрованный текст:", result)
        (OUT_DIR / "decrypted.txt").write_text(f"Ключ: {k}\nРасшифрованный текст: {result}\n", encoding="utf-8")
        print("Сохранено в decrypted.txt")

    print()
    print("Часть 2. Взлом шифровки варианта перебором ключа")
    cipher = input("Введите зашифрованную фразу: ")

    freq = dict(zip(ALPHABET, [
        8.0, 1.6, 4.5, 1.7, 3.0, 8.5, 0.9, 1.6, 7.4, 1.2, 3.5, 4.4, 3.2, 6.7, 11.0, 2.8,
        4.7, 5.5, 6.3, 2.6, 0.3, 1.0, 0.5, 1.4, 0.7, 0.4, 0.04, 1.9, 1.7, 0.3, 0.6, 2.0,
    ]))
    lines = [f"ШИФР-ТЕКСТ (ШТ): {cipher}", "Варианты расшифрования при различных значениях ключа:"]
    best_k, best_score = 1, -1.0
    for key in range(1, M):
        variant = caesar(cipher, key, 1)
        lines.append(f"k = {key}: {variant}")
        print(f"k = {key:2}: {variant}")
        score = sum(freq.get(ch, 0) for ch in variant)
        if score > best_score:
            best_k, best_score = key, score

    answer = caesar(cipher, best_k, 1)
    print()
    print(f"Осмысленная фраза при k = {best_k}: {answer}")
    author_title = input("Введите фамилию автора и название произведения (без инициалов и кавычек): ")
    author_title = "".join(ch for ch in author_title.lower().replace("ё", "е") if ch in ALPHABET)
    author_title_cipher = caesar(author_title, best_k, 0)
    print("Зашифрованные фамилия и название:", author_title_cipher)

    lines[1:1] = [
        f"РАСШИФРОВАННЫЙ ТЕКСТ (ОТ): {answer}",
        f"КЛЮЧ: {best_k}",
        f"АВТОР И ПРОИЗВЕДЕНИЕ (ОТ): {author_title}",
        f"ЗАШИФРОВАННЫЕ ФАМИЛИЯ И НАЗВАНИЕ (ШТ): {author_title_cipher}",
    ]
    (OUT_DIR / "bruteforce.txt").write_text("\n".join(lines) + "\n", encoding="utf-8")
    print("Сохранено в bruteforce.txt")


if __name__ == "__main__":
    main()
