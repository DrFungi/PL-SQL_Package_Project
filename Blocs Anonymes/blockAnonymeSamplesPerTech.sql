accept tech_name char prompt 'Enter the name of the employee'
accept start_date char prompt 'Enter the starting date as YYYY-MM-DD'
accept end_date char prompt 'Enter the ending date as YYYY-MM-DD'

DECLARE
  v_tech_name         technician.technician_name%TYPE := '&tech_name';
  v_start_date        DATE := TO_DATE ( '&start_date', 'YYYY-MM-DD' );
  v_end_date          DATE := TO_DATE ( '&end_date', 'YYYY-MM-DD' );
  v_number_of_samples NUMBER := 0;
  c_samples           SYS_REFCURSOR;
  l_sample_id         sample.sample_id%TYPE;
  l_test_name         test.test_name%TYPE;
  l_start_date        DATE;
  l_end_date          DATE;
BEGIN
  gestion_laboratoire.chercher_tests_fait_par_tech(v_tech_name, v_start_date, v_end_date, v_number_of_samples, c_samples);
  dbms_output.put_line('Total number of samples for '
                       || initcap(v_tech_name)
                       || ': '
                       || v_number_of_samples);

  LOOP
    FETCH c_samples INTO
      l_sample_id,
      l_test_name,
      l_start_date,
      l_end_date;
    EXIT WHEN c_samples%notfound;
    dbms_output.put_line('Sample number: '
                         || l_sample_id
                         || ' Test: '
                         || l_test_name
                         || ' Start date: '
                         || to_char(l_start_date, 'YYYY-MM-DD')
                         || ' End date: '
                         || to_char(l_end_date, 'YYYY-MM-DD'));

  END LOOP;

  CLOSE c_samples;
EXCEPTION
  WHEN global_exceptions.tech_not_found THEN
    dbms_output.put_line('technician not found');
    --log into something
  --when others
    --dbms other errors
    --log into table
END;