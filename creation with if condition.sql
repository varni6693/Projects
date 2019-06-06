drop sequence appt_id_sequence;
drop sequence hs_id_sequence;
drop sequence cs_id_sequence;
drop sequence cust_id_sequence;
drop table appointment;
drop table hair_stylist_schedule;
drop table customer_schedule;
drop table timeslot;
drop table cost;
drop table services;
drop table hairstylist;
drop table loe;
drop table customers;

create table customers
(
CID integer,
FirstName varchar(30) NOT NULL,
LastName varchar(30) NOT NULL,
UserName varchar(30) NOT NULL,
Password varchar(30) NOT NULL,
Phone varchar(15) NOT NULL,
primary key (CID),
unique(phone),
unique(UserName)
);

create sequence cust_id_sequence start with 5 increment by 1 maxvalue 1000;

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

create table cost
(
LID varchar(3),
SID varchar(3),
cost integer,
primary key(LID,SID),
Foreign key(LID) references loe(LID),
Foreign key(SID) references services(SID)
);

create table timeslot
(
TID varchar(3),
slots varchar(20),
primary key (TID)
);

create table customer_schedule
(
CS_ID number(10),
CID integer,
date_of_appt date,
TID varchar(3),
SID varchar(3),
unique(CID,TID,date_of_appt),
primary key(CS_ID),
Foreign key(CID) REFERENCES customers(CID),
Foreign key(TID) REFERENCES timeslot(TID)
);

create sequence cs_id_sequence start with 1001 increment by 1 maxvalue 2000;

create table hair_stylist_schedule
(
HS_ID number(10),
HID varchar(3),
date_of_appt date,
TID varchar(3),
unique(HID,date_of_appt,TID),
primary key(hs_id),
Foreign key(HID) REFERENCES hairstylist(HID),
Foreign key(TID) REFERENCES timeslot(TID)
);

create sequence hs_id_sequence start with 2001 increment by 1 maxvalue 3000;

create table appointment
(
appointment_id number(10),
cs_id number(10) unique,
hs_id number(10) unique,
cost integer,
primary key(appointment_id),
Foreign key(CS_ID) REFERENCES customer_schedule(CS_ID),
Foreign key(HS_ID) REFERENCES hair_stylist_schedule(HS_ID)
);

create sequence appt_id_sequence start with 3001 increment by 1 maxvalue 4000;

--------------Test Procedure--------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE insert_appoitment_details   
(  
p_cid IN customer_schedule.CID%TYPE,	   
p_tid IN customer_schedule.TID%TYPE,	   
p_date_of_appt customers.FirstName%TYPE,
p_hid IN hair_stylist_schedule.HID%TYPE,
p_sid IN services.sid%type
)
AS
dum integer;
dun integer;
counting integer;
BEGIN
DBMS_OUTPUT.ENABLE;
dum := cs_id_sequence.nextval;
dun := hs_id_sequence.nextval;
select count(*) into counting from customer_schedule where date_of_appt=TO_DATE(p_date_of_appt,'MM-DD-YYYY') and tid=p_tid;
--dbms_output.put_line(counting);
if counting=6 then
dbms_output.put_line(counting);
end if;
if (counting is NULL or counting<6) then
--insert in customer schedule table first
insert into customer_schedule values(dum,p_cid,TO_DATE(p_date_of_appt,'MM-DD-YYYY'),p_tid,p_sid);
--insert data in hair stylist schedule second
insert into hair_stylist_schedule values(dun,p_hid,TO_DATE(p_date_of_appt,'MM-DD-YYYY'),p_tid);
--insert into appointment table
insert into appointment (appointment_id,cs_id,hs_id) values(appt_id_sequence.nextval,dum,dun);
-- update cost
update appointment
set cost = 
(select cost from cost
where SID in (select SID from customer_schedule where cs_id=dum) and
LID in (select LID from hairstylist a, hair_stylist_schedule b where b.hid = a.hid and b.hs_id=dun)) and app;
--end update
end if;
COMMIT;  
END insert_appoitment_details; 



-----------------------------------------------------------------------------------------------------------------------