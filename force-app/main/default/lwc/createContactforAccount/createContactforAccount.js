import { LightningElement } from 'lwc';
import {createContact} from 'lightning/uiRecordApi';
import {showToastMessage} from 'lightning/platformShowToastEvent';


export default class CreateContactforAccount extends LightningElement {
    
    contact_Id='';

    //CREATE CONTACT FOR ACCOUNT
    handleCreate(){
        var currentDate = new Date();
        var today = ''+currentDate.getDate()+'/'+currentDate.getMonth()+'/'+currentDate.getFullYear()+' @ '+currentDate.getHours()+':'+currentDate.getMinutes()+':'+currentDate.getSeconds();
        console.log('TODAY => '+today);
        const fields={};
        fields['LastName']='LWC '+today;
        fields['email']=''+currentDate.getDate()+''+currentDate.getMonth()+''+currentDate.getFullYear();''+currentDate.getHours()+''+currentDate.getSeconds()+'Lwc@gmail.com';
        const parameters ={apiName:'Contact',fields};
        createContact(parameters).then((con)=>{
            this.contact_Id = con.Id;
            this.dispatchEvent(
                new showToastMessage({
                    title:'Success',
                    variant:'success',
                    messge:'Contact created Successfully!'
                })
            );
        }).catch((err)=>{
            this.contact_Id ='ERROR';
            this.dispatchEvent(
                new showToastMessage({
                    title:'error',
                    message:'error encountered ',
                    variant:'error'
                })
            );
        });
    }
}