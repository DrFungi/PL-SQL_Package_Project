declare
  
begin

  v_sal:='&salary';
  employees_pkg.dept_salary_threshold(v_sal, v_departments_tab);
  dbms_output.put_line('Department');
  for i in v_departments_tab.first .. v_departments_tab.last loop
    dbms_output.put_line(v_departments_tab(i).department_id);
  end loop;
  
exception
  when others then
  
  dbms_output.put_line('erreur'||sqlerrm);
end;