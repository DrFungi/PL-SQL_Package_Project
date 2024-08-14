SET SERVEROUTPUT ON

accept sample_id char prompt 'enter the sample number to edit'
accept test_id char prompt 'enter the test to change. 1-dry weight 2-protein 3-phosphate 4-viability 5-wild yeast 6-bacteria'
accept new_value char prompt 'enter the new value'

DECLARE
  v_sample_id             result.sample_id%TYPE := '&sample_id';
  v_test_id               result.test_id%TYPE := '&test_id';
  v_new_value             result.valeur%TYPE := '&new_value';
  v_rows_updated          NUMBER;
  v_old_value             result.valeur%TYPE;
  v_is_value_within_specs BOOLEAN;
  updated_rec             gestion_laboratoire.updated_result_rec;
BEGIN
  v_is_value_within_specs := gestion_laboratoire.is_value_within_specs(v_new_value, v_sample_id, v_test_id);
  IF NOT v_is_value_within_specs THEN
    dbms_output.put_line('Value is not within specs! please make sure of your results');
  END IF;
  gestion_laboratoire.update_test_result(v_new_value, v_sample_id, v_test_id, v_rows_updated, v_old_value,
                                        updated_rec);
  dbms_output.put_line('number of rows updated: ' || v_rows_updated);
  dbms_output.put_line('sample number: '
                       || updated_rec.sample_id
                       || ' technician name: '
                       || updated_rec.tech_name
                       || ' test name: '
                       || updated_rec.test_name
                       || ' new value: '
                       || v_new_value
                       || ' old value '
                       || v_old_value);

EXCEPTION
  WHEN no_data_found THEN
    dbms_output.put_line('No Data found');
  WHEN global_exceptions.sample_not_found THEN
    dbms_output.put_line('Sample not found');
  WHEN global_exceptions.test_not_found THEN
    dbms_output.put_line('Test not found');
  WHEN global_exceptions.not_test_for_sample THEN
    dbms_output.put_line('Test not found for this sample');
END;