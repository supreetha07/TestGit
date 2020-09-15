declare
    V_START_DTM date:= to_date('2020/05/01','yyyy/mm/dd');
    V_CONTACT_TYPE number(9) := 1000000;
    V_CONTACT_SEQ        integer;
    V_ATPLANGUAGEID number(9) := 1;
         V_CUSTOMER_REF customer.customer_ref%type;
         V_ACCOUNT_NUM  account.account_num%type;
         V_PATTERN               varchar2(4000) := 101122;
         V_START_NUMBER          integer := '3';
     V_JCODE varchar2(20)  := '021100030';
     V_ADDRESS_SEQ        integer;
     V_CUST_TYPE_ID varchar2(20) := '1';
     V_NEXT_BILL_DTM         date := to_date('2020/06/01','yyyy/mm/dd');
      V_ACCOUNTLOCKVERSION account.account_lock_version%type;

         v_contractseq number;
  v_contractRef varchar2(20);
 V_CNTRCT_TARIFF varchar2(10) := 19;
      V_CNTRCT_PROD varchar2(10) := 21;
        V_BTD_TARIFF varchar2(10) := 1;
        V_BTD_PROD varchar2(10) := 22;
      V_PRODUCTSEQ         integer;
           V_parent_TARIFF varchar2(10) := 1;
        V_parent_PROD varchar2(10) := 25;

        V_PARENT_PROD_SEQ integer;
        V_event_source custeventsource.event_source%type;
        V_evsource_PROD_SEQ integer;



