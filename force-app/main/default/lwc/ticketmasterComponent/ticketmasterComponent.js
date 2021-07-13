import { LightningElement, track, api, wire } from 'lwc';
import { getRecord } from "lightning/uiRecordApi";
import GEOHASH_FIELD from "@salesforce/schema/Account.Geohash__c";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import startRequest from '@salesforce/apexContinuation/TicketmasterConnector.startRequest';
import { helper } from './helper.js';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import styles from '@salesforce/resourceUrl/ticketMasterCompStyle';

export default class TicketmasterComponent extends LightningElement {
    
    // constructor() {
    //     super(); // required
    // }
    
    account;
    eventPayload;
    hasEvents;
    jsonPayload;
    status;
    parsedEventArray;
    error;
    boolShowSpinner;
    
    @track fields = ['GEOHASH_FIELD'];
    @api recordId;
    @wire(getRecord, { recordId: '$recordId', fields: '$fields' })
    receiveRecord({error, data}) {
        if (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading contact',
                    message: error.message,
                    variant: 'error',
                }),
            );
            console.log('error provisioning data from wire service');
            
        } else if (data) {
            console.log('data provisioned from wire service');
            //alert('data provisioned from wire service');
        }
    }

    renderedCallback(){
        //alert('renderedCallback!');
        console.log('styles resource: ' + styles);
        loadStyle(this, styles)
            .then(() => console.log('css files loaded'))
            .catch(error => console.log("Error " + error.body.message))
    }

    //fire when inserted into DOM
    connectedCallback() {
        this.eventPayload = false;
        this.boolShowSpinner = true;
        this.fetchLocalEvents();
    }

    fetchLocalEvents() {
        const accountId = this.recordId;
        console.log('fetching events...');
        startRequest({id: accountId})
        .then(result => {
            this.boolShowSpinner = false;
            this.error = undefined;
            this.jsonPayload = JSON.parse(result);
            //are there any events (during a pandemic)? 
            if(this.jsonPayload._embedded.events.length > 0){
                this.eventPayload = true;
                this.hasEvents = true;
                console.log('JSON event name: ' + this.jsonPayload._embedded.events[0].name)
                this.parsedEventArray = helper.parseJsonEvents(this.jsonPayload);
                console.log('parsedEventArray' + JSON.stringify(this.parsedEventArray));
            }
            else{
                this.hasEvents = false;
            }
            
            
        })
        .catch(error => {
            this.error = error;
            console.log('Error: ' + error.body.message);
        });
    }
 
}