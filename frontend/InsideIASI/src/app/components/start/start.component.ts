import { Component } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { DataService } from './services/data.service';
import { MatDialog } from '@angular/material/dialog';
import { InstructionsComponent } from 'src/app/instructions/instructions.component';

@Component({
  selector: 'app-start',
  templateUrl: './start.component.html',
  styleUrls: ['./start.component.scss'],
})
export class StartComponent {
  roFlag!: boolean;
  defaultFlag: boolean = true;

  constructor(
    public translate: TranslateService,
    private _dataService: DataService,
    private _dialogRef: MatDialog
  ) {
    translate.addLangs(['en', 'ro']);
    translate.setDefaultLang('en');
    this._dataService.flag != undefined
      ? (this.roFlag = this._dataService.flag)
      : (this.roFlag = this.defaultFlag);
  }

  switchLanguage(lang: string): void {
    this.translate.use(lang);
  }

  switchRo(): void {
    this.switchLanguage('ro');
    this._dataService.flag = false;
    this.roFlag = false;
  }

  switchEn(): void {
    this.switchLanguage('en');
    this._dataService.flag = true;
    this.roFlag = true;
  }

  openInfoDialog(): void {
    this._dialogRef.open(InstructionsComponent, {
      hasBackdrop: true, 
      panelClass: 'dialog'
    })
  }
}
