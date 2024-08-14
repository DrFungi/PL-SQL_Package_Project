SET SERVEROUTPUT ON
 
accept sample_id char prompt 'enter num échantillon'
accept test_id char prompt 'enter num test'
DECLARE
    v_SampleID Result.Sample_ID%TYPE:='&sample_id';
    v_TestID Result.test_id%TYPE:='&test_id';
    v_Result Result.Valeur%TYPE;
    v_ResultExists BOOLEAN;
BEGIN
    

    -- Appeler la procédure pour rechercher le résultat du test
    GESTION_LABORATOIRE.CHERCHER_RESULTAT_TEST(v_SampleID, v_TestID, v_Result, v_ResultExists);

    -- Vérifier si le résultat existe
    IF v_ResultExists THEN
        -- Afficher le résultat du test s'il existe
        DBMS_OUTPUT.PUT_LINE('Le résultat du test pour l''échantillon ' || v_SampleID || ' et le test ' || v_TestID || ' est : ' || v_Result);
    ELSE
        -- Afficher un message si le résultat n'existe pas
        DBMS_OUTPUT.PUT_LINE('Aucun résultat trouvé pour l''échantillon ' || v_SampleID || ' et le test ' || v_TestID);
    END IF;
EXCEPTION
  WHEN no_data_found then
    dbms_output.put_line('No Data found');
  WHEN global_exceptions.SAMPLE_NOT_FOUND THEN
    dbms_output.put_line('Echantillon non trouvé');
  WHEN global_exceptions.TEST_NOT_FOUND then
    dbms_output.put_line('Test non trouvé');

END;
/
