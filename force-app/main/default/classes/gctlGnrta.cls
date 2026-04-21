public class gctlGnrta {
    
    public String paidP {get;set;}public String freeP {get;set;}public String srvc {get;set;}
    
    public gctlGnrta(){
        srvc = ApexPages.currentPage().getParameters().get('srvc');paidP = ApexPages.currentPage().getParameters().get('pp');freeP = ApexPages.currentPage().getParameters().get('fp');
    }
    
}