begin;

alter table buh_docs add column client_1c jsonb not null;
alter table buh_docs add column contract_1c jsonb not null;
alter table buh_docs add column if not exists  items jsonb;
alter table buh_docs add column comment_text text;

commit;
