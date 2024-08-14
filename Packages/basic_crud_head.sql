create or replace PACKAGE basic_crud AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */ 
--insert
  PROCEDURE ins (
    p_type_id         IN sample.type_id%TYPE,
    p_receivedon      IN sample.receivedon%TYPE,
    p_strain_id       IN sample.strain_id%TYPE,
    p_expectedon      IN sample.expectedon%TYPE DEFAULT NULL,
    p_requestor_id    IN sample.requestor_id%TYPE,
    p_approvedon      IN sample.approvedon%TYPE,
    p_technician_id   IN sample.technician_id%TYPE,
    p_businessunit_id IN sample.businessunit_id%TYPE,
    p_test_id         IN sample.test_id%TYPE,
    p_sample_id       IN sample.sample_id%TYPE
  );

-- update
  PROCEDURE upd (
    p_type_id         IN sample.type_id%TYPE,
    p_receivedon      IN sample.receivedon%TYPE,
    p_strain_id       IN sample.strain_id%TYPE,
    p_expectedon      IN sample.expectedon%TYPE DEFAULT NULL,
    p_requestor_id    IN sample.requestor_id%TYPE,
    p_approvedon      IN sample.approvedon%TYPE,
    p_technician_id   IN sample.technician_id%TYPE,
    p_businessunit_id IN sample.businessunit_id%TYPE,
    p_test_id         IN sample.test_id%TYPE,
    p_sample_id       IN sample.sample_id%TYPE
  );
-- delete
  PROCEDURE del (
    p_sample_id IN sample.sample_id%TYPE
  );

END basic_crud;