BEGIN

     V_START_NUMBER := V_START_NUMBER + 21;
       -- Customer Ref
     V_CUSTOMER_REF := 'ATBRAC2' || V_PATTERN || lpad(V_START_NUMBER, 1, 0);
    dbms_output.put_line('Customer='||V_CUSTOMER_REF);
      -- Account Num
      V_ACCOUNT_NUM := '30011' || V_PATTERN || lpad(V_START_NUMBER, 1, 0);
    dbms_output.put_line('Account='||V_ACCOUNT_NUM);
	    dbms_output.put_line('Data');
			    dbms_output.put_line('Data2');
	
    --SUBscription Ref



    --v_contractRef

 --    v_contractRef := 'CNTRCTREF' || V_PATTERN ||lpad(V_START_NUMBER, 3, 0);

                    -- Event source
      V_event_source := 'EVTJAYLP_' || V_PATTERN ||  lpad(V_START_NUMBER, 5, 0);

      dbms_output.put_line(V_CUSTOMER_REF || ' ' || V_ACCOUNT_NUM || ' ' || V_event_source);

      -- Call the procedures to create Customers.
      gnvcust.reservecustomernocommit(customerref => V_CUSTOMER_REF);
    --6 - spanish , 7 - English, 14 - Norwegian , 15 - Polish, 10 - portugese brazil
  gnvcontact.addcontact2nc(customerref    => V_CUSTOMER_REF,
                   contacttypeid  => V_CONTACT_TYPE, -- INTERNAL
                   contactnotes   => null,
                   title          => 'Mr',
                   firstname      => 'Viasat',
                   initials       => null,
                   namepostfix    => null,
                   lastname       => 'Customer',
                   addressname    => 'Viasat ST customer',
                   salutationname => null,
                   languageid     => V_ATPLANGUAGEID,
                   contactseq     => V_CONTACT_SEQ);
  V_ADDRESS_SEQ := gnvaddress.addaddress3nc(customerref     => V_CUSTOMER_REF,
                                              addr1           => 'Test address 1',
                                              addr2           => 'Test address 2',
                                              addr3           => 'Test address 3',
                                             addr4           => 'Florida',
                                              addr5           => 'Test',
                                              postcode        => '04-04401',
                                              countryid       => 33, -- USA
                                              addressformatid => 1   ,
                                              jcode           => V_JCODE,
                                              ustincityboo    => null);
  gnvcontact.addcontactdetails1nc(customerref => V_CUSTOMER_REF,
                                    contactseq  => V_CONTACT_SEQ,
                                    startdate   => V_START_DTM,
                                    daytimetel  => null,
                                    daytimeext  => null,
                                    eveningtel  => null,
                                    eveningext  => null,
                                    faxtel      => null,
                                    mobiletel   => '7813459908',
                                    edi         => null,
                                    email       => 'test@netcracker.com',
                                    position    => 'QA',
                                    department  => 'QACOE',
                                    addressseq  => V_ADDRESS_SEQ
                                    );
  gnvcust.confirmcustomer8nc(p_customerref             => V_CUSTOMER_REF,
                               p_customertypeid          => V_CUST_TYPE_ID, -- Residential 51
                               p_contactseq              => V_CONTACT_SEQ,
                               p_companyname             => null,
                               p_taxexemptref            => null,
                               p_providerid              => null,
                               p_custpassword            => null,
                               p_billperiod              => null,
                               p_billperiodunits         => null,
                               p_nextbilldtm             => null,
                               p_statementfreq           => null,
                               p_vatregnum               => null,
                               p_permissionid            => 1,
                               p_summarycontactseq       => null,
                               p_summarycurrencycode     => null,
                               p_summarystyleid          => null,
                               p_concatenatebillsboo     => 'F',
                               p_summarybillhandlingcode => null,
                               p_invoicingcoid           => null, --3 Mexico 4 spain, 5 norway 6 poland 7 brazil
                               p_marketsegmentid         => null,
                               p_templaterefcustboo      => 'F',
                               p_billdayofthemonth        => null,
                               p_negativepointsthreshold => null);


  gnvcontract.addtocustomer1nc(p_customerref => V_CUSTOMER_REF,
                               p_startdate =>V_START_DTM,
                               p_enddate => null,
                               p_contractterm => 12,
                               p_contracttermunit => 'M',
                               p_contracttypeid => 1, --2 variable 1 fixed
                               p_contractref => v_contractRef,
                               p_contractname => 'CONTRCTVSAT',
                               p_customerorderref => null,
                               p_supplierorderref => null,
                               p_salesperson => 'Viasat',
                               p_contractnotestxt => null,
                               p_contractseq => v_contractseq);

   gnvacc.createaccount22nc(p_accountnum            => V_ACCOUNT_NUM,
                            p_customerref           => V_CUSTOMER_REF,
                            p_accountname           => 'Test ST Account',
                            p_currencycode          => 'USD',
                            p_nextbilldtm           => V_NEXT_BILL_DTM,
                            p_golivedtm             => V_START_DTM,
                            p_billperiod            => 1,
                            p_billperiodunits       => 'M',
                            p_billstyleid           => 1,
                            p_paymentmethodid       => 5, -- Payment Method
                            p_billingcontactseq     => V_CONTACT_SEQ,
                            p_creditclassid         => 29, -- Credit Class
                            p_creditlimitmny        => '250000',
                            p_infocurrencycode      => null,
                            p_packagediscaccnum     => null,
                            p_eventdiscaccnum       => null,
                            p_accountingmethod      => 1, -- Balance Forward
                            p_statementfrequency    => 1,
                            p_billhandlingcode      => null,
                            p_defaultserviceaddress => null,
                            p_invoicingcoid         => 1, --3 Mexico 4 spain, 5 norway 6 poland
                            p_defaultcpsid          => null, -- STC CPS
                            p_donateddiscountcps    => null,
                            p_autodelbilledeventboo => 'F',
                            p_businessboo           => null,
                            p_endcustomerboo        => null,
                            p_prepayboo             => 'F',
                            p_thresholdsetid        => null,
                            p_taxinclusiveboo       => 'F',
                            p_internalaccountboo    => 'F',
                            p_eventsperday          => 1,
                            p_holidayprofileid      => null,
                            p_templateref           => null,
                            p_eventdeletionmode     => null,
                            p_reguidedeventdelmode  => null,
                            p_maskeventsonbillboo   => 'F',
                            p_maskeventsinstoreboo  => 'F',
                            p_maskreguidedonbillboo => 'F',
                            p_maskreguidedinstoreboo=> 'F',
                            p_ticketboo             => null,
                            p_languageid            => V_ATPLANGUAGEID,
                            p_lcprofileid           => 1,
                            p_lcstateid             => 1,
                            p_nextlcsprocessdays    => null,
                            p_csruser               => 'GENEVA_ADMIN',
                            p_lcstatereasontxt      => null,
                            p_prodchargeprofileid   => null,
                            p_disablerealtimebillboo=> 'F',
                            p_createdepositbalanceboo=>'T',
                            p_eventtidemark         => null,
                            p_rechargepaymentsboo   => 'F',
                            p_outputeventtofileboo  => null,
                            p_aggregatestartdat     => null,
                            p_eventdispatchprofileid=> null,
                            p_dormancylcprofileid   => null,
                            p_dormancychecknbrofdays=> null,
                            p_excludefrompromoboo   => null,
                            p_taxreengineerboo      => 'F',
                            p_creditcheckedboo      => 'F',
                            p_billdayofthemonth     => null,
                            p_eventstoretype        => null,
                            p_currencymode          => null,
                            p_currencyconvcalday    => null,
                            p_accountlockversion    => V_ACCOUNTLOCKVERSION);

  /* to be called only if configuration have subscription
  gnvcustSUBscription.createcustSUBscription5nc(p_customerref    => V_CUSTOMER_REF,
                                        p_SUBscriptionref        => V_SUBSCRIPTION_REF,
                                        p_SUBscriptiontypeid     => V_SUBS_PROD,
                                        p_startdtm               => V_START_DTM,
                                        p_termdtm                => null,
                                        p_accountnum             => V_ACCOUNT_NUM,
                                        p_budgetcentreseq        => null,
                                        p_tariffid               => V_SUBS_TARIFF,
                                        p_competitortariffid     => null,
                                        p_SUBscriptionlabel      => 'SUBscription1',
                                        p_custordernum           => null,
                                        p_supplierordernum       => null,
                                        p_custSUBscriptioncontactseq  => null,
                                        p_contractedpos          => 1, -- STC CPS
                                        p_cpstaxexemptref        => null,
                                        p_cpstaxexempttxt        => null,
                                        p_contractseq            => null,
                                        p_SUBscriptionstatus     => 'OK',
                                        p_statusreasontxt        => null,
                                        p_defaulteventsource     =>null,
                                        p_budgetplanid           => null,
                                        p_prorateinitialperiodboo=> null,
                                        p_pointsredemptiontype   => null,
                                        p_pointstoredeem         => null,
                                        p_productseq             => V_SUBSSEQ);*/



