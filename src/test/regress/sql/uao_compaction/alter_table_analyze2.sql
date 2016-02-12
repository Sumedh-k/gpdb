-- @Description Checks analyze and drop column interfaction

CREATE TABLE ck_ct_ao_analyze2(
text_col text,
bigint_col bigint,
char_vary_col character varying(30),
numeric_col numeric,
int_col int4,
float_col float4,
int_array_col int[],
drop_col numeric,
before_rename_col int4,
change_datatype_col numeric,
a_ts_without timestamp without time zone,
b_ts_with timestamp with time zone,
date_column date) with (appendonly=true) distributed randomly;

INSERT INTO ck_ct_ao_analyze2 values ('0_zero', 0, '0_zero', 0, 0, 0, '{0}', 0, 0, 0, '2004-10-19 10:23:54', '2004-10-19 10:23:54+02', '1-1-2000');
INSERT INTO ck_ct_ao_analyze2 values ('1_zero', 1, '1_zero', 1, 1, 1, '{1}', 1, 1, 1, '2005-10-19 10:23:54', '2005-10-19 10:23:54+02', '1-1-2001');
INSERT INTO ck_ct_ao_analyze2 values ('2_zero', 2, '2_zero', 2, 2, 2, '{2}', 2, 2, 2, '2006-10-19 10:23:54', '2006-10-19 10:23:54+02', '1-1-2002');
select count(*) AS only_visi_tups_ins  from ck_ct_ao_analyze2;
set gp_select_invisible = true;
select count(*) AS invisi_and_visi_tups_ins  from ck_ct_ao_analyze2;
set gp_select_invisible = false;
update ck_ct_ao_analyze2 set bigint_col = bigint_col + 1 where text_col = '0_zero';
select count(*) AS only_visi_tups_upd  from ck_ct_ao_analyze2;
set gp_select_invisible = true;
select count(*) AS invisi_and_visi_tups_upd  from ck_ct_ao_analyze2;
set gp_select_invisible = false;
delete from ck_ct_ao_analyze2  where int_col = 2;
select count(*) AS only_visi_tups_del  from ck_ct_ao_analyze2;
set gp_select_invisible = true;
select count(*) AS invisi_and_visi_tups_del  from ck_ct_ao_analyze2;
set gp_select_invisible = false;
--
ALTER TABLE ck_ct_ao_analyze2 ADD COLUMN added_col character varying(30) default 'test_value';
ALTER TABLE ck_ct_ao_analyze2 DROP COLUMN drop_col ;
ALTER TABLE ck_ct_ao_analyze2 RENAME COLUMN before_rename_col TO after_rename_col;
ALTER TABLE ck_ct_ao_analyze2 ALTER COLUMN change_datatype_col TYPE int4;
ALTER TABLE ck_ct_ao_analyze2 set with ( reorganize='true') distributed by (int_col);
update ck_ct_ao_analyze2 set bigint_col = bigint_col + 1 where text_col = '1_zero';
ANALYZE ck_ct_ao_analyze2;