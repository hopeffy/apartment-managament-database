-- create person table

create table Person (
    person_id int not null AUTO_INCREMENT,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    birthdate date not null,
    identify_number varchar(11) not null,
    phone_number varchar(20) not null,
    email varchar(50) not null,
    p_password varchar(20) not null,

    PRIMARY KEY(person_id)

);

-- insertion from unf to person table

INSERT INTO person(first_name,last_name , birthdate, identify_number,phone_number, email, p_password )
SELECT DISTINCT p.tenantName , p.TenantSurname , p.TenantBirthdate, p.TenantIdentifyNumber, p.TenantPhoneNo, p.TenantEmail, p.TenantPassword
FROM apartment_management_data p;

INSERT INTO person(first_name,last_name , birthdate, identify_number,phone_number, email, p_password )
SELECT DISTINCT p.landlordName , p.landlordSurname , p.LandlordBirthdate, p.LandlordIdentifyNumber, p.LandlordPhoneNo, p.LandlordEmail, p.LandlordPassword
FROM apartment_management_data p;

-- create tenant table

create table Tenant (
    tenant_id varchar(10),
    person_id int not null,
    moveIn date,
    moveOut date,

    PRIMARY KEY(tenant_id),
    FOREIGN KEY (person_id) REFERENCES Person(person_id)
);

-- insertion from unf to tenant table

INSERT INTO tenant(tenant_id , person_id, moveIn, moveOut)
SELECT DISTINCT t.TenantId, p.person_id, t.MoveIn, t.MoveOut
FROM apartment_management_data t join person p on p.identify_number = t.TenantIdentifyNumber;

-- drop related columns from unf tables

Alter table apartment_management_data
DROP COLUMN TenantName, 
DROP COLUMN TenantSurname,
DROP COLUMN TenantBirthdate, 
DROP COLUMN TenantIdentifyNumber, 
DROP COLUMN TenantPhoneNo,
DROP COLUMN TenantEmail,
DROP COLUMN TenantPassword,
DROP COLUMN MoveIn,
DROP COLUMN MoveOut;

-- create landlord table

create table landlord (
    landlord_id varchar(10),
    person_id int not null,

    PRIMARY KEY(landlord_id),
    FOREIGN KEY (person_id) REFERENCES Person(person_id)
);

-- insertion from unf to landlord table

INSERT INTO landlord(landlord_id , person_id)
SELECT DISTINCT l.LandlordId , p.person_id
FROM apartment_management_data l join person p on p.identify_number = l.LandlordIdentifyNumber;

-- drop related columns from unf tables

Alter table apartment_management_data
DROP COLUMN LandlordName, 
DROP COLUMN LandlordSurname,
DROP COLUMN LandlordBirthdate, 
DROP COLUMN LandlordIdentifyNumber, 
DROP COLUMN LandlordPhoneNo,
DROP COLUMN LandlordEmail,
DROP COLUMN LandlordPassword;

-- create property table

create table property (
    property_id varchar(10),
    landlord_id varchar(10),
    door_number varchar(255) not null,
    market_price decimal not null,
    floor_area int not null,
    rooms int not null,

    PRIMARY KEY(property_id),
    FOREIGN KEY (landlord_id) REFERENCES Landlord(landlord_id)
);

-- insertion from unf to property table

INSERT INTO property(property_id , landlord_id ,door_number, market_price , floor_area, rooms)
SELECT DISTINCT p.PropertyId, l.landlord_id, p.PropertyDoorNo, p.PropertyPrice, p.PropertyFloorArea, p.PropertyRooms
FROM apartment_management_data p join landlord l on l.landlord_id = p.LandlordId;

-- drop related columns from unf tables

Alter table apartment_management_data
DROP COLUMN PropertyDoorNo, 
DROP COLUMN PropertyPrice,
DROP COLUMN PropertyFloorArea, 
DROP COLUMN PropertyRooms;

-- create Apartment table

create table Apartment (
    apartment_id varchar(10),
    property_id varchar(10),
    floors int not null,
    pool varchar(20) not null,
    playground varchar(20) not null,
    garden varchar(20) not null,
    garage varchar(20) not null,


    PRIMARY KEY(apartment_id),
    FOREIGN KEY (property_id) REFERENCES Property(property_id)
);

-- insertion from unf to Apartment table

INSERT INTO apartment(apartment_id , property_id, floors, pool ,playground, garden, garage)
SELECT DISTINCT p.ApartmentId, pty.property_id, p.ApartmentFloor, p.Pool, p.Playground, p.Garden, p.Garage
FROM apartment_management_data p join property pty on p.PropertyId = pty.property_id;

-- drop related columns from unf tables

Alter table apartment_management_data
DROP COLUMN ApartmentFloor;

-- create Complaint table

create table Complaint (
    complaint_id varchar(10),
    landlord_id varchar(10),
    tenant_id varchar(10) not null,
    complaint_title varchar(50) not null,
    complaint_text varchar(300) not null,


    PRIMARY KEY(complaint_id),
    FOREIGN KEY (landlord_id) REFERENCES landlord(landlord_id),
    FOREIGN KEY (tenant_id) REFERENCES tenant(tenant_id)
);

-- insertion from unf to Complaint table

INSERT INTO Complaint(complaint_id, landlord_id, tenant_id, complaint_title,complaint_text)
SELECT DISTINCT c.ContractId, l.landlord_id , t.tenant_id, c.ComplaintTitle, c.ComplaintText
FROM apartment_management_data c join landlord l on l.landlord_id = c.LandlordId
join tenant t on t.tenant_id = c.TenantId;

-- drop related columns from unf tables

Alter table apartment_management_data
DROP COLUMN ComplaintTitle, 
DROP COLUMN ComplaintText;

-- create Contract table

create table Contract (
    contract_id varchar(10),
    property_id varchar(10),
    landlord_id varchar(10),
    tenant_id varchar(10),
    valid_until date not null,
    rent_amount decimal not null,
    pledge_amount decimal not null,
    sign_date date not null,

    PRIMARY KEY(contract_id),
    FOREIGN KEY (property_id) REFERENCES Property(property_id),
    FOREIGN KEY (landlord_id) REFERENCES Landlord(landlord_id),
    FOREIGN KEY (tenant_id) REFERENCES Tenant(tenant_id)
);

-- insertion from unf to Contract table

INSERT INTO Contract(contract_id , property_id, landlord_id, tenant_id, valid_until, rent_amount, pledge_amount, sign_date)
SELECT DISTINCT c.ContractId, pty.property_id, l.landlord_id , t.tenant_id, c.ContractValidUntilDate, c.ContractRentAmount, c.ContractPledgeAmount, c.ContractSignDate
FROM apartment_management_db c join landlord l on l.landlord_id = c.LandlordId
join property pty on pty.property_id = c.PropertyId
join tenant t on t.tenant_id = c.TenantId;

-- drop unf tables

Drop table apartment_management_data;
