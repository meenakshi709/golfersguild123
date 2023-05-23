import * as FileSaver from 'file-saver';

import { Injectable } from '@angular/core';

import { Workbook } from 'exceljs';
const exceltype = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
const EXCEL_EXTENSION = '.xlsx';
const logoBase64 = "data:image/png;base64,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";

@Injectable({
  providedIn: 'root'
})

export class ExcelService {
  
  title:any;
  selecteddate:any;
  constructor() { }

  public exportAsExcelFile(json: any[], excelFileName: string, addingRows: any = []): void {
    this.title = excelFileName;
    let workbook = new Workbook();
    let worksheet = workbook.addWorksheet(excelFileName,);
    let header = [];
    for (let x1 of json) {
      let x2 = Object.keys(x1);
      if (header.length == 0) {
        header.push(x2);
        let titleRow = worksheet.addRow([]);
        worksheet.addRow([]);
        let newData: any = "";
        let rowCount = 0;
   
        if (rowCount > 0) {
            this.selecteddate=rowCount;
          if (rowCount == 1) {
            newData=newData.substring(0, newData.length - 1);
          }
          worksheet.addRow([newData]);
        }
        worksheet.addRow(header[0]);
      
      }
      let temp = [];
      for (let y of x2) {
        temp.push(x1[y]);
      }
      worksheet.addRow(temp)
    }

    worksheet.eachRow(function (row, rowNumber) {
      row.eachCell(function (cell, colNumber) {
        if (cell.value)
          row.getCell(colNumber).font = {
            name: 'Century Gothic',
            family: 7,
            size: 9
          }
      });
    });

    if( this.selecteddate>0){
      worksheet.getRow(3).font = { name: 'Century Gothic', family: 4, size: 11, bold: true };

      worksheet.getRow(4).font = { name: 'Century Gothic', family: 4, size: 11, bold: true };
    }else{
      worksheet.getRow(3).font = { name: 'Century Gothic', family: 4, size: 11, bold: true };
    }
    

    // const imageId2 = workbook.addImage({
    //   base64: logoBase64,
    //   extension: 'png',
    // });
    worksheet.mergeCells('A1:B2');
    // worksheet.addImage(imageId2, 'A1:B2');

    workbook.xlsx.writeBuffer().then((data) => {
      let blob = new Blob([data], { type: exceltype });
      FileSaver.saveAs(blob, excelFileName + '_export_' +new Date().getFullYear()+ new Date().getMonth() + new Date().getDate() +new Date().getHours() +new Date().getMinutes() + EXCEL_EXTENSION);
    });

  }

  private saveAsExcelFile(buffer: any, fileName: string): void {
    const data: Blob = new Blob([buffer], {
      // type: EXCEL_TYPE
    });
    FileSaver.saveAs(data, fileName + '_export_' + new Date().getTime() + EXCEL_EXTENSION);
  }

  //Previous code 

  // const worksheet: XLSX.WorkSheet = XLSX.utils.json_to_sheet(json);
  //   
  //   const workbook: XLSX.WorkBook = { Sheets: { 'data': worksheet }, SheetNames: ['data'], };
  //   const excelBuffer: any = XLSX.write(workbook, { bookType: 'xlsx', type: 'array' });
  //   //const excelBuffer: any = XLSX.write(workbook, { bookType: 'xlsx', type: 'buffer' });
  //   this.saveAsExcelFile(excelBuffer, excelFileName);

  // end code of previos 


}