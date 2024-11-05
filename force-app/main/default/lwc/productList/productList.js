import { LightningElement, wire, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import PRODUCT_OBJECT from '@salesforce/schema/Product__c';
import CATEGORY_FIELD from '@salesforce/schema/Product__c.Category__c';
import { getListUi } from 'lightning/uiListApi';
import PRODUCT_NAME from '@salesforce/schema/Product__c.Name';
import UNIT_PRICE from '@salesforce/schema/Product__c.Unit_Price__c';
import STOCK_QUANTITY from '@salesforce/schema/Product__c.Stock_Quantity__c';
import CATEGORY from '@salesforce/schema/Product__c.Category__c';

export default class ProductList extends LightningElement {

    @track products = [];
    @track filteredProducts = [];
    @track categoryTotals = new Map();
    @track categoryTotalsArray = [];
    @track minPrice = 0;
    @track sortBy = 'name'; // Default sorting by name
    @track sortOrder = 'asc';
    sortOptions = [
        { label: 'Name', value: 'name' },
        { label: 'Unit Price', value: 'unitPrice' }
    ];
    
    // Fetch the picklist values for the Category field
    @wire(getObjectInfo, { objectApiName: PRODUCT_OBJECT })
    objectInfo;
    
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: CATEGORY_FIELD })
    categories;

    // Fetch the products using wire with the List UI API
    @wire(getListUi, { objectApiName: PRODUCT_OBJECT, listViewApiName: 'All' })
    wiredProducts({ error, data }) {
        if (data) {
            console.log('Products: ', this.products);
            this.products = data.records.records.map(record => ({
                id: record.id,
                name: getFieldValue(record, PRODUCT_NAME),
                category: getFieldValue(record, CATEGORY),
                unitPrice: getFieldValue(record, UNIT_PRICE),
                stockQuantity: getFieldValue(record, STOCK_QUANTITY),
            }));
            this.filteredProducts = this.products;
            this.calculateCategoryTotals();
            console.log('Products: ', this.products);
            console.log('Categories: ', this.categories.data.values);
            console.log('Categories: ', this.categories.data.picklistFieldValues.Category__c.values);
        } else if (error) {
            console.error('Error retrieving products:', error);
        }
    }

    // Method to handle changes in the minimum price filter
    handleMinPriceChange(event) {
        this.minPrice = event.target.value;
        this.applyFilters();
    }

    // Method to handle sorting changes
    handleSortChange(event) {
        this.sortBy = event.target.value;
        this.sortOrder = this.sortOrder === 'asc' ? 'desc' : 'asc';
        this.sortProducts();
    }

    // Apply the minimum price filter to the product list
    applyFilters() {
        this.filteredProducts = this.products.filter(product => product.unitPrice >= this.minPrice);
        this.sortProducts();
        this.calculateCategoryTotals();
    }

    // Sort the products based on the selected field and order
    sortProducts() {
        const sorted = [...this.filteredProducts];
        sorted.sort((a, b) => {
            let fieldA = a[this.sortBy];
            let fieldB = b[this.sortBy];
            
            if (this.sortOrder === 'asc') {
                return fieldA > fieldB ? 1 : -1;
            } else {
                return fieldA < fieldB ? 1 : -1;
            }
        });
        this.filteredProducts = sorted;
    }

    // Calculate the total inventory value per category
    calculateCategoryTotals() {
        this.categoryTotals = new Map();
        this.filteredProducts.forEach(product => {
            const totalValue = product.unitPrice * product.stockQuantity;
            if (this.categoryTotals.has(product.category)) {
                this.categoryTotals.set(product.category, this.categoryTotals.get(product.category) + totalValue);
            } else {
                this.categoryTotals.set(product.category, totalValue);
            }
        });
        this.categoryTotalsArray = Array.from(this.categoryTotals, ([category, totalValue]) => ({
            key: category, // Use category as a unique key
            category,
            totalValueFormatted: `$${totalValue.toFixed(2)}` // Pre-format total value as a string
        }));
    }
}