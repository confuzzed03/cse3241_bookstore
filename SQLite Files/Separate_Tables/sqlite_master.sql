INSERT INTO "sqlite_master" VALUES('table','Address','Address',2,'CREATE TABLE "Address" ("AddressID" INTEGER PRIMARY KEY  NOT NULL , "Street" VARCHAR, "City" VARCHAR, "State" VARCHAR, "Zip" VARCHAR)');
INSERT INTO "sqlite_master" VALUES('table','Author','Author',3,'CREATE TABLE "Author" ("PersonID" INTEGER PRIMARY KEY NOT NULL ,"Favorites" INTEGER,"Rating" DOUBLE,"Birthdate" VARCHAR DEFAULT (null), FOREIGN KEY("PersonID") REFERENCES "Person(PersonID)" )');
INSERT INTO "sqlite_master" VALUES('table','Book','Book',4,'CREATE TABLE "Book" ("ISBN" VARCHAR PRIMARY KEY  NOT NULL ,"Price" DOUBLE DEFAULT (null) ,"Year" INTEGER,"Title" VARCHAR,"Category" VARCHAR DEFAULT (null) ,"Stock" INTEGER DEFAULT (0) )');
INSERT INTO "sqlite_master" VALUES('index','sqlite_autoindex_Book_1','Book',5,NULL);
INSERT INTO "sqlite_master" VALUES('table','Customer','Customer',6,'CREATE TABLE "Customer" ("PersonID" INTEGER PRIMARY KEY  NOT NULL ,"Preferences" VARCHAR,"Username" VARCHAR,"Password" VARCHAR,"EmailAddress" VARCHAR DEFAULT (null), FOREIGN KEY ("PersonID") REFERENCES "Person(PersonID)" )');
INSERT INTO "sqlite_master" VALUES('table','Have_Purchased','Have_Purchased',7,'CREATE TABLE "Have_Purchased" ("ISBN" VARCHAR NOT NULL , "PersonID" INTEGER NOT NULL , "Qty" INTEGER, PRIMARY KEY ("ISBN", "PersonID"), FOREIGN KEY ("ISBN") REFERENCES "Book(ISBN)", FOREIGN KEY ("PersonID") REFERENCES "Person(PersonID)")');
INSERT INTO "sqlite_master" VALUES('index','sqlite_autoindex_Have_Purchased_1','Have_Purchased',8,NULL);
INSERT INTO "sqlite_master" VALUES('table','Offline','Offline',9,'CREATE TABLE "Offline" ("OrderNumber" INTEGER PRIMARY KEY  NOT NULL  DEFAULT (null) ,"Location" VARCHAR, FOREIGN KEY ("OrderNumber") REFERENCES "Order(OrderNumber)" )');
INSERT INTO "sqlite_master" VALUES('table','Online','Online',10,'CREATE TABLE "Online" ("OrderNumber" INTEGER PRIMARY KEY  NOT NULL  DEFAULT (null) ,"DeliveryDay" DATETIME DEFAULT (null) ,"TrackingNum" INTEGER DEFAULT (null), FOREIGN KEY ("OrderNumber") REFERENCES "Order(OrderNumber)" )');
INSERT INTO "sqlite_master" VALUES('table','Order','Order',11,'CREATE TABLE "Order" ("OrderNumber" INTEGER PRIMARY KEY  NOT NULL  DEFAULT (null) ,"Date" DATETIME,"TransNum" INTEGER,"AddressID" INTEGER,"Status" VARCHAR, FOREIGN KEY ("TransNum") REFERENCES "Payment(TransNum)", FOREIGN KEY ("AddressID") REFERENCES "Address(AddressID)" )');
INSERT INTO "sqlite_master" VALUES('table','Order_For','Order_For',12,'CREATE TABLE "Order_For" ("ISBN" VARCHAR PRIMARY KEY  NOT NULL ,"OrderNumber" INTEGER NOT NULL  DEFAULT (null) ,"Qty" INTEGER, FOREIGN KEY ("OrderNumber") REFERENCES "Order(OrderNumber)", FOREIGN KEY ("ISBN") REFERENCES "Book(ISBN)" )');
INSERT INTO "sqlite_master" VALUES('index','sqlite_autoindex_Order_For_1','Order_For',13,NULL);
INSERT INTO "sqlite_master" VALUES('table','Person','Person',15,'CREATE TABLE "Person" ("PersonID" INTEGER PRIMARY KEY  NOT NULL , "First" VARCHAR, "Middle" VARCHAR, "Last" VARCHAR, "AddressID" INTEGER REFERENCES "Address(AddressID)")');
INSERT INTO "sqlite_master" VALUES('table','Published_By','Published_By',16,'CREATE TABLE "Published_By" ("PublisherName" VARCHAR NOT NULL , "ISBN" VARCHAR NOT NULL , PRIMARY KEY ("PublisherName", "ISBN"), FOREIGN KEY ("PublisherName") REFERENCES "Publisher(PublisherName)", FOREIGN KEY ("ISBN") REFERENCES "Book(ISBN)")');
INSERT INTO "sqlite_master" VALUES('index','sqlite_autoindex_Published_By_1','Published_By',17,NULL);
INSERT INTO "sqlite_master" VALUES('table','Publisher','Publisher',18,'CREATE TABLE "Publisher" ("PublisherName" VARCHAR PRIMARY KEY  NOT NULL  DEFAULT (null) ,"AddressID" INTEGER, FOREIGN KEY ("AddressID") REFERENCES "Address(AddressID)")');
INSERT INTO "sqlite_master" VALUES('index','sqlite_autoindex_Publisher_1','Publisher',19,NULL);
INSERT INTO "sqlite_master" VALUES('table','Written_By','Written_By',20,'CREATE TABLE "Written_By" ("ISBN" VARCHAR NOT NULL , "PersonID" INTEGER NOT NULL , PRIMARY KEY ("ISBN", "PersonID"), FOREIGN KEY ("ISBN") REFERENCES "Book(ISBN)", FOREIGN KEY ("PersonID") REFERENCES "Person(PersonID)")');
INSERT INTO "sqlite_master" VALUES('index','sqlite_autoindex_Written_By_1','Written_By',21,NULL);
INSERT INTO "sqlite_master" VALUES('table','Payment','Payment',14,'CREATE TABLE "Payment" ("TransNum" INTEGER PRIMARY KEY  NOT NULL , "Type" VARCHAR, "Amount" DOUBLE, "Date" DATETIME, "PersonID" INTEGER REFERENCES "Person(PersonID)")');
INSERT INTO "sqlite_master" VALUES('view','Sum_Payments','Sum_Payments',0,'CREATE VIEW Sum_Payments
AS SELECT sum(Amount) AS SUM, PersonID
FROM Payment
GROUP BY PersonID');
INSERT INTO "sqlite_master" VALUES('view','Avg_Sums','Avg_Sums',0,'CREATE VIEW Avg_Sums
AS SELECT AVG(SUM) AS AVG
FROM Sum_Payments');
INSERT INTO "sqlite_master" VALUES('view','Persons_Above_Average','Persons_Above_Average',0,'CREATE VIEW Persons_Above_Average
AS SELECT PersonID
FROM Sum_Payments AS SP, Avg_Sums
WHERE SP.SUM > Avg_Sums.AVG');
INSERT INTO "sqlite_master" VALUES('view','Payment_of_Above_Average','Payment_of_Above_Average',0,'CREATE VIEW Payment_of_Above_Average
AS SELECT TransNum
FROM Persons_Above_Average AS PAA, Payment AS P
WHERE PAA.PersonID = P.PersonID');
INSERT INTO "sqlite_master" VALUES('view','OrderNumber_Above_AVG','OrderNumber_Above_AVG',0,'CREATE VIEW OrderNumber_Above_AVG
AS SELECT OrderNumber
FROM "Order" AS O, Payment_of_Above_Average AS POAA
WHERE O.TransNum = POAA.TransNum');
INSERT INTO "sqlite_master" VALUES('view','ISBN_Above_AVG','ISBN_Above_AVG',0,'CREATE VIEW ISBN_Above_AVG
AS SELECT OF.ISBN
FROM Order_For AS OF, OrderNumber_Above_AVG AS ONAA
WHERE OF.OrderNumber = ONAA.OrderNumber');
INSERT INTO "sqlite_master" VALUES('view','AuthorIDs','AuthorIDs',0,'CREATE VIEW AuthorIDs
AS SELECT PersonID
FROM ISBN_Above_AVG AS IAA, Written_By AS WB
WHERE IAA.ISBN = WB.ISBN');
