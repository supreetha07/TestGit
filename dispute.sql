declare 
V_disputeseq integer := 0;
V_ACCOUNT_NUM varchar(40) := ':account_Num';
V_CUSTOMER_REF varchar(40) := 'null';
V_Dispute_date date := to_date(':Dispute_date', 'mm/dd/yyyy');
V_createddtm date ;
V_Bill_seq integer := ':Bill_seq';
V_dispute_text varchar(40) := ':dispute_text';
V_Amount integer := ':Amount';
V_Product_ID integer := ':Product_ID';
V_Product_seq integer := ':Product_seq';
V_Dispute_type_id integer := ':Dispute_type_id';
V_OTC_sequence integer := ':OTC_sequence';
V_Charge_type integer := ':Charge_type';
V_out_text varchar(40) := ':out_text';
V_Adj_Id integer := ':Adj_Id';
V_Credit_note varchar(40) := ':Credit_note';
V_CPS_ID integer := ':CPS_ID';
V_rvbl_class_id integer := ':rcvbl_class_id';
V_Charge_seq integer := ':Charge_seq';
V_Charge_Number integer := ':Charge_Number';
V_ADJSEQ integer := 0;
V_BILLREQUESTSEQ integer :=0;
V_INVLEVELDISP varchar(40) ;


begin

select to_date(sysdate) into V_createddtm from dual;
select nvl(max(adjustment_seq),0)+1 into V_ADJSEQ from adjustment where account_num= V_ACCOUNT_NUM;
dbms_output.put_line('Mandate_seq is ' || V_ADJSEQ);

select nvl(max(dispute_seq),0)+1 into V_disputeseq from dispute where account_num= V_ACCOUNT_NUM;
dbms_output.put_line('Mandate_seq is ' || V_disputeseq);

gnvdispadj.createdispute9nc(accountnumber => V_ACCOUNT_NUM,
                              disputedtm => V_Dispute_date,
                              billseq => V_Bill_seq,
                              disputetxt => V_dispute_text,
                              disputemny => V_Amount,
                              productid => V_Product_ID,
                              eventtypeid => null,
                              disputetypeid => V_Dispute_type_id,
                              cpsid => V_CPS_ID,
                              productseq => V_Product_seq,
                              chargetype => V_Charge_type,
                              eventref => null,
                              receivableclassid => V_rvbl_class_id,
                              otcseq => V_OTC_sequence,
                              billchargenumber => V_Charge_Number,
                              billchargeseq => V_Charge_seq,
                              invoiceleveldisp => V_INVLEVELDISP,
                              groupid => null,
                              disputeseq => V_disputeseq);

---FOR accept dispute------

  gnvdispadj.acceptdispute4nc(accountnumber => V_account_Num,
                              disputeseq => V_disputeseq,
                              outcomedesc => V_out_text,
                              adjustdat => V_Dispute_date,
                              adjusttypeid => V_Adj_Id,
                              budgetcentreseq => null,
                              adjusttxt => 'Dispute TA',
                              adjustmentoutcome => 'TA Approved',
                              requestcreditnote => 'F',
                              createddtm => V_createddtm,
                              adjustmny => V_Amount,
                              attrsubidarray => null,
                              attrvaluearray => null,
                              adjustseq => V_ADJSEQ,
                              billrequestseq => V_BILLREQUESTSEQ);
 commit;
 
    SELECT CUSTOMER_REF INTO V_CUSTOMER_REF from ACCOUNT where account_num = V_ACCOUNT_NUM;
    Insert into attable (ACCOUNT_NUM,CUSTOMER_REF) values (V_ACCOUNT_NUM,V_CUSTOMER_REF);
    commit;
end;
