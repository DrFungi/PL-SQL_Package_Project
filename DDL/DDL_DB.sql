rem Laboratory database
rem MODIFIED:     2024-04-18
rem  
rem CONGDON       Invoked in RDBMS at build time. 2024-04-16
rem OATES:        Created: 2024-04-16

DROP TABLE requestor CASCADE CONSTRAINTS;
DROP TABLE technician CASCADE CONSTRAINTS;
DROP TABLE sampletype CASCADE CONSTRAINTS;
DROP TABLE origin CASCADE CONSTRAINTS;
DROP TABLE businessunit CASCADE CONSTRAINTS;
DROP TABLE test CASCADE CONSTRAINTS;
DROP TABLE unit CASCADE CONSTRAINTS;
DROP TABLE result CASCADE CONSTRAINTS;
DROP TABLE yeaststrain CASCADE CONSTRAINTS;
DROP TABLE sample CASCADE CONSTRAINTS;
DROP TABLE updated_result CASCADE CONSTRAINTS;


DROP USER labo CASCADE;

CREATE USER labo IDENTIFIED BY "D45epeUcfhr3_";

GRANT
  CREATE MATERIALIZED VIEW,
  CREATE PROCEDURE,
  CREATE SEQUENCE,
  CREATE SESSION,
  CREATE SYNONYM,
  CREATE TABLE,
  CREATE TRIGGER,
  CREATE TYPE,
  CREATE VIEW,
  UNLIMITED TABLESPACE
TO labo;



ALTER SESSION SET current_schema = labo;
ALTER SESSION SET nls_language = american;
ALTER SESSION SET nls_territory = america;
ALTER SESSION SET nls_date_format = "YYYY-MM-DD";
SET TERMOUT OFF
SET ECHO OFF



PROMPT Please wait while tables are created....


CREATE TABLE requestor (
  requestor_id   NUMBER(10)
    GENERATED ALWAYS AS IDENTITY,
  requestor_name VARCHAR2(50) NOT NULL,
  PRIMARY KEY ( requestor_id )
);

CREATE TABLE technician (
  technician_id   NUMBER(10)
    GENERATED ALWAYS AS IDENTITY,
  technician_name VARCHAR2(50) NOT NULL,
  PRIMARY KEY ( technician_id )
);

CREATE TABLE sampletype (
  type_id   NUMBER(10)
    GENERATED ALWAYS AS IDENTITY,
  type_name VARCHAR2(50) NOT NULL UNIQUE,
  PRIMARY KEY ( type_id )
);

CREATE TABLE origin (
  origin_id   NUMBER(10)
    GENERATED ALWAYS AS IDENTITY,
  origin_name NUMBER(10) NOT NULL,
  PRIMARY KEY ( origin_id )
);

CREATE TABLE businessunit (
  businessunit_id   NUMBER(10)
    GENERATED ALWAYS AS IDENTITY,
  businessunit_name VARCHAR2(50) NOT NULL UNIQUE,
  PRIMARY KEY ( businessunit_id )
);

CREATE TABLE unit (
  unit_id   NUMBER(3)
    GENERATED ALWAYS AS IDENTITY,
  unit_name VARCHAR2(50) NOT NULL UNIQUE,
  PRIMARY KEY ( unit_id )
);

CREATE TABLE yeaststrain (
  strain_id   NUMBER(10)
    GENERATED ALWAYS AS IDENTITY,
  strain_name VARCHAR2(50),
  PRIMARY KEY ( strain_id )
);

CREATE TABLE updated_result (
  updated_result_id NUMBER
    GENERATED ALWAYS AS IDENTITY,
  modified_date     DATE,
  sample_id         NUMBER(10),
  technician_name     VARCHAR2(50),
  test_name           VARCHAR2(40),
  old_value         NUMBER(19, 2),
  new_value         NUMBER(19, 2)
);

CREATE TABLE test (
  test_id   NUMBER(3)
    GENERATED ALWAYS AS IDENTITY,
  test_name VARCHAR2(40) NOT NULL UNIQUE,
  unit_id   NUMBER(3) NOT NULL,
  PRIMARY KEY ( test_id ),
  CONSTRAINT ck_test CHECK ( test_name IN ( 'dry weight', 'protein', 'phosphate', 'viability', 'wild yeast',
                                            'bacteria' ) ),
  CONSTRAINT test_unit_fk FOREIGN KEY ( unit_id )
    REFERENCES unit ( unit_id )
);

