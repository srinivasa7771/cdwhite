@isTest(SeeAllData=false)
public class SegmentsActivitiesControllerTest {

    @testSetup
    static void setup() {
        testData.init();/*MS*/
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        //gStg__c crtstng = testData.createSetting('test', 'testvalue');

    }

    // ApexPages.currentPage().getParameters().put('id', rq.Id);
    static testmethod void test1() {

        g_srvc_definition__c sd= new g_srvc_definition__c(Name='test', ptype__c='Normal:10 Days;Express:3 Days;',
            cv__c='NewVisa', sd__c='Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>',
            docslbl__c='Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        system.debug('srvcLst----'+srvcLst);
        Contact c = new Contact(Id=conLst[0].Id, mbs__c=500000, eidid__c='784198774283257', eidedt__c=system.today().addyears(3));
        update c;
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        Contact emp=testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        system.debug('conLst[0].Id'+conLst[0].Id);
        g_Req__c r=testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', srvcsettings[0].reqq__c);
        system.Debug('request r'+r);

        String selectedActs = '[{"name":"Environment", "segId":"a08D000000Zb70DIAR", "allowed":"5", "price":"15000.00", "SegActivities":[{"name":"Research &amp; Development", "actId":"a12D0000001YygKIAS", "price":"15000.00", "docs":[]}]}, {"name":"Specialty Supplies", "segId":"a08D000000Zb6zZIAR", "allowed":"5", "price":"15000.00", "SegActivities":[{"name":"Research &amp; Development", "actId":"a12D0000001Yyd1IAC", "price":"15000.00", "docs":[]}]}]';
        r.xadtx2__c = selectedActs;
        update r;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new mockGetActivities());
        ApexPages.currentPage().getParameters().put('id', r.Id);
        SegmentsActivitiesController sa = new SegmentsActivitiesController();
      sa.paymentMethods=sa.paymentMethods;
    sa.serviceItemList=sa.serviceItemList;
    sa.allSegments=sa.allSegments;
        sa.recSeg=sa.recSeg;
        sa.moreSegments();
        ApexPages.currentPage().getParameters().put('segmentActivityJson', selectedActs);
        sa.updateleaseJsonStr();
        sa.updateRequest();

        List<g_srvcitm__c> lstItem = [SELECT id, name FROM g_srvcitm__c limit 1];
        Set<Id> setIds = new Set<Id>(); setIds.add(lstItem[0].id);

        ApexPages.currentPage().getParameters().put('srvItemIds', JSON.serializePretty(setIds));

        sa.createRequestItems();
        sa.confirm();
        sa.getDedActsJson();
        Test.stopTest();
    }

    public class mockGetActivities implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String dummyResp = '[{"key1":"46956", "city":"dubai", "value":"Telnet Communications Tech LLC", "product_type":"1", "id":"5584", "name_slug":"telnet-communications-tech-llc"}]';
            //String dummyResp ='[{"segmentId":"a089000000SmL2bAAF", "Segment":"Media and Marketing Consultancy", "Price":15000.00, "Label":"Media and Marketing Consultancy", "Description":null, "Brand":"Dubai Studio City", "AllowedActivites":1, "Activities":[{"Price":15000.00, "Name":"Media and Marketing Consultancy", "Label":"Media and Marketing Consultancy", "isRelatedtoTitles":false, "isRelatedtoChannel":false, "doclist":[""], "Description":"Companies providing media and marketing consultancy services to other firms, including \r\nplanning,  brand  strategies,  marketing  strategies,  designing  marketing  promotions, \r\ncampaigns development and determining sales process.", "BusinessUnit":"Dubai Studio City", "activityId":"a1290000007ysr9AAA"}]}, {"segmentId":"a089000000SmL2gAAF", "Segment":"Digital Content Creation", "Price":15000.00, "Label":"Digital Content Creation", "Description":null, "Brand":"Dubai Studio City", "AllowedActivites":2, "Activities":[{"Price":15000.00, "Name":"Animation", "Label":"Animation", "isRelatedtoTitles":false, "isRelatedtoChannel":false, "doclist":[""], "Description":"Companies involved in the creation of animated content, such as animated films, \ndocumentaries, TV shows and TV commercials.", "BusinessUnit":"Dubai Studio City", "activityId":"a1290000007ysrUAAQ"}, {"Price":15000.00, "Name":"Video Games", "Label":"Video Games", "isRelatedtoTitles":false, "isRelatedtoChannel":false, "doclist":[""], "Description":"Companies specialised in developing and implementing the art or process of preparing \nvideo games, and/or electronic or computerised game played by manipulating images on a \nvideo display or television screen.", "BusinessUnit":"Dubai Studio City", "activityId":"a1290000007ysrTAAQ"}]}, {"segmentId":"a08D000000Zb6yvIAB", "Segment":"Property Management Services", "Price":15000.00, "Label":"Property Management Services", "Description":"Branches of existing companies or other licensed commercial entities or companies incorporated\nin the Free Zone to manage commercial and residential property located within the Free Zone\nonly.", "Brand":"Dubai Studio City", "AllowedActivites":1, "Activities":[{"Price":15000.00, "Name":"Property Management", "Label":"Property Management", "isRelatedtoTitles":false, "isRelatedtoChannel":false, "doclist":[{"isMandatory":true, "docName":"A valid No Objection Certificate from the Real Estate Regulatory Agency (RERA)"}], "Description":"Branches of existing companies or other licensed commercial entities or companies\nincorporated in the Free Zone to manage the leasing and administration of commercial and\nresidential property located within the Free Zone only", "BusinessUnit":"Dubai Studio City", "activityId":"a12D0000001YyYUIA0"}, {"Price":15000.00, "Name":"Commercial Developer", "Label":"Commercial Developer", "isRelatedtoTitles":false, "isRelatedtoChannel":false, "doclist":[{"isMandatory":true, "docName":"Title Deed / Usufruct Title Deed issued by the Dubai Land Department"}], "Description":"Branches of existing companies or other licensed commercial entities or companies\nincorporated in the Free Zone that has purchased or leased land with the intention of\nconstructing premises for commercial purpose.  This will also allow the Licensee to\ncollaborate with the Master Developer under the terms of the Master Developers Property\nManagement and Leasing Agreement - PMLA)", "BusinessUnit":"Dubai Studio City", "activityId":"a12D0000001YyYSIA0"}, {"Price":15000.00, "Name":"Administration office", "Label":"Administration office", "isRelatedtoTitles":false, "isRelatedtoChannel":false, "doclist":[{"isMandatory":true, "docName":"Copy of Contract signed between Building Developer and Property Management"}, {"isMandatory":true, "docName":"Copy of Contract signed between Property Management and Leasing Company"}, {"isMandatory":true, "docName":"Property Management Services Guideline"}, {"isMandatory":true, "docName":"Original Title Deed issued by Dubai Land Department for verification"}, {"isMandatory":true, "docName":"A copy of Certificate from Center for Healthcare Planning and Quality"}], "Description":"Branches of existing companies or other licensed commercial entities or companies\nincorporated in the Free Zone to manage the construction process of the Licensees\npremises in the Free Zone.  An Administration Office activity licence does not otherwise\npermit the Licensee to undertake any business activity from the Free Zone", "BusinessUnit":"Dubai Studio City", "activityId":"a12D0000001YyYQIA0"}, {"Price":15000.00, "Name":"Residential Developer", "Label":"Residential Developer", "isRelatedtoTitles":false, "isRelatedtoChannel":false, "doclist":[{"isMandatory":true, "docName":"Title Deed / Usufruct Title Deed issued by the Dubai Land Department"}], "Description":"Branches of existing companies or other licensed commercial entities or companies\nincorporated in the Free Zone that has purchased or leased land with the intention of\nconstructing a building for residential purpose.", "BusinessUnit":"Dubai Studio City", "activityId":"a12D0000001YzruIAC"}]}, {"segmentId":"a08D000000Zb6z3IAB", "Segment":"Film Support Services", "Price":15000.00, "Label":"Film Support Services", "Description":null, "Brand":"Dubai Studio City", "AllowedActivites":2, "Activities":[{"Price":15000.00, "Name":"Talent Management", "Label":"Talent Management", "isRelatedtoTitles":false, "isRelatedtoChannel":false, "doclist":[""], "Description":"Companies that represent talent and involved in sourcing talent for film, television, media\nand entertainment industry.  Talent shall include:  actors, directors, musicians, singers, \ndancers, script writers, TV/radio presenters, set and stage designers, art directors, visual\nartists, performing artists, recording artists and literary artists.", "BusinessUnit":"Dubai Studio City", "activityId":"a12D0000001YyZYIA0"}, {"Price":15000.00, "Name":"Casting Agency", "Label":"Casting Agency", "isRelatedtoTitles":false, "isRelatedtoChannel":false, "doclist":[""], "Description":"Companies  involved  in  sourcing  talent  for  the  media  entertainment  industry  and\nproviding services for hiring actors.", "BusinessUnit":"Dubai Studio City", "activityId":"a12D0000001YyZXIA0"}]}]';
            res.setBody(dummyResp);
            res.setStatusCode(200);
            return res;
        }
    }
}