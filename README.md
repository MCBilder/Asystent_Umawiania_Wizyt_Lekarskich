# Asystent Umawiania Wizyt Lekarskich

### Spis treści
1. [Wstęp i cel projektu](#wstęp-i-cel-projektu)
2. [Opis bazy wiedzy](#opis-bazy-wiedzy)
3. [Najważniejsze reguły](#najważniejsze-reguły)
4. [Instrukcja obsługi i przykłady użycia](#instrukcja-obsługi-i-przykłady-użycia)

---

### Wstęp i cel projektu

Projekt przedstawia stworzonego asystenta do wyszukiwania lekarzy, który
wspomaga użytkownika w procesie wyboru odpowiedniego specjalisty zgodnie
z jego preferencjami. System został zaprojektowany w celu uproszczenia i
przyspieszenia procesu umawiania wizyt lekarskich poprzez automatyczne
dopasowanie lekarzy na podstawie określonych kryteriów.
Asystent umożliwia dobór lekarzy według takich parametrów jak:
• cena wizyty,
• forma konsultacji (online lub stacjonarna),
• dostępność terminów odpowiadających harmonogramowi użytkownika,
• specjalizacja medyczna i lokalizacja.

Na podstawie tych danych system analizuje preferencje użytkownika i
przedstawia najlepiej dopasowane wyniki, co pozwala ograniczyć czas
potrzebny na samodzielne przeszukiwanie wielu serwisów medycznych.
Wybrany temat jest odpowiedni dla programowania logicznego, ponieważ
system opiera się na regułach dopasowania i filtrowania danych. Każdy lekarz w
bazie ma określone cechy (np. cena, dostępność, forma wizyty), a użytkownik
definiuje swoje wymagania. Programowanie logiczne umożliwia efektywne
przeszukiwanie takich relacji i automatyczne wyciąganie wniosków, które
lekarze spełniają wszystkie kryteria jednocześnie.

System ma rozwiązywać kilka typowych problemów:
1. Skrócenie czasu wyszukiwania lekarza – użytkownik nie musi przeglądać
wielu portali ani stron internetowych.
2. Dopasowanie do indywidualnych potrzeb – system bierze pod uwagę
cenę, dostępność terminów oraz formę wizyty.
3. Ułatwienie decyzji – użytkownik otrzymuje gotowe propozycje najlepiej
dopasowanych specjalistów, co zmniejsza ryzyko pomyłki lub wyboru
niewłaściwego lekarza.
---
### Opis bazy wiedzy

System opiera się na bazie faktów, w której przechowywane są informacje o
lekarzach i ich dostępności. Każdy fakt reprezentuje jednego lekarza wraz z
jego cechami.


#### Obiekty
Podstawowym obiektem w systemie jest lekarz. Każdy lekarz w bazie jest
opisany jako fakt w postaci:
```prolog
lekarz(Imie, Specjalizacja, Koszt, Dostepnosc, Forma, Miasto, Ocena, Platnosc)
```
gdzie:
• Imie – pełne imię i nazwisko lekarza,
• Specjalizacja – dziedzina medycyny, w której specjalizuje się lekarz (np.
internista, kardiolog),
• Koszt – cena wizyty w złotówkach; wartość 0 oznacza wizytę refundowaną
przez NFZ,
• Dostepnosc – lista dni tygodnia, w których lekarz przyjmuje pacjentów,
• Forma – forma wizyty: stacjonarnie, online lub hybrydowo (połączenie
obu),
• Miasto – lokalizacja wizyty,
• Ocena – ocena lekarza w skali 1–5,
• Platnosc – typ płatności: nfz, prywatnie lub oba (oba typy wizyt).

#### Atrybuty
Baza wiedzy uwzględnia następujące cechy lekarzy:
1. Specjalizacja – pozwala użytkownikowi wybierać lekarza według dziedziny
medycyny.
2. Koszt wizyty – umożliwia filtrowanie lekarzy w zależności od budżetu
użytkownika.
3. Dostępność – dni tygodnia, w których możliwe jest umówienie wizyty.
4. Forma wizyty – określa sposób realizacji wizyty (stacjonarnie, online,
hybrydowo).
5. Miasto – lokalizacja wizyty, co pozwala uwzględnić ograniczenia
geograficzne.
6. Ocena lekarza – wartość liczbowa umożliwiająca ranking i sortowanie
wyników według jakości usług.
7. Rodzaj płatności – możliwość dopasowania wizyty do preferencji NFZ lub
prywatnie.
---

