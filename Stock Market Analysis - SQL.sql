#Change the date format in all the six csv files to'YYYY-MM-DD' format by selecting the Location as English(Phillipines) in the excel and selecting the 'YYYY-MM-DD' format
#Fill the missing data with 0 in all the csv files
#Create the tables for all the six stocks by using the Table Import Wizard and selecting appropriate data types

# Modifying the data type of the Date column to date in all the six  tables 

alter table bajaj_auto modify `Date` date;

alter table eicher_motors modify `Date` date;

alter table hero_motocorp modify `Date` date;

alter table infosys modify `Date` date;

alter table tcs modify `Date` date;

alter table tvs_motors modify `Date` date;


# Details of the all the six tables containing the stock information
# --------------Bajaj------------------------
describe bajaj_auto;

select * from bajaj_auto order by 1;

select count(1) from bajaj_auto;

# --------------Eicher------------------------
describe eicher_motors;

select * from eicher_motors  order by 1;

select count(1) from eicher_motors;

# -------------Hero----------------------------
describe hero_motocorp;

select * from hero_motocorp  order by 1;

select count(1) from hero_motocorp;

# -------------Infosys-------------------------
describe infosys;

select * from infosys order by 1;

select count(1) from infosys;

# ---------------TCS----------------------------
describe tcs;

select * from tcs  order by 1;

select count(1) from tcs;

# --------------TVS----------------------------
describe tvs_motors;

select * from tvs_motors  order by 1;

select count(1) from tvs_motors;


#---------------Task-1---------------------------
#Creating the tables for all the six stocks to store the 20 Day Moving Average & 50 Day Moving Average
# ---------------Bajaj----------------------------

drop table  if exists bajaj1;

create table bajaj1 as
 select `Date`,
 `Close Price`, 
 avg(`Close Price`) over (order by `Date` rows between 19 preceding and current row ) as `20 Day MA`, 
 avg(`Close Price`) over (order by `Date` rows between 49 preceding and current row ) as `50 Day MA` from assignment.bajaj_auto order by 1;

# ---------------Eicher----------------------------
drop table  if exists eicher1;

create table eicher1 as
 select `Date`,
 `Close Price`, 
 avg(`Close Price`) over (order by `Date` rows between 19 preceding and current row )as `20 Day MA`,
 avg(`Close Price`) over (order by `Date` rows between 49 preceding and current row ) as `50 Day MA` from assignment.eicher_motors order by 1;

# ---------------Hero----------------------------
drop table  if exists hero1;

create table hero1 as
 select`Date`,
 `Close Price`, 
 avg(`Close Price`) over (order by `Date` rows between 19 preceding and current row )as `20 Day MA`,
 avg(`Close Price`) over (order by `Date` rows between 49 preceding and current row ) as `50 Day MA` from assignment.hero_motocorp order by 1;

# ---------------Infosys----------------------------
drop table  if exists infosys1;

create table infosys1 as
 select`Date`,
 `Close Price`, 
 avg(`Close Price`) over (order by `Date` rows between 19 preceding and current row )as `20 Day MA`,
 avg(`Close Price`) over (order by `Date` rows between 49 preceding and current row ) as `50 Day MA` from assignment.infosys order by 1;
 
 # ---------------TCS----------------------------
 drop table  if exists tcs1;

 create table tcs1 as
 select`Date`,
 `Close Price`, 
 avg(`Close Price`) over (order by `Date`  rows between 19 preceding and current row )as `20 Day MA`,
 avg(`Close Price`) over (order by `Date`  rows between 49 preceding and current row ) as `50 Day MA` from assignment.tcs order by 1;

# ---------------TVS----------------------------
drop table  if exists tvs1;

create table tvs1 as
 select`Date`,
 `Close Price`, 
 avg(`Close Price`) over (order by `Date`  rows between 19 preceding and current row )as `20 Day MA`,
 avg(`Close Price`) over (order by `Date`  rows between 49 preceding and current row ) as `50 Day MA` from assignment.tvs_motors order by 1;


#Details of all the six tables storing the 20 Day MA & 50 Day MA
# ---------------Bajaj----------------------------
describe bajaj1;

select * from bajaj1 order by 1;

select count(1) from bajaj1;

# ---------------Eicher----------------------------
describe eicher1;

select * from eicher1 order by 1;

select count(1) from eicher1;

# ---------------Hero----------------------------
describe hero1;

select * from hero1 order by 1;

select count(1) from hero1;


# ---------------Infosys----------------------------
describe infosys1;

select * from infosys1 order by 1;

select count(1) from infosys1;


# ---------------TCS----------------------------
describe tcs1;

select * from tcs1 order by 1;

select count(1) from tcs1;

# ---------------TVS----------------------------
describe tvs1;

select * from tvs1 order by 1;

select count(1) from tvs1;


#---------------Task-2---------------------------
#Creating master table containing the date and close price of all the six stocks
drop table if exists master_stock;

create table master_stock (
`Date` date,
 Bajaj double,
 TCS double,
 TVS double, 
 Infosys double,
 Eicher double,
 Hero double);
 
# Inserting the values into the master table
Insert into master_stock(`Date`,Bajaj,TCS,TVS,Infosys,Eicher,Hero) 
(select b.`Date`,b.`Close Price`,
tcs.`Close Price`,tvs.`Close Price`,
i.`Close Price`,e.`Close Price`,h.`Close Price`
from assignment.bajaj_auto b inner join assignment.tcs tcs inner join assignment.tvs_motors tvs
inner join assignment.infosys i inner join assignment.eicher_motors e inner join assignment.hero_motocorp h on b.`Date`= tcs.`Date` && b.`Date`= tvs.`Date`&& b.`Date`=e.`Date`&&b.`Date`=h.`Date`&& b.`Date`=i.`Date`) order by 1;

