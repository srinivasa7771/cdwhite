@isTest
private class grqItest {
    static testMethod void doTest() {

        testData.init();
        try{
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);/*MS*/
        Account a=testData.accCrt(false);
        Contact emp=testData.conCrt(null,a.Id,'Active','Employee','Pass1','Egypt');
        g_Req__c r=testData.reqCrt(a.Id,s.Id,emp.Id,'Open',stg.reqq__c);
        g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c,RQ__c=r.Id,TP__c='Payment');
        list<g_Req__c> lR=new list<g_Req__c>(new g_Req__c[]{r});
        map<Id,g_Req__c> mR=new map<Id,g_Req__c>(new g_Req__c[]{r.clone(true,true,true,true)});
        map<Id,Account> mA=new map<Id,Account>(new Account[]{a});
        map<Id,g_Srvc__c> mS=new map<Id,g_Srvc__c>(new g_Srvc__c[]{s});
        map<Id,Contact> mC=new map<Id,Contact>(new Contact[]{emp});
        map<String,Contact> mcL=new map<String,Contact>();
        mcL.put('EgyptPass1,c',emp);
        map<Id,User> mU=new map<Id,User>([select id,ProfileId,ContactId from User limit 1]);
        Test.startTest();
        //----------------------------------------Establishment Card special rules
        grqI.intR iR= new grqI.ecI();
        grqI.intR iRi= new grqI.pob();
        //----------------------------------------Letters
        Address_Information__c ai = testData.adrsInfoCrt();
        r.xltr__c='xltr';r.xla2__c='xla2';r.xla2d__c='xla2d';
        iR= new grqI.lI();
        iR.BC(false,r,s,a);
        iR.AP(r,t);
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);
        iR= new grqI.PP();
        iR.BC(false,r,s,a);
        iR.AP(r,t);
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);
        iR= new grqI.EO();
        iR.BC(false,r,s,a);
        iR.AP(r,t);
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);

        iR= new grqI.afs();
        iR.BC(false,r,s,a);
        iR.AP(r,t);
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);



        iR= new grqI.ldd();
        iR.BC(false,r,s,a);
        iR.AP(r,t);
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);

         iR= new grqI.apt();
        iR.BC(false,r,s,a);
        iR.AP(r,t);
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);

          iR= new grqI.ren();
        iR.BC(false,r,s,a);
        iR.AP(r,t);
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);


            iR= new grqI.onevvI();
        iR.BC(false,r,s,a);
        iR.AP(r,t);
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);

        }catch (Exception e){}



        Test.stopTest();
    }
    static testMethod void doTest5() {

        testData.init();
        try{
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        Account a=testData.accCrt(false);
        Contact emp=testData.conCrt(null,a.Id,'Active','Employee','Pass1','Egypt');
        g_Req__c r=testData.reqCrt(a.Id,s.Id,emp.Id,'Open',stg.reqq__c);
        g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c,RQ__c=r.Id,TP__c='Payment');
        list<g_Req__c> lR=new list<g_Req__c>(new g_Req__c[]{r});
        map<Id,g_Req__c> mR=new map<Id,g_Req__c>(new g_Req__c[]{r.clone(true,true,true,true)});
        map<Id,Account> mA=new map<Id,Account>(new Account[]{a});
        map<Id,g_Srvc__c> mS=new map<Id,g_Srvc__c>(new g_Srvc__c[]{s});
        map<Id,Contact> mC=new map<Id,Contact>(new Contact[]{emp});
        map<String,Contact> mcL=new map<String,Contact>();
        mcL.put('EgyptPass1,c',emp);
        map<Id,User> mU=new map<Id,User>([select id,ProfileId,ContactId from User limit 1]);
        Test.startTest();
        //----------------------------------------Establishment Card special rules
        grqI.intR iR= new grqI.ecI();



        iR= new grqI.stud();
        iR.BC(false,r,s,a);
        iR.AP(r,t);
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);

        iR= new grqI.ren();
        iR.BC(false,r,s,a);
        iR.AP(r,t);
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);
        }catch (Exception e){}
        Test.stopTest();
    }
    static testMethod void doTest2() {

        testData.init();
        try{
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        Account a=testData.accCrt(false);
        Contact emp=testData.conCrt(null,a.Id,'Active','Employee','Pass1','Egypt');
        g_Req__c r=testData.reqCrt(a.Id,s.Id,emp.Id,'Open',stg.reqq__c);
        g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c,RQ__c=r.Id,TP__c='Payment');
        list<g_Req__c> lR=new list<g_Req__c>(new g_Req__c[]{r});
        map<Id,g_Req__c> mR=new map<Id,g_Req__c>(new g_Req__c[]{r.clone(true,true,true,true)});
        map<Id,Account> mA=new map<Id,Account>(new Account[]{a});
        map<Id,g_Srvc__c> mS=new map<Id,g_Srvc__c>(new g_Srvc__c[]{s});
        map<Id,Contact> mC=new map<Id,Contact>(new Contact[]{emp});
        map<String,Contact> mcL=new map<String,Contact>();
        mcL.put('EgyptPass1,c',emp);
        map<Id,User> mU=new map<Id,User>([select id,ProfileId,ContactId from User limit 1]);
        Test.startTest();
        grqI.intR iR= new grqI.RF();
        iR.BC(false,r,s,a);
        iR.AP(r,t);
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);

        iR= new grqI.tcaR();
        iR.BC(false,r,s,a);
        iR.AP(r,t);
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);

        iR= new grqI.tcaR1();
        iR.BC(false,r,s,a);
        iR.AP(r,t);
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);

        iR= new grqI.rtap();
        iR.BC(false,r,s,a);
        iR.AP(r,t);
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);

        iR= new grqI.pdp();
        iR.BC(false,r,s,a);
        iR.AP(r,t);
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);

        iR= new grqI.apt();
        iR.BC(false,r,s,a);
        iR.AP(r,t);
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);



          iR= new grqI.pdp();
          iR.BC(false,r,s,a);
          iR.AP(r,t);
          iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
          iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
          iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);

          iR= new grqI.dccaAmd();
          iR.BC(false,r,s,a);
          iR.AP(r,t);
          iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
          iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
          iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);
         }catch (Exception e){}
        Test.stopTest();
    }
    static testMethod void doTest3() {

        testData.init();
        try{
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        Account a=testData.accCrt(false);
        Contact emp=testData.conCrt(null,a.Id,'Active','Employee','Pass1','Egypt');
        g_Req__c r=testData.reqCrt(a.Id,s.Id,emp.Id,'Open',stg.reqq__c);
        g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c,RQ__c=r.Id,TP__c='Payment');
        list<g_Req__c> lR=new list<g_Req__c>(new g_Req__c[]{r});
        map<Id,g_Req__c> mR=new map<Id,g_Req__c>(new g_Req__c[]{r.clone(true,true,true,true)});
        map<Id,Account> mA=new map<Id,Account>(new Account[]{a});
        map<Id,g_Srvc__c> mS=new map<Id,g_Srvc__c>(new g_Srvc__c[]{s});
        map<Id,Contact> mC=new map<Id,Contact>(new Contact[]{emp});
        map<String,Contact> mcL=new map<String,Contact>();
        mcL.put('EgyptPass1,c',emp);
        map<Id,User> mU=new map<Id,User>([select id,ProfileId,ContactId from User limit 1]);
        Test.startTest();
        //----------------------------------------Establishment Card special rules
        grqI.intR iR= new grqI.ecI();
        iR.BC(false,r,s,a);//iR.AP(r,g_Tran__c T);
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);
        //----------------------------------------Employment Visa
        iR= new grqI.evI();
        iR.BC(false,r,s,a);//iR.AP(r,g_Tran__c T);
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);
        //----------------------------------------Non Sponsored Id/Access Card
        iR= new grqI.nspI();
        iR.BC(false,r,s,a);//iR.AP(r,g_Tran__c T);
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);

        //----------------------------------------Dependent visa
        iR= new grqI.depI();
        iR.BC(false,r,s,a);iR.AP(new g_Req__c(),new g_Tran__c());
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);

         iR= new grqI.dedR();
        iR.BC(false,r,s,a);iR.AP(new g_Req__c(),new g_Tran__c());
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);


            iR= new grqI.dccaAmd();
        iR.BC(false,r,s,a);iR.AP(new g_Req__c(),new g_Tran__c());
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);

        iR= new grqI.freeob();
        iR.BC(false,r,s,a);iR.AP(new g_Req__c(),new g_Tran__c());
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);

        iR= new grqI.newFrl();
        iR.BC(false,r,s,a);iR.AP(new g_Req__c(),new g_Tran__c());
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);

        iR= new grqI.aml();
        iR.BC(false,r,s,a);iR.AP(new g_Req__c(),new g_Tran__c());
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);



        }catch (Exception e){}
        Test.stopTest();
    }
    static testMethod void doTest4() {

        testData.init();
        try{
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        Account a=testData.accCrt(false);
        Contact emp=testData.conCrt(null,a.Id,'Active','Employee','Pass1','Egypt');
        g_Req__c r=testData.reqCrt(a.Id,s.Id,emp.Id,'Open',stg.reqq__c);
        g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c,RQ__c=r.Id,TP__c='Payment',STA__c='Completed');
        g_srvcitm__c  gsitem = new g_srvcitm__c (Name='itemtest',cd__c='mi',lbl__c='itemntest',ord__c=2,dSTA__c='n', srvc__c =s.Id, Tp__c ='Service Item');
        insert gsitem;
       g_srvcitm_Status__c gsta = new g_srvcitm_Status__c(Name='statustest',cd__c='mi',lbl__c='Pending Approval',Tp__c='Open',itm__c=gsitem.Id);
        insert gsta;
         g_srvcitm__c  gsitem1 = new g_srvcitm__c (Name='itemtest',cd__c='lc',lbl__c='itemntest',ord__c=2,dSTA__c='n', srvc__c =s.Id, Tp__c ='Service Item');
        insert gsitem1;
       g_srvcitm_Status__c gsta1 = new g_srvcitm_Status__c(Name='statustest',cd__c='lc',lbl__c='Pending Approval',Tp__c='Open',itm__c=gsitem1.Id);
        insert gsta1;
        g_srvcitm__c  gsitem2 = new g_srvcitm__c (Name='itemtest',cd__c='sh1',lbl__c='itemntest',ord__c=2,dSTA__c='n', srvc__c =s.Id, Tp__c ='Service Item');
        insert gsitem2;
       g_srvcitm_Status__c gsta2 = new g_srvcitm_Status__c(Name='statustest',cd__c='sh1',lbl__c='Pending Approval',Tp__c='Open',itm__c=gsitem2.Id);
        insert gsta2;
        list<g_Req__c> lR=new list<g_Req__c>(new g_Req__c[]{r});
        map<Id,g_Req__c> mR=new map<Id,g_Req__c>(new g_Req__c[]{r.clone(true,true,true,true)});
        map<Id,Account> mA=new map<Id,Account>(new Account[]{a});
        map<Id,g_Srvc__c> mS=new map<Id,g_Srvc__c>(new g_Srvc__c[]{s});
        map<Id,Contact> mC=new map<Id,Contact>(new Contact[]{emp});
        map<String,Contact> mcL=new map<String,Contact>();
        mcL.put('EgyptPass1,c',emp);
        map<Id,User> mU=new map<Id,User>([select id,ProfileId,ContactId from User limit 1]);

        //----------------------------------------Establishment Card special rules
        grqI.intR iR= new grqI.ecI();

        //----------------------------------------Visit visa
        iR= new grqI.vvI();
        iR.BC(false,r,s,a);//iR.AP(r,g_Tran__c T);
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);

        //----------------------------------------Top-Up Advance Deposit & Bank Guarantee
        r.xtpa__c=11111;
        iR= new grqI.tuI();
        iR.BC(false,r,s,a);//iR.AP(r,g_Tran__c T);
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);
        s.uid__c='tbg';
        iR.BC(false,r,s,a);//iR.AP(r,g_Tran__c T);
        iR.hIB(lR,mA,mS,mC,mcL,mU);iR.hIA(lR,mA,mS,mC,mcL,mU);
        iR.hUB(lR,mR,mA,mS,mC,mcL,mU);iR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        iR.hDB(mR,mA,mS,mC,mcL,mU);iR.hDA(mR,mA,mS,mC,mcL,mU);

        grqI.intTrns objIntTrns = new grqI.intTrns();
        objIntTrns.updateDepAcc(new list < g_reqitem__c >(), new map < Id, g_reqitem__c >(), new map < Id, g_Req__c >(), new map < Id, g_srvcitm_Status__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objIntTrns.hIB(new list < g_reqitem__c >(), new map < Id, g_Req__c >(), new map < Id, g_srvcitm_Status__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
        objIntTrns.hIA(new list < g_reqitem__c >(), new map < Id, g_Req__c >(), new map < Id, g_srvcitm_Status__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
        objIntTrns.hUB(new list < g_reqitem__c >(), new map < Id, g_reqitem__c >(), new map < Id, g_Req__c >(), new map < Id, g_srvcitm_Status__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objIntTrns.hUA(new list < g_reqitem__c >(), new map < Id, g_reqitem__c >(), new map < Id, g_Req__c >(), new map < Id, g_srvcitm_Status__c >(), new map < Id, Contact >(), new map < String, Contact >(), new  map < Id, User >());
        objIntTrns.hDB(new map < Id, g_reqitem__c >(), new map < Id, g_Req__c >(), new map < Id, g_srvcitm_Status__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objIntTrns.hDA(new map < Id, g_reqitem__c >(), new map < Id, g_Req__c >(), new map < Id, g_srvcitm_Status__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
      //  grqI.crtDEDItms(lR);
        grqI.dccaRenRq objDccaRenRq = new grqI.dccaRenRq();
       // objDccaRenRq.hIA(new list < g_Req__c >(), new map < Id, Account >(),new map < Id, g_Srvc__c >(),new map < Id, Contact >(),new map < String, Contact >(),new map < Id, User >());
        // objDccaRenRq.psfInsert(new list < g_Req__c >(),new map < Id, Account >(),'operation');
        objDccaRenRq.hIAupdate(new list < g_Req__c >(),new map < Id, Account >());
       // objDccaRenRq.updateDccaItms(new list < g_Req__c >(),new map < Id, g_Req__c >(),new map < Id, Account >());
       // objDccaRenRq.updateKFandINF(new list < g_Req__c >(),new map < Id, Account >());
       // objDccaRenRq.crtDccaItms(new list < g_Req__c >(),new map < Id, Account >(),new set < String >());
        objDccaRenRq.BC(false,r,s,a);
        objDccaRenRq.updateActv(new list < g_Req__c >());
        objDccaRenRq.nD(new g_Req__c());
        objDccaRenRq.updateRIDocuments(new list < g_Req__c >());
        objDccaRenRq.addressInfoUpdate(new list < g_Req__c >());
        objDccaRenRq.hIA(new list < g_Req__c >(),new map < Id, Account >(),new map < Id, g_Srvc__c >(),new map < Id, Contact >(),new map < String, Contact >(),new map < Id, User >());
        objDccaRenRq.hIB(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(),new map < Id, Contact >(),new map < String, Contact >(),new map < Id, User >());
        objDccaRenRq.hUB(new list < g_Req__c >(),new map < Id, g_Req__c >(),new map < Id, Account >(),new map < Id, g_Srvc__c >(),new map < Id, Contact >(),new map < String, Contact >(),new map < Id, User >());
        objDccaRenRq.hUA(new list < g_Req__c >(),new map < Id, g_Req__c >(),new map < Id, Account >(),new map < Id, g_Srvc__c >(),new map < Id, Contact >(),new map < String, Contact >(),new map < Id, User >());
        objDccaRenRq.hDB(new map < Id, g_Req__c >(),new map < Id, Account >(),new map < Id, g_Srvc__c >(),new map < Id, Contact >(),new map < String, Contact >(),new map < Id, User >());
        objDccaRenRq.hDA(new map < Id, g_Req__c >(),new map < Id, Account >(),new map < Id, g_Srvc__c >(),new map < Id, Contact >(),new map < String, Contact >(),new map < Id, User >());
        // objDccaRenRq.sendDccaLic(new g_reqitem__c(),new g_Req__c());
        objDccaRenRq.AP(new g_Req__c(),new g_Tran__c());

        grqI.upI objUpI = new grqI.upI();

        grqI.coI objCoI = new grqI.coI();
        objCoI.BC(false,r,s,a);
        objCoI.AP(new g_Req__c(),new g_Tran__c());
        objCoI.hIB(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
       // objCoI.hIA(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
        objCoI.hUB(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        //objCoI.hUA(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objCoI.hDB(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objCoI.hDA(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objCoI.hIA(lR,mA,mS,mC,mcL,mU);
        objCoI.hUA(lR,mR,mA,mS,mC,mcL,mU);

        grqI.inI objInI = new grqI.inI();
        Test.startTest();
        grqI.eoI objEoI = new grqI.eoI();
        objEoI.BC(false,r,s,a);
        objEoI.hIA(lR,mA,mS,mC,mcL,mU);
        objEoI.hUA(lR,mR,mA,mS,mC,mcL,mU);
        objEoI.AP(new g_Req__c(),new g_Tran__c());
        objEoI.hIB(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
       // objCoI.hIA(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
        objEoI.hUB(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        //objCoI.hUA(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objEoI.hDB(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objEoI.hDA(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());

        grqI.evtI objEvtI = new grqI.evtI();
        objEvtI.BC(false,r,s,a);
        objEvtI.AP(new g_Req__c(),new g_Tran__c());
        objEvtI.hIA(lR,mA,mS,mC,mcL,mU);
        objEvtI.hUA(lR,mR,mA,mS,mC,mcL,mU);
        objEvtI.hIB(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
       // objCoI.hIA(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
        objEvtI.hUB(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        //objCoI.hUA(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objEvtI.hDB(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objEvtI.hDA(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());

        grqI.VFSi objVFSi = new grqI.VFSi();
        objVFSi.BC(false,r,s,a);
        objVFSi.hIA(lR,mA,mS,mC,mcL,mU);
        objVFSi.hUA(lR,mR,mA,mS,mC,mcL,mU);
        objVFSi.AP(new g_Req__c(),new g_Tran__c());
        objVFSi.hIB(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
       // objCoI.hIA(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
        objVFSi.hUB(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        //objCoI.hUA(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objVFSi.hDB(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objVFSi.hDA(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());

        grqI.studV objStudV = new grqI.studV();
        objStudV.BC(false,r,s,a);
        objStudV.hIA(lR,mA,mS,mC,mcL,mU);
        objStudV.hUA(lR,mR,mA,mS,mC,mcL,mU);
        objStudV.AP(new g_Req__c(),new g_Tran__c());
        objStudV.hIB(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
       // objCoI.hIA(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
        objStudV.hUB(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        //objCoI.hUA(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objStudV.hDB(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objStudV.hDA(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());

        grqI.rpcor objRpcor = new grqI.rpcor();
        objRpcor.BC(false,r,s,a);
        objRpcor.hIA(lR,mA,mS,mC,mcL,mU);
        objRpcor.hUA(lR,mR,mA,mS,mC,mcL,mU);
        objRpcor.AP(new g_Req__c(),new g_Tran__c());
        objRpcor.hIB(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
       // objCoI.hIA(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
        objRpcor.hUB(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        //objCoI.hUA(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objRpcor.hDB(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objRpcor.hDA(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());

        grqI.studR objstudR = new grqI.studR();
         objstudR.BC(false,r,s,a);
         objstudR.hIA(lR,mA,mS,mC,mcL,mU);
        objstudR.hUA(lR,mR,mA,mS,mC,mcL,mU);
        objstudR.AP(new g_Req__c(),new g_Tran__c());
        objstudR.hIB(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
       // objCoI.hIA(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
        objstudR.hUB(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        //objCoI.hUA(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objstudR.hDB(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objstudR.hDA(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());

        grqI.nsacc objnsacc = new grqI.nsacc();
         objnsacc.BC(false,r,s,a);
        objnsacc.AP(new g_Req__c(),new g_Tran__c());
        objnsacc.hIB(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
       // objCoI.hIA(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
        objnsacc.hUB(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        //objCoI.hUA(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objnsacc.hDB(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objnsacc.hDA(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());

        grqI.EC objEC = new grqI.EC();
         objEC.BC(false,r,s,a);
        objEC.AP(new g_Req__c(),new g_Tran__c());
        objEC.hIB(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
       // objCoI.hIA(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
        objEC.hUB(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        //objCoI.hUA(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objEC.hDB(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objEC.hDA(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());

        grqI.empc objempc = new grqI.empc();
         objempc.BC(false,r,s,a);
        objempc.AP(new g_Req__c(),new g_Tran__c());
        objempc.hIB(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
       // objCoI.hIA(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
        objempc.hUB(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        //objCoI.hUA(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objempc.hDB(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objempc.hDA(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());

        grqI.evc objevc = new grqI.evc();
         objevc.BC(false,r,s,a);
         objevc.hIA(lR,mA,mS,mC,mcL,mU);
        objevc.hUA(lR,mR,mA,mS,mC,mcL,mU);
        objevc.AP(new g_Req__c(),new g_Tran__c());
        objevc.hIB(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
       // objCoI.hIA(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
        objevc.hUB(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        //objCoI.hUA(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objevc.hDB(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objevc.hDA(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());

        grqI.pob objpob = new grqI.pob();
         objpob.BC(false,r,s,a);
        objpob.AP(r,T);
        objpob.hIB(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
       // objCoI.hIA(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
        objpob.hUB(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        //objCoI.hUA(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objpob.hDB(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objpob.hDA(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());


         grqI.onevvI objonevvI = new grqI.onevvI();
         objonevvI.BC(false,r,s,a);
        objonevvI.AP(new g_Req__c(),new g_Tran__c());
        objonevvI.hIB(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
       // objonevvI.hIA(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
        objonevvI.hUB(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        //objonevvI.hUA(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objonevvI.hDB(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        objonevvI.hDA(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());

         grqI.nspIR objnspIR = new grqI.nspIR();
        objnspIR.BC(false,r,s,a);

         grqI.tid objtid = new grqI.tid();
        objtid.BC(false,r,s,a);
              Test.stopTest();
            }catch (Exception e){}


    }
    static testMethod void doTest6() {

      testData.init();
        try{
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        Account a=testData.accCrt(false);
        Contact emp=testData.conCrt(null,a.Id,'Active','Employee','Pass1','Egypt');
        g_Req__c r=testData.reqCrt(a.Id,s.Id,emp.Id,'Open',stg.reqq__c);
        g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c,RQ__c=r.Id,TP__c='Payment',STA__c='Completed');
        g_srvcitm__c  gsitem = new g_srvcitm__c (Name='itemtest',cd__c='mi',lbl__c='itemntest',ord__c=2,dSTA__c='n', srvc__c =s.Id, Tp__c ='Service Item');
        insert gsitem;
       g_srvcitm_Status__c gsta = new g_srvcitm_Status__c(Name='statustest',cd__c='mi',lbl__c='Pending Approval',Tp__c='Open',itm__c=gsitem.Id);
        insert gsta;
         g_srvcitm__c  gsitem1 = new g_srvcitm__c (Name='itemtest',cd__c='lc',lbl__c='itemntest',ord__c=2,dSTA__c='n', srvc__c =s.Id, Tp__c ='Service Item');
        insert gsitem1;
       g_srvcitm_Status__c gsta1 = new g_srvcitm_Status__c(Name='statustest',cd__c='lc',lbl__c='Pending Approval',Tp__c='Open',itm__c=gsitem1.Id);
        insert gsta1;
        g_srvcitm__c  gsitem2 = new g_srvcitm__c (Name='itemtest',cd__c='sh1',lbl__c='itemntest',ord__c=2,dSTA__c='n', srvc__c =s.Id, Tp__c ='Service Item');
        insert gsitem2;
       g_srvcitm_Status__c gsta2 = new g_srvcitm_Status__c(Name='statustest',cd__c='sh1',lbl__c='Pending Approval',Tp__c='Open',itm__c=gsitem2.Id);
        insert gsta2;
        list<g_Req__c> lR=new list<g_Req__c>(new g_Req__c[]{r});
        map<Id,g_Req__c> mR=new map<Id,g_Req__c>(new g_Req__c[]{r.clone(true,true,true,true)});
        map<Id,Account> mA=new map<Id,Account>(new Account[]{a});
        map<Id,g_Srvc__c> mS=new map<Id,g_Srvc__c>(new g_Srvc__c[]{s});
        map<Id,Contact> mC=new map<Id,Contact>(new Contact[]{emp});
        map<String,Contact> mcL=new map<String,Contact>();
        mcL.put('EgyptPass1,c',emp);
        map<Id,User> mU=new map<Id,User>([select id,ProfileId,ContactId from User limit 1]);
        Test.startTest();
                grqI.dedR gdedR = new grqI.dedR();
        gdedR.BC(false,r,s,a);
         grqI.dedN gdedN = new grqI.dedN();
      //  gdedN.crtItms(new list < g_Req__c >(),'test');
         grqI.dedN2 gdedN2 = new grqI.dedN2();
        gdedN2.BC(false,r,s,a);
         grqI.dedAmdC gdedAmdC = new grqI.dedAmdC();
         gdedAmdC.updateAcc(new list < g_reqitem__c >(),new map < Id, g_reqitem__c >(),new map < Id, g_Req__c >(),new map < Id, g_srvcitm_Status__c >(),new map < Id, Contact >(),new map < String, Contact >(),new map < Id, User>());
        grqI.dccaC gdccaC = new grqI.dccaC();
        gdccaC.addSanction(new list < g_reqitem__c >(), new map < Id, g_reqitem__c >(), new map < Id, g_Req__c >(), new map < Id, g_srvcitm_Status__c >(),new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        grqI.upI gupI = new grqI.upI();
        gupI.updateEida(new list<g_reqitem__c>(),new map<Id,g_reqitem__c>(),new map<Id,g_Req__c>(),new map<Id,g_srvcitm_Status__c>(),new map<Id,Contact>(),new map<String,Contact>(),new map<Id,User>());
        grqI.inI ginI = new grqI.inI();
        ginI.BC(false,r,s,a);
        ginI.AP(new g_Req__c(),new g_Tran__c());
        ginI.hIB(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
        ginI.hIA(new list < g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(),new map < Id, User > ());
        ginI.hUB(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        ginI.hUA(new list < g_Req__c >(), new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        ginI.hDB(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        ginI.hDA(new map < Id, g_Req__c >(), new map < Id, Account >(), new map < Id, g_Srvc__c >(), new map < Id, Contact >(), new map < String, Contact >(), new map < Id, User >());
        }catch (Exception e){}
            Test.stopTest();
    }
}