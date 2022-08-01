// AuthorName:Ankit Khandelwal
// Purpose:Use for custom list CommonListProperties
// Date:Feb-10-2021

import { Subject } from 'rxjs';
import { CommonListMenu } from './common-list-menu';
import { MatTableDataSource } from '@angular/material/table';



export class CommonListProperties {
    miDataSource!: MatTableDataSource<any>;
    displayedColumns: string[] = [];
    columnLabels: string[] = [];
    refreshHandler!: Subject<boolean>;
    miListMenu: CommonListMenu = new CommonListMenu;
    url: any;
    showPaging: boolean = true; //  pagination  hide/show based on this conditon
    sortingShown: boolean = true;
    isContextMenuShown: boolean = false;
}