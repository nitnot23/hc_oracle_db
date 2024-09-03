select 'grant insert,update,delete on '||owner||'.'||object_name||' to gbrierley;'
from dba_objects where owner='VETMXPRD' and object_type='VIEW';
--and object_type='TABLE' and object_name not like 'DR$%';
--and object_type='VIEW';

select 'create synonym gbrierley.'||object_name||' for '||owner||'.'||object_name||';'
from dba_objects where owner='VETMXPRD' and object_type='VIEW';
--and object_type='TABLE' and object_name not like 'DR$%';
