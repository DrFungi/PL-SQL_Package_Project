accept date_received char prompt 'please enter the date after which the samples were received (YYYY-MM-DD)'

declare
  v_date date:=TO_DATE ( '&date_received', 'YYYY-MM-DD' );
  v_results_tab gestion_laboratoire.result_tab_type;
  
begin
  
  gestion_laboratoire.chercher_received_samples(v_date, v_results_tab);
  dbms_output.put_line('samples received after '||v_date);
  for i in v_results_tab.first .. v_results_tab.last loop
    dbms_output.put_line(v_results_tab(i).sample_id);
  end loop;
  
end;