import { createElement } from 'lwc';
import LastChanges from 'c/lastChanges';
import getActivityHistory from '@salesforce/apex/LastChangesHelper.getActivityHistory';

const mockGetActivityHistory = require('./data/getActivityHistory.json');
// eslint-disable-next-line no-undef

// Mock getContactList Apex wire adapter
jest.mock(
  '@salesforce/apex/LastChangesHelper.getActivityHistory',
  () => {
      const {
          createApexTestWireAdapter
      } = require('@salesforce/sfdx-lwc-jest');
      return {
          default: createApexTestWireAdapter(jest.fn())
      };
  },
  { virtual: true }
);

describe('c-last-changes', () => {
  afterEach(() => {
      // The jsdom instance is shared across test cases in a single file so reset the DOM
      while (document.body.firstChild) {
          document.body.removeChild(document.body.firstChild);
      }
      // Prevent data saved on mocks from leaking between tests
      jest.clearAllMocks();
  });

  // Helper function to wait until the microtask queue is empty.
  async function flushPromises() {
      return Promise.resolve();
  }
  it('renders two rows in the lightning datatable', async () => {
    const element = createElement('c-last-changes', {
        is: LastChanges
    });
    document.body.appendChild(element);

    // Emit data from @wire
    getActivityHistory.emit(mockGetActivityHistory);

    // Wait for any asynchronous DOM updates
    await flushPromises();

    const tableEl = element.shadowRoot.querySelector('lightning-datatable');

    //Validate the datatable is populated with correct number of records
    expect(tableEl.data.length).toBe(mockGetActivityHistory.length);
    
    //Validate the record to have rendered with correct data
    expect(tableEl.data[0].CreatedDate).toBe(
        mockGetActivityHistory[0].CreatedDate
    );
    console.log(tableEl.data);
    console.log(mockGetActivityHistory);
    expect(tableEl.data[0].FieldName__c).toBe(mockGetActivityHistory[0].FieldName__c);

    expect(tableEl.data[0].OldValue__c).toBe(mockGetActivityHistory[0].OldValue__c);

    expect(tableEl.data[0].NewValue__c).toBe(mockGetActivityHistory[0].NewValue__c);

    expect(tableEl.data[0].Who__c).toBe(mockGetActivityHistory[0].Who__r.Name);

    

  });


});