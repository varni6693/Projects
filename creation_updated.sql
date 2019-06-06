drop sequence apt_sequence;
drop table appointment;
drop table timeslot;
drop table services;
drop table hairstylist;
drop table loe;
drop table customers;

create table customers
(
CID varchar(3),
FirstName varchar(30) NOT NULL,
LastName varchar(30) NOT NULL,
UserName varchar(30) NOT NULL,
Password varchar(30) NOT NULL,
Phone varchar(15) NOT NULL,
primary key (CID),
unique(phone),
unique(UserName)
);

create table loe
(
LID varchar(2),
Description varchar(20),
primary key (LID)
);

create table hairstylist
(
HID varchar(3),
FirstName varchar(30),
LastName varchar(30),
LID varchar(20),
primary key(HID),
Foreign key (LID) REFERENCES loe(LID)
);

create table services
(
SID varchar(3),
Description varchar(20),
primary key (SID)
);

create table timeslot
(
TID varchar(3),
slots varchar(20),
primary key (TID)
);

create table appointment
(
aptid integer,
dateofapp date,
HID varchar(3),
CID varchar(3),
SID varchar(3),
TID varchar(3),
primary key(aptid),
Foreign key (HID) REFERENCES hairstylist(HID),
Foreign key (CID) REFERENCES customers(CID),
Foreign key (SID) REFERENCES services(SID),
Foreign key (TID) REFERENCES timeslot(TID),
unique(dateofapp,HID,TID,CID)
);

Create sequence apt_sequence start with 1
increment by 1
minvalue 1
maxvalue 10000
==================================================
create table customer_schedule
(
CS_ID number(10),
CID varchar(3),
TID varchar(3),
date_of_appt date,
primary key(CS_ID),
Foreign key(CID) REFERENCES customers(CID),
Foreign key(TID) REFERENCES timeslot(TID)
);

create sequence cs_id_sequence start with 1 increment by 1 minvalue 1;

create table hair_stylist_schedule
(
HS_ID number(10),
date_of_appt date,
HID varchar(3),
TID varchar(3),
primary key(hs_id),
Foreign key(HID) REFERENCES hairstylist(HID),
Foreign key(TID) REFERENCES timeslot(TID)
);

create sequence hs_id_sequence start with 1 increment by 1 minvalue 1;

create table appointment
(
appointment_id number(10),
cs_id number(10),
hs_id number(10),
primary key(appointment_id),
Foreign key(CS_ID) REFERENCES customer_schedule(CS_ID),
Foreign key(HS_ID) REFERENCES hair_stylist_schedule(HS_ID)
);

create sequence appointment_id_sequence start with 1000 increment by 1 minvalue 1000;