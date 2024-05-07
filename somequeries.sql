-- a view is a virtual table based on the result-set of an SQL statement. 

create view back_3NF_to_1NF as
select a.apartment_id, a.property_id, a.floors, a.pool, a.playground, a.garden, a.garage, 
co.complaint_id, co.landlord_id, co.tenant_id, co.complaint_title, co.complaint_text,
c.contract_id, c.property_id, c.landlord_id, c.tenant_id, c.valid_until, c.rent_amount, c.pledge_amount, c.sign_date,
l.landlord_id, l.person_id,
p.person_id, p.first_name, p.last_name, p.birthdate, p.identify_number, p.phone_number, p.email, p.p_password,
pro.property_id, pro.landlord_id, pro.door_number, pro.market_price, pro.floor_area, pro.rooms,
t.tenant_id, t.person_id, t.moveIn, t.moveOut
from apartment a, complaint co, contract c, landlord l, person p, property pro, tenant t
where pro.property_id = a.property_id and c.property_id = pro.property_id and
t.tenant_id = co.tenant_id and c.tenant_id = t.tenant_id and
l.landlord_id = co.landlord_id and c.landlord_id = l.landlord_id and
l.person_id = p.person_id and t.person_id = p.person_id and
pro.landlord_id = l.landlord_id;

-- 1.	List all residents at a certain property.
-- This is the queries, shows whose contract date is still in progress, so it mean whose live in property at the moment.

SELECT person.person_id, person.first_name, person.last_name, person.birthdate, person.identify_number, person.phone_number, person.email
FROM person JOIN tenant ON person.person_id = tenant.person_id
JOIN contract ON tenant.tenant_id = contract.tenant_id WHERE CONTRACT.VALID_UNTIL > NOW();

-- 2.	A list all landlords and how many properties each owns.
-- This is the queries, shows how many properties landlords have.

SELECT property.property_id AS property_id, 
landlord.landlord_id AS landlord_id,
person.first_name AS landlords_name , person.last_name AS landlords_lastname,
count(property_id) AS hasProperities
FROM property join landlord on  landlord.landlord_id = property.landlord_id
join person on person.person_id = landlord.person_id
group by property_id;

-- 3.	A way to change the rent amount.
-- This is the queries that by using the contract id we changed the rent amount.

UPDATE EXAMPLE_DB.CONTRACT
SET RENT_AMOUNT = 15123
WHERE CONTRACT.CONTRACT_ID LIKE "C4";

-- 4.	A way to add a new property.
-- This is the queries that added the new property.

INSERT INTO PROPERTY(PROPERTY_ID , LANDLORD_ID ,DOOR_NUMBER, MARKET_PRICE , FLOOR_AREA, ROOMS)
VALUES ('P17', 'L1', '6', '4500000', '150', '4');


-- 5.	A way to remove a tenant from the system.
-- This is the queries that removing a tenant from the system. 

DELETE FROM TENANT
WHERE TENANT_ID LIKE "T1";
