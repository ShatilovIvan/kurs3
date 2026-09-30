"""ЛР 1. Шифр Цезаря на русском алфавите из 32 букв (таблица 1, без Ё)."""

ALPHABET = "АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ"
N = len(ALPHABET)


def encrypt(text, k):
    """Шифрование: y = (x + k) mod 32. Символы не из таблицы 1 не меняются."""
    result = ""
    for ch in text.upper():
        if ch in ALPHABET:
            result += ALPHABET[(ALPHABET.index(ch) + k) % N]
        else:
            result += ch
    return result


def decrypt(text, k):
    """Расшифровка: x = (y - k) mod 32. Символы не из таблицы 1 не меняются."""
    result = ""
    for ch in text.upper():
        if ch in ALPHABET:
            result += ALPHABET[(ALPHABET.index(ch) - k) % N]
        else:
            result += ch
    return result


if __name__ == "__main__":
    print("Часть 1. Проверка шифрования и расшифровки")
    while True:
        raw = input("Введите ключ k (целое число от 1 до 32): ").strip()
        try:
            k = int(raw)
        except ValueError:
            print("Ошибка: ключ должен быть целым числом.")
            continue
        if 1 <= k <= N:
            break
        if k < 0:
            k = k % N or N
            print(f"Отрицательный ключ заменён сравнимым по модулю {N}: k = {k}")
            break
        print(f"Ошибка: ключ должен быть от 1 до {N}.")

    text = input("Введите текст: ")
    cipher = encrypt(text, k)
    print("Зашифрованный текст:  ", cipher)
    print("Расшифрованный текст: ", decrypt(cipher, k))

    print()
    print("Часть 2. Вариант: перебор ключа")
    cipher = input("Введите зашифрованную фразу: ")
    # Частоты букв русского языка, % (для подсказки, какой вариант осмысленный)
    freq = dict(zip(ALPHABET, [
        8.0, 1.6, 4.5, 1.7, 3.0, 8.5, 0.9, 1.6, 7.4, 1.2, 3.5, 4.4, 3.2, 6.7, 11.0, 2.8,
        4.7, 5.5, 6.3, 2.6, 0.3, 1.0, 0.5, 1.4, 0.7, 0.4, 0.04, 1.9, 1.7, 0.3, 0.6, 2.0,
    ]))
    best_k, best_score = None, -1.0
    for k in range(1, N + 1):
        variant = decrypt(cipher, k)
        print(f"k = {k:2}: {variant}")
        score = sum(freq.get(ch, 0) for ch in variant)
        if score > best_score:
            best_k, best_score = k, score

    print()
    print(f"Осмысленная фраза при k = {best_k}: {decrypt(cipher, best_k)}")
