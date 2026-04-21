/**
     * This class used for  data transformation of Transaction into JSON
     * Methods
     *
     * @class gTDataTransformation
     * @constructor  gTDataTransformation
     *
     */

    public class gTDataTransformation {

        public static final String CURRENCY_CODE='AED';
        public static final String BRAND='AXS';
        public static final String CD='CUSTOMER DEPOSIT';
        public static final String BG='BANK GUARANTEE';
        public static final String SERVICE='AXS';
        public static final String STYPE='SERVICE';
        public static final String SERVICE_TYPE='AXS';
        public static final String CM='CREDIT_MEMO';
        public static final String DM='DEBIT_MEMO';
        public static final String FLEX_Context='AXS';
        public static final String temp_partyid='NA';
        public static final string CREDIT_OR_DEBIT='Credit / Debit Card';
        public static final string CREDIT_CARD='CREDIT CARD';

        public static final String WALKIN_CUSTOMER= Label.ORA_WALKIN_CUSTOMER;
        public static final String WALKIN_CUSTOMER_BILL_TO_SITE= Label.ORA_WALKIN_CUSTOMER_BILL_TO_SITE;
        public static final String DED_NOC= Label.ORA_DED_NOC;
        public static final String TOP_UP_CD= Label.ORA_TOP_UP_CD;
        public static final String TOP_UP_BG= Label.ORA_TOP_UP_BG;
        public static final String REFUND= Label.ORA_REFUND;
        public static final String REFUND_PAYMENT_METHOD= Label.ORA_REFUND_PAYMENT_METHOD;
        public static final String PARKING_SERVICES= Label.ORA_PARKING_SERVICES;
        public static final String FREELANCER_SERVICES= Label.ORA_FREELANCER_SERVICES;
        public static final String PMS_SERVICES= Label.ORA_PMS_SERVICES;
        public static  final  String YARDI_SERVICES= Label.ORA_YARDI_SERVICES;
        public static final String TAX_REGIME_CODE= Label.ORA_TAX_REGIME_CODE;
        public static final String TAX_STD= Label.ORA_TAX_STD;
        public static final String TAX_OUT_OF_SCOPE=Label.ORA_TAX_OUT_OF_SCOPE;
        public static String suppliers = Label.ORA_SUPPLIERMAP;
        public static String BUNDLE_SERV=Label.ORA_BUNDLE_SRV;

        /* Creation of invoice json reading data from ORAMETA    paratements , transaction id,
            * Intype  referers invoice to be created  under AXS, specfic business unit  value to be passed as BU
            * and for creation of Credit Memo
            *
            */

        public static String  datatransformationInv(String tid, String invtype) {
        String inpJson;
            try{
        Map <String, ORAMETA__c> metaLookup= gTOraFusionLookup.getOraMetaLookup();

            Map<String, Object> supplierMap = (Map<String, Object>) JSON.deserializeUntyped(suppliers);
            list<g_TranItem__c> tranLst=[select id, name, itm__r.name, itm__r.xcbsd__c, itm__r.xcbed__c,
                A__c, ml__c, T__r.Name, VAT__c, DDA_Inv_no__c, yardiinv__c, Service_Name__c, itm__r.xlesd__c,
                itm__r.xleed__c, itm__r.itm__r.Bill_To__c from g_TranItem__c where T__c=:tid];
            //g_tran__c tran= [Select Id, Name, STA__c, Zone__c, Srv_Code__c, RQ__r.xcfn__c, RQ__r.xled__c, dt__c, A__c, md__c, Acc__r.park__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Legal_Framework__c, TP__c, op__r.Name From g_tran__c where id=:tid and isDeleted=false][0];
            g_tran__c tran= [Select Id, Name, YardiInv__c, repush__c, pre_fix__c, STA__c, Zone__c,
                Srv_Code__c, RQ__r.xps__c, RQ__r.xpmsle__c, RQ__r.xcpid__c, RQ__r.xcped__c, RQ__r.xcfn__c,
                RQ__r.xled__c, dt__c, A__c, md__c, Acc__r.park__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Legal_Framework__c,
                TP__c, op__r.Name From g_tran__c where id=:tid and isDeleted=false][0];
            String serviceType=SERVICE_TYPE;
            String sType=STYPE;
            String brand=BRAND;
            String PAYMENT_METHOD=tran.md__c == CREDIT_OR_DEBIT?CREDIT_CARD:tran.md__c;
            String type=tran.TP__c;
            
            system.debug('invtype---'+invtype);
            
            Date transDate=(tran.dt__c == null || invtype == CM || invtype == DM)?system.today():tran.dt__c;

            IF(PARKING_SERVICES.contains(tran.Srv_Code__c)) {
                serviceType='PARKING';
                brand=tran.Acc__r.park__c;
            }
                IF(FREELANCER_SERVICES.contains(tran.Srv_Code__c) && invtype=='BU' && tran.Acc__r.Legal_Framework__c=='Freelancer') {
                serviceType='FREELANCER';
                brand=tran.Acc__r.park__c;
            }
                IF(PMS_SERVICES.contains(tran.Srv_Code__c) && invtype=='BU' && tran.Acc__r.Legal_Framework__c!='Freelancer') {
                serviceType='PMS';
                brand=tran.Acc__r.park__c;
            }

            if (invtype == CM) {sType='CREDIT MEMO';serviceType='REFUND';}
            String key =(sType+serviceType+brand+PAYMENT_METHOD).toUpperCase();
            system.debug('key===>'+key);
            if (invtype == DM) {key='DEBIT MEMODEBIT_MEMOAXSCUSTOMER DEPOSIT';}
            if (invtype == DM && tran.Srv_Code__c == TOP_UP_BG) {key='DEBIT MEMOCDTOBGAXSCUSTOMER DEPOSIT';}
            if (invtype == DM && tran.Srv_Code__c == TOP_UP_CD) {key='DEBIT MEMOBGTOCDAXSCUSTOMER DEPOSIT';}

            ORAMETA__c oraMeta=metaLookup.get(key);
            InvoiceLinesFusion inlf= new InvoiceLinesFusion();
            InvoiceLinesFusion.Input inp= new InvoiceLinesFusion.Input();
            inp.AccountingDate=String.ValueOf(transDate);//'2025-09-01';//
                if (temp_partyid=='NA') {
                inp.BillToCustomerNumber=tran.Acc__r.ORACLE_PARTY_ID__c;
                }else {inp.BillToCustomerNumber=temp_partyid;}
            inp.BillToSite=oraMeta.BILLTOSITE__c;

            if (tran != null && tran.Srv_Code__c == DED_NOC) {inp.BillToCustomerNumber=WALKIN_CUSTOMER;inp.BillToSite=WALKIN_CUSTOMER_BILL_TO_SITE;}
            inp.BusinessUnit=oraMeta.BUSINESSUNITNAME__c;
            inp.InvoiceCurrencyCode=CURRENCY_CODE;
            inp.PaymentTerms=oraMeta.PaymentTerms__c;
            inp.TransactionDate=String.ValueOf(transDate);
            inp.TransactionNumber=tran.Name;
            if (tran.repush__c) {inp.TransactionNumber=tran.Name+'_'+tran.pre_fix__c;}
            inp.TransactionSource=oraMeta.TRANSACTION_SOURCE__c;
            inp.TransactionType=oraMeta.TRANSACTION_TYPE__c;
            inp.Prevalidation=BUNDLE_SERV.contains(tran.Srv_Code__c)?'Yes':'No';
            if (invtype == DM) {inp.Prevalidation=null;}
            InvoiceLinesFusion.receivablesInvoiceDFF hDff=new InvoiceLinesFusion.receivablesInvoiceDFF();
            if (tran.md__c == CD && invtype == DM && tran.Srv_Code__c == TOP_UP_BG) {hDff.axsExtensionReference='AXSADBG';}

            else if (tran.md__c=='Bank Guarantee' && invtype == DM && tran.Srv_Code__c == TOP_UP_CD) {hDff.axsExtensionReference='AXSBGAD';}
            else if (tran.md__c == CD && invtype != CM && invtype != DM) {hDff.axsExtensionReference='AXSCD';}
            else{hDff.axsExtensionReference='NA';}
            hDff.pmsBuilding='NA';
            hDff.FLEX_Context=FLEX_Context;
            inp.receivablesInvoiceDFF=hDff;
            inp.PaymentTerms=oraMeta.PAYMENTTERMS__c != null&&oraMeta.PAYMENTTERMS__c!=''?oraMeta.PAYMENTTERMS__c:'';
                if (invtype=='BU') {
                    inp.BillToSite=(tran.Acc__r.park__c).toUppercase();inp.InvoicingRule=oraMeta.INVOICINGRULE__c;}

            InvoiceLinesFusion.receivablesInvoiceLines recv=new InvoiceLinesFusion.receivablesInvoiceLines();

            Integer i=1; Integer j=0;Integer k=0;
            Map<String, InvoiceLinesFusion.receivablesInvoiceLines> tiMap=new Map<String, InvoiceLinesFusion.receivablesInvoiceLines>();
            list<transItm> tranlt=new list<transItm>();
            tranlt=mergeTransItm(tranLst);

            if (invtype == DM && tran.TP__c=='Refund') {
            tranlt=mergeDMTransItm(tranLst);
            }

            InvoiceLinesFusion.receivablesInvoiceLines[] arrayname = new InvoiceLinesFusion.receivablesInvoiceLines[tranlt.size()];
            for (transItm ti:tranlt) {
                if (ti.billTo != null && (ti.billTo == invtype || invtype == DM)) {
                    recv=new InvoiceLinesFusion.receivablesInvoiceLines();
                    recv.Description=ti.memoline;
                    if (tran.Srv_Code__c=='220') {recv.Description='DDA Amendments';}
                    if (tran.md__c=='Bank Guarantee' && invtype == DM && tran.Srv_Code__c == TOP_UP_CD) {recv.Description='AXS-GSO- Advance Deposit Top-up - BG to CD';}
                    recv.LineNumber=i++;
                    recv.LineAmount=ti.amount-ti.vat;
                    recv.Quantity=1;
                    recv.UnitSellingPrice=ti.amount-ti.vat;

                    /* for DM and New Cutomer onboarding , tax to be included in the line amount */
                    if (invtype == DM || (YARDI_SERVICES.contains(tran.Srv_Code__c) && !tran.RQ__r.xpmsle__c)) {
            recv.LineAmount=ti.amount;
            recv.UnitSellingPrice=ti.amount;
                    }
                    recv.MemoLine=ti.memoline;

                    if (tran.Srv_Code__c=='154' || tran.Srv_Code__c=='156') {
                            String Sector=tran.RQ__r.xps__c;
                                    if (Sector != null && Sector.contains('DIC') && Sector.contains('Offstreet')) {
                                    recv.MemoLine='AXS-DIC Off Street parking';
                                    inp.TransactionSource='AXS_TECOM';
                                    inp.TransactionType='DIC AXS Parking Fees';
                                    inp.BusinessUnit='TEF: TECOM Investments FZ';
                                    inp.BillToSite='DIC';
                                    }
                                    if (Sector != null && Sector.contains('DIC') && Sector.contains('Basement')) {
                                    recv.MemoLine='AXS-DIC Basement parking';
                                    inp.TransactionSource='AXS_TECOM';
                                    inp.TransactionType='DIC AXS Parking Fees';
                                    inp.BusinessUnit='TEF: TECOM Investments FZ';
                                    inp.BillToSite='DIC';
                                    }
                                    if (Sector != null && Sector.contains('DMC') && Sector.contains('Offstreet')) {
                                    recv.MemoLine='AXS-DMC Off Street parking';
                                    inp.TransactionSource='AXS_TECOM';
                                    inp.TransactionType='DMC AXS Parking Fees';
                                    inp.BusinessUnit='TEF: TECOM Investments FZ';
                                    inp.BillToSite='DMC';
                                    }
                                    if (Sector != null && Sector.contains('DMC') && Sector.contains('Basement')) {
                                    recv.MemoLine='AXS-DMC Basement parking';
                                    inp.TransactionSource='AXS_TECOM';
                                    inp.TransactionType='DMC AXS Parking Fees';
                                    inp.BusinessUnit='TEF: TECOM Investments FZ';
                                    inp.BillToSite='DMC';
                                    }
                                    if (Sector != null && Sector.contains('DKP') && Sector.contains('Offstreet')) {
                                    recv.MemoLine='AXS-DKP Off Street parking';
                                    inp.TransactionSource='AXS_TECOM';
                                    inp.TransactionType='TEF AXS Parking Fees';
                                    inp.BusinessUnit='TEF: TECOM Investments FZ';
                                    inp.BillToSite='DKP';
                                    }
                                    if (Sector != null && Sector.contains('DKP') && Sector.contains('Basement')) {
                                    recv.MemoLine='AXS-DKP Basement parking';
                                    inp.TransactionSource='AXS_TECOM';
                                    inp.TransactionType='TEF AXS Parking Fees';
                                    inp.BusinessUnit='TEF: TECOM Investments FZ';
                                    inp.BillToSite='DKP';
                                    }
                                    if (Sector != null && Sector.contains('DMC') && Sector.contains('Multi-Storey')) {
                                    recv.MemoLine='AXS-DMC Multistorey parking';
                                    inp.TransactionSource='AXS_TECOM';
                                    inp.TransactionType='DMC AXS Parking Fees';
                                    inp.BusinessUnit='TEF: TECOM Investments FZ';
                                    inp.BillToSite='DMC';
                                    }

                                    if (recv.MemoLine != null &&  recv.MemoLine=='AXS-INV_HUB-Paid Parking') {
                                    recv.MemoLine='AXS-INV_HUB-Paid Parking';
                                    inp.TransactionSource='AXS_IH1_IFACE';
                                    inp.TransactionType='IH1 AXS INV Parking';
                                    inp.BusinessUnit='IH1: Innovation Hub Phase 1 FZ';
                                    inp.BillToSite='INHUB-PH1';
                                    }

                    }

                    if (tran.md__c == CD && invtype == DM && tran.Srv_Code__c == TOP_UP_BG) {
                        recv.MemoLine=oraMeta.MEMOLINE__c;
                        // recv.MemoLine='AXS-GSO DUMMY- AD to BG Top-up (Internal Trf.)';

                    } if (invtype == DM && tran.Srv_Code__c == TOP_UP_CD) {
                        recv.MemoLine=oraMeta.MEMOLINE__c;
                    //  recv.MemoLine='AXS-GSO DUMMY- BG to AD Top-up (Internal Trf.)';
                    }
                    if (type == REFUND && invtype == DM) {
                        recv.MemoLine=oraMeta.MEMOLINE__c;
                    }
                    InvoiceLinesFusion.ValidationCriteria[]  valiDAr=new InvoiceLinesFusion.ValidationCriteria[1];
                    InvoiceLinesFusion.ValidationCriteria valiD=new InvoiceLinesFusion.ValidationCriteria();
                    if (BUNDLE_SERV.contains(tran.Srv_Code__c) &&  invtype != DM) {
                    //if (tran.Srv_Code__c=='216'|| tran.Srv_Code__c=='208' ||  tran.Srv_Code__c=='322' || tran.Srv_Code__c=='220') {
                        valiD.serviceName='BUNDLE SERVICES';
                        valiD.attribute1=tran.Name;
                        valiD.attribute2=null;
                        valiD.attribute3=null;

                    }else{ valiD.serviceName=null; valiD.attribute1=tran.Name; valiD.attribute2=null; valiD.attribute3=null;}
                    valiDAr[0]=valiD;
                    recv.ValidationCriteria=valiDAr;
                    /*FREELANCER, PMS, PARKING */
                    if (invtype=='BU') {
                        recv.AccountingRule=oraMeta.ACCOUNTINGRULE__c;
                        recv.RuleStartDate= String.ValueOf(transDate);
                        recv.RuleEndDate=tran.RQ__r.xled__c != null?String.ValueOf(tran.RQ__r.xled__c):String.ValueOf((transDate.addYears(1)).addDays(-1));
                        if (tran.RQ__r.xpmsle__c) {
                            recv.RuleStartDate= String.ValueOf(tran.RQ__r.xcpid__c)!=null?String.ValueOf(tran.RQ__r.xcpid__c):ti.StartDate;
                            recv.RuleEndDate=String.ValueOf(tran.RQ__r.xcped__c)!=null?String.ValueOf(tran.RQ__r.xcped__c):ti.EndDate;
                            Date sd=Date.valueOf(recv.RuleStartDate);
                            String sdt= DateTime.newInstance(sd.year(), sd.month(), sd.day()).format('dd-MMM-YYYY');
                            Date ed=Date.valueOf(recv.RuleEndDate);
                            String edt= DateTime.newInstance(ed.year(), ed.month(), ed.day()).format('dd-MMM-YYYY');
                            recv.Description= 'Partner Service Fees Renew for period from '+ sdt +' to '+edt;
                        }
                    }
                    InvoiceLinesFusion.receivablesInvoiceLineTransactionDFF dffline=new InvoiceLinesFusion.receivablesInvoiceLineTransactionDFF();
                    dffline.FLEX_Context=FLEX_Context;
                    dffline.sourceTransactionNumber=ti.tranRef;
                    dffline.sourceLineNumber=k++;
                    dffline.originalInvoiceNumber='NA';
                    dffline.supplierNumber='NA';
                    if (ti.ddaInv != null && ti.ddaInv!='') {
                        dffline.originalInvoiceNumber=ti.ddaInv;
                        dffline.supplierNumber=(String)supplierMap.get('DDA');
                    }else if (ti.yardiInv != null && ti.yardiInv!='') {
                        dffline.originalInvoiceNumber=ti.yardiInv;
                        dffline.supplierNumber=(String)supplierMap.get(tran.Acc__r.park__c != null?(tran.Acc__r.park__c).toUppercase():'DIC');
                        if (tran.YardiInv__c != null && tran.YardiInv__c!='' && (tran.YardiInv__c).toUpperCase().contains('IN5')) {
                            dffline.supplierNumber=(String)supplierMap.get('IN5');
                        }
                        if (tran.YardiInv__c != null && tran.YardiInv__c!='' && (tran.YardiInv__c).toUpperCase().contains('INNOVATION')) {
                            dffline.supplierNumber=(String)supplierMap.get('INNOVATION');
                        }
                    }
                    if (invtype == DM && tran.Srv_Code__c == TOP_UP_BG) {
                        dffline.originalInvoiceNumber='NA';
                        dffline.supplierNumber='NA';
                    }
            /* passsing cusstomer name  for DED NOC */
                    if (tran != null && tran.Srv_Code__c == DED_NOC) {
                        String accName=tran.RQ__r.xcfn__c;
                        dffline.originalInvoiceNumber=accName != null&&accName.length()<30?accName:accName.substring(0, 29);
                    }

                    if (invtype == CM) { dffline.previousInvoiceNumber=tran.op__r.Name;}
                    if (invtype == DM) { dffline.previousInvoiceNumber=tran.Name;}

                    InvoiceLinesFusion.receivablesInvoiceLineTransactionDFF[] dffArr = new InvoiceLinesFusion.receivablesInvoiceLineTransactionDFF[1];
                    dffArr[0]=dffline;
                    recv.receivablesInvoiceLineTransactionDFF=dffArr;
                    InvoiceLinesFusion.receivablesInvoiceLineTaxLines  txline=new InvoiceLinesFusion.receivablesInvoiceLineTaxLines();
                    InvoiceLinesFusion.receivablesInvoiceLineTaxLines[]  txArrline=new InvoiceLinesFusion.receivablesInvoiceLineTaxLines[1];

                    /*AP invoice tax lines not applicable */
                    if (ti.vat != 0 && ti.yardiInv == null && invtype != DM) {
                        txline.TaxRegimeCode=TAX_REGIME_CODE;
                        txline.TaxAmount=ti.vat;
                        if (invtype == CM) {txline.TaxAmount=ti.vat*-1;}
                        txline.TaxRateCode=TAX_STD;
                        txArrline[0]=txline;
                        recv.receivablesInvoiceLineTaxLines=txArrline;
                    }else  {
                        txline.TaxRegimeCode=TAX_REGIME_CODE;
                        txline.TaxRateCode=TAX_OUT_OF_SCOPE;
                        txline.TaxAmount=0;
                        txArrline[0]=txline;
                        recv.receivablesInvoiceLineTaxLines=txArrline;}
                    arrayname[j]=recv;
                    j++;
            }
            }
        inp.receivablesInvoiceLines=arrayname;
                inlf.Input=inp;
            inpJson=System.JSON.serialize(inlf);
                inpJson=inpJson.replaceall(', null', '');
        system.debug('INV Input JSON===>'+inpJson);
            }catch (Exception e) {
                system.debug(e.getStackTraceString());
            }

            return inpJson;
        }

        /* Creation of credit memo json reading data from ORAMETA
        * Negative amount lines to be passed for  Credit Memo
        */
        public static String  datatransformationCM(String tid, String invtype) {

            String inpJson;
            try{
            Map <String, ORAMETA__c> metaLookup=gTOraFusionLookup.getOraMetaLookup();
            list<g_TranItem__c> tranLst=[select id, name, itm__r.name, itm__r.xcbsd__c, itm__r.xcbed__c,
                A__c, ml__c, T__r.Name, VAT__c, DDA_Inv_no__c, yardiinv__c, Service_Name__c, itm__r.xlesd__c,
                itm__r.xleed__c, itm__r.itm__r.Bill_To__c from g_TranItem__c where T__c=:tid];
            g_tran__c tran= [Select Id, Name, STA__c, Zone__c, Srv_Code__c, RQ__r.xcfn__c, RQ__r.xled__c,
                dt__c, A__c, md__c, Acc__r.park__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Legal_Framework__c,
                TP__c, op__r.Name From g_tran__c where id=:tid and isDeleted=false][0];
            String serviceType='NA';
            // service Type
            if (tran != null && tran.Srv_Code__c == TOP_UP_CD) {serviceType=CD;}
            else {serviceType=SERVICE;}
            String brand=BRAND;
            String paymentMethod=(tran.md__c).toUpperCase();
            String type=tran.TP__c;
            String key ='CREDIT MEMO'+invtype+brand+paymentMethod;
            System.debug('===key====='+key);
            ORAMETA__c oraMeta=metaLookup.get(key.toUpperCase());
            CreditMemiLinesFusion inlf= new CreditMemiLinesFusion();
            CreditMemiLinesFusion.Input inp= new CreditMemiLinesFusion.Input();
            inp.AccountingDate='2025-09-01';//String.ValueOf(system.today());
            inp.BillToCustomerNumber=tran.Acc__r.ORACLE_PARTY_ID__c;
            inp.BillToSite=oraMeta.BillToSite__c;
            inp.BusinessUnit=oraMeta.BUSINESSUNITNAME__c;
            inp.CreditMemoCurrency=CURRENCY_CODE;
            inp.TransactionDate=String.ValueOf(system.today());
            inp.TransactionSource=oraMeta.TRANSACTION_SOURCE__c;
            inp.TransactionNumber=tran.Name;
            inp.TransactionType=oraMeta.TRANSACTION_TYPE__c;
            CreditMemiLinesFusion.receivablesCreditMemoDFF hdff=new CreditMemiLinesFusion.receivablesCreditMemoDFF();
            hdff.FLEX_Context=FLEX_Context;
        inp.receivablesCreditMemoDFF=hdff;
            CreditMemiLinesFusion.receivablesCreditMemoLines recv=new CreditMemiLinesFusion.receivablesCreditMemoLines();
            CreditMemiLinesFusion.receivablesCreditMemoLines[] arrayname = new CreditMemiLinesFusion.receivablesCreditMemoLines[tranLst.size()];
            Integer i=1; Integer j=0;
            list<transItm> tranItmLst =mergeTransItm(tranLst);

            for (transItm ti:tranItmLst) {
                    recv=new CreditMemiLinesFusion.receivablesCreditMemoLines();
                    recv.LineNumber=i++;
                    recv.LineAmountCredit=ti.Amount-ti.vat;
                    recv.LineQuantityCredit=1;
                    recv.UnitSellingPrice=ti.Amount-ti.vat;
                    recv.MemoLine=ti.memoline;
                    /*Negative amount lines for Credit Memo*/
                    recv.LineAmountCredit=((ti.Amount-ti.vat)*-1).setScale(2);
                    recv.UnitSellingPrice=(ti.Amount-ti.vat)*-1;
                    CreditMemiLinesFusion.receivablesCreditMemoLineTransactionDFF dffline=new CreditMemiLinesFusion.receivablesCreditMemoLineTransactionDFF();
                    dffline.FLEX_Context=FLEX_Context;
                    dffline.sourceTransactionNumber=ti.tranRef;
                    dffline.sourceLineNumber='1';
                    dffline.supplierNumber=oraMeta.SUPPILER__c;
                    dffline.previousInvoiceNumber=tran.op__r.Name;
                    CreditMemiLinesFusion.receivablesCreditMemoLineTransactionDFF[] dffArr = new CreditMemiLinesFusion.receivablesCreditMemoLineTransactionDFF[1];
                    dffArr[0]=dffline;
                    recv.receivablesCreditMemoLineTransactionDFF=dffArr;
                    CreditMemiLinesFusion.receivablesCreditMemoLineTaxLines  txline=new CreditMemiLinesFusion.receivablesCreditMemoLineTaxLines();
                    CreditMemiLinesFusion.receivablesCreditMemoLineTaxLines[]  txArrline=new CreditMemiLinesFusion.receivablesCreditMemoLineTaxLines[1];
                    if (ti.vat != 0) {
                        txline.TaxRegimeCode=TAX_REGIME_CODE;
                        txline.TaxAmount=ti.vat;
                        if (invtype == CM) {txline.TaxAmount=ti.vat*-1;}
                        txline.TaxRateCode=TAX_STD;
                        txArrline[0]=txline;
                        recv.receivablesCreditMemoLineTaxLines=txArrline;
                    }else {
                        txline.TaxRegimeCode=TAX_REGIME_CODE;
                        txline.TaxRateCode=TAX_OUT_OF_SCOPE;
                        txline.TaxAmount=0;
                        txArrline[0]=txline;
                        recv.receivablesCreditMemoLineTaxLines=txArrline;
                        }
                    arrayname[j]=recv;
                    j++;

            }
                    inp.receivablesCreditMemoLines=arrayname;
                    inlf.Input=inp;
                    inpJson=System.JSON.serialize(inlf);
                    inpJson=inpJson.replaceall(', null', '');
                    // system.debug('CREDIT MEMO Input Json==>'+inpJson);
            }catch (Exception e) {
                system.debug(e.getStackTraceString());
            }

            return inpJson;
        }

        /* Creation of Receipt input json reading data from ORAMETA
        *  used for normal receipt creation Dummy receipt creation
        *  Dummy Receipt creation is  used for  the cases of
        *  Refund , Customer  Deposit to Bank Grauntee and
        *  Bank Grauntee to Customer  Deposit cases
        *  Receipt Creation under AXS books
        */
        public static String datatransformationReceipt(String tid) {
            String inpJson;
            ReceiptFusion repFu=new ReceiptFusion();
            String serviceType=SERVICE_TYPE;
            String sType=STYPE;
            String brand=BRAND;
        try{
                Map <String, ORAMETA__c> metaLookup= gTOraFusionLookup.getOraMetaLookup();
                g_tran__c tran= [Select Id, Name, repush__c, pre_fix__c, STA__c, Zone__c, RQ__r.xcna__c,
                    RQ__r.xcfn__c, Service_Name__c, nt__c, Srv_Code__c, dt__c, A__c, md__c, Acc__r.park__c,
                    Acc__r.ORACLE_PARTY_ID__c, Acc__r.Legal_Framework__c, TP__c, op__r.Name, gwrf__c From g_tran__c where id=:tid and isDeleted=false][0];
                Boolean DED_NOC=tran != null && tran.Srv_Code__c == DED_NOC?true:false;
                String PAYMENT_METHOD=tran.md__c == CREDIT_OR_DEBIT?CREDIT_CARD:tran.md__c;
                serviceType=(tran.Srv_Code__c == TOP_UP_CD||tran.Srv_Code__c == TOP_UP_BG)?(tran.Srv_Code__c).toUpperCase():serviceType;
                PAYMENT_METHOD=tran.TP__c == REFUND?REFUND_PAYMENT_METHOD:PAYMENT_METHOD;
                String key =(sType+serviceType+brand+PAYMENT_METHOD).toUpperCase();
                system.debug('Key===>'+key);
                ORAMETA__c oraMeta=metaLookup.get(key);
                repFu.Amount=tran.A__c;
                repFu.CurrencyCode=CURRENCY_CODE;
                Date transDate=(tran.dt__c == null || tran.TP__c == REFUND || tran.md__c=='Bank Guarantee' || tran.md__c=='Customer Deposit')?system.today():tran.dt__c;
                repFu.DepositDate=String.ValueOf(transDate);
                repFu.GlDate=String.ValueOf(transDate);
                repFu.IssueDate=String.ValueOf(transDate);
            /*for DED  noc Company name to be passed in the comments*/
                repFu.Comments=DED_NOC?tran.RQ__r.xcfn__c:tran.nt__c;
                /* for refund to be passed for orginal transaction*/
                repFu.Comments=serviceType=='TBG' && tran.md__c=='Customer Deposit' && system.today()>tran.dt__c?'Original Transaction Date:'+tran.dt__c:'';
                repFu.Comments=tran.TP__c == REFUND && tran.op__c != null?'Service Refund to Customer Deposit against TXN No:'+tran.op__r.Name+', refund transtion date:'+tran.dt__c:repFu.Comments;
                repFu.CustomerSiteName=oraMeta.BILLTOSITE__c;
                repFu.BusinessUnitName=oraMeta.BUSINESSUNITNAME__c;
                repFu.ReceiptMethodName=oraMeta.RECEIPT_METHOD__c;
                repFu.MaturityDate='';
                repFu.FLEXContext=BRAND;
                repFu.Issuer=BRAND;
                /*for DED  NOC  will be under walkin customer*/
                repFu.CustomerAccountNumber=DED_NOC?System.Label.ORA_WALK_IN_CUSTOMER:tran.Acc__r.ORACLE_PARTY_ID__c;
                repFu.ReceiptDate=String.ValueOf(transDate);
                repFu.ReceiptNumber=tran.Name;
                if (tran.repush__c) {repFu.ReceiptNumber=tran.Name+'_'+tran.pre_fix__c;}
                repFu.AxsReference=tran.Name;
                repFu.StructuredPaymentReference=tran.gwrf__c;
                inpJson=System.JSON.serialize(repFu);
                system.debug('Receipt Input Json==>'+inpJson);
            }Catch(Exception e) {

                System.debug(e.getStackTraceString());
            }
            return inpJson;
        }

    /*  Appliction of credit memo and debit memo
        Applcation  should happen after  successful appalation of DM
    */

    public static String  CMDMApplication(String tid) {
        String inpJson;
        CMDMFuApp cmdmFu=new CMDMFuApp();
            try{
                Map <String, ORAMETA__c> metaLookup= gTOraFusionLookup.getOraMetaLookup();
                g_tran__c tran= [Select Id, CMCustomerTransactionId__c, DMTransactionNumber__c, DMCustomerTrnsactionId__c,
                    Name, STA__c, Srv_Code__c, dt__c, A__c, md__c, Acc__r.park__c, TP__c, op__r.Name,
                    gwrf__c From g_tran__c where id=:tid and isDeleted=false][0];
                String serviceType='NA';
                String brand=BRAND;
                String PAYMENT_METHOD=tran.md__c == CREDIT_OR_DEBIT?CREDIT_CARD:tran.md__c;
                String type=tran.TP__c;

                String key =(type+brand+PAYMENT_METHOD).toUpperCase();
                system.debug('key===>'+key);
                system.debug('metaLookup===>'+metaLookup);
                ORAMETA__c oraMeta=metaLookup.get(key);
                cmdmFu.CreditMemoTrxId=tran.CMCustomerTransactionId__c;
                cmdmFu.DebitMemoTrxId=tran.DMCustomerTrnsactionId__c;
                cmdmFu.AmountApplied=((tran.A__c).setScale(2));
                cmdmFu.GlDate= (Label.ORA_CMD_SkipDates == 'TRUE') ? '2023-12-31' : String.ValueOf(system.today());
                cmdmFu.ApplyDate=(Label.ORA_CMD_SkipDates == 'TRUE') ? '2023-12-31' : String.ValueOf(system.today());
                cmdmFu.BusinessUnitName=oraMeta.BUSINESSUNITNAME__c;
                cmdmFu.InvoiceLineNumber='1';
        inpJson=System.JSON.serialize(cmdmFu);
        system.debug('CM AND DM Input json===>'+inpJson);

            }catch (Exception e) {

            }
            return inpJson;
        }

        public static  list<transItm> mergeDMTransItm(list<g_TranItem__c> tranLst) {
        List<transItm> transItms=new  List<transItm>();
            try{
                transItm titm =new transItm();
                for (g_TranItem__c ti:tranLst) {

            titm.amount=titm.amount == null?((ti.A__c).setScale(2)):titm.amount+((ti.A__c).setScale(2));
            titm.vat=0;
            titm.memoline=ti.ml__c;
                        titm.ddaInv='';
                        titm.yardiInv='';
            titm.itemName=ti.Service_Name__c;
            titm.billTo=ti.itm__r.itm__r.Bill_To__c;
            titm.tranRef=ti.T__r.Name;

                }

        transItms.add(titm);

            }catch (Exception e) {}

            return transItms;
        }

        public static  list<transItm> mergeTransItm(list<g_TranItem__c> tranLst) {
            Map<String, transItm> transMap=new Map<String, transItm>();
            List<transItm> transItms=new  List<transItm>();
            try{
                transItm trnItm =new transItm();
                integer i=0;
                for (g_TranItem__c ti:tranLst) {

                    String withVatMl=ti.ml__c+'VAT';
                    if (ti.ml__c=='TEF AXS Partner Serv_Renew') {withVatMl=withVatMl+'-'+i++;
                            system.debug('withVatMl--'+withVatMl);
                                                            }
                    String withOutVatMl=ti.ml__c;
                    if (transMap.containsKey(withVatMl) && ti.VAT__c != 0) {
                        transItm  titm=transMap.get(withVatMl);
                        titm.amount=titm.amount+((ti.A__c).setScale(2));
                        titm.vat=titm.vat+ti.VAT__c;
                        titm.memoline=ti.ml__c;
                        titm.ddaInv=ti.DDA_Inv_no__c != null&&ti.DDA_Inv_no__c!=''?ti.DDA_Inv_no__c:titm.ddaInv;
                        titm.yardiInv=ti.yardiinv__c != null&&ti.yardiinv__c!=''?ti.yardiinv__c:titm.yardiInv;
                        titm.itemName=ti.Service_Name__c;
                        titm.billTo=ti.itm__r.itm__r.Bill_To__c;
                        titm.tranRef=ti.T__r.Name;
                        transMap.put(withVatMl, titm);
                    } else if (ti.VAT__c != 0) {
                        transItm  titm=new transItm();
                        titm.amount=((ti.A__c).setScale(2));
                        titm.vat=ti.VAT__c;
                        titm.memoline=ti.ml__c;
                        titm.ddaInv=ti.DDA_Inv_no__c != null&&ti.DDA_Inv_no__c!=''?ti.DDA_Inv_no__c:titm.ddaInv;
                        titm.yardiInv=ti.yardiinv__c != null&&ti.yardiinv__c!=''?ti.yardiinv__c:titm.yardiInv;
                        titm.itemName=ti.Service_Name__c;
                        titm.billTo=ti.itm__r.itm__r.Bill_To__c;
                        titm.tranRef=ti.T__r.Name;
                        titm.StartDate=String.ValueOf(ti.itm__r.xcbsd__c);
                            titm.EndDate= String.ValueOf(ti.itm__r.xcbed__c);
                        transMap.put(withVatMl, titm);
                    } else if (transMap.containsKey(withOutVatMl) && ti.VAT__c == 0) {
                        transItm  titm=transMap.get(withOutVatMl);
                        titm.amount=titm.amount+((ti.A__c).setScale(2));
                        titm.vat=titm.vat+ti.VAT__c;
                        titm.memoline=ti.ml__c;
                        titm.ddaInv=ti.DDA_Inv_no__c != null&&ti.DDA_Inv_no__c!=''?ti.DDA_Inv_no__c:titm.ddaInv;
                        titm.yardiInv=ti.yardiinv__c != null&&ti.yardiinv__c!=''?ti.yardiinv__c:titm.yardiInv;
                        titm.itemName=ti.Service_Name__c;
                        titm.billTo=ti.itm__r.itm__r.Bill_To__c;
                        titm.tranRef=ti.T__r.Name;
                        transMap.put(withOutVatMl, titm);
                        }else if (ti.VAT__c == 0) {
                        transItm  titm=new transItm();
                        titm.amount=((ti.A__c).setScale(2));
                        titm.vat=ti.VAT__c;
                        titm.memoline=ti.ml__c;
                        titm.ddaInv=ti.DDA_Inv_no__c != null&&ti.DDA_Inv_no__c!=''?ti.DDA_Inv_no__c:titm.ddaInv;
                        titm.yardiInv=ti.yardiinv__c != null&&ti.yardiinv__c!=''?ti.yardiinv__c:titm.yardiInv;
                        titm.itemName=ti.Service_Name__c;
                        titm.billTo=ti.itm__r.itm__r.Bill_To__c;
                        titm.tranRef=ti.T__r.Name;
                        transMap.put(withOutVatMl, titm);
                        }

                }

            transItms = transMap.values();
                system.debug('transItms---'+transItms);

            }catch (Exception e) {system.debug(e.getStackTraceString());}

            return transItms;
        }

            public class transItm{
                public String id{set;get;}
                public String name{set;get;}
                public Decimal amount{set;get;}
                public Decimal vat{set;get;}
                public String memoline{set;get;}
                public String ddaInv{set;get;}
                public String yardiInv{set;get;}
                public String itemName{set;get;}
                public String billTo{set;get;}
                public String tranRef{set;get;}
                public String StartDate{set;get;}
                public String EndDate{set;get;}
            }

    }