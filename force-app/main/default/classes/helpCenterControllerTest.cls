@isTest
public class helpCenterControllerTest {
    static testMethod void method1() {

        User u = testData.createportalUser('HeCeUsr');
        insert u;
        Contact C = [Select Id, Name, AccountId, Photo_ID__c from Contact where Id=:u.contactId];
        Account A = [Select id, on__c , onar__c , Website, vespe__c, vespex__c, vetemp__c,
            vbtemp__c , vetst__c, vespst__c, vespstx__c , vbtst__c, vev__c, mxPortalUsers__c,
            Name, Email__c, lPrk__c, Building_Name__c,
                     xcublg__c, Location__c, Location_Cluster__c, xcuzn__c , Phone, Type, Prk__c, adb__c,
                         info__c, bgnr__c, bg__c, bgc__c, bgcabsc__c, bgb__c, vctemp__c, speabsc__c, vctst__c,
                         sncNt__c, vbvv__c, lcidt1__c,
                     ec__c, ecidt__c, lctp__c, ecedt__c, lcedt__c, lcsnc__c, lcsncnt__c, Legal_Framework__c,
                         psasnc__c, psasncnt__c, lcsta__c, ecsnc__c, ecsncnt__c, lcrndt__c, cosnc__c, cosncnt__c,
                         licexdt__c, licIdt__c,
                     bgsnc__c, bgsncnt__c, snc__c, voep__c, lc__c, ORACLE_PARTY_ID__c, rpa__c, os__c, adob__c , adx__c, adc__c from Account where id=:C.AccountId ];
        list<g_Srvc__c> srList=new list<g_Srvc__c>();
        list<g_srvc_definition__c> sdList=new list<g_srvc_definition__c>();
        sdList.add(new g_srvc_definition__c(Name='testServDef1', slbl__c='Service 1', sd__c='testing ser1', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        sdList.add(new g_srvc_definition__c(Name='testServDef2', slbl__c='Service 2', sd__c='testing ser2', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        sdList.add(new g_srvc_definition__c(Name='testServDef3', slbl__c='Service 3', sd__c='testing ser3', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        sdList.add(new g_srvc_definition__c(Name='testServDef4', slbl__c='Service 4', sd__c='testing ser4', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        sdList.add(new g_srvc_definition__c(Name='testServDef5', slbl__c='Service 5', sd__c='testing ser5', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        sdList.add(new g_srvc_definition__c(Name='testServDef6', slbl__c='Service 6', sd__c='testing ser6', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        sdList.add(new g_srvc_definition__c(Name='testServDef7', slbl__c='Service 7', sd__c='testing ser7', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        sdList.add(new g_srvc_definition__c(Name='testServDef8', slbl__c='Service 8', sd__c='testing ser8', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        sdList.add(new g_srvc_definition__c(Name='testServDef9', slbl__c='Service 9', sd__c='testing ser9', docslbl__c='doc1;doc2;doc3;', ptype__c='normal;express;'));
        insert sdList;

        g_srvc_settings__c ssetting = testData.stgCrt();

        srList.add(new g_Srvc__c(Name='testServ1', sdg__c=[Select Id, Name from g_srvc_definition__c where Name='testServDef1'].Id, lbl__c='Service 1', payMd__c='Cash;Credit Card;',
                                 Fee_Structure__c='fee1;fee2;fee3;', Service_Group__c='EMPLOYEE / STUDENT SERVICES', Sub_Category__c='LETTERS & NOCs', AccTp__c='Customer - External;',
                                stg__c=ssetting.id, uid__c='te1', actv__c=true));
        srList.add(new g_Srvc__c(Name='testServ2', sdg__c=[Select Id, Name from g_srvc_definition__c where Name='testServDef2'].Id, lbl__c='Service 2', payMd__c='Cash;Credit Card;',
                                 Fee_Structure__c='fee1;fee2;fee3;', Service_Group__c='VISAS AND IMMIGRATION', Sub_Category__c='NEW', AccTp__c='Customer - External;',
                                stg__c=ssetting.id, uid__c='te2', actv__c=true));
        srList.add(new g_Srvc__c(Name='testServ3', sdg__c=[Select Id, Name from g_srvc_definition__c where Name='testServDef3'].Id, lbl__c='Service 3', payMd__c='Cash;Credit Card;',
                                 Fee_Structure__c='fee1;fee2;fee3;', Service_Group__c='COMPANY SERVICES', Sub_Category__c='NEW', AccTp__c='Customer - External;',
                                stg__c=ssetting.id, uid__c='te3', actv__c=true));
        srList.add(new g_Srvc__c(Name='testServ4', sdg__c=[Select Id, Name from g_srvc_definition__c where Name='testServDef4'].Id, lbl__c='Service 4', payMd__c='Cash;Credit Card;',
                                 Fee_Structure__c='fee1;fee2;fee3;', Service_Group__c='OTHER SERVICES', Sub_Category__c='TRANSFER', AccTp__c='Customer - External;',
                                stg__c=ssetting.id, uid__c='te4', actv__c=true));
        srList.add(new g_Srvc__c(Name='testServ5', sdg__c=[Select Id, Name from g_srvc_definition__c where Name='testServDef5'].Id, lbl__c='Service 5', payMd__c='Cash;Credit Card;',
                                 Fee_Structure__c='fee1;fee2;fee3;', Service_Group__c='EMPLOYEE / STUDENT SERVICES', Sub_Category__c='RENEW', AccTp__c='Customer - External;',
                                stg__c=ssetting.id, uid__c='te5', actv__c=true));
        srList.add(new g_Srvc__c(Name='testServ6', sdg__c=[Select Id, Name from g_srvc_definition__c where Name='testServDef6'].Id, lbl__c='Service 6', payMd__c='Cash;Credit Card;',
                                 Fee_Structure__c='fee1;fee2;fee3;', Service_Group__c='VISAS AND IMMIGRATION', Sub_Category__c='TRANSFER', AccTp__c='Customer - External;',
                                stg__c=ssetting.id, uid__c='te6', actv__c=true));
        srList.add(new g_Srvc__c(Name='testServ7', sdg__c=[Select Id, Name from g_srvc_definition__c where Name='testServDef7'].Id, lbl__c='Service 7', payMd__c='Cash;Credit Card;',
                                 Fee_Structure__c='fee1;fee2;fee3;', Service_Group__c='COMPANY SERVICES', Sub_Category__c='DEPOSIT & PAYMENTS', AccTp__c='Customer - External;',
                                stg__c=ssetting.id, uid__c='te7', actv__c=true));
        //srList.add(new g_Srvc__c(Name='testServ8', sdg__c=[Select Id, Name from g_srvc_definition__c where Name='testServDef8'].Id, lbl__c='Service 8', payMd__c='Cash;Credit Card;',
                                 //Fee_Structure__c='fee1;fee2;fee3;', Service_Group__c='OTHER SERVICES', Sub_Category__c='DEPOSIT & PAYMENTS', AccTp__c='Customer - External;', NotForServCatalogue__c=false,
                                //stg__c=ssetting.id, uid__c='te8'));
        //srList.add(new g_Srvc__c(Name='testServ9', sdg__c=[Select Id, Name from g_srvc_definition__c where Name='testServDef9'].Id, lbl__c='Service 9', payMd__c='Cash;Credit Card;',
                                 //Fee_Structure__c='fee1;fee2;fee3;', Service_Group__c='EMPLOYEE / STUDENT SERVICES', Sub_Category__c='AMEND', AccTp__c='Customer - External;', NotForServCatalogue__c=false,
                                //stg__c=ssetting.id, uid__c='te9'));
        insert srList;
        System.debug('srList======='+srList);
        list<Glossary__c> gList=new list<Glossary__c>();
        gList.add(new Glossary__c(Label__c='aGloss1', Definition__c='Glossary Defination a'));
        gList.add(new Glossary__c(Label__c='bGloss1', Definition__c='Glossary Defination b'));
        gList.add(new Glossary__c(Label__c='cGloss1', Definition__c='Glossary Defination c'));
        gList.add(new Glossary__c(Label__c='dGloss1', Definition__c='Glossary Defination d'));
        gList.add(new Glossary__c(Label__c='eGloss1', Definition__c='Glossary Defination e'));
        gList.add(new Glossary__c(Label__c='fGloss1', Definition__c='Glossary Defination f'));
        gList.add(new Glossary__c(Label__c='gGloss1', Definition__c='Glossary Defination g'));
        insert gList;

        list<FAQ__kav> faqList=new list<FAQ__kav>();
        faqList.add(new FAQ__kav(Details__c='FAQ detail 1', Summary='Summary1', Title='Summary1', Header__c='EMPLOYEE SERVICES', Sub_Header__c='', ValidationStatus='Validated', IsVisibleInCsp=true,
                                 IsVisibleInPkb=true, IsVisibleInPrm=true, Language='en_US', UrlName='Summary1'));
        faqList.add(new FAQ__kav(Details__c='FAQ detail 2', Summary='Summary2',
            Title='Summary2', Header__c='VISAS AND IMMIGRATION', Sub_Header__c='NEW',
            ValidationStatus='Validated', IsVisibleInCsp=true,
                                 IsVisibleInPkb=true, IsVisibleInPrm=true, Language='en_US', UrlName='Summary2'));
        faqList.add(new FAQ__kav(Details__c='FAQ detail 3', Summary='Summary3',
            Title='Summary3', Header__c='VISAS AND IMMIGRATION', Sub_Header__c='TRANSFER',
            ValidationStatus='Validated', IsVisibleInCsp=true,
                                 IsVisibleInPkb=true, IsVisibleInPrm=true, Language='en_US', UrlName='Summary3'));
        faqList.add(new FAQ__kav(Details__c='FAQ detail 4', Summary='Summary4', Title='Summary4', Header__c='COMPANY SERVICES', Sub_Header__c='', ValidationStatus='Validated', IsVisibleInCsp=true,
                                 IsVisibleInPkb=true, IsVisibleInPrm=true, Language='en_US', UrlName='Summary4'));
        faqList.add(new FAQ__kav(Details__c='FAQ detail 5', Summary='Summary5', Title='Summary5', Header__c='COMPANY SERVICES', Sub_Header__c='', ValidationStatus='Validated', IsVisibleInCsp=true,
                                 IsVisibleInPkb=true, IsVisibleInPrm=true, Language='en_US', UrlName='Summary5'));
        faqList.add(new FAQ__kav(Details__c='FAQ detail 6', Summary='Summary6', Title='Summary6', Header__c='OTHER SERVICES', Sub_Header__c='', ValidationStatus='Validated', IsVisibleInCsp=true,
                                 IsVisibleInPkb=true, IsVisibleInPrm=true, Language='en_US', UrlName='Summary6'));
        faqList.add(new FAQ__kav(Details__c='FAQ detail 7', Summary='Summary7', Title='Summary7', Header__c='GENERAL INFORMATION', Sub_Header__c='', ValidationStatus='Validated', IsVisibleInCsp=true,
                                 IsVisibleInPkb=true, IsVisibleInPrm=true, Language='en_US', UrlName='Summary7'));
        insert faqList;
       /* for (FAQ__kav faq: faqList) {
            faq__kav f1 = [Select Id, KnowledgeArticleId from faq__kav where id=:faq.Id ];
                KbManagement.PublishingService.publishArticle(f1.KnowledgeArticleId, true);
        }*/

        Test.startTest();
        System.runAs(u) {
        helpCenterController hc = new helpCenterController();
            //PageReference scPage = Page.serviceCatalogue;
            PageReference scPage = new PageReference('/apex/serviceCatalogue');
            scPage.getParameters().put('contentId1', '1');
            scPage.getParameters().put('contentId2', '1');
            scPage.getParameters().put('contentId3', '1');
            Test.setCurrentPage(scPage);
            hc.serviceData();
            hc.getAllvalues();
            hc.onGlossClick();
            //PageReference hfPage = Page.helpFAQ;
            PageReference hfPage = new PageReference('/apex/helpFAQ');
            hfPage.getParameters().put('contentId1', '1');
            hfPage.getParameters().put('contentId2', '1');
            hfPage.getParameters().put('dataVal1', 'All');
            Test.setCurrentPage(hfPage);
            hc.filterVal='All';
            hc.searchFAQ();
            //hc.onFAQCatChange();
        }
        Test.stopTest();

    }
}