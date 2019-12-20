/** 
* File Name:   caseTrigger.apxt
* Description: Drives the logic based on whether the trigger needs to be before insert,
*              after insert, before update, after update, before delete or after delete. 
* @author:     Ted Pincas
* Modification Log 
* ========================================================================================= 
* Ver Date          Author              Modification 
* --- ----------    ------              -------------
* 01 27/04/2019     Ted Pincas          Creation
* 02 16/11/2019		Ted Pincas			Refactoring this trigger by leveraging a Switch
* ========================================================================================= 
**/
trigger caseTrigger on Case (
    // before insert,
    // before update,
    // before delete,
    after insert,
    after update,
    after delete
) { if(CaseTriggerHandler.isFirstTime || Test.isRunningTest()){
    CaseTriggerHandler cthandler = new CaseTriggerHandler(Trigger.New, Trigger.oldmap);
    
    Switch on Trigger.operationType{
        When BEFORE_INSERT {
            
        }
        
        When BEFORE_UPDATE {
            
        }
        
        When BEFORE_DELETE {
            
        }
        
        When AFTER_INSERT { 
            CaseTriggerHandler.isFirstTime = false;
            cthandler.afterInsert();
        }
        
        When AFTER_UPDATE {
            CaseTriggerHandler.isFirstTime = false;
            cthandler.afterUpdate();
        }
        
        When AFTER_DELETE {
            CaseTriggerHandler.isFirstTime = false;
            cthandler.afterDelete(); 
            
        }
    }
}
   System.debug('################################################################################');
  }