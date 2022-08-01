import { Injectable } from '@angular/core';

@Injectable({
    providedIn: 'root',
})
export class PaginationHelper {
    pageSize: number = 0;
    pageIndex: number = 0;
    length: number = 0;

    constructor() { }

    setPageOptions(p_size: any, t_index: any, t_length: any) {
        this.pageIndex = t_index;
        this.pageSize = p_size;
        this.length = t_length;
    }
    getPageOptions() {
        return {
            pageIndex: this.pageIndex,
            pageSize: this.pageSize,
            length: this.length
        }
    }
}