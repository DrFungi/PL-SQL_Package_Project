accept Date_Debut char prompt 'Entrez la date de début YYYY-MM-DD :'
accept Date_Fin char prompt 'Entrez la date de fin YYYY-MM-DD :'
DECLARE
    v_Date_Debut DATE := TO_DATE ( '&Date_Debut', 'YYYY-MM-DD' );  -- Variable de la date de début 
    v_Date_Fin DATE:= TO_DATE ( '&Date_Fin', 'YYYY-MM-DD' );    -- Variable de la date de fin
    v_Cursor SYS_REFCURSOR;
    v_Requestor_Name Requestor.REQUESTOR_NAME%TYPE;
    v_Sample_ID Sample.SAMPLE_ID%TYPE;
    v_Test_Name Test.TEST_NAME%TYPE;
    v_Type_Name SampleType.TYPE_NAME%TYPE;
    v_Valeur Result.VALEUR%TYPE;
    v_Expected_Min Result.EXPECTED_MIN%TYPE;
    v_Expected_Max Result.EXPECTED_MAX%TYPE;
    v_Technician_Name Technician.TECHNICIAN_NAME%TYPE;
BEGIN
    -- Appel de la procédure
    GESTION_LABORATOIRE.RESULT_NOT_CONFORM (
        p_Date_Debut => v_Date_Debut,
        p_Date_Fin => v_Date_Fin,
        p_RESULT_NOT_CONFORM => v_Cursor
    );

    -- Traitement des résultats du curseur
    LOOP
        FETCH v_Cursor INTO v_Requestor_Name, v_Sample_ID, v_Test_Name, v_Type_Name, v_Valeur, v_Expected_Min, v_Expected_Max,v_Technician_Name;
        EXIT WHEN v_Cursor%NOTFOUND;

        -- Afficher ou traiter les données récupérées
        DBMS_OUTPUT.PUT_LINE('Requestor Name: ' || v_Requestor_Name || 
                             ', Sample ID: ' || v_Sample_ID || 
                             ', Test Name: ' || v_Test_Name || 
                             ', Type Name: ' || v_Type_Name || 
                             ', Valeur: ' || v_Valeur || 
                             ', Expected Min: ' || v_Expected_Min || 
                             ', Expected Max: ' || v_Expected_Max);
    END LOOP;
    CLOSE v_Cursor;
EXCEPTION
    WHEN OTHERS THEN
        -- Gestion des exceptions
        IF v_Cursor%ISOPEN THEN
            CLOSE v_Cursor;
        END IF;
        RAISE;
END;
/