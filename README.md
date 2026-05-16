# Asystent Umawiania Wizyt Lekarskich

### Spis treści
1. [Wstęp i cel projektu](#wstęp-i-cel-projektu)
2. [Opis bazy wiedzy](#opis-bazy-wiedzy)
3. [Implementacja logiki ](#Implementacja-logiki)
4. [Instrukcja obsługi i przykłady użycia](#instrukcja-obsługi-i-przykłady-użycia)

---

### Wstęp i cel projektu

Projekt przedstawia stworzonego asystenta do wyszukiwania lekarzy, który
wspomaga użytkownika w procesie wyboru odpowiedniego specjalisty zgodnie
z jego preferencjami. System został zaprojektowany w celu uproszczenia i
przyspieszenia procesu umawiania wizyt lekarskich poprzez automatyczne
dopasowanie lekarzy na podstawie określonych kryteriów.
Asystent umożliwia dobór lekarzy według takich parametrów jak:
- cena wizyty,
- forma konsultacji (online lub stacjonarna),
- dostępność terminów odpowiadających harmonogramowi użytkownika,
- specjalizacja medyczna i lokalizacja.

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
- Imie – pełne imię i nazwisko lekarza,
- Specjalizacja – dziedzina medycyny, w której specjalizuje się lekarz (np.
internista, kardiolog),
- Koszt – cena wizyty w złotówkach; wartość 0 oznacza wizytę refundowaną
przez NFZ,
- Dostepnosc – lista dni tygodnia, w których lekarz przyjmuje pacjentów,
- Forma – forma wizyty: stacjonarnie, online lub hybrydowo (połączenie
obu),
- Miasto – lokalizacja wizyty,
- Ocena – ocena lekarza w skali 1–5,
- Platnosc – typ płatności: nfz, prywatnie lub oba (oba typy wizyt).

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
### Implementacja logiki 
#### Pasuje
Sprawdza, czy lekarz spełnia wymagania użytkownika dotyczące
maksymalnego kosztu wizyty, dnia tygodnia, formy konsultacji i rodzaju
płatności.
```prolog
pasuje(Imie, Koszt, Dostepnosc, Forma, Miasto, Ocena, Platnosc,
       Specjalizacja, MaxKoszt, Dzien, PForma, PPlatnosc) :-
    lekarz(Imie, Specjalizacja, Koszt, Dostepnosc, Forma, Miasto, Ocena, Platnosc),
    (PPlatnosc = dowolna -> true
    ; PPlatnosc = nfz -> (Platnosc = nfz ; Platnosc = oba)
    ; PPlatnosc = prywatnie -> (Platnosc = prywatnie ; Platnosc = oba)
    ),
    (PPlatnosc = nfz -> true ; Koszt =< MaxKoszt),
    (Dzien = dowolny -> true ; member(Dzien, Dostepnosc)),
    (PForma = dowolna -> true ; Forma = PForma ; Forma = hybrydowo).
```
#### Znajdź
Generuje listę lekarzy spełniających kryteria użytkownika i sortuje ją
według oceny od najwyższej do najniższej.
```prolog
znajdz(Spec, MaxKoszt, Dzien, Forma, Platnosc, Wyniki) :-
    findall(
        lek(Ocena, Imie, Koszt, Forma2, Miasto, Dostepnosc, Platnosc2),
        pasuje(Imie, Koszt, Dostepnosc, Forma2, Miasto, Ocena, Platnosc2,
               Spec, MaxKoszt, Dzien, Forma, Platnosc),
        Lista
    ),
    msort(Lista, Posortowana),
    reverse(Posortowana, Wyniki).
```
#### Pokaż wyniki
Wyświetla użytkownikowi listę dopasowanych lekarzy wraz z ich
oceną, ceną, formą wizyty i dostępnością.
```prolog
pokaz_wyniki(Lista) :-
    Lista \= [],
    length(Lista, N),
    format('~nZnaleziono ~w lekarzy:~n', [N]),
    nl,
    pokaz_liste(Lista, 1).
```
#### Ograniczenia danych – system wymusza
- maksymalny koszt wizyty dla płatności prywatnej (100, 150, 200 PLN lub
brak limitu),
- dopasowanie tylko do dni, w których lekarz przyjmuje,
- dopasowanie formy wizyty: stacjonarnie, online lub hybrydowo jako
zgodne z każdą formą.
---
### Instrukcja obsługi i przykłady użycia
Aby rozpocząć pracę z systemem i uruchomić asystenta umawiania wizyt
lekarskich, należy w konsoli Prologa wpisać predykat:
```prolog
start
```
Po uruchomieniu systemu asystent wyświetli listę dostępnych specjalizacji. Z
listy należy wybrać typ lekarza, którego poszukujemy, wpisując odpowiedni
numer odpowiadający wybranej specjalizacji.
```prolog
Jakiego lekarza potrzebujesz?
  1. Internista
  2. Kardiolog
  3. Dermatolog
  4. Ortopeda
  5. Neurolog
  6. Okulista
  7. Pediatra
  8. Psychiatra
  9. Stomatolog
  10. Urolog
Podaj numer: 2
```
Po wybraniu specjalizacji asystent pyta o typ wizyty, czyli sposób płatności.
Użytkownik może wybrać jedną z opcji.
```prolog
Rodzaj wizyty?
  1. NFZ (bezpłatnie)
  2. Prywatnie
  3. Dowolny
Podaj numer: 2
```
Po wyborze typu wizyty system dostosowuje kolejne pytania w zależności od
wybranej opcji:
- Jeśli użytkownik wybierze NFZ, system pomija pytanie o budżet, ponieważ
wizyta jest bezpłatna.
- Jeśli użytkownik wybierze wizytę prywatną, asystent prosi o określenie
maksymalnego budżetu na wizytę. Można wybrać jedną z dostępnych opcji.
```prolog
Maksymalny koszt wizyty?
  1. do 100 PLN
  2. do 150 PLN
  3. do 200 PLN
  4. bez limitu
Podaj numer: 2
```
Kolejnym krokiem jest wybór preferowanego dnia tygodnia, w którym
użytkownik chciałby odbyć wizytę. System wyświetla listę dni do wyboru.
```prolog
Preferowany dzień tygodnia?
  1. Poniedziałek
  2. Wtorek
  3. Środa
  4. Czwartek
  5. Piątek
  6. Sobota
  7. Dowolny
Podaj numer: 3
```
Po wyborze preferowanego dnia system pyta o formę wizyty, czyli sposób, w
jaki wizyta ma się odbyć.
```prolog
Forma wizyty?
  1. Stacjonarnie
  2. Online
  3. Dowolna
Podaj numer: 1
```
Po podaniu wszystkich kryteriów (specjalizacja, typ wizyty, maksymalny budżet,
preferowany dzień i forma wizyty) system analizuje bazę danych i wyświetla
listę dopasowanych lekarzy.
• Jeśli znalezieni zostaną lekarze spełniający wszystkie wymagania,
asystent przedstawia ich dane, w tym imię, koszt wizyty, formę, miasto,
ocenę oraz dostępne dni.
```prolog
1. Dr Piotr Wisniewski
   Koszt: 200 PLN
   Płatność: prywatnie
   Forma: stacjonarnie
   Miasto: Warszawa
   Ocena: 5/5
   Dni: [poniedziałek, środa]
```
##### lub
```prolog
Brak lekarzy spełniających podane kryteria.
Spróbuj zmienić dzień, formę lub zwiększyć budżet.
```
