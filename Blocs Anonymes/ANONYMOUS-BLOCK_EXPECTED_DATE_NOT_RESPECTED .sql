ACCEPT Date_Debut CHAR PROMPT 'Entrez la date de début (YYYY-MM-DD) :'
ACCEPT Date_Fin CHAR PROMPT 'Entrez la date de fin (YYYY-MM-DD) :'

DECLARE
    v_Date_Debut  DATE := TO_DATE('&Date_Debut', 'YYYY-MM-DD');
    v_Date_Fin    DATE := TO_DATE('&Date_Fin', 'YYYY-MM-DD');
    v_Cursor      SYS_REFCURSOR;
    v_Requestor_Name Requestor.REQUESTOR_NAME%TYPE;
    v_Sample_ID      Sample.SAMPLE_ID%TYPE;
    v_ExpectedOn     Sample.EXPECTEDON%TYPE;
    v_Type_Name      SampleType.TYPE_NAME%TYPE;
    v_Technician_Name Technician.TECHNICIAN_NAME%TYPE;
BEGIN
    -- Appel de la procédure 
    GESTION_LABORATOIRE.EXPECTED_DATE_NOT_RESPECTED(
        p_Date_Debut => v_Date_Debut,
        p_Date_Fin => v_Date_Fin,
        p_EXPECTED_DATE_NOT_RESPECTED => v_Cursor
    );

    -- Traitement des résultats du curseur
    LOOP
        FETCH v_Cursor INTO v_Requestor_Name, v_Sample_ID, v_Type_Name, v_ExpectedOn, v_Technician_Name;
        EXIT WHEN v_Cursor%NOTFOUND;

        -- Afficher ou traiter les données récupérées
        DBMS_OUTPUT.PUT_LINE('Requestor Name: ' || v_Requestor_Name || 
                             ', Sample ID: ' || v_Sample_ID || 
                             ', Type Name: ' || v_Type_Name || 
                             ', Expected On: ' || TO_CHAR(v_ExpectedOn, 'YYYY-MM-DD HH24:MI:SS') ||
                             ', Technician Name: ' || v_Technician_Name);
    END LOOP;

    -- Fermer le curseur
    CLOSE v_Cursor;
EXCEPTION
    WHEN OTHERS THEN
        -- Gestion des exceptions
        IF v_Cursor%ISOPEN THEN
            CLOSE v_Cursor;
        END IF;
END;
/