select * from newenvironment where ENVIRONMENT_ID = 'env_064';  
select * from results where ENVIRONMENT_ID = 'env_005';

delete from results 
where ENVIRONMENT_ID = 'env_050';

commit;
delete from results where ENVIRONMENT_ID = 'env_00';
delete from resul