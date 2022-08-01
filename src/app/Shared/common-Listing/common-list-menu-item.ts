export class CommonListMenuItem {
    itemName: '';
    itemLabel: '' = "";
    itemIndex: number;
    visible: true;
    class: string;
    primaryClass: string = "";
    // This will keep track if menu item shall be
    // rendered through function or property(itemLabel).
    isFunction: false;
    // This property shall keep the function
    // which needs to be executed to render the menu item
    // (this is required only if isFunction property is true).
    functionToReturnMenuItem: any;
    // isSubMenuExist: Boolean = false;
    // functionToReturnSUbMenuItem: [];
    constructor(_itemName:any, _itemIndex:any, _visible:any, _isFunction:any, _functionToReturnMenuItem:any, _class:any, _primaryClass="") {
        this.itemName = _itemName;
        this.itemIndex = _itemIndex;
        this.visible = _visible;
        this.isFunction = _isFunction;
        this.class = _class;
        this.functionToReturnMenuItem = _functionToReturnMenuItem;
        this.primaryClass = _primaryClass;
    }
}