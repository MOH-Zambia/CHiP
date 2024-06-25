create sequence if not exists report_master_id_seq;
ALTER TABLE public.report_master
   ALTER COLUMN id SET DEFAULT nextval('report_master_id_seq'::regclass);
ALTER TABLE public.report_master
  ADD COLUMN code character varying(20);
select setval('report_master_id_seq', max(id)) FROM report_master  ;