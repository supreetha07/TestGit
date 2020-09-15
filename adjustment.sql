declare
V_ACCOUNT_NUM   varchar(40) :=    ':ACCOUNT_NUM';-- pass account_num
V_CUSTOMER_REF varchar(40);
V_BILLRQSTSEQ integer := 0;--:BILL_SEQ;
V_ADJSEQ integer := 0; --:ADJUSTMENT_SEQ;
V_ADJUSTMENT_TYPE_ID integer := :ADJUSTMENT_TYPE_ID;
V_ADJUSTMENT_MONEY integer := :ADJUSTMENT_MONEY;
V_ADJSTMENT_DTM    date := to_date(':ADJUSTMENT_DATE', 'mm/dd/yyyy');--pass date
V_CPSID integer := :CPS_ID;
V_ADJUSTMENT_TEXT varchar(80) := ':ADJUSTMENT_TEXT';
V_ADJUSTMENT_OUTCOME varchar(80) := ':ADJUSTMENT_OUTCOME';
  
begin
  

select nvl(max(adjustment_seq),0)+1 into V_ADJSEQ from adjustment where account_num= V_ACCOUNT_NUM;
dbms_output.put_line('Mandate_seq is ' || V_ADJSEQ);

gnvdispadj.createadjustment4nc(accountnumber => V_ACCOUNT_NUM,
                                 adjustdat => V_ADJSTMENT_DTM,
                                 adjusttypeid => V_ADJUSTMENT_TYPE_ID,
                                 adjusttxt => V_ADJUSTMENT_TEXT,
                                 adjustmny => V_ADJUSTMENT_MONEY,
                                 budgetcentreseq => null,
                                 requestcreditnote => 'F',
                                 createddtm => V_ADJSTMENT_DTM,
                                 cpsid => V_CPSID,--13 mex 16 esp, 19 nor, 22 pol 
                                 adjustmentoutcome => V_ADJUSTMENT_OUTCOME,
                                 attrsubidarray => null,
                                 attrvaluearray => null,
                                 adjustseq => V_ADJSEQ,
                                 billrequestseq => V_BILLRQSTSEQ);
                            commit;
    
    SELECT CUSTOMER_REF INTO V_CUSTOMER_REF from ACCOUNT where account_num = V_ACCOUNT_NUM;
    Insert into attable (ACCOUNT_NUM,CUSTOMER_REF) values (V_ACCOUNT_NUM,V_CUSTOMER_REF);
    commit;                         
end;
