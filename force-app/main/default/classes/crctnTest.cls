@isTest
private class crctnTest {

    static testMethod void doTest() {
        boolean blV;String sV;
        Test.startTest();
            testData.init();
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s = new g_Srvc__c(Name='Srvc', lbl__c='Srvc', stg__c=stg.id, uid__c='xxx',
                actv__c=true, ckgsnc__c=true, Prk__c='Dubai Internet City', AccTp__c='Customer - External',
                ConRol__c='Employee', ConSTA__c='Active', payMd__c='Customer Deposit; Cash; Credit / Debit Card',
                Category__c='Employees Services', Sub_Category__c='Renewal Visa', Milestone_Stage__c='Ep;Medical;Rp;',
                Milestone_SLA__c='10;2;6');
            insert s;
            list<g_srvcitm__c> itms = new list<g_srvcitm__c>();
            itms.add(new g_srvcitm__c(srvc__c=s.Id, dSTA__c='n', slaN__c=4,
                slaXP__c=2, ord__c=1, Tp__c='Service Item', cd__c='rp', Name='rp',
                lbl__c='rp', Req__c=true, aln__c=true, mxcnt__c=1, rv__c=true,
                prcEdt__c=false, DscApp__c=true, EXP__c=true, KF__c=0, scN__c=10,
                cN__c=5, smN__c=1, spChN__c=1, scXP__c=1, cXP__c=1, smXP__c=1,
                spChXP__c=1, xf__c='xf__c;xfid__c;xfed__c;xrp__c;xrpid__c;xrped__c;xui__c;xr__c;xcmbso__c;xcmbs__c;xcmao__c;xcma__c;xcmoao__c;xcmoa__c;xcmtao__c;xcmta__c;xef__c;'));
            itms.add(new g_srvcitm__c(srvc__c=s.Id, dSTA__c='n', slaN__c=4,
                slaXP__c=2, ord__c=2, Tp__c='Service Item', cd__c='md', Name='md',
                lbl__c='md', Req__c=true, aln__c=true, mxcnt__c=1, rv__c=false,
                prcEdt__c=false, DscApp__c=true, EXP__c=false, KF__c=0, scN__c=10,
                cN__c=5, smN__c=1, spChN__c=1, scXP__c=1, cXP__c=1, smXP__c=1,
                spChXP__c=1, xf__c='xf__c;xmid__c;xmed__c;xef__c;'));
            insert itms;
            list<g_srvcitm_Status__c> sta = new list<g_srvcitm_Status__c>();
            for (g_srvcitm__c i:itms) {
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c='EP',
                slaa__c='Standard', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='n', name='n', lbl__c='n', Tp__c='Open', rqSTA__c='',
                clm__c=false, clmA__c=0, rfnd__c=false, rfndA__c=0, Shift_At__c='Payment',
                Shift_Items__c='rp;md;'));
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c='EP',
                slaa__c='Completed', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='ook', name='ook', lbl__c='ook', Tp__c='Completed',
                rqSTA__c='', clm__c=false, clmA__c=0, rfnd__c=false, rfndA__c=0,
                Shift_At__c='Payment', Shift_Items__c='rp;md;'));
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c = 'Medical',
                slaa__c='Parallel', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='c', name='c', lbl__c='c', Tp__c='Cancelled',
                rqSTA__c='Cancelled', clm__c=true, clmA__c=1, rfnd__c=true, rfndA__c=1,
                Shift_At__c='Payment', Shift_Items__c='rp;md;'));
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c='RP',
                slaa__c='Standard', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='ok', name='ok', lbl__c='ok', Tp__c='Completed',
                rqSTA__c='Completed', clm__c=false, clmA__c=0, rfnd__c=false,
                rfndA__c=0, Shift_At__c='Payment', Shift_Items__c='rp;md;'));
           }
           insert sta;
           g_srvcitm_Status__c sts =  [select id, next_status__c from g_srvcitm_Status__c where name = 'n' limit 1];
           sts.next_status__c = sta[1].id;
           sts.staown__c = 'Customer';
           update sts;
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
           // g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
            g_Req__c r = new g_Req__c(Acc__c=a.Id, srvc__c=s.Id, Con__c=emp.Id, STA__c='Open', xcnc__c='Egypt', xcp__c='Pass1');insert r;
            list<g_reqitem__c> ritms = new list<g_reqitem__c>();
            list<g_srvcitm_Status__c> STAs=[select id, cd__c, statype__c, slaa__c, Milestone__c,
                itm__r.cd__c, Name, lbl__c, Tp__c, rqSTA__c, rc__c, slaN__c, slaXP__c, noEXP__c from g_srvcitm_Status__c where itm__r.srvc__c=:s.Id and itm__r.actv__c = true and isDeleted = false];
           for (g_srvcitm__c si:[Select Id, cd__c, Stage__c, Name, lbl__c, Tp__c, xf__c, Req__c,
               rv__c, aln__c, mxcnt__c, dSTA__c, prcEdt__c, DscApp__c, EXP__c, KF__c, cN__c, scN__c,
               smN__c, spChN__c, cXP__c, scXP__c, smXP__c, spChXP__c, slaN__c, slaXP__c From  g_srvcitm__c where actv__c=true and IsDeleted=false and srvc__c=:s.Id]) {
            g_reqitem__c i = new g_reqitem__c(Name=si.Name, xcdocs__c = 'Attested Degree Certificate;',
                itm__c=si.id, RQ__c=r.Id, m__c=null, exp__c=false, rv__c=si.rv__c, vSTA__c=si.rv__c?'Requires Verification':'Verified',
                slaN__c=4, slaXP__c=2, DscApp__c=si.DscApp__c, KF__c=si.KF__c, cN__c=si.cN__c, cXP__c=si.cXP__c,
                smN__c=si.smN__c, smXP__c=si.smXP__c, scN__c=0, scXP__c=0, dtiacls__c=Datetime.now(),
                dtsc__c=Datetime.now());
            for (g_srvcitm_Status__c iSTA:STAs) {if (i.itm__c == iSTA.itm__c) {i.STA__c=iSTA.id;break;}}
            ritms.add(i);
          }
         insert ritms;

         r=(g_Req__c)Database.query(stg.reqq__c+' where id=\'' + String.escapeSingleQuotes(String.valueOf(r.Id)) + '\' and isDeleted = false');
          g_reqDoc__c rdoc = new g_reqDoc__c(RQ__c = r.id, name = 'Attested Degree Certificate');
          insert rdoc;
          g_reqitemDoc__c ridoc = new g_reqitemDoc__c(name='Attested Degree Certificate', lbl__c='Attested Degree Certificate', reqDoc__c=rdoc.id, reqItm__c=ritms[0].id);
          insert ridoc;
            Attachment att = new Attachment(ParentId =r.Id, Name='Attested Degree Certificate', Body=Blob.valueOf('Test Data')); insert att;
            att = [Select Id, Name, CreatedBy.ProfileId, CreatedById From Attachment where id=:att.Id];
            crctn.D d = new crctn.D(new g_reqDoc__c());d.Doc=d.Doc;d.VF=d.VF;d.reqAts=false;blV=d.cnUp;d.Ats=d.Ats;d.Info=d.Info;
            crctn.Attach atc = new crctn.Attach(att);atc.At=atc.At;blV=atc.crtbyPU;d.addAttachments(new Attachment[]{att});
            crctn ctrl = new crctn();
            ctrl.docName = 'Personal Photo';
            ctrl.imageBase64 = 'safdsdf';
            ctrl.usrComments = 'test comments';
            ctrl.reqDocId = rdoc.id;
            ctrl.setrq(r);
            ctrl.getrq();
            ctrl.init();
            ctrl.submitCorrection();
            ctrl.submitPayment();
            ctrl.getSanctions();
            ctrl.saveAttachment();
            ctrl.deleteAttachment();
        Test.stopTest();

    }
  }