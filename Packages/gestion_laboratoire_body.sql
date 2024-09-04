create or replace PACKAGE BODY GESTION_LABORATOIRE AS
    
/*
The objective of this procedure is that the lab manager can search how many
samples and which samples a technician has done in a given period.
It takes in the employee name, start date, and end date as parameters; and
it retrieves the number of samples made as well as a list with all the details
from each test.

Lab supervisor must provide employee name and dates in a specific format
the procedure will supply an integer with the number of samples made and the
details of each sample in a cursor
*/
  PROCEDURE CHERCHER_TESTS_FAIT_PAR_TECH  
(
  p_emp_name in technician.technician_name%type,
  p_starting_date in date,
  p_ending_date in date,
  p_number_of_samples out number,
  p_samples_record out sys_refcursor --will contain the sample data
  )is
  v_is_tech number;
  begin
    --verify tech exists
  select count(technician_name)
  into v_is_tech
  from technician
  where upper(technician_name) = upper(p_emp_name);
  
  if v_is_tech = 0 then 
  raise_application_error(-20104, 'Technician not found');
  else
    open p_samples_record for
    select sample_id, test_name, receivedon, approvedon
    from tests_per_tech
    where upper(technician_name) = upper(p_emp_name)
      and receivedon between p_starting_date and p_ending_date
    order by receivedon; 
           
    select count(technician_name)
    into p_number_of_samples
    from tests_per_tech
    where upper(technician_name) = upper(p_emp_name)
    and receivedon between p_starting_date and p_ending_date;
  end if;   
  END CHERCHER_TESTS_FAIT_PAR_TECH;

--place pour mettre la prochaine procedure

--Procedure to search for a test result using sample ID and test ID with exceptions

/*The procedure "CHERCHER_RESULTAT_TEST" searches for the result of a test for a given sample. 
It first validates the sample and test IDs and then checks their existence in the database. 
If the IDs are valid and the records exist, it retrieves the corresponding test result. 
If a result is found, it is returned along with an indicator of its existence. Otherwise, 
an appropriate error message is raised. In summary, this procedure handles the retrieval of test 
results while managing cases of invalid IDs or the absence of results.*/

PROCEDURE CHERCHER_RESULTAT_TEST
( 
    p_SampleID IN Result.Sample_ID%TYPE,
    p_TestID IN Result.test_id%TYPE,
    p_Result OUT Result.Valeur%TYPE,
    p_ResultExists OUT BOOLEAN
)
IS
   v_sample_id_validation BOOLEAN;
   v_test_id_validation BOOLEAN;
   v_nbRes NUMBER;
BEGIN
   -- Valider l'identifiant de l'échantillon et du test
   v_sample_id_validation := validate_sample_id(p_SampleID);
   v_test_id_validation := validate_test_id(p_TestID);
   
   -- Vérifier si l'échantillon et le test existent
   IF (v_sample_id_validation) THEN
        IF (v_test_id_validation) THEN
            -- Vérifier si le résultat existe 
            SELECT COUNT(*) INTO v_nbRes
            FROM Result
            WHERE Sample_id = p_SampleID
            AND test_id = p_TestID;

            IF v_nbRes > 0 THEN
                -- Le résultat existe, on le récupère dans p_Result
                SELECT Valeur INTO p_Result
                FROM Result
                WHERE Sample_id = p_SampleID
                AND test_id = p_TestID;

                p_ResultExists := TRUE;
            ELSE
                -- Le résultat n'existe pas
                p_Result := NULL;
                p_ResultExists := FALSE;
                RAISE_APPLICATION_ERROR (-20001,'Résultat non disponible');
            END IF;
        ELSE
            RAISE_APPLICATION_ERROR(-20102, 'Test non trouvé');
        END IF;
    else
    raise_application_error(-20101, 'Echantillon non trouvé');
  end if;
END CHERCHER_RESULTAT_TEST;

--Procedure to check the status of a test with exceptions

/*The procedure "CHECK_TEST_STATUS" first validates the IDs of a sample and a test. 
It then retrieves the reception and approval dates of the sample from the "sample" and "result" tables. 
Based on these dates, it determines the status of the test: "Sample not received," "Sample not approved," 
or "Approved after reception." Finally, it increments the counter that tracks how many times this test, sample, 
and status have been checked in a statistics table. In summary, this procedure provides an overview of the status 
of a test for a given sample and keeps track of the number of checks performed for each combination of test, sample, and status.*/


 PROCEDURE CHECK_TEST_STATUS (
    p_SampleID IN Sample.Sample_ID%TYPE,
    p_TestID IN Sample.test_id%TYPE,
    p_statut OUT VARCHAR2
) IS
    v_sample_id_validation BOOLEAN;
   v_test_id_validation BOOLEAN;
    v_date_reception DATE;
    v_date_approbation DATE;