CREATE TABLE sample (
  sample_id       NUMBER(10)
    GENERATED ALWAYS AS IDENTITY,
  requestor_id    NUMBER(10) NOT NULL,
  technician_id   NUMBER(10) NOT NULL,
  type_id         NUMBER(10) NOT NULL,
  strain_id       NUMBER(10) NOT NULL,
  test_id         NUMBER(10) NOT NULL,
  businessunit_id NUMBER(10) NOT NULL,
  receivedon      DATE NOT NULL,
  expectedon      DATE,
  approvedon      DATE NOT NULL,
  expected_min number(19,2),
  expected_max number(19,2),
  PRIMARY KEY ( sample_id ),
  CONSTRAINT sample_requestor_fk FOREIGN KEY ( requestor_id )
    REFERENCES requestor ( requestor_id ),
  CONSTRAINT sample_technician_fk FOREIGN KEY ( technician_id )
    REFERENCES technician ( technician_id ),
  CONSTRAINT sample_sampletype_fk FOREIGN KEY ( type_id )
    REFERENCES sampletype ( type_id ),
  CONSTRAINT sample_yeaststrain_fk FOREIGN KEY ( strain_id )
    REFERENCES yeaststrain ( strain_id ),
  CONSTRAINT sample_businessunit_fk FOREIGN KEY ( businessunit_id )
    REFERENCES businessunit ( businessunit_id )
);

CREATE TABLE result (
  result_id    NUMBER(10)
    GENERATED ALWAYS AS IDENTITY,
  sample_id    NUMBER(10) NOT NULL,
  test_id      NUMBER(3) NOT NULL,
  expected_min NUMBER(19, 2),
  expected_max NUMBER(19, 2),
  value        NUMBER(19, 2),
  PRIMARY KEY ( result_id ),
  CONSTRAINT result_sample_fk FOREIGN KEY ( sample_id )
    REFERENCES sample ( sample_id ),
  CONSTRAINT result_test_fk FOREIGN KEY ( test_id )
    REFERENCES test ( test_id )
);

REM
REM VALUES TO INSERT WILL BE PASTED BELOW
REM

INSERT INTO technician ( technician_name ) VALUES ( 'David' );
INSERT INTO technician ( technician_name ) VALUES ( 'Gulnara' );
INSERT INTO technician ( technician_name ) VALUES ( 'Hera' );
INSERT INTO technician ( technician_name ) VALUES ( 'Guy' );
INSERT INTO technician ( technician_name ) VALUES ( 'Julie' );

INSERT INTO requestor ( requestor_name ) VALUES ( 'Katrin' );
INSERT INTO requestor ( requestor_name ) VALUES ( 'Luis' );
INSERT INTO requestor ( requestor_name ) VALUES ( 'Stan' );
INSERT INTO requestor ( requestor_name ) VALUES ( 'Avi' );
INSERT INTO requestor ( requestor_name ) VALUES ( 'Florencia' );
INSERT INTO requestor ( requestor_name ) VALUES ( 'Tobias' );
INSERT INTO requestor ( requestor_name ) VALUES ( 'Rodd' );
INSERT INTO requestor ( requestor_name ) VALUES ( 'Benjamin' );

INSERT INTO yeaststrain ( strain_name ) VALUES ( 'LYCC6101' );
INSERT INTO yeaststrain ( strain_name ) VALUES ( 'Liquiferm' );
INSERT INTO yeaststrain ( strain_name ) VALUES ( 'PE2' );
INSERT INTO yeaststrain ( strain_name ) VALUES ( 'LYCC8841' );
INSERT INTO yeaststrain ( strain_name ) VALUES ( 'M34189' );
INSERT INTO yeaststrain ( strain_name ) VALUES ( 'LYCC6420' );
INSERT INTO yeaststrain ( strain_name ) VALUES ( 'LYCC7405' );
INSERT INTO yeaststrain ( strain_name ) VALUES ( 'C-strain' );
INSERT INTO yeaststrain ( strain_name ) VALUES ( 'LYCC9457' );
INSERT INTO yeaststrain ( strain_name ) VALUES ( '#278' );
INSERT INTO yeaststrain ( strain_name ) VALUES ( 'C+' );

INSERT INTO sampletype ( type_name ) VALUES ( 'Broth' );
INSERT INTO sampletype ( type_name ) VALUES ( 'Cake' );
INSERT INTO sampletype ( type_name ) VALUES ( 'Cream' );
INSERT INTO sampletype ( type_name ) VALUES ( 'Dry' );
INSERT INTO sampletype ( type_name ) VALUES ( 'IDY' );
INSERT INTO sampletype ( type_name ) VALUES ( 'Juice' );
INSERT INTO sampletype ( type_name ) VALUES ( 'Liquid' );
INSERT INTO sampletype ( type_name ) VALUES ( 'Molasses' );
INSERT INTO sampletype ( type_name ) VALUES ( 'Nutrient' );
INSERT INTO sampletype ( type_name ) VALUES ( 'SLY' );