-- Product 1




gnvcustproduct.createcustproduct12nc(p_customerref             => V_CUSTOMER_REF,
                                        p_productid              => V_CNTRCT_PROD, -- z WS 8YY Misdirected
                                        p_startdtm               => V_START_DTM,
                                        p_termdtm                => null,
                                       p_parentproductseq       => null,
                                        p_packageseq             => null,
                                        p_productpackageinstance => null,
                                        p_accountnum             => V_ACCOUNT_NUM,
                                        p_budgetcentreseq        => null,
                                        p_tariffid               => V_CNTRCT_TARIFF, -- WS 8YY Misdirected 1075
                                        p_competitortariffid     => null,
                                        p_productlabel           => 'prod_BD',
                                        p_productquantity        => 1,
                                        p_custordernum           => null,
                                        p_supplierordernum       => null,
                                        p_custproductcontactseq  => null,
                                        p_contractedpos          => null, -- STC CPS
                                        p_cpstaxexemptref        => null,
                                        p_cpstaxexempttxt        => null,
                                        p_contractseq            => null,
                                        p_additions_quantity     => null,
                                        p_terminations_quantity  => null,
                                        p_productstatus          => 'OK',
                                        p_statusreasontxt        => null,
                                        p_SUBscription_ref       => null,
                                        p_productoptionalboo     => 'F',
                                        p_eventdeletionmode      => null,
                                        p_budgetplanid           => null,
                                        p_communitygroupid       => null,
                                        p_communitygroupownerboo => null,
                                        p_prorateinitialperiodboo=> null,
                                        p_pointsredemptiontype   => null,
                                        p_pointstoredeem         => null,
                                        p_productseq             => V_PRODUCTSEQ);

gnvcustproduct.createcustproduct12nc(p_customerref             => V_CUSTOMER_REF,
                                    p_productid              => V_parent_PROD, -- z WS 8YY Misdirected
                                    p_startdtm               => V_START_DTM,
                                    p_termdtm                => null,
                                   p_parentproductseq       => null,
                                    p_packageseq             => null,
                                    p_productpackageinstance => null,
                                    p_accountnum             => V_ACCOUNT_NUM,
                                    p_budgetcentreseq        => null,
                                    p_tariffid               => V_parent_TARIFF, -- WS 8YY Misdirected 1075
                                    p_competitortariffid     => null,
                                    p_productlabel           => 'prod_BD',
                                    p_productquantity        => 1,
                                    p_custordernum           => null,
                                    p_supplierordernum       => null,
                                    p_custproductcontactseq  => null,
                                    p_contractedpos          => null, -- STC CPS
                                    p_cpstaxexemptref        => null,
                                    p_cpstaxexempttxt        => null,
                                    p_contractseq            => null,
                                    p_additions_quantity     => null,
                                    p_terminations_quantity  => null,
                                    p_productstatus          => 'OK',
                                    p_statusreasontxt        => null,
                                    p_SUBscription_ref       => null,
                                    p_productoptionalboo     => 'F',
                                    p_eventdeletionmode      => null,
                                    p_budgetplanid           => null,
                                    p_communitygroupid       => null,
                                    p_communitygroupownerboo => null,
                                    p_prorateinitialperiodboo=> null,
                                    p_pointsredemptiontype   => null,
                                    p_pointstoredeem         => null,
                                    p_productseq             => V_PRODUCTSEQ);

select product_seq into V_PARENT_PROD_SEQ  from custhasproduct where customer_ref = V_CUSTOMER_REF and product_id=V_parent_PROD;

  gnvcustproduct.createcustproduct12nc(p_customerref             => V_CUSTOMER_REF,
                                        p_productid              => V_BTD_PROD, -- z WS 8YY Misdirected
                                        p_startdtm               => V_START_DTM,
                                        p_termdtm                => null,
                                       p_parentproductseq       => V_PARENT_PROD_SEQ,
                                        p_packageseq             => null,
                                        p_productpackageinstance => null,
                                        p_accountnum             => null,
                                        p_budgetcentreseq        => null,
                                        p_tariffid               => V_BTD_TARIFF, -- WS 8YY Misdirected 1075
                                        p_competitortariffid     => null,
                                        p_productlabel           => 'prod_BD',
                                        p_productquantity        => 1,
                                        p_custordernum           => null,
                                        p_supplierordernum       => null,
                                        p_custproductcontactseq  => null,
                                        p_contractedpos          => null, -- STC CPS
                                        p_cpstaxexemptref        => null,
                                        p_cpstaxexempttxt        => null,
                                        p_contractseq            => null,
                                        p_additions_quantity     => null,
                                        p_terminations_quantity  => null,
                                        p_productstatus          => 'OK',
                                        p_statusreasontxt        => null,
                                        p_SUBscription_ref       => null,
                                        p_productoptionalboo     => 'F',
                                        p_eventdeletionmode      => null,
                                        p_budgetplanid           => null,
                                        p_communitygroupid       => null,
                                        p_communitygroupownerboo => null,
                                        p_prorateinitialperiodboo=> null,
                                        p_pointsredemptiontype   => null,
                                        p_pointstoredeem         => null,
                                        p_productseq             => V_PRODUCTSEQ);



  select product_seq into V_evsource_PROD_SEQ  from custhasproduct where customer_ref = V_CUSTOMER_REF and product_id=V_CNTRCT_PROD;

       gnveventsrc.createeventsource5nc(p_customerref                  => V_CUSTOMER_REF,
                                                 p_productseq                   => V_evsource_PROD_SEQ,
                                                 p_eventsource                  => V_event_source,
                                                 p_eventtypeid                  => 1,
                                                 p_startdtm                     => V_START_DTM,
                                                 p_enddtm                       => null,
                                                 p_eventsourcelabel             => V_event_source,
                                                 p_eventsourcetext              => 'EVENTSOURCE',
                                                 p_creditlimit                  => null,
                                                 p_ratingtariffid               => 1,
                                                 p_competitorratingtariffid     => null,
                                                 p_copyguidingrules             => null,
                                                 p_eventdeletionmode            => null,
                                                 p_onbillmaskingruleid          => null,
                                                 p_datastoremaskingruleid       => null,
                                                 p_defaultrchgpayeventconfigboo => null);



END;
