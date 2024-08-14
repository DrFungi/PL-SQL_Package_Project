create or replace PACKAGE BODY basic_crud AS

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
  ) AS
  BEGIN
    -- TODO: Implementation required for procedure BASIC_CRUD.ins
    INSERT INTO sample (
      type_id,
      receivedon,
      strain_id,
      expectedon,
      requestor_id,
      approvedon,
      technician_id,
      businessunit_id,
      test_id,
      sample_id
    ) VALUES (
      p_type_id,
      p_receivedon,
      p_strain_id,
      p_expectedon,
      p_requestor_id,
      p_approvedon,
      p_technician_id,
      p_businessunit_id,
      p_test_id,
      p_sample_id
    );

  END ins;

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
  ) AS
  BEGIN
    -- TODO: Implementation required for procedure BASIC_CRUD.upd
    UPDATE sample
    SET
      type_id = p_type_id,
      receivedon = p_receivedon,
      strain_id = p_strain_id,
      expectedon = p_expectedon,
      requestor_id = p_requestor_id,
      approvedon = p_approvedon,
      technician_id = p_technician_id,
      businessunit_id = p_businessunit_id,
      test_id = p_test_id
    WHERE
      sample_id = p_sample_id;

  END upd;

  PROCEDURE del (
    p_sample_id IN sample.sample_id%TYPE
  ) AS
  BEGIN
    -- TODO: Implementation required for procedure BASIC_CRUD.del
    DELETE FROM sample
    WHERE
      sample_id = p_sample_id;

  END del;

END basic_crud;