INSERT INTO unit ( unit_name ) VALUES ( 'g/L' );
INSERT INTO unit ( unit_name ) VALUES ( '%' );
INSERT INTO unit ( unit_name ) VALUES ( 'CFU/g' );

INSERT INTO test (
  test_name,
  unit_id
) VALUES (
  'dry weight',
  2
);

INSERT INTO test (
  test_name,
  unit_id
) VALUES (
  'protein',
  2
);

INSERT INTO test (
  test_name,
  unit_id
) VALUES (
  'phosphate',
  2
);

INSERT INTO test (
  test_name,
  unit_id
) VALUES (
  'viability',
  3
);

INSERT INTO test (
  test_name,
  unit_id
) VALUES (
  'wild yeast',
  3
);

INSERT INTO test (
  test_name,
  unit_id
) VALUES (
  'bacteria',
  3
);

INSERT INTO businessunit ( businessunit_name ) VALUES ( 'Bak EMEA - BI' );
INSERT INTO businessunit ( businessunit_name ) VALUES ( 'Bak EMEA - EU' );
INSERT INTO businessunit ( businessunit_name ) VALUES ( 'Bak NAB' );
INSERT INTO businessunit ( businessunit_name ) VALUES ( 'Brew - Brewing' );
INSERT INTO businessunit ( businessunit_name ) VALUES ( 'Brew - Siebel (not in QC)' );
INSERT INTO businessunit ( businessunit_name ) VALUES ( 'Cosmetics' );
INSERT INTO businessunit ( businessunit_name ) VALUES ( 'Enology - Enology R-D' );
INSERT INTO businessunit ( businessunit_name ) VALUES ( 'Enology - Oenobrands' );
INSERT INTO businessunit ( businessunit_name ) VALUES ( 'External' );
INSERT INTO businessunit ( businessunit_name ) VALUES ( 'LAN - Animal Nutr' );
INSERT INTO businessunit ( businessunit_name ) VALUES ( 'LBDS' );
INSERT INTO businessunit ( businessunit_name ) VALUES ( 'LBI - BioIngredients' );
INSERT INTO businessunit ( businessunit_name ) VALUES ( 'LBI - Enzymes' );
INSERT INTO businessunit ( businessunit_name ) VALUES ( 'LBS - Baking Solutions EMEA' );
INSERT INTO businessunit ( businessunit_name ) VALUES ( 'LBS - Baking Solutions North America' );
INSERT INTO businessunit ( businessunit_name ) VALUES ( 'LHS - Health Solns' );
INSERT INTO businessunit ( businessunit_name ) VALUES ( 'LPC - Plant Care' );
INSERT INTO businessunit ( businessunit_name ) VALUES ( 'LPU - Pharma' );
INSERT INTO businessunit ( businessunit_name ) VALUES ( 'LSC - Specialty Cultures' );

INSERT INTO SAMPLE (REQUESTOR_ID, TECHNICIAN_ID, TYPE_ID, STRAIN_ID, TEST_ID, BUSINESSUNIT_ID, RECEIVEDON, EXPECTEDON, APPROVEDON) 
VALUES (1, 5, 10, 9, 4, 3, to_date('2024-04-18', 'RRRR-MM-DD'), to_date('2024-04-20', 'RRRR-MM-DD'), to_date('2024-04-21', 'RRRR-MM-DD'));

INSERT INTO SAMPLE (REQUESTOR_ID, TECHNICIAN_ID, TYPE_ID, STRAIN_ID, TEST_ID, BUSINESSUNIT_ID, RECEIVEDON, EXPECTEDON, APPROVEDON) 
VALUES (2, 4, 10, 2, 5, 18, to_date('2024-04-18', 'RRRR-MM-DD'), to_date('', 'RRRR-MM-DD'), to_date('2024-04-23', 'RRRR-MM-DD'));

INSERT INTO SAMPLE (REQUESTOR_ID, TECHNICIAN_ID, TYPE_ID, STRAIN_ID, TEST_ID, BUSINESSUNIT_ID, RECEIVEDON, EXPECTEDON, APPROVEDON) 
VALUES (6, 5, 10, 9, 5, 15, to_date('2024-03-18', 'RRRR-MM-DD'), to_date('2024-03-20', 'RRRR-MM-DD'), to_date('2024-03-24', 'RRRR-MM-DD'));

INSERT INTO SAMPLE (REQUESTOR_ID, TECHNICIAN_ID, TYPE_ID, STRAIN_ID, TEST_ID, BUSINESSUNIT_ID, RECEIVEDON, EXPECTEDON, APPROVEDON) 
VALUES (7, 1, 7, 7, 4, 5, to_date('2024-04-14', 'RRRR-MM-DD'), to_date('2024-04-16', 'RRRR-MM-DD'), to_date('2024-04-19', 'RRRR-MM-DD'));

INSERT INTO SAMPLE (REQUESTOR_ID, TECHNICIAN_ID, TYPE_ID, STRAIN_ID, TEST_ID, BUSINESSUNIT_ID, RECEIVEDON, EXPECTEDON, APPROVEDON) 
VALUES (4, 1, 6, 6, 5, 10, to_date('2024-04-18', 'RRRR-MM-DD'), to_date('', 'RRRR-MM-DD'), to_date('2024-04-22', 'RRRR-MM-DD'));

INSERT INTO SAMPLE (REQUESTOR_ID, TECHNICIAN_ID, TYPE_ID, STRAIN_ID, TEST_ID, BUSINESSUNIT_ID, RECEIVEDON, EXPECTEDON, APPROVEDON) 
VALUES (2, 3, 3, 2, 3, 13, to_date('2024-04-18', 'RRRR-MM-DD'), to_date('2024-04-20', 'RRRR-MM-DD'), to_date('2024-04-21', 'RRRR-MM-DD'));

INSERT INTO SAMPLE (REQUESTOR_ID, TECHNICIAN_ID, TYPE_ID, STRAIN_ID, TEST_ID, BUSINESSUNIT_ID, RECEIVEDON, EXPECTEDON, APPROVEDON) 
VALUES (7, 5, 2, 8, 1, 14, to_date('2024-03-18', 'RRRR-MM-DD'), to_date('2024-03-20', 'RRRR-MM-DD'), to_date('2024-03-24', 'RRRR-MM-DD'));

INSERT INTO SAMPLE (REQUESTOR_ID, TECHNICIAN_ID, TYPE_ID, STRAIN_ID, TEST_ID, BUSINESSUNIT_ID, RECEIVEDON, EXPECTEDON, APPROVEDON) 
VALUES (4, 4, 10, 1, 4, 3, to_date('2024-04-14', 'RRRR-MM-DD'), to_date('', 'RRRR-MM-DD'), to_date('2024-04-19', 'RRRR-MM-DD'));

INSERT INTO SAMPLE (REQUESTOR_ID, TECHNICIAN_ID, TYPE_ID, STRAIN_ID, TEST_ID, BUSINESSUNIT_ID, RECEIVEDON, EXPECTEDON, APPROVEDON) 
VALUES (4, 3, 4, 10, 3, 12, to_date('2024-04-18', 'RRRR-MM-DD'), to_date('2024-04-20', 'RRRR-MM-DD'), to_date('2024-04-24', 'RRRR-MM-DD'));

INSERT INTO SAMPLE (REQUESTOR_ID, TECHNICIAN_ID, TYPE_ID, STRAIN_ID, TEST_ID, BUSINESSUNIT_ID, RECEIVEDON, EXPECTEDON, APPROVEDON) 
VALUES (6, 2, 6, 7, 5, 15, to_date('2024-04-18', 'RRRR-MM-DD'), to_date('', 'RRRR-MM-DD'), to_date('2024-04-24', 'RRRR-MM-DD'));

INSERT INTO SAMPLE (REQUESTOR_ID, TECHNICIAN_ID, TYPE_ID, STRAIN_ID, TEST_ID, BUSINESSUNIT_ID, RECEIVEDON, EXPECTEDON, APPROVEDON) 
VALUES (8, 1, 1, 8, 6, 17, to_date('2024-03-18', 'RRRR-MM-DD'), to_date('2024-03-20', 'RRRR-MM-DD'), to_date('2024-03-22', 'RRRR-MM-DD'));

INSERT INTO SAMPLE (REQUESTOR_ID, TECHNICIAN_ID, TYPE_ID, STRAIN_ID, TEST_ID, BUSINESSUNIT_ID, RECEIVEDON, EXPECTEDON, APPROVEDON) 
VALUES (3, 3, 7, 10, 2, 6, to_date('2024-04-14', 'RRRR-MM-DD'), to_date('2024-04-16', 'RRRR-MM-DD'), to_date('2024-04-20', 'RRRR-MM-DD'));

