create or replace PACKAGE GESTION_LABORATOIRE AS 

  --type declarations from here
  type updated_result_rec;
  type result_tab_type is table of result%rowtype index by pls_integer;
  
-------------      procedures from here ------------------------------------
 
  PROCEDURE CHERCHER_TESTS_FAIT_PAR_TECH
  (
  p_emp_name in technician.technician_name%type,
  p_starting_date in date,
  p_ending_date in date,
  p_number_of_samples out number,
  p_samples_record out sys_refcursor --will contain the sample data
  );
  --------------next declaration below this line-------------------------------
  
  -- procedure chercher resultat d'un test à partir de id echantillon et id test
  
  PROCEDURE CHERCHER_RESULTAT_TEST 
  ( p_SampleID IN Result.Sample_ID%TYPE,
    p_TestID IN Result.test_id%TYPE,
    p_Result OUT Result.Valeur%TYPE,
    p_ResultExists OUT BOOLEAN
  );
  -- procedure chercher le statut d'un test  ---------------------------------
  PROCEDURE CHECK_TEST_STATUS 
  (
    p_SampleID IN Sample.Sample_ID%TYPE,
    p_TestID IN Sample.test_id%TYPE,
    p_statut OUT VARCHAR2
  );
  
  -- procedure to update a test result ---------------------------------------
  PROCEDURE UPDATE_TEST_RESULT (
  p_new_value in result.valeur%type,
  p_sample_id in result.sample_id%type,
  p_test_id in result.test_id%type,
  p_rows_updated out number,
  p_old_value out result.valeur%type,
  updated_rec out updated_result_rec
  );
  
  -- Procedure to have all sample that exceeds the expected delivery date.-----
  PROCEDURE EXPECTED_DATE_NOT_RESPECTED (
    p_Date_Debut IN DATE,
    p_Date_Fin IN DATE,
    p_EXPECTED_DATE_NOT_RESPECTED  OUT SYS_REFCURSOR
  );
  
----- Procedure to have all non-conforming test results -----------------------
  PROCEDURE RESULT_NOT_CONFORM(
    p_Date_Debut IN DATE,
    p_Date_Fin IN DATE,
    p_RESULT_NOT_CONFORM OUT SYS_REFCURSOR
  );

-- Procedure to look for samples after a date  --------------------------------

--PROCEDURE chercher_received_samples(p_date_received in date, table_results out result_tab_type);


--------------------------------------------------------------------------------
  --function declarations from here
  
  FUNCTION validate_sample_id(p_sample_id sample.sample_id%type) return boolean;
  FUNCTION validate_test_id(p_test_id sample.test_id%type) return boolean;
  FUNCTION validate_sample_test(p_test_id sample.test_id%type,p_sample_id sample.sample_id%type) return boolean;
  FUNCTION is_value_within_specs(p_value result.valeur%type, p_sample_id result.sample_id%type, p_test_id result.test_id%type) RETURN boolean;

--record declarations from here
  type updated_result_rec is record
    (
      update_date date,
      sample_id sample.sample_id%type,
      tech_name technician.technician_name%type,
      test_name test.test_name%type
    );
  
end GESTION_LABORATOIRE;