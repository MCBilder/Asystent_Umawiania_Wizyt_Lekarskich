lekarz('Dr Jan Kowalski',        internista,   120, [poniedzialek,sroda,piatek],                        stacjonarnie, warszawa, 5, prywatnie).
lekarz('Dr Anna Nowak',          internista,   100, [wtorek,czwartek,sobota],                           hybrydowo,    krakow,   4, oba).
lekarz('Dr Ewa Malinowska',      internista,     0, [poniedzialek,wtorek,sroda,czwartek,piatek],        online,       online,   4, nfz).
lekarz('Dr Piotr Wisniewski',    kardiolog,    200, [poniedzialek,sroda],                               stacjonarnie, warszawa, 5, prywatnie).
lekarz('Dr Maria Zajac',         kardiolog,      0, [wtorek,czwartek,piatek],                           hybrydowo,    wroclaw,  4, nfz).
lekarz('Dr Tomasz Krol',         dermatolog,   150, [sroda,czwartek,piatek,sobota],                    stacjonarnie, gdansk,   5, prywatnie).
lekarz('Dr Katarzyna Baran',     dermatolog,     0, [poniedzialek,wtorek,sroda],                       stacjonarnie, warszawa, 4, nfz).
lekarz('Dr Robert Lewandowski',  ortopeda,     200, [poniedzialek,czwartek],                            stacjonarnie, warszawa, 5, prywatnie).
lekarz('Dr Monika Dabrowska',    ortopeda,       0, [wtorek,sroda,sobota],                              hybrydowo,    krakow,   4, nfz).
lekarz('Dr Lukasz Szymanski',    neurolog,     220, [poniedzialek,sroda,piatek],                       stacjonarnie, wroclaw,  5, prywatnie).
lekarz('Dr Joanna Wojcik',       neurolog,     190, [wtorek,czwartek],                                  hybrydowo,    warszawa, 4, oba).
lekarz('Dr Adam Kaminski',       okulista,     140, [poniedzialek,wtorek,sroda,czwartek,piatek],       stacjonarnie, poznan,   5, prywatnie).
lekarz('Dr Barbara Kwiatkowska', okulista,       0, [sroda,czwartek,sobota],                            hybrydowo,    gdansk,   4, nfz).
lekarz('Dr Pawel Zielinski',     pediatra,     100, [poniedzialek,wtorek,sroda,czwartek,piatek],       stacjonarnie, warszawa, 5, oba).
lekarz('Dr Sylwia Wieczorek',    pediatra,       0, [wtorek,czwartek,sobota],                           hybrydowo,    krakow,   5, nfz).
lekarz('Dr Marek Jankowski',     psychiatra,   200, [poniedzialek,sroda,piatek],                       stacjonarnie, warszawa, 5, prywatnie).
lekarz('Dr Agnieszka Michalak',  psychiatra,     0, [wtorek,czwartek,sobota],                           online,       online,   4, nfz).
lekarz('Dr Krzysztof Nowicki',   stomatolog,   180, [poniedzialek,wtorek,sroda,czwartek,piatek,sobota], stacjonarnie, gdansk,  4, prywatnie).
lekarz('Dr Magdalena Grabowska', stomatolog,   150, [poniedzialek,sroda,piatek],                       stacjonarnie, wroclaw,  5, oba).
lekarz('Dr Rafal Czarnecki',     urolog,       210, [wtorek,czwartek],                                  stacjonarnie, warszawa, 4, prywatnie).

pasuje(Imie, Koszt, Dostepnosc, Forma, Miasto, Ocena, Platnosc, Specjalizacja, MaxKoszt, Dzien, PForma, PPlatnosc) :-
    lekarz(Imie, Specjalizacja, Koszt, Dostepnosc, Forma, Miasto, Ocena, Platnosc),
    (PPlatnosc = dowolna   -> true
    ;PPlatnosc = nfz       -> (Platnosc = nfz   ; Platnosc = oba)
    ;PPlatnosc = prywatnie -> (Platnosc = prywatnie ; Platnosc = oba)
    ),
    (PPlatnosc = nfz -> true ; Koszt =< MaxKoszt),
    (Dzien  = dowolny  -> true ; member(Dzien, Dostepnosc)),
    (PForma = dowolna  -> true ; Forma = PForma ; Forma = hybrydowo).

znajdz(Spec, MaxKoszt, Dzien, Forma, Platnosc, Wyniki) :-
    findall(
        lek(Ocena, Imie, Koszt, Forma2, Miasto, Dostepnosc, Platnosc2),
        pasuje(Imie, Koszt, Dostepnosc, Forma2, Miasto, Ocena, Platnosc2,
               Spec, MaxKoszt, Dzien, Forma, Platnosc),
        Lista
    ),
    msort(Lista, Posortowana),
    reverse(Posortowana, Wyniki).