INSERT INTO SAMPLE (REQUESTOR_ID, TECHNICIAN_ID, TYPE_ID, STRAIN_ID, TEST_ID, BUSINESSUNIT_ID, RECEIVEDON, EXPECTEDON, APPROVEDON) 
VALUES (8, 4, 8, 4, 1, 4, to_date('2024-04-18', 'RRRR-MM-DD'), to_date('', 'RRRR-MM-DD'), to_date('2024-04-21', 'RRRR-MM-DD'));

INSERT INTO SAMPLE (REQUESTOR_ID, TECHNICIAN_ID, TYPE_ID, STRAIN_ID, TEST_ID, BUSINESSUNIT_ID, RECEIVEDON, EXPECTEDON, APPROVEDON) 
VALUES (6, 4, 7, 7, 4, 2, to_date('2024-04-18', 'RRRR-MM-DD'), to_date('2024-04-20', 'RRRR-MM-DD'), to_date('2024-04-23', 'RRRR-MM-DD'));

INSERT INTO RESULT (SAMPLE_ID, TEST_ID, EXPECTED_MIN, EXPECTED_MAX, VALUE) 
VALUES (10, 4, NULL, 1000, 100);

INSERT INTO RESULT (SAMPLE_ID, TEST_ID, EXPECTED_MIN, EXPECTED_MAX, VALUE) 
VALUES (3, 5, NULL, 1000, 17000);

INSERT INTO RESULT (SAMPLE_ID, TEST_ID, EXPECTED_MIN, EXPECTED_MAX, VALUE) 
VALUES (8, 1, 16, 24, 17.37);

INSERT INTO RESULT (SAMPLE_ID, TEST_ID, EXPECTED_MIN, EXPECTED_MAX, VALUE) 
VALUES (9, 5, NULL, 100000, 48000);

INSERT INTO RESULT (SAMPLE_ID, TEST_ID, EXPECTED_MIN, EXPECTED_MAX, VALUE) 
VALUES (11, 4, NULL, 100000, 270000);

INSERT INTO RESULT (SAMPLE_ID, TEST_ID, EXPECTED_MIN, EXPECTED_MAX, VALUE) 
VALUES (9, 3, 1.8, 2.8, 2.08);

INSERT INTO RESULT (SAMPLE_ID, TEST_ID, EXPECTED_MIN, EXPECTED_MAX, VALUE) 
VALUES (12, 4, NULL, 100000, 35000);

INSERT INTO RESULT (SAMPLE_ID, TEST_ID, EXPECTED_MIN, EXPECTED_MAX, VALUE) 
VALUES (1, 3, 1.7, 2.1, 2.31);

INSERT INTO RESULT (SAMPLE_ID, TEST_ID, EXPECTED_MIN, EXPECTED_MAX, VALUE) 
VALUES (4, 1, 93, 93, 94.52);

INSERT INTO RESULT (SAMPLE_ID, TEST_ID, EXPECTED_MIN, EXPECTED_MAX, VALUE) 
VALUES (14, 6, 20000000000, NULL, 27900000000);

INSERT INTO RESULT (SAMPLE_ID, TEST_ID, EXPECTED_MIN, EXPECTED_MAX, VALUE) 
VALUES (4, 1, 18, 25, 23.17);

INSERT INTO RESULT (SAMPLE_ID, TEST_ID, EXPECTED_MIN, EXPECTED_MAX, VALUE) 
VALUES (3, 3, 1.7, 2.1, 2.69);

INSERT INTO RESULT (SAMPLE_ID, TEST_ID, EXPECTED_MIN, EXPECTED_MAX, VALUE) 
VALUES (13, 5, NULL, 1000, 100);

INSERT INTO RESULT (SAMPLE_ID, TEST_ID, EXPECTED_MIN, EXPECTED_MAX, VALUE) 
VALUES (11, 2, 32, 38, 36.31);

INSERT INTO RESULT (SAMPLE_ID, TEST_ID, EXPECTED_MIN, EXPECTED_MAX, VALUE) 
VALUES (8, 2, 32, 38, 39.14);

INSERT INTO RESULT (SAMPLE_ID, TEST_ID, EXPECTED_MIN, EXPECTED_MAX, VALUE) 
VALUES (5, 6, 1000000000, NULL, 5000000000);

INSERT INTO RESULT (SAMPLE_ID, TEST_ID, EXPECTED_MIN, EXPECTED_MAX, VALUE) 
VALUES (12, 1, 90, 95, 97.38);

COMMIT;

SET TERMOUT ON
SET ECHO ON