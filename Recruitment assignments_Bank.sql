--Tworzenie tabel w SQL / Creates tables in SQL

create table klienci_2 (klient_id number(1,0), klient_nazwisko varchar2(25), plec varchar2(1), klient_od varchar2(4));

select
*
from klienci_2;

insert into klienci_2 values(1, 'Majewski', 'M', '2005');
select* from klienci_2;

insert into klienci_2 values(2, 'Kuczaj', 'M', '2020');
insert into klienci_2 values(3, 'Adamiak', 'M', '1992');
insert into klienci_2 values(4, 'Grzechnik', 'K', '2004');
insert into klienci_2 values(5, 'Andrzejewski', 'M', '2009');
insert into klienci_2 values(6, 'Karbowska', 'K', '2015');
insert into klienci_2 values(7, 'Bugaj', 'K', '1998');
insert into klienci_2 values(8, 'Mazur', 'K', '2020');

select * from klienci_2;

---truncate table klienci;

create table lokaty (klient_id number(1,0), lokata_id varchar2(3), waluta varchar2(3), kwota_w_pln number(6,0));

insert into lokaty values (1, '100', 'EUR', 1000);
insert into lokaty values (2, '101', 'EUR', 2500);
insert into lokaty values (3, '102', 'EUR', 75000);
insert into lokaty values (4, '103', 'PLN', 15000);
insert into lokaty values (5, '104', 'PLN', 850);
insert into lokaty values (6, '105', 'PLN', 7000);
select* from lokaty;
delete from lokaty where klient_id=6;
select* from lokaty;
--insert into lokaty values (1, '100', 'EUR', 1000);
insert into lokaty values (4, '103', 'PLN', 15000);
insert into lokaty values (5, '104', 'PLN', 850);
insert into lokaty values (6, '105', 'PLN', 7000);

insert into lokaty values (5, '106', 'USD', 25000);

select * from lokaty;

insert into lokaty values (8, '107', 'PLN', 200);
insert into lokaty values (7, '108', 'PLN', 1250);
insert into lokaty values (2, '109', 'EUR', 350);
insert into lokaty values (7, '110', 'PLN', 200000);

select * from lokaty;

--Zadanie 1. Jaki procent klientów banku to mê¿czyŸni? Ile œrednio lokat (w sztukach)
--w ka¿dej z walut, ma mê¿czyzna-klient banku.

-- pierwszy sposób gdzie od razu widaæ ¿e 50% to mê¿czyŸni

select
plec,
count(*)
from klienci_2
group by rollup (plec);

-- drugi sposób

select 
count(
case
when plec = 'M' then 1
end) as ilosc_mezczyzn,
count(*) as ilosc_wszystkich
from klienci_2;

select 
count(
case
when plec = 'M' then 1
end) *100 /
count(*) as procent_mezczyzn
from klienci_2;

--Ile œrednio lokat (w sztukach) w ka¿dej z walut, ma mê¿czyzna-klient banku.



select 
waluta,
plec,
count(lokata_id)
from klienci_2 k
join lokaty l on k.klient_id = l.klient_id
group by waluta, plec
having plec = 'M';

--Zadanie 2 / Ile kobiet i ilu mê¿czyzn ma lokaty w PLN,
--z których przynajmniej jedna lokata jest mniejsza ni¿ 5000 z³.

select 
plec,
waluta,
count(*)
from klienci_2 k join lokaty l on k.klient_id=l.klient_id
where kwota_w_pln < 5000 or kwota_w_pln > 5000
group by plec,waluta
having waluta = 'PLN';

select *
from klienci_2 k join lokaty l on k.klient_id=l.klient_id;

---Zadanie 3 /  Wybierz klienta, który ma 
--najwiêksz¹ lokatê w PLN i podaj sumê lokat jakie ten klient posiada w ka¿dej z walut.


select
waluta,
max(kwota_w_pln) as maksymalna_lokata,
count(lokata_id) as ilosc_lokat
from
klienci_2 k join lokaty l on k.klient_id=l.klient_id
group by waluta;

-- stad wiem ze chodzi o klient o kliet_id = 7 

---Zadanie 3 /  Wybierz klienta, który ma 
--najwiêksz¹ lokatê w PLN i podaj sumê lokat jakie ten klient posiada w ka¿dej z walut.

select
klient_id, 
max(kwota_w_pln) max_lokata
from klienci_2 join lokaty using (klient_id)
group by klient_id;

-- tu widzimy dla kazdego klienta jaka jest maksymalna lokata i widze ze najwyzsza z tego jest dla klienta o id=7

--suma lokat jakie ten klient posiada w kazdej z walut





select
klient_id,
waluta,
count(lokata_id)
from klienci_2 join lokaty using (klient_id)
--where klient_id=7
group by waluta,klient_id
having klient_id=7;

--cos nie tak, bo ten klient ma tylko 2 lokaty.

---Zadanie 4

--Utwórz tabelê zawieraj¹c¹ nastêpuj¹ce informacje:
--p³eæ, waluta, liczba lokat, suma lokat. 
--Tabela ma byæ segmentacj¹ lokat bankowych wg p³ci klienta i waluty lokaty.

select
    k.plec,
    l.waluta,
    count(l.lokata_id) as liczba_lokat,
    sum(l.kwota_w_PLN) as suma_lokat
from
    klienci_2 k
join
    lokaty l ON k.klient_id = l.klient_id
group by
    k.plec, l.waluta;
    
---Zadanie 5

--Wybierz nazwiska klientów, którzy maj¹ mniej œrodków zainwestowanych we wszystkie lokaty,
--ni¿ wszyscy mê¿czyŸni maj¹ zainwestowane w lokaty w euro.

select k.klient_nazwisko
from klienci_2 k
join lokaty l on k.klient_id = l.klient_id
group by k.klient_id, k.klient_nazwisko
having sum(l.kwota_w_pln) < (
    select sum(l.kwota_w_pln)
    from klienci_2 k
    join lokaty l on k.klient_id = l.klient_id
    where k.plec = 'M' and l.waluta = 'EUR'
);
