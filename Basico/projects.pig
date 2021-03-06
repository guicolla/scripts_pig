/*https://www.kaggle.com/kemical/kickstarter-projects*/
/*Script que realiza a leitura de um arquivo no hdfs e realiza alguns filtros para formatar a saida*/
project_template = LOAD '/user/admin/projects2.csv' USING PigStorage(',') as (id: int, name: chararray,
category: chararray, main_category: chararray, currency: chararray, deadline: chararray, goal: int,
launched: chararray, pledged: int, state: chararray, backers: int, country: chararray, usd_pledged: int);

project_status = FOREACH project_template GENERATE id, SUBSTRING(launched,0,10) as inicio,
SUBSTRING(deadline,0,10) as fim, state;

project = FOREACH project_template GENERATE id, name, category, main_category, currency, country;

project_filter = FILTER project_status BY state == 'failed' or state == 'successful' 
or state == 'suspended' or state == 'live';

project_join = JOIN project BY id, project_filter BY id;

project_final = FOREACH project_join GENERATE project::id,name,state;

project_group = GROUP project_final BY state;

project_print = FOREACH project_group GENERATE $0, COUNT($1) as cont;

dump project_print;
