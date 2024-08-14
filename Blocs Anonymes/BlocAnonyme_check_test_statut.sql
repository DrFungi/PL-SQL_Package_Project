SET SERVEROUTPUT ON
 
accept sample_id char prompt 'enter num échantillon'
accept test_id char prompt 'enter num test'

DECLARE
     v_SampleID Result.Sample_ID%TYPE:='&sample_id';
    v_TestID Result.test_id%TYPE:='&test_id';
    v_statut VARCHAR2(100); -- La variable pour stocker le statut retourné par la procédure
BEGIN
    -- Appeler la procédure CHECK_TEST_STATUS
    GESTION_LABORATOIRE.CHECK_TEST_STATUS(v_SampleID, v_TestID, v_statut);
    
    -- Afficher le statut retourné
    DBMS_OUTPUT.PUT_LINE('Statut de l''échantillon: ' || v_statut);
EXCEPTION
  WHEN no_data_found then
    dbms_output.put_line('No Data found');
  WHEN global_exceptions.SAMPLE_NOT_FOUND THEN
    dbms_output.put_line('Echantillon non trouvé');
  WHEN global_exceptions.TEST_NOT_FOUND then
    dbms_output.put_line('Test non trouvé');


END;