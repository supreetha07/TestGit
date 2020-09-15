declare
V_CUSTOMER_REF varchar(40) := ':CUSTOMER_REF';--pass customer_Ref
V_ACCOUNT_NUM   varchar(40) :=    ':ACCOUNT_NUM';-- pass accountnumber
V_PAYMENT_DTM    date := to_date(':PAYMENT_DATE', 'mm/dd/yyyy');-- pass date
V_PHYPAYSEQ integer := :PAYMENT_SEQUENCE;
V_ACCPAYSEQ integer := :PAYMENT_SEQUENCE;
V_OITEM integer := 2;
  
begin
  
V_CUSTOMER_REF := ':CUSTOMER_REF';
V_ACCOUNT_NUM := ':ACCOUNT_NUM';

gnvpay.createphysicalpay4(customerref => V_CUSTOMER_REF,--'CUSTESP_5',
                            physicalpaydate => V_PAYMENT_DTM, --to_date('7/24/2019','mm/dd/yyyy'),
                            physicalpaymoney => :PAYMENT_MONEY,
                            physicalpaycurrency => ':PAYMENT_CURRENCY',
                            paymentmethodid => :PAYMENT_METHOD,--13 mex, 14 esp, 18 nor, 21 pol
                            physicalpaydescription => 'desc',
                            physicalpayref => null,
                            creationdate => V_PAYMENT_DTM, --to_date('7/24/2019','mm/dd/yyyy'),
                            batchid => null,
                            payrequestid => null,
                            physicalpayseq => V_PHYPAYSEQ,
                            refundboo => ':REFUND_BOO',
                            suspenseaccountpayboo => 'F',
                            p_attribindexarray => null,
                            p_newstringvaluesarray => null,
                            p_oldstringvaluesarray => null);
                            

gnvpay.createaccountpay1nc(accountnumber => V_ACCOUNT_NUM,
                             paymentdate => V_PAYMENT_DTM,
                             paymentmoney => :PAYMENT_MONEY,
                             paymentcurrency => ':PAYMENT_CURRENCY',
                             depositboo => 'F',
                             paymenttext => 'PayText',
                             paymentref => null,
                             physicalcustomerref =>V_CUSTOMER_REF,
                             physicalpayseq => V_PHYPAYSEQ,
                             creationdate => V_PAYMENT_DTM,
                             openitemaccount => V_OITEM,
                             accountpayseq => V_ACCPAYSEQ);
commit;

    Insert into attable (ACCOUNT_NUM,CUSTOMER_REF) values (V_ACCOUNT_NUM,V_CUSTOMER_REF);
    commit;
end;