pokaz_wyniki([]) :-
    nl,
    write('Brak lekarzy spelniajacych podane kryteria.'), nl,
    write('Sprobuj zmienic dzien, forme lub zwiekszyc budzet.'), nl.

pokaz_wyniki(Lista) :-
    Lista \= [],
    length(Lista, N),
    format('~nZnaleziono ~w lekarzy:~n', [N]),
    nl,
    pokaz_liste(Lista, 1).

pokaz_liste([], _).
pokaz_liste([lek(Ocena,Imie,Koszt,Forma,Miasto,Dni,Platnosc)|Reszta], Nr) :-
    format('~w. ~w~n',      [Nr, Imie]),
    ( Koszt =:= 0
    -> write('   Koszt:  bezplatnie (NFZ)'), nl
    ;  format('   Koszt:  ~w PLN~n', [Koszt])
    ),
    format('   Platnosc: ~w~n',  [Platnosc]),
    format('   Forma:    ~w~n',  [Forma]),
    format('   Miasto:   ~w~n',  [Miasto]),
    format('   Ocena:    ~w/5~n',[Ocena]),
    write('   Dni:      '), write(Dni), nl,
    nl,
    Nr1 is Nr + 1,
    pokaz_liste(Reszta, Nr1).

start :-
    nl,
    write('==================================='), nl,
    write('  ASYSTENT UMAWIANIA WIZYT LEKARSKICH'), nl,
    write('==================================='), nl,
    nl,

    write('Jakiego lekarza potrzebujesz?'), nl,
    write('  1. Internista'), nl,
    write('  2. Kardiolog'), nl,
    write('  3. Dermatolog'), nl,
    write('  4. Ortopeda'), nl,
    write('  5. Neurolog'), nl,
    write('  6. Okulista'), nl,
    write('  7. Pediatra'), nl,
    write('  8. Psychiatra'), nl,
    write('  9. Stomatolog'), nl,
    write('  10. Urolog'), nl,
    write('Podaj numer: '),
    read(WS),
    specjalizacja(WS, Spec),
    nl,

    write('Rodzaj wizyty?'), nl,
    write('  1. NFZ (bezplatnie)'), nl,
    write('  2. Prywatnie'), nl,
    write('  3. Dowolny'), nl,
    write('Podaj numer: '),
    read(WP),
    platnosc(WP, Platnosc),
    nl,

    ( Platnosc = nfz ->
        MaxKoszt = 9999
    ;
        write('Maksymalny koszt wizyty?'), nl,
        write('  1. do 100 PLN'), nl,
        write('  2. do 150 PLN'), nl,
        write('  3. do 200 PLN'), nl,
        write('  4. bez limitu'), nl,
        write('Podaj numer: '),
        read(WB),
        budzet(WB, MaxKoszt),
        nl
    ),

    write('Preferowany dzien tygodnia?'), nl,
    write('  1. Poniedzialek'), nl,
    write('  2. Wtorek'), nl,
    write('  3. Sroda'), nl,
    write('  4. Czwartek'), nl,
    write('  5. Piatek'), nl,
    write('  6. Sobota'), nl,
    write('  7. Dowolny'), nl,
    write('Podaj numer: '),
    read(WD),
    dzien(WD, Dzien),
    nl,

    write('Forma wizyty?'), nl,
    write('  1. Stacjonarnie'), nl,
    write('  2. Online'), nl,
    write('  3. Dowolna'), nl,
    write('Podaj numer: '),
    read(WF),
    forma(WF, Forma),
    nl,

    write('==================================='), nl,
    znajdz(Spec, MaxKoszt, Dzien, Forma, Platnosc, Wyniki),
    pokaz_wyniki(Wyniki).


specjalizacja(1,  internista).
specjalizacja(2,  kardiolog).
specjalizacja(3,  dermatolog).
specjalizacja(4,  ortopeda).
specjalizacja(5,  neurolog).
specjalizacja(6,  okulista).
specjalizacja(7,  pediatra).
specjalizacja(8,  psychiatra).
specjalizacja(9,  stomatolog).
specjalizacja(10, urolog).

platnosc(1, nfz).
platnosc(2, prywatnie).
platnosc(3, dowolna).

budzet(1, 100).
budzet(2, 150).
budzet(3, 200).
budzet(4, 9999).

dzien(1, poniedzialek).
dzien(2, wtorek).
dzien(3, sroda).
dzien(4, czwartek).
dzien(5, piatek).
dzien(6, sobota).
dzien(7, dowolny).

forma(1, stacjonarnie).
forma(2, online).
forma(3, dowolna).