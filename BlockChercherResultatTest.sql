DECLARE
    v_SampleID Sample.Sample_ID%TYPE := &p_SampleID;
    v_TestID Test.test_id%TYPE := &p_TestID;
    v_Result Result.Valeur%TYPE;
    v_ResultExists BOOLEAN;
BEGIN
    CHERCHERRESULTATTEST(v_SampleID, v_TestID, v_Result, v_ResultExists);
 
    -- V�rifier si le r�sultat existe
    IF v_ResultExists THEN
        DBMS_OUTPUT.PUT_LINE('Le r�sultat existe : ' || v_Result);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Le r�sultat n''existe pas.');
    END IF;
 
    
END;