public class displayLetterCtl{
    
    
    public g_Req__c rq{get;set;}
    public String urlLetter{get;set;}
    //boolean chkflag {get;set;}
    
    public boolean displayflag{get;set;}
    
    //*** ------- Initialization --------------------------------------------------------------------------------
    public displayLetterCtl(ApexPages.StandardController c){
        rq=(g_Req__c)c.getRecord();
        system.debug('JJ'+rq);
        displayflag=false;
        init();
    }
    
    public void init(){
        system.debug('JJ inside init');
        List<Attachment> attId    =[SELECT id FROM Attachment WHERE ParentID =: rq.Id limit 1]; 
        system.debug('JJ inside attId ' +attId);
        if(attId!=null && attId.size()>0){
            displayflag=true;
            urlLetter= URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.FileDownload?file='+attId[0].id;
        }
        
    }
    
}