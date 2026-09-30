from pathlib import Path

ALPHABET = "абвгдежзийклмнопрстуфхцчшщъыьэюя"
M = len(ALPHABET)
OUT_DIR = Path(__file__).parent
FREQ = {
    "о": 0.090, "е": 0.072, "а": 0.062, "и": 0.062, "т": 0.053, "н": 0.053, "с": 0.045, "р": 0.040,
    "в": 0.038, "л": 0.035, "к": 0.028, "м": 0.026, "д": 0.025, "п": 0.023, "у": 0.021, "я": 0.018,
    "ы": 0.016, "з": 0.016, "ъ": 0.014, "ь": 0.014, "б": 0.014, "г": 0.013, "ч": 0.012, "й": 0.010,
    "х": 0.009, "ж": 0.007, "ю": 0.006, "ш": 0.006, "ц": 0.004, "щ": 0.003, "э": 0.003, "ф": 0.002,
}


def ext_gcd(a, b):
    sign_a = -1 if a < 0 else 1
    sign_b = -1 if b < 0 else 1
    a, b = abs(a), abs(b)
    x2, x1, y2, y1 = 1, 0, 0, 1
    while b > 0:
        q = a // b
        a, b = b, a - q * b
        x2, x1 = x1, x2 - q * x1
        y2, y1 = y1, y2 - q * y1
    return a, sign_a * x2, sign_b * y2


def inverse(a, m):
    d, x, _ = ext_gcd(a, m)
    if d != 1:
        return None
    return x % m


def solve_congruence(a, b, m):
    a, b = a % m, b % m
    d = ext_gcd(a, m)[0]
    if b % d != 0:
        return []
    m1 = m // d
    x0 = inverse(a // d, m1) * (b // d) % m1
    return [x0 + i * m1 for i in range(d)]


def solve_system(a, b, c, d, m):
    return [(x, (b - a * x) % m) for x in solve_congruence(a - c, b - d, m)]


def affine(text, a, b, mode):
    a_inv = inverse(a, M)
    result = ""
    for ch in text.lower().replace("ё", "е"):
        if ch in ALPHABET:
            x = ALPHABET.index(ch)
            y = (a * x + b) % M if mode == 0 else a_inv * (x - b) % M
            result += ALPHABET[y]
        else:
            result += ch
    return result


def read_int(prompt, minimum=None):
    while True:
        raw = input(prompt).strip()
        try:
            value = int(raw)
        except ValueError:
            print("Ошибка: нужно ввести целое число.")
            continue
        if minimum is not None and value < minimum:
            print(f"Ошибка: число должно быть не меньше {minimum}.")
            continue
        return value


def crack():
    raw = input("Введите шифр-текст варианта: ")
    cipher = "".join(ch for ch in raw.lower().replace("ё", "е") if ch in ALPHABET)
    if not cipher:
        print("Ошибка: в тексте нет русских букв.")
        return

    counts = {ch: cipher.count(ch) for ch in ALPHABET}
    lines = [f"ШИФР-ТЕКСТ (ШТ): {cipher}", f"Длина: {len(cipher)}", "Результаты частотного анализа ШТ:"]
    for i in range(0, M, 8):
        row = ALPHABET[i:i + 8]
        lines.append("буква   " + " ".join(f"{ch:>5}" for ch in row))
        lines.append("частота " + " ".join(f"{counts[ch] / len(cipher):5.3f}" for ch in row))
    top_cipher = sorted(ALPHABET, key=lambda ch: -counts[ch])[:6]
    top_plain = "оеаитн"
    lines.append("Наиболее часто встречающиеся символы: " + ", ".join(f"{ch} ({counts[ch]})" for ch in top_cipher))
    print("\n".join(lines))

    keys = {}
    for i in range(len(top_plain)):
        for j in range(i + 1, len(top_plain)):
            for k in top_cipher:
                for n in top_cipher:
                    if k == n:
                        continue
                    x1, x2 = ALPHABET.index(top_plain[i]), ALPHABET.index(top_plain[j])
                    y1, y2 = ALPHABET.index(k), ALPHABET.index(n)
                    for a, b in solve_system(x1, y1, x2, y2, M):
                        if inverse(a, M) is not None and (a, b) not in keys:
                            keys[(a, b)] = (
                                f"E({top_plain[i]}) = {k}, E({top_plain[j]}) = {n}: "
                                f"(({x1}a + b) mod {M} ≡ {y1}, ({x2}a + b) mod {M} ≡ {y2})"
                            )

    order = sorted(keys, key=lambda key: -sum(FREQ[ch] for ch in affine(cipher, key[0], key[1], 1)))
    lines.append("Варианты ключа и расшифровки:")
    for number, (a, b) in enumerate(order, 1):
        plain = affine(cipher, a, b, 1)
        lines += [f"{number}. Система: {keys[(a, b)]}", f"   Ключ: a = {a}, b = {b}", f"   Текст: {plain}"]
        (OUT_DIR / "variant.txt").write_text("\n".join(lines) + "\n", encoding="utf-8")
        print()
        print(f"Вариант {number} из {len(order)}. Система: {keys[(a, b)]}")
        print(f"Ключ: a = {a}, b = {b}")
        print(f"Текст: {plain}")
        answer = ""
        while answer not in ("0", "1"):
            answer = input("Текст осмысленный? (1 - да, 0 - нет): ").strip()
        if answer == "1":
            lines += [f"ВЕРНЫЙ КЛЮЧ: a = {a}, b = {b}", f"РАСШИФРОВАННЫЙ ТЕКСТ (ОТ): {plain}"]
            (OUT_DIR / "variant.txt").write_text("\n".join(lines) + "\n", encoding="utf-8")
            print(f"Верный ключ: a = {a}, b = {b}. Сохранено в variant.txt")
            return
    print("Осмысленный текст не найден. Варианты сохранены в variant.txt")


def main():
    while True:
        print()
        print("Основное меню")
        print("1 - Проверка математики")
        print("2 - Выполнение варианта")
        print("3 - Выход")
        choice = input("Выберите пункт: ").strip()

        if choice == "1":
            while True:
                print()
                print("Проверка математики")
                print("1 - Расширенный алгоритм Евклида")
                print("2 - Элемент, обратный данному")
                print("3 - Решение сравнения ax ≡ b (mod m)")
                print("4 - Решение системы ax + y ≡ b, cx + y ≡ d (mod m)")
                print("0 - Назад")
                sub = input("Выберите пункт: ").strip()

                if sub == "1":
                    a = read_int("a = ")
                    b = read_int("b = ")
                    if a == 0 and b == 0:
                        print("НОД(0, 0) не определён.")
                        continue
                    d, x, y = ext_gcd(a, b)
                    print(f"d = НОД({a}, {b}) = {d}")
                    print(f"Коэффициенты Безу: x = {x}, y = {y}")
                    print(f"Проверка: {a} * ({x}) + {b} * ({y}) = {a * x + b * y}")

                elif sub == "2":
                    a = read_int("a = ")
                    m = read_int("m = ", 2)
                    d, x, _ = ext_gcd(a, m)
                    if d != 1:
                        print(f"НОД({a}, {m}) = {d} ≠ 1: элемента, обратного {a} по модулю {m}, не существует.")
                        continue
                    print(f"Коэффициент Безу при a: x = {x}")
                    if x < 0:
                        print(f"Коэффициент отрицательный, наименьший неотрицательный вычет: {x % m}")
                    print(f"Обратный элемент к {a} по модулю {m}: {x % m}")
                    print(f"Проверка: {a} * {x % m} mod {m} = {a * (x % m) % m}")

                elif sub == "3":
                    a = read_int("a = ")
                    b = read_int("b = ")
                    m = read_int("m = ", 2)
                    d = ext_gcd(a, m)[0]
                    print(f"d = НОД({a}, {m}) = {d}")
                    solutions = solve_congruence(a, b, m)
                    if not solutions:
                        print(f"{b} не делится на {d}: сравнение решений не имеет.")
                    elif d == 1:
                        print(f"d = 1: единственное решение x = {solutions[0]} (mod {m})")
                    else:
                        print(f"{b} делится на {d}: решений по модулю {m} - {d}: x = " + ", ".join(map(str, solutions)))

                elif sub == "4":
                    a = read_int("a = ")
                    b = read_int("b = ")
                    c = read_int("c = ")
                    d = read_int("d = ")
                    m = read_int("m = ", 2)
                    print(f"Вычитаем сравнения: {a - c}x ≡ {b - d} (mod {m})")
                    g = ext_gcd(a - c, m)[0]
                    print(f"НОД({a - c}, {m}) = {g}")
                    solutions = solve_system(a, b, c, d, m)
                    if not solutions:
                        print("Система решений не имеет.")
                    else:
                        print(f"Решений: {len(solutions)}")
                        for x, y in solutions:
                            print(f"x = {x}, y = {y}")

                elif sub == "0":
                    break
                else:
                    print("Ошибка: выберите пункт 0-4.")

        elif choice == "2":
            crack()
        elif choice == "3":
            break
        else:
            print("Ошибка: выберите пункт 1-3.")


if __name__ == "__main__":
    main()
