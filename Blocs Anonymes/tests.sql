select *
from tests_per_tech
where technician_name='David'
order by receivedon;

select count(technician_name)
    --into p_number_of_samples
    from tests_per_tech
    where technician_name = 'David';
    
alter table sample
add (expected_min number(19,2),
     expected_max number(19,2));
 
     
INSERT INTO RESULT (SAMPLE_ID, TEST_ID, EXPECTED_MIN, EXPECTED_MAX, VALUE) 
VALUES (8, 1, 16, 24, 17.37);

update result
  set valeur = 10
  where sample_id = 4
    and test_id = 2;
    commit;

CREATE TABLE updated_result (
  updated_result_id NUMBER
    GENERATED ALWAYS AS IDENTITY,
  modified_date     DATE,
  sample_id         NUMBER(10),
  technician_name     VARCHAR2(50),
  test_name           VARCHAR2(40),
  old_value         NUMBER(19, 2),
  new_value         NUMBER(19, 2)
);

select sysdate from sampletype;


select 
          sysdate, 
          result.sample_id,
          technician.technician_name,
          test.test_name
        --into updated_result_rec
        from result
          join sample on result.sample_id = sample.sample_id
          join technician on sample.technician_id = technician.technician_id
          join test on sample.test_id = test.test_id
        where result.sample_id = 4
                and result.test_id = 2;
                
                
select result_id, sample_id, test_id, expected_min, expected_max, valeur  
    from result
    where sample_id in (select sample_id
                        from sample
                        where receivedon > to_date('2024-04-16', 'YYYY-MM-DD'));
                        
                        
select avg(salary)
from employees;

select c.country_id, c.country_name, c.region_id
    from countries c
      join locations l on c.country_id = l.country_id
      join departments de on l.location_id = de.location_id
      join employees em on de.department_id = em.department_id            
      group by c.country_id, c.country_name, c.region_id
      having avg(em.salary) > 6461;
      
      
select count(*)
    --into v_rows_choix_pays_table
    from sql_choix_pays;

