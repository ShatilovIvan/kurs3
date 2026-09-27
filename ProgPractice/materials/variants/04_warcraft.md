# Вариант №4. Warcraft / World of Warcraft

![](https://i.playground.ru/e/wgoXPG9CtjzeyzGL9-8HIw.jpeg)

##  МЕМО встречи с заказчиком

Ссылка на датасет: [https://drive.google.com/file/d/1OzFhx_yDSGPNr_yUgRg1XEMYSmphs5Pp/view?usp=sharing](https://drive.google.com/file/d/1OzFhx_yDSGPNr_yUgRg1XEMYSmphs5Pp/view?usp=sharing)

После того как от земель Лордерона отступила чума, Отрекшиеся решили заняться обычными крестьянскими делами — восстановлением хозяйства и сбором урожая для торговли. Леса Лордерона издавна славились своими грибами, однако чума не прошла для них бесследно: многие грибы изменились и стали непригодны для употребления.

Чтобы не рисковать урожаем и не допустить попадания опасных грибов на рынки, травники Отрекшихся начали внимательно исследовать найденные экземпляры. Для каждого гриба они записывали его внешний вид, размеры, форму и цвет различных частей, место произрастания и другие характеристики.

Так травники собрали большой датасет грибов Лордерона. Теперь необходимо помочь им определить, какие грибы пригодны для сбора и торговли, а какие после воздействия чумы стали опасными.

**Калия Менетилл, член Мрачносовета**
— Многое из того, что было известно нашим травникам о землях Лордерона, погибло вместе с Третьей войной. Старые записи сгорели, архивы были разграблены, а те, кто хранил эти знания, погибли или покинули наши земли. Поэтому собрать полную информацию о грибах Лордерона нам так и не удалось. Некоторые характеристики удалось восстановить по сохранившимся записям, другие травники определяли самостоятельно, а о некоторых экземплярах сведений и вовсе не осталось. Теперь нам предстоит разобраться с тем, что удалось собрать, и понять, какие знания все еще можно восстановить. Да хранит нас Свет.

##  Дополнительные сведения о данных

Class information:

- class		poisonous=p, edibile=e (binary)

Variable Information (n: nominal, m: metrical; nominal values as sets of values):

- cap-diameter (m): float number in cm

- cap-shape (n): bell=b, conical=c, convex=x, flat=f, sunken=s, spherical=p, others=o

- cap-surface (n):          fibrous=i, grooves=g, scaly=y, smooth=s, shiny=h, leathery=l, silky=k, sticky=t, wrinkled=w, fleshy=e

- cap-color (n):            brown=n, buff=b, gray=g, green=r, pink=p, purple=u, red=e, white=w, yellow=y, blue=l, orange=o,  black=k

- does-bruise-bleed (n):	bruises-or-bleeding=t,no=f

- gill-attachment (n):      adnate=a, adnexed=x, decurrent=d, free=e, sinuate=s, pores=p, none=f, unknown=?

- gill-spacing (n): close=c, distant=d, none=f

- gill-color (n): see cap-color + none=f

- stem-height (m): float number in cm

- stem-width (m): float number in mm

- stem-root (n): bulbous=b, swollen=s, club=c, cup=u, equal=e, rhizomorphs=z, rooted=r

- stem-surface (n): see cap-surface + none=f

- stem-color (n): see cap-color + none=f

- veil-type (n): partial=p, universal=u

- veil-color (n): see cap-color + none=f

- has-ring (n): ring=t, none=f

- ring-type (n): cobwebby=c, evanescent=e, flaring=r, grooved=g, large=l, pendant=p, sheathing=s, zone=z, scaly=y, movable=m, none=f, unknown=?

- spore-print-color (n): see cap color

- habitat (n): grasses=g, leaves=l, meadows=m, paths=p, heaths=h, urban=u, waste=w, woods=d

- season (n): spring=s, summer=u, autumn=a, winter=w


---
Локальная копия датасета: [../datasets/04_warcraft.csv](../datasets/04_warcraft.csv)

Источник: https://wiki.pmifi.ru/disciplines/programming-workshop-bachelors-5sem/variants/4