#Details of the master table
describe master_stock;

select * from master_stock order by 1;

select count(1) from master_stock;


#---------------Task-3---------------------------
#Creating the tables for all the six stocks to store the BUY/SELL/HOLD Signal   
# ---------------Bajaj----------------------------
drop table if exists bajaj2;
 
create table bajaj2 as
select`Date`,
 `Close Price`, 
 if(`20 Day MA` >`50 Day MA` && lag(`20 Day MA`,1) over (order by `Date`)<lag(`50 Day MA`,1) over (order by `Date`),"BUY",
 if(`20 Day MA` <`50 Day MA` && lag(`20 Day MA`,1) over (order by `Date`)>lag(`50 Day MA`,1) over (order by `Date`),"SELL","HOLD") ) as `Signal` from assignment.bajaj1 order by 1;

# ---------------Eicher----------------------------
drop table if exists eicher2;

create table eicher2 as
select`Date`,
 `Close Price`, 
 if(`20 Day MA` >`50 Day MA` && lag(`20 Day MA`,1) over (order by `Date`)<lag(`50 Day MA`,1) over (order by `Date`),"BUY",
 if(`20 Day MA` <`50 Day MA` && lag(`20 Day MA`,1) over (order by `Date`)>lag(`50 Day MA`,1) over (order by `Date`),"SELL","HOLD") ) as `Signal` from assignment.eicher1 order by 1;

# ---------------Hero----------------------------
drop table if exists hero2;

create table hero2 as
select`Date`,
 `Close Price`, 
 if(`20 Day MA` >`50 Day MA` && lag(`20 Day MA`,1) over (order by `Date`)<lag(`50 Day MA`,1) over (order by `Date`),"BUY",
 if(`20 Day MA` <`50 Day MA` && lag(`20 Day MA`,1) over (order by `Date`)>lag(`50 Day MA`,1) over (order by `Date`),"SELL","HOLD") ) as `Signal` from assignment.hero1 order by 1;

# ---------------Infosys----------------------------
drop table if exists infosys2;

create table infosys2 as
select`Date`,
 `Close Price`, 
 if(`20 Day MA` >`50 Day MA` && lag(`20 Day MA`,1) over (order by `Date`)<lag(`50 Day MA`,1) over (order by `Date`),"BUY",
 if(`20 Day MA` <`50 Day MA` && lag(`20 Day MA`,1) over (order by `Date`)>lag(`50 Day MA`,1) over (order by `Date`),"SELL","HOLD") ) as `Signal` from assignment.infosys1 order by 1;
 
# ---------------TCS----------------------------
drop table if exists tcs2;

create table tcs2 as
select`Date`,
 `Close Price`, 
 if(`20 Day MA` >`50 Day MA` && lag(`20 Day MA`,1) over (order by `Date`)<lag(`50 Day MA`,1) over (order by `Date`),"BUY",
 if(`20 Day MA` <`50 Day MA` && lag(`20 Day MA`,1) over (order by `Date`)>lag(`50 Day MA`,1) over (order by `Date`),"SELL","HOLD") ) as `Signal` from assignment.tcs1 order by 1;
 
# ---------------TVS----------------------------
drop table if exists tvs2;

create table tvs2 as
select`Date`,
 `Close Price`, 
 if(`20 Day MA` >`50 Day MA` && lag(`20 Day MA`,1) over (order by `Date`)<lag(`50 Day MA`,1) over (order by `Date`),"BUY",
 if(`20 Day MA` <`50 Day MA` && lag(`20 Day MA`,1) over (order by `Date`)>lag(`50 Day MA`,1) over (order by `Date`),"SELL","HOLD") ) as `Signal` from assignment.tvs1 order by 1;


#Details of all the six tables storing the BUY/SELL/HOLD signal
# ---------------Bajaj----------------------------
describe bajaj2;

select * from bajaj2 order by 1;

select count(1) from bajaj2;

# ---------------Eicher----------------------------
describe eicher2;

select * from eicher2 order by 1;

select count(1) from eicher2;

# ---------------Hero----------------------------
describe hero2;

select * from hero2 order by 1;

select count(1) from hero2;


# ---------------Infosys----------------------------
describe infosys2;

select * from infosys2 order by 1;

select count(1) from infosys2;



# ---------------TCS----------------------------
describe tcs2;

select * from tcs2 order by 1;

select count(1) from tcs2;

# ---------------TVS----------------------------
describe tvs2;

select * from tvs2 order by 1;

select count(1) from tvs2;


#---------------Task-4---------------------------
# User Defined function to get the signal on a particular date for Bajaj Auto stock
drop function if exists fn_getSignal_Bajaj;

DELIMITER $$
create function fn_getSignal_Bajaj(d date) returns varchar(4) deterministic
Begin
  
  declare `Signal_Bajaj` varchar(4) ;
  select `Signal` into `Signal_Bajaj` from bajaj2 where `Date`= d;
  return `Signal_Bajaj`;

END$$
DELIMITER ;


# Calling the funtion fn_getSignal_Bajaj() by passing the date as the input parameter
select fn_getSignal_Bajaj('2015-03-02');


