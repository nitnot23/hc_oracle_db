-- Oracle Text Preferences and Sub-Lexer Definitions --
-- Running on MAXIMO schema in database --
-- Before that running : GRANT EXECUTE ON CTXSYS.CTX_DDL TO VETMXPRE; --

call ctx_ddl.drop_preference('global_lexer');
call ctx_ddl.drop_preference('default_lexer');
call ctx_ddl.drop_preference('english_lexer');
call ctx_ddl.drop_preference('chinese_lexer');
call ctx_ddl.drop_preference('japanese_lexer');
call ctx_ddl.drop_preference('korean_lexer');
call ctx_ddl.drop_preference('german_lexer');
call ctx_ddl.drop_preference('dutch_lexer');
call ctx_ddl.drop_preference('swedish_lexer');
call ctx_ddl.drop_preference('french_lexer');
call ctx_ddl.drop_preference('italian_lexer');
call ctx_ddl.drop_preference('spanish_lexer');
call ctx_ddl.drop_preference('portu_lexer');
call ctx_ddl.create_preference('default_lexer','basic_lexer');
call ctx_ddl.create_preference('english_lexer','basic_lexer');
call ctx_ddl.create_preference('chinese_lexer','chinese_lexer');
call ctx_ddl.create_preference('japanese_lexer','japanese_lexer');
call ctx_ddl.create_preference('korean_lexer','korean_morph_lexer');
call ctx_ddl.create_preference('german_lexer','basic_lexer');
call ctx_ddl.create_preference('dutch_lexer','basic_lexer');
call ctx_ddl.create_preference('swedish_lexer','basic_lexer');
call ctx_ddl.create_preference('french_lexer','basic_lexer');
call ctx_ddl.create_preference('italian_lexer','basic_lexer');
call ctx_ddl.create_preference('spanish_lexer','basic_lexer');
call ctx_ddl.create_preference('portu_lexer','basic_lexer');
call ctx_ddl.create_preference('global_lexer', 'multi_lexer');
call ctx_ddl.add_sub_lexer('global_lexer','default','default_lexer');
call ctx_ddl.add_sub_lexer('global_lexer','english','english_lexer','en');
call ctx_ddl.add_sub_lexer('global_lexer','simplified chinese','chinese_lexer','zh');
call ctx_ddl.add_sub_lexer('global_lexer','japanese','japanese_lexer',null);
call ctx_ddl.add_sub_lexer('global_lexer','korean','korean_lexer',null);
call ctx_ddl.add_sub_lexer('global_lexer','german','german_lexer','de');
call ctx_ddl.add_sub_lexer('global_lexer','dutch','dutch_lexer',null);
call ctx_ddl.add_sub_lexer('global_lexer','swedish','swedish_lexer','sv');
call ctx_ddl.add_sub_lexer('global_lexer','french','french_lexer','fr');
call ctx_ddl.add_sub_lexer('global_lexer','italian','italian_lexer','it');
call ctx_ddl.add_sub_lexer('global_lexer','spanish','spanish_lexer','es');
call ctx_ddl.add_sub_lexer('global_lexer','portuguese','portu_lexer',null);
