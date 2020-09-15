declare
V_ACCOUNT_NUM   varchar(40) :=    ':ACCOUNT_NUM';
V_ACTIVEFROM_DTM date := to_date (':ACTIVE_FROM_DATE', 'mm/dd/yyyy');
V_ACTIVETO_DTM date := to_date (':ACTIVE_TO_DATE', 'mm/dd/yyyy');
V_PAYMENT_METHOD_ID integer := ':PAYMENT_METHOD_ID';
V_MANDATE_ATTR_VAL varchar(40) := ':MANDATE_ATTR1_VALUE';
V_MANDATE_SEQ integer :=0;
V_MANDATE_REF varchar (40);
V_METHOD_NAME varchar (40) := 'Credit';
V_CUSTOMER_REF varchar(40) := null;
begin
select nvl(max(mandate_seq),0)+1 into V_MANDATE_SEQ from prmandate where account_num= V_ACCOUNT_NUM;
dbms_output.put_line('Mandate_seq is ' || V_MANDATE_SEQ);

select 'C'||CCMANDATESEQ.nextval into V_MANDATE_REF from dual;
dbms_output.put_line('Mandate_ref is ' || V_MANDATE_REF);

/*
select nvl(SUBSTR(payment_method_name,7,instr(payment_method_name,'-')+1),payment_method_name) into V_METHOD_NAME from paymentmethod where sales_end_dat is null and payment_method_id in (select payment_method_id from prmandate where account_num = V_ACCOUNT_NUM);
if(V_METHOD_NAME = 'Credit') THEN
select 'C'||CCMANDATESEQ.nextval into V_MANDATE_REF from dual;
dbms_output.put_line('Mandate_ref is ' || V_MANDATE_REF);
ELSE
select 'D'||CCMANDATESEQ.nextval into V_MANDATE_REF from dual;
dbms_output.put_line('Mandate_ref is ' || V_MANDATE_REF);
END IF;
*/
gnvddm.createprmandate1nc(accountnum => V_ACCOUNT_NUM,
paymentmethodid => V_PAYMENT_METHOD_ID,
activefromdat => V_ACTIVEFROM_DTM,
activetodat => V_ACTIVETO_DTM,
bankaccountholder => null,
bankaccountnumber => null,
bankcode => null,
bankbranchnumber => null,
cardnumber => null,
cardexpirydat => null,
cardissuedat => null,
cardissuenum => null,
mandateattr1 => V_MANDATE_ATTR_VAL,
mandateattr2 => null,
mandateattr3 => null,
mandateattr4 => null,
mandateattr5 => null,
mandateattr6 => null,
mandateref => V_MANDATE_REF,
mandateseq => V_MANDATE_SEQ);
commit;

    SELECT CUSTOMER_REF INTO V_CUSTOMER_REF from ACCOUNT where account_num = V_ACCOUNT_NUM;
    Insert into attable (ACCOUNT_NUM,CUSTOMER_REF) values (V_ACCOUNT_NUM,V_CUSTOMER_REF);
    commit;
end;
