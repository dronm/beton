begin;

alter table buh_docs drop column client_1c;
alter table buh_docs drop column contract_1c;
alter table buh_docs drop column items;
alter table buh_docs drop column comment_text;

commit;
