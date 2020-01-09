/** 
* File Name: CaseTest.apxc
* Description: performs tests on all potential scenarios around the Case sObject
* @author:     Ted Pincas [testing git]
* Modification Log 
* ========================================================================================= 
* Ver Date          Author              Modification 
* --- ----------    ------              -------------
* 01 13/12/2019     Ted Pincas          Creation of Test Class and its scenarios
* =========================================================================================
**/
public class Utilities {

    // ------------------------------------------------------------------------------------
    // Method's name: cloneRecords();
    // Description:     
    // ------------------------------------------------------------------------------------   
    public static List<sObject> cloneRecords(List<sObject> recordsLst){
        List<sObject> clonedrecords = new List<sObject>();
        for(sObject eachObjToBeCloned : recordsLst){
            sObject eachClonedRecord = eachObjToBeCloned.clone(false, false, false, false);
            clonedrecords.add(eachClonedRecord);
        }
		System.debug('Lista de registros clonados antes de retornarlos: '+clonedrecords);        
        return clonedrecords;
    } 
    
    // ------------------------------------------------------------------------------------
    // Method's name: getAllFieldsForSObject(Id recordId);
    // Description:     
    // ------------------------------------------------------------------------------------  
    public static String getAllFieldsForSObject(Id recordId){
        String fieldNames;
        //fetch all columns of that record here
        System.debug('getting all fields for the sobject');
     
        return fieldNames;
    }  
    // ------------------------------------------------------------------------------------
    // Method's name: removeDuplicatesFromList();
    // Description:     
    // ------------------------------------------------------------------------------------ 
    public static List<Case> removeDuplicatesFromList(List<Case> myInboundList){
        Set<Case> mySetWithoutDupes = new Set<Case>();
		List<Case> myResultingList = new List<Case>(); 
        mySetWithoutDupes.addAll(myInboundList);
        myResultingList.addAll(mySetWithoutDupes);
        return myResultingList;
    } 
}