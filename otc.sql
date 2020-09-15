declare
V_ACCOUNT_NUM   varchar(40) :=    ':ACCOUNT_NUM';
V_CUSTOMER_REF varchar(40) := 'null';
V_START_DTM date := to_date (':OTC_DATE', 'mm/dd/yyyy');
V_OTC_ID integer := :OTC_ID;
V_CPSID integer := :CPS_ID;
V_OTC_MNY integer := :OTC_MNY;
V_OTCSEQ integer :=0;
V_PRODSEQ integer := :PROD_SEQ;
V_OTCINSTLSEQ varchar(10) := 'null'; --:INSTLMNT_SEQ;
V_RCVBL_CLASS_ID integer := :RCVBL_CLASS_ID;
V_OTC_ATTR_POS integer := :OTC_ATTR_POSITION;
V_OTC_ATTR_VAL varchar(40) := ':OTC_ATTR_VALUE';
V_SERVICE_ADDR_SEQ integer;
begin
select nvl(max(address_seq),0) into V_SERVICE_ADDR_SEQ from custproductaddress where product_seq = V_PRODSEQ and customer_ref in (select customer_ref from account where account_num= V_ACCOUNT_NUM);
dbms_output.put_line('service_addr_seq is ' || V_SERVICE_ADDR_SEQ);
select ACCHASOTCSEQ.nextval into V_OTCSEQ from dual;
dbms_output.put_line('OTCSEQ is ' || V_OTCSEQ);



gnvotcharge.createonetimecharge6nc(p_accountnum => V_ACCOUNT_NUM,
                                     p_otcdtm => V_START_DTM,
                                     p_createddtm => V_START_DTM,
                                     p_otcid => V_OTC_ID,
                                     p_otcmny => V_OTC_MNY,
                                     p_cpsid => V_CPSID,-- --13 mex 16 esp, 19 nor, 22 pol
                                     p_genevauserora => 'GENEVA_ADMIN',
                                     p_revenuecodeid => null,
                                     p_receivableclassid => V_RCVBL_CLASS_ID,
                                     p_revrecognclassid => null,
                                     p_otclabel => 'otctest',
                                     p_productseq => V_PRODSEQ,
                                     p_budgetcentreseq => null,
                                     p_otctxt => 'otcText',
                                     p_serviceaddressseq => V_SERVICE_ADDR_SEQ,
                                     p_attrsubidarray => V_OTC_ATTR_POS,
                                     p_attrvaluearray => V_OTC_ATTR_VAL,
                                     p_otcinstallmentboo => null,
                                     p_downpaymentpct => null,
                                     p_downpaymentmny => null,
                                     p_numberofinstalmnts => null,
                                     p_productquantity => null,
                                     p_pointsredemptiontype => null,
                                     p_pointstoredeem => null,
                                     p_discappliedotccreation => null,
                                     p_discountedamount => null,
                                     p_awarddisconotccreationboo => null,
                                     p_altcurrencycode => null,
                                     p_revenuestartdat => null,
                                     p_revenueenddat => null,
                                     p_otcinstlmntseq => V_OTCINSTLSEQ,
                                     p_otcseq => V_OTCSEQ);
commit;

    SELECT CUSTOMER_REF INTO V_CUSTOMER_REF from ACCOUNT where account_num = V_ACCOUNT_NUM;
    Insert into attable (ACCOUNT_NUM,CUSTOMER_REF) values (V_ACCOUNT_NUM,V_CUSTOMER_REF);
    commit;
end;
