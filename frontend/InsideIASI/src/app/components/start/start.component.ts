import { Component } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { DataService } from './services/data.service';

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
    private _dataService: DataService
  ) {
    translate.addLangs(['en', 'ro']);
    translate.setDefaultLang('en');
    this._dataService.flag != undefined? this.roFlag = this._dataService.flag : this.roFlag = this.defaultFlag;
  }

  switchLanguage(lang: string) {
    this.translate.use(lang);
  }

  switchRo() {
    this.switchLanguage('ro');
    this._dataService.flag = false;
    this.roFlag = false;
  }

  switchEn() {
    this.switchLanguage('en');
    this._dataService.flag = true;
    this.roFlag = true;
  }
}