BEGIN
  v_sample_id_validation := validate_sample_id(p_SampleID);
   v_test_id_validation := validate_test_id(p_TestID);

    IF NOT (v_sample_id_validation) THEN
        RAISE_APPLICATION_ERROR(-20101, 'Echantillon non trouvé');
    ELSIF NOT (v_test_id_validation) THEN
        RAISE_APPLICATION_ERROR(-20102, 'Test non trouvé');
    ELSIF (v_sample_id_validation) AND (v_test_id_validation) THEN
    -- Récupérer les dates de réception et d'approbation pour l'échantillon donné
        SELECT s.RECEIVEDON, s.approvedon
        INTO v_date_reception, v_date_approbation
        FROM sample s
        JOIN result r ON s.sample_id = r.sample_id
        WHERE s.sample_id = p_SampleID
        AND r.test_id = p_TestID;
    
    -- Vérifier le statut en fonction des dates
    IF v_date_reception IS NULL THEN
        p_statut := 'Échantillon non reçu';
    ELSIF v_date_approbation IS NULL THEN
        p_statut := 'Échantillon non approuvé';
    ELSIF v_date_approbation > v_date_reception THEN
        p_statut := 'Approuvé après réception';
    END IF;
	END IF;

    -- Incrémenter le compteur du nombre de fois que ce test_id, sample_id et statut sont vérifiés
   UPDATE TEST_STATUS_CHECK_STATS
    SET status_checked_count = status_checked_count + 1
    WHERE test_id = p_TestID
    AND sample_id = p_SampleID;

END CHECK_TEST_STATUS;
----- next procedure 

/*
This procedure updates the result of a test that has already been entered.
a verification is made to compare if the result is within specs and warns the
technician if the results are out of specs.
There are 3 verifications as follows:
  . if the sample exists
  . if the test exists
  . if the test exists for that particular sample
Then there is a log into the updated result table which contains the sample number, the
technician, the date, the old result, and the new result

This procedure takes in the sample number, tech name, and test name.
calls several verification functions and takes out a number/message to let 
the person know that the change has been made
*/
PROCEDURE UPDATE_TEST_RESULT (
  p_new_value in result.valeur%type,
  p_sample_id in result.sample_id%type,
  p_test_id in result.test_id%type,
  p_rows_updated out number,
  p_old_value out result.valeur%type,
  updated_rec out updated_result_rec
)
AS 
  v_sample_id_validation boolean;
  v_test_id_validation boolean;
  v_test_sample_validation boolean;
  --updated_result_rec updated_result;
BEGIN
  v_sample_id_validation:= validate_sample_id(p_sample_id);
  v_test_id_validation:=validate_test_id(p_test_id);
  v_test_sample_validation:=validate_sample_test(p_test_id, p_sample_id);
  
  --instructions to select the old value
  
  if (v_sample_id_validation) then
    if (v_test_id_validation) then
      if (v_test_sample_validation) then
        --selection of old value
        select valeur
        into p_old_value
        from result
        where sample_id = p_sample_id
                and test_id = p_test_id;
        
        --query that populates the record
        select 
          sysdate, 
          result.sample_id,
          technician.technician_name,
          test.test_name
        into updated_rec
        from result
          join test on result.test_id = test.test_id
          join sample on result.sample_id = sample.sample_id
          join technician on sample.technician_id = technician.technician_id          
        where result.sample_id = p_sample_id
                and result.test_id = p_test_id;
                
        --update result table
        update result
        set valeur = p_new_value
        where sample_id = p_sample_id
          and test_id = p_test_id;  
        p_rows_updated:=sql%rowcount;
        
        --insert updated info into the log table (updated result)
        insert into updated_result (
          modified_date, 
          sample_id, 
          technician_name,
          test_name,
          old_value,
          new_value)
        values(
          sysdate, 
          updated_rec.sample_id, 
          updated_rec.tech_name, 
          updated_rec.test_name,
          p_old_value,
          p_new_value);           
      
      commit;
      
      
      else
        raise_application_error(-20103, 'Test not present for this sample');
      end if;      
    else
      raise_application_error(-20102, 'Test not found');      
    end if;    
  else
    raise_application_error(-20101, 'Sample not found');
  end if;
END UPDATE_TEST_RESULT;

------ next procedure
/*To efficiently manage the analysis of samples that exceed their scheduled 
  delivery dates, this procedure has been implemented which guarantees 
  the identification of all late analyses between two dates.*/

PROCEDURE EXPECTED_DATE_NOT_RESPECTED (
    p_Date_Debut IN DATE,
    p_Date_Fin IN DATE,
    p_EXPECTED_DATE_NOT_RESPECTED  OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_EXPECTED_DATE_NOT_RESPECTED  FOR
       SELECT R.REQUESTOR_NAME,S.SAMPLE_ID, SP.TYPE_NAME ,S.EXPECTEDON, T.TECHNICIAN_NAME
       FROM Requestor R
       JOIN Sample S ON S.REQUESTOR_ID = R.REQUESTOR_ID
       JOIN TECHNICIAN T ON T.TECHNICIAN_ID = S.TECHNICIAN_ID
       JOIN SAMPLETYPE SP ON SP.TYPE_ID = S.TYPE_ID  
       WHERE (S.RECEIVEDON BETWEEN p_Date_Debut AND p_Date_Fin )AND
             (S.EXPECTEDON IS NOT NULL) AND (S.EXPECTEDON < SYSDATE)AND(S.APPROVEDON IS NULL);
END EXPECTED_DATE_NOT_RESPECTED;
------ next procedure

/*Non-conforming test results are results that deviate from the standards, specifications, 
  or expectations defined by the requester. So this procedure reports all records of results 
  out of range EXPECTED_MIN and EXPECTED_MAX between two dates.*/

PROCEDURE RESULT_NOT_CONFORM (
    p_Date_Debut IN DATE,
    p_Date_Fin IN DATE,
    p_RESULT_NOT_CONFORM OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_RESULT_NOT_CONFORM FOR
        SELECT R.REQUESTOR_NAME,S.SAMPLE_ID, T.TEST_NAME,SP.TYPE_NAME ,R.VALEUR, R.EXPECTED_MIN, R.EXPECTED_MAX,T.TECHNICIAN_NAME
        FROM Requestor R
        JOIN Sample S ON S.REQUESTOR_ID = R.REQUESTOR_ID
        JOIN SAMPLETYPE SP ON SP.TYPE_ID = S.TYPE_ID  
        JOIN Result R ON R.SAMPLE_ID = S.SAMPLE_ID
        JOIN TEST T ON T.TEST_ID=R.TEST_ID
        JOIN TECHNICIAN T ON T.TECHNICIAN_ID = S.TECHNICIAN_ID
        WHERE (S.RECEIVEDON BETWEEN p_Date_Debut AND p_Date_Fin )AND (R.VALEUR NOT BETWEEN R.EXPECTED_MIN AND R.EXPECTED_MAX);
END RESULT_NOT_CONFORM;
------ next procedure
--------------------------------------------------------------------------------
-------function implementations here
-- validate sample ID
FUNCTION validate_sample_id(p_sample_id sample.sample_id%type) return boolean is
    v_sample_exists boolean;
    v_number_of_samples number(2);
    begin
      select count(sample_id)
      into v_number_of_samples
      from result
      where sample_id = p_sample_id;
      if v_number_of_samples > 0 then
        v_sample_exists:= true;
      else
        v_sample_exists:= false;
      end if;
    return v_sample_exists;
    end validate_sample_id;
    
------Function that validates the existence of the test
    
FUNCTION validate_test_id(p_test_id sample.test_id%type) return boolean is
    v_test_exists boolean;
    v_number_of_samples number(2);
    begin
      select count(test_id)
      into v_number_of_samples
      from result
      where test_id = p_test_id;
      if v_number_of_samples > 0 then
        v_test_exists:= true;
      else
        v_test_exists:= false;
      end if;
    return v_test_exists;
    end validate_test_id;
    
--validate if the test exists for the sample

FUNCTION validate_sample_test(p_test_id sample.test_id%type,p_sample_id sample.sample_id%type) return boolean is
    v_exists boolean;
    v_number_of_samples number(2);
    begin
      select count(sample_id)
      into v_number_of_samples
      from result
      where test_id = p_test_id
        and sample_id = p_sample_id;
      if v_number_of_samples > 0 then
        v_exists:= true;
      else
        v_exists:= false;
      end if;
    return v_exists;
    end validate_sample_test;

-- Validate if new test result is on spec

FUNCTION is_value_within_specs
    (p_value result.valeur%type, p_sample_id result.sample_id%type, p_test_id result.test_id%type) RETURN boolean AS
  
  v_expected_min result.expected_min%type;
  v_expected_max result.expected_max%type;
BEGIN
  select expected_min, expected_max
  into v_expected_min, v_expected_max
  from result
  where sample_id = p_sample_id
    and test_id = p_test_id;
  if p_value >= v_expected_min and p_value <= v_expected_max then
    return true;
  else
    return false;
  end if;  
END is_value_within_specs;


END GESTION_LABORATOIRE